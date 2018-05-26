/*FIRST TRIGGER*/
DROP TABLE IF EXISTS CPG; 
CREATE TABLE CPG AS
SELECT ft.faculty_name as faculty_name, ct.course as course,
COUNT(CASE WHEN ct.grade IN ('A-', 'A', 'A+') THEN 1 END) AS "A",
COUNT(CASE WHEN ct.grade IN ('B-', 'B', 'B+') THEN 1 END) AS "B",
COUNT(CASE WHEN ct.grade IN ('C-', 'C', 'C+') THEN 1 END) AS "C",
COUNT(CASE WHEN ct.grade IN ('D-', 'D', 'D+') THEN 1 END) AS "D",
COUNT(CASE WHEN ct.grade IN ('F-', 'F', 'F+') THEN 1 END) AS "F"
FROM Class_Taken ct, Faculty_teaching ft
WHERE ft.section=11 AND ft.course_number = ct.course AND ft.quarter=ct.quarter AND ft.year=ct.year
GROUP BY faculty_name, course;

INSERT INTO CPG (faculty_name, course,"A", "B", "C","D","F")
SELECT ft.faculty_name, ft.course_number,0,0,0,0,0
FROM Faculty_teaching ft
WHERE NOT EXISTS (SELECT 1 FROM CPG c WHERE c.faculty_name = faculty_name AND c.course=course_number AND ft.section=11);

DROP FUNCTION IF EXISTS class_taken_over_years() CASCADE;
DROP TRIGGER IF EXISTS class_taken_over_years ON Class_Taken CASCADE; 

CREATE FUNCTION class_taken_over_years() RETURNS TRIGGER AS $class_taken_over_years$
DECLARE 
VARIABLE text;
TEACHER text;
FLAG_VAL int;
    BEGIN 
    CREATE TEMP TABLE tmp_table_class_taken_over_years AS 
    SELECT DISTINCT ct.course,ft.faculty_name FROM Class_Taken ct, Faculty_Teaching ft 
    WHERE ft.section=11 AND ft.course_number=NEW.course AND ft.quarter=NEW.quarter AND ft.year=NEW.year;
    IF(TG_OP='INSERT') 
    THEN 
    UPDATE CPG SET
    "A" = (CASE WHEN NEW.grade IN ('A-', 'A', 'A+') THEN "A" + 1 ELSE "A" END),
	"B" =(CASE WHEN NEW.grade IN ('B-', 'B', 'B+') THEN "B" + 1 ELSE "B"  END),
	"C" =(CASE WHEN NEW.grade IN ('C-', 'C', 'C+') THEN "C" + 1  ELSE "C"  END),
	"D" =(CASE WHEN NEW.grade IN ('D-', 'D', 'D+') THEN "D" + 1 ELSE "D"  END),
	"F" =(CASE WHEN NEW.grade IN ('F-', 'F', 'F+') THEN "F" + 1 ELSE "F" END)
    WHERE course=NEW.course AND faculty_name=(SELECT faculty_name FROM tmp_table_class_taken_over_years LIMIT 1);
    END IF;
    IF(TG_OP='UPDATE')
    THEN 
    UPDATE CPG SET
    "A" = (CASE WHEN NEW.grade IN ('A-', 'A', 'A+') THEN "A" +1 ELSE "A" END),
	"B" =(CASE WHEN NEW.grade IN ('B-', 'B', 'B+') THEN "B" +1 ELSE "B" END),
	"C" =(CASE WHEN NEW.grade IN ('C-', 'C', 'C+') THEN "C" +1 ELSE "C" END),
	"D" =(CASE WHEN NEW.grade IN ('D-', 'D', 'D+') THEN "D" +1 ELSE "D" END),
	"F" =(CASE WHEN NEW.grade IN ('F-', 'F', 'F+') THEN "F" +1 ELSE "F" END)
    WHERE course=NEW.course AND faculty_name=(SELECT faculty_name FROM tmp_table_class_taken_over_years LIMIT 1);
    
    UPDATE CPG SET
    "A" = (CASE WHEN OLD.grade IN ('A-', 'A', 'A+') THEN "A" -1 ELSE "A" END),
	"B" =(CASE WHEN OLD.grade IN ('B-', 'B', 'B+') THEN "B" -1 ELSE "B" END),
	"C" =(CASE WHEN OLD.grade IN ('C-', 'C', 'C+') THEN "C" -1 ELSE "C" END),
    "D" =(CASE WHEN OLD.grade IN ('D-', 'D', 'D+') THEN "D" -1 ELSE "D" END),
	"F" =(CASE WHEN OLD.grade IN ('F-', 'F', 'F+') THEN "F" -1 ELSE "F" END)
    WHERE course=OLD.course AND faculty_name=(SELECT faculty_name FROM tmp_table_class_taken_over_years LIMIT 1);
    END IF; 
    DROP TABLE IF EXISTS tmp_table_class_taken_over_years;
        RETURN NEW;
    END;
    $class_taken_over_years$LANGUAGE plpgsql;
    CREATE TRIGGER class_taken_over_years BEFORE INSERT OR UPDATE ON Class_Taken
    FOR EACH ROW EXECUTE PROCEDURE class_taken_over_years();
 
	/*INSERT INTO Class_Taken VALUES (15,'CSE8A', 'B-', 'FALL',2015,10,'TESTING');*/
    /*UPDATE Class_Taken
    SET Grade='B+'
    WHERE ssn=4 AND course='CSE8A' AND quarter='FALL' AND year=2015;*/
/*SECOND TRIGGER*/
DROP FUNCTION IF EXISTS class_section_overlap() CASCADE;
DROP TRIGGER IF EXISTS class_section_overlap ON Class CASCADE;     
CREATE FUNCTION class_section_overlap() RETURNS TRIGGER  AS $class_section_overlap$
   BEGIN 
        -- Compare current enrollment size with section's limit
        IF (SELECT count(d.class_id) FROM Discussion d WHERE d.start_time = NEW.start_time AND d.days LIKE '%' || NEW.days || '%' AND d.class_id=NEW.class_id)> 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH DISCUSSION CLASS_SECTION_OVERLAP CONSTRAINT CAUSED ERROR'; 
        END IF;
        IF (SELECT count(l.class_id) FROM  Lab l WHERE l.start_time = NEW.start_time AND l.days LIKE '%' || NEW.days || '%' AND l.class_id = NEW.class_id) > 0
        THEN 
        	RAISE EXCEPTION 'CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH LAB CLASS_SECTION_OVERLAP CONSTRAINT CAUSED ERROR'; 
        END IF;
        IF (SELECT count(c.class_id) FROM  Class c WHERE c.start_time = NEW.start_time AND c.days LIKE '%' || NEW.days || '%' AND c.course_number = NEW.course_number) > 0
        THEN 
        	RAISE EXCEPTION 'CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH CLASS CLASS_SECTION_OVERLAP CONSTRAINT CAUSED ERROR'; 
        END IF;
        RETURN NEW;
    END;
$class_section_overlap$ LANGUAGE plpgsql;
CREATE TRIGGER class_section_overlap BEFORE INSERT OR UPDATE ON Class
FOR EACH ROW EXECUTE PROCEDURE class_section_overlap();
/*THIRD TRIGGER*/    
DROP FUNCTION IF EXISTS checking_enrollment_limit() CASCADE;
DROP TRIGGER IF EXISTS checking_enrollment_limit ON Class_Taking CASCADE;     
CREATE FUNCTION checking_enrollment_limit() RETURNS TRIGGER  AS $checking_enrollment_limit$   
   BEGIN
        -- Compare current enrollment size with section's limit
        IF (SELECT COUNT(ssn) FROM Class_Taking WHERE course = NEW.course) >=
        (SELECT enroll_limit FROM Class WHERE class_id = NEW.course) THEN
            RAISE EXCEPTION 'CANNOT ENROLL DUE TO EXCEEDING ENROLLMENT LIMIT WITH CHECKING_ENROLLMENT_LIMIT CONSTRAINT BEING CALLED'; 
        END IF;

        RETURN NEW;
    END;
$checking_enrollment_limit$ LANGUAGE plpgsql;
CREATE TRIGGER checking_enrollment_limit BEFORE INSERT OR UPDATE ON Class_Taking
FOR EACH ROW EXECUTE PROCEDURE checking_enrollment_limit();
/*FOURTH TRIGGER*/
DROP FUNCTION IF EXISTS discussion_section_overlap() CASCADE;
DROP TRIGGER IF EXISTS discussion_section_overlap ON Discussion CASCADE;
CREATE FUNCTION discussion_section_overlap() RETURNS TRIGGER  AS $discussion_section_overlap$  
    BEGIN 
        IF (SELECT count(class_id) FROM Class WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW DISCUSSION DUE TO TIME CONFLICT WITH LECTURE WITH DISCUSSION_SECTION_OVERLAP CONSTRAINT BREACHED % %.',NEW.days,
            (SELECT days FROM Class WHERE NEW.class_id=class_id); 
             
        END IF;
        IF (SELECT count(class_id) FROM Lab WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW DISCUSSION DUE TO TIME CONFLICT WITH LAB WITH DISCUSSION_SECTION_OVERLAP CONSTRAINT BREACHED % %.',NEW.days,
            (SELECT days FROM Lab WHERE NEW.class_id=class_id); 
             
        END IF;
        IF (SELECT count(class_id) FROM Discussion WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW DISCUSSION DUE TO TIME CONFLICT WITH DISCUSSION WITH DISCUSSION_SECTION_OVERLAP CONSTRAINT BREACHED % %.',NEW.days,
            (SELECT days FROM Discussion WHERE NEW.class_id=class_id); 
             
        END IF;
        RETURN NEW;
    END;
$discussion_section_overlap$ LANGUAGE plpgsql;
CREATE TRIGGER discussion_section_overlap BEFORE INSERT OR UPDATE ON Discussion
FOR EACH ROW EXECUTE PROCEDURE discussion_section_overlap();

/*FIFTH TRIGGER*/
DROP FUNCTION IF EXISTS lab_section_overlap() CASCADE;
DROP TRIGGER IF EXISTS lab_section_overlap ON Lab CASCADE;
CREATE FUNCTION lab_section_overlap() RETURNS TRIGGER  AS $lab_section_overlap$  
    BEGIN 
        IF (SELECT count(class_id) FROM Class WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW LAB DUE TO TIME CONFLICT WITH LECTURE DUE TO LAB_SECTION_OVERLAP CONSTRAINT % %.',NEW.days,
            (SELECT days FROM Class WHERE NEW.class_id=class_id); 
             
        END IF;
        IF (SELECT count(class_id) FROM Lab WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW LAB DUE TO TIME CONFLICT WITH LAB DUE TO LAB_SECTION_OVERLAP CONSTRAINT % %.',NEW.days,
            (SELECT days FROM Lab WHERE NEW.class_id=class_id); 
             
        END IF;
        IF (SELECT count(class_id) FROM Discussion WHERE start_time=NEW.start_time AND class_id=NEW.class_id AND days LIKE '%' || NEW.days || '%') > 0 
        THEN
            RAISE EXCEPTION 'CANNOT ADD NEW LAB DUE TO TIME CONFLICT WITH DISCUSSION DUE TO LAB_SECTION_OVERLAP CONSTRAINT % %.',NEW.days,
            (SELECT days FROM Discussion WHERE NEW.class_id=class_id); 
             
        END IF;
        RETURN NEW;
    END;
$lab_section_overlap$ LANGUAGE plpgsql;
CREATE TRIGGER lab_section_overlap BEFORE INSERT OR UPDATE ON Lab
FOR EACH ROW EXECUTE PROCEDURE lab_section_overlap();

/*SIXTH TRIGGER*/
DROP FUNCTION IF EXISTS faculty_lecture_section_overlap() CASCADE;
DROP TRIGGER IF EXISTS faculty_lecture_section_overlap ON Faculty_Teaching CASCADE;
CREATE FUNCTION faculty_lecture_section_overlap() RETURNS TRIGGER  AS $faculty_lecture_section_overlap$  
DECLARE 
VARIABLE text;
TEACHER text;
FLAG_VAL int;
    BEGIN 
      	CREATE TEMP TABLE faculty_taught_course2 AS 
        SELECT ft.section FROM Faculty_Teaching ft WHERE ft.faculty_name = NEW.faculty_name AND ft.section!=11; 
       
        CREATE TEMP TABLE class_ids AS
        SELECT c.start_time,c.days FROM faculty_taught_course2 ft2, Class c WHERE ft2.section=c.class_id;
        
        CREATE TEMP TABLE discussion_ids AS
        SELECT c.start_time,c.days FROM faculty_taught_course2 ft2, Discussion c WHERE ft2.section=c.class_id;
        
        CREATE TEMP TABLE lab_ids AS
        SELECT c.start_time,c.days FROM faculty_taught_course2 ft2, Lab c WHERE ft2.section=c.class_id;
        
        CREATE TEMP TABLE new_entry_day_and_time AS
        SELECT c.start_time, c.days FROM Class c WHERE NEW.section=c.class_id; 
        
 IF (SELECT count(ci.start_time) FROM class_ids ci, new_entry_day_and_time x WHERE x.start_time=ci.start_time AND ci.days LIKE '%' || x.days || '%' ) > 0
        THEN 
            RAISE EXCEPTION 'PROFESSOR CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH A LECTURE OF CLASS WITH CONSTRAINT FACULTY_LECTURE_SECTION_OVERLAP CALLED 1';
        END IF;
        IF (SELECT count(ci.start_time) FROM discussion_ids ci, new_entry_day_and_time x WHERE x.start_time=ci.start_time AND ci.days LIKE '%' || x.days || '%') >0
            THEN
            RAISE EXCEPTION 'PROFESSOR CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH A DISCUSSION OF CLASS WITH CONSTRAINT FACULTY_LECTURE_SECTION_OVERLAP CALLED 2';
        END IF;
        IF (SELECT count(ci.start_time) FROM lab_ids ci, new_entry_day_and_time x WHERE x.start_time=ci.start_time AND ci.days LIKE '%' || x.days || '%') >0
        	THEN 
            RAISE EXCEPTION 'PROFESSOR CANNOT ADD NEW LECTURE DUE TO TIME CONFLICT WITH A LAB OF CLASS WITH CONSTRAINT FACULTY_LECTURE_SECTION_OVERLAP CALLED 3';
        END IF; 
        RETURN NEW;
    END;
$faculty_lecture_section_overlap$ LANGUAGE plpgsql;
CREATE TRIGGER faculty_lecture_section_overlap BEFORE INSERT OR UPDATE ON Faculty_Teaching
FOR EACH ROW EXECUTE PROCEDURE faculty_lecture_section_overlap();

/*SEVENTH TRIGGER*/
DROP FUNCTION IF EXISTS class_taken_update() CASCADE;
DROP TRIGGER IF EXISTS class_taken_update ON Class_Taken CASCADE; 


DROP TABLE IF EXISTS CPQG; 
    CREATE TABLE CPQG AS
    SELECT ft.faculty_name as faculty_name, ft.course_number as course, ft.quarter, ft.year as year,
    COUNT(CASE WHEN ct.grade IN ('A-', 'A', 'A+') THEN 1 END) AS "A",
    COUNT(CASE WHEN ct.grade IN ('B-', 'B', 'B+') THEN 1 END) AS "B",
    COUNT(CASE WHEN ct.grade IN ('C-', 'C', 'C+') THEN 1 END) AS "C",
    COUNT(CASE WHEN ct.grade IN ('D-', 'D', 'D+') THEN 1 END) AS "D",
    COUNT(CASE WHEN ct.grade IN ('F-', 'F', 'F+') THEN 1 END) AS "F"
    FROM Class_Taken ct, Faculty_teaching ft
    WHERE ft.section=11 AND ft.course_number = ct.course AND ft.quarter=ct.quarter AND ft.year=ct.year
    GROUP BY faculty_name, ft.course_number, ft.quarter, ft.year;

INSERT INTO CPQG (faculty_name, course, quarter, year,"A", "B", "C","D","F")
SELECT ft.faculty_name, ft.course_number, ft.quarter, ft.year,0,0,0,0,0
FROM Faculty_teaching ft
WHERE NOT EXISTS (SELECT 1 FROM CPQG c WHERE c.faculty_name = faculty_name AND c.course=course_number AND c.quarter=quarter AND c.year=year AND ft.section=11);



CREATE FUNCTION class_taken_update() RETURNS TRIGGER AS $class_taken_update$
DECLARE 
VARIABLE text;
TEACHER text;
FLAG_VAL int;
    BEGIN 
    CREATE TEMP TABLE tmp_table_class_taken AS 
    SELECT DISTINCT ct.course,ct.quarter,ct.year,ft.faculty_name FROM Class_Taken ct, Faculty_Teaching ft 
    WHERE ft.section=11 AND NEW.quarter=ft.quarter AND NEW.year=ft.year AND ft.course_number=NEW.course;
    IF(TG_OP='INSERT') 
    THEN 
    UPDATE CPQG SET
    "A" = (CASE WHEN NEW.grade IN ('A-', 'A', 'A+') THEN "A" + 1 ELSE "A" END),
	"B" =(CASE WHEN NEW.grade IN ('B-', 'B', 'B+') THEN "B" + 1 ELSE "B" END),
	"C" =(CASE WHEN NEW.grade IN ('C-', 'C', 'C+') THEN "C" +1 ELSE "C" END),
	"D" =(CASE WHEN NEW.grade IN ('D-', 'D', 'D+') THEN "D" +1 ELSE "D" END),
	"F" =(CASE WHEN NEW.grade IN ('F-', 'F', 'F+') THEN "F" +1 ELSE "F" END)
    WHERE course=NEW.course AND quarter=NEW.quarter AND year=NEW.year;
    END IF;
    IF(TG_OP='UPDATE')
    THEN 
    UPDATE CPQG SET
    "A" = (CASE WHEN NEW.grade IN ('A-', 'A', 'A+') THEN "A" +1 ELSE "A" END),
	"B" =(CASE WHEN NEW.grade IN ('B-', 'B', 'B+') THEN "B" +1 ELSE "B" END),
	"C" =(CASE WHEN NEW.grade IN ('C-', 'C', 'C+') THEN "C" +1 ELSE "C" END),
	"D" =(CASE WHEN NEW.grade IN ('D-', 'D', 'D+') THEN "D" +1 ELSE "D" END),
	"F" =(CASE WHEN NEW.grade IN ('F-', 'F', 'F+') THEN "F" +1 ELSE "F" END)
    WHERE course=NEW.course AND quarter=NEW.quarter AND year=NEW.year;
    
    UPDATE CPQG SET
    "A" = (CASE WHEN OLD.grade IN ('A-', 'A', 'A+') THEN "A" -1 ELSE "A" END),
	"B" =(CASE WHEN OLD.grade IN ('B-', 'B', 'B+') THEN "B" -1 ELSE "B" END),
	"C" =(CASE WHEN OLD.grade IN ('C-', 'C', 'C+') THEN "C" -1 ELSE "C" END),
    "D" =(CASE WHEN OLD.grade IN ('D-', 'D', 'D+') THEN "D" -1 ELSE "D" END),
	"F" =(CASE WHEN OLD.grade IN ('F-', 'F', 'F+') THEN "F" -1 ELSE "F" END)
    WHERE course=NEW.course AND quarter=NEW.quarter AND year=NEW.year;
    END IF; 
    DROP TABLE IF EXISTS tmp_table_class_taken;
        RETURN NEW;
    END;
 $class_taken_update$ LANGUAGE plpgsql;
    CREATE TRIGGER class_taken_update AFTER INSERT OR UPDATE ON Class_Taken
    FOR EACH ROW EXECUTE PROCEDURE class_taken_update();


