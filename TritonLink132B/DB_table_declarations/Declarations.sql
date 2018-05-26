-- Table: public.attendence

-- DROP TABLE public.attendence;

CREATE TABLE public.attendence
(
    sid integer NOT NULL,
    attendence_id integer NOT NULL,
    start_quarter character varying(15) COLLATE pg_catalog."default" NOT NULL,
    start_year integer NOT NULL,
    end_quarter character varying(15) COLLATE pg_catalog."default" NOT NULL,
    end_year integer NOT NULL,
    CONSTRAINT "Attendence_pkey1" PRIMARY KEY (attendence_id),
    CONSTRAINT attendence_student_fkey FOREIGN KEY (sid)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.attendence
    OWNER to postgres;
	
	
-- Table: public.bachelors

-- DROP TABLE public.bachelors;

CREATE TABLE public.bachelors
(
    degree_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    max_units integer,
    CONSTRAINT bachelors_pkey PRIMARY KEY (degree_name),
    CONSTRAINT "Bachelors_degree_name_fkey" FOREIGN KEY (degree_name)
        REFERENCES public.degrees (degree_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.bachelors
    OWNER to postgres;
	
-- Table: public.candidate

-- DROP TABLE public.candidate;

CREATE TABLE public.candidate
(
    thesis character varying(40) COLLATE pg_catalog."default" NOT NULL,
    p_ssn integer NOT NULL,
    CONSTRAINT candidate_pkey PRIMARY KEY (p_ssn),
    CONSTRAINT candidate_p_ssn_fkey FOREIGN KEY (p_ssn)
        REFERENCES public.phd (p_ssn) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.candidate
    OWNER to postgres;

	-- Table: public.categories

-- DROP TABLE public.categories;

CREATE TABLE public.categories
(
    category_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    degree_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    min_units integer,
    min_gpa double precision,
    CONSTRAINT "Categories_pkey" PRIMARY KEY (category_name),
    CONSTRAINT "Categories_degree_name_fkey" FOREIGN KEY (degree_name)
        REFERENCES public.degrees (degree_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.categories
    OWNER to postgres;
	
-- Table: public.class

-- DROP TABLE public.class;

CREATE TABLE public.class
(
    class_id integer NOT NULL,
    course_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    enrollment_limit integer NOT NULL,
    faculty_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    location character varying(30) COLLATE pg_catalog."default" NOT NULL,
    days character varying(10) COLLATE pg_catalog."default" NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    class_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT class_pkey PRIMARY KEY (class_id),
    CONSTRAINT "Class_faculty_name_fkey" FOREIGN KEY (faculty_name)
        REFERENCES public.faculty (faculty_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT class_course_entry_fkey FOREIGN KEY (course_number)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.class
    OWNER to postgres;
	

-- Table: public.class_taken

-- DROP TABLE public.class_taken;

CREATE TABLE public.class_taken
(
    ssn integer NOT NULL,
    course character varying(50) COLLATE pg_catalog."default" NOT NULL,
    grade character varying(5) COLLATE pg_catalog."default" NOT NULL,
    quarter character varying(30) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    CONSTRAINT "Class_Taken_pkey" PRIMARY KEY (ssn, course),
    CONSTRAINT class_taken_course_entry_fkey FOREIGN KEY (course)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT class_taken_student_fkey FOREIGN KEY (ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.class_taken
    OWNER to postgres;
	
-- Table: public.class_taking

-- DROP TABLE public.class_taking;

CREATE TABLE public.class_taking
(
    ssn integer NOT NULL,
    course character varying(50) COLLATE pg_catalog."default" NOT NULL,
    units integer NOT NULL,
    section integer,
    CONSTRAINT "Class_Taking_pkey" PRIMARY KEY (ssn, course),
    CONSTRAINT class_taking_course_entry_fkey FOREIGN KEY (course)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT class_taking_section_fkey FOREIGN KEY (section)
        REFERENCES public.class (class_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT class_taking_student_fkey FOREIGN KEY (ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.class_taking
    OWNER to postgres;
	
-- Table: public.course_entry

-- DROP TABLE public.course_entry;

CREATE TABLE public.course_entry
(
    "Course Number" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Grade Option" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    units character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "Lab Option" character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "Discussion Option" character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "Review Option" character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "Department" character varying(35) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT course_entry_pkey PRIMARY KEY ("Course Number"),
    CONSTRAINT "course_entry_Department_fkey" FOREIGN KEY ("Department")
        REFERENCES public.department ("Department Name") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.course_entry
    OWNER to postgres;

-- Table: public.degrees

-- DROP TABLE public.degrees;

CREATE TABLE public.degrees
(
    degree_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    total_units integer NOT NULL,
    department_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Degress_pkey" PRIMARY KEY (degree_name),
    CONSTRAINT "Degress_department_name_fkey" FOREIGN KEY (department_name)
        REFERENCES public.department ("Department Name") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.degrees
    OWNER to postgres;
	
-- Table: public.department

-- DROP TABLE public.department;

CREATE TABLE public.department
(
    "Department Name" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT department_pkey PRIMARY KEY ("Department Name")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.department
    OWNER to postgres;
	
-- Table: public.discussion

-- DROP TABLE public.discussion;

CREATE TABLE public.discussion
(
    discussion_id integer NOT NULL,
    class_id integer NOT NULL,
    location character varying(40) COLLATE pg_catalog."default" NOT NULL,
    days character varying(40) COLLATE pg_catalog."default" NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT "Discussion_pkey" PRIMARY KEY (discussion_id),
    CONSTRAINT "Discussion_class_id_fkey" FOREIGN KEY (class_id)
        REFERENCES public.class (class_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.discussion
    OWNER to postgres;
	
-- Table: public.faculty

-- DROP TABLE public.faculty;

CREATE TABLE public.faculty
(
    faculty_name character varying(40) COLLATE pg_catalog."default" NOT NULL,
    title character varying(40) COLLATE pg_catalog."default" NOT NULL,
    department character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Faculty_pkey" PRIMARY KEY (faculty_name),
    CONSTRAINT "Faculty_department_fkey" FOREIGN KEY (department)
        REFERENCES public.department ("Department Name") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.faculty
    OWNER to postgres;
	

	-- Table: public.fees

-- DROP TABLE public.fees;

CREATE TABLE public.fees
(
    fee_id integer NOT NULL,
    amount integer NOT NULL,
    payment_date date NOT NULL,
    CONSTRAINT "Fees_pkey" PRIMARY KEY (fee_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fees
    OWNER to postgres;
	
-- Table: public.five_year_bs_ms

-- DROP TABLE public.five_year_bs_ms;

CREATE TABLE public.five_year_bs_ms
(
    g_ssn integer NOT NULL,
    CONSTRAINT five_year_bs_ms_pkey PRIMARY KEY (g_ssn),
    CONSTRAINT five_year_bs_ms_student_fkey FOREIGN KEY (g_ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.five_year_bs_ms
    OWNER to postgres;
	
	
-- Table: public.graduate

-- DROP TABLE public.graduate;

CREATE TABLE public.graduate
(
    g_ssn integer NOT NULL,
    department_name character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT graduate_pkey PRIMARY KEY (g_ssn),
    CONSTRAINT graduate_department_name_fkey FOREIGN KEY (department_name)
        REFERENCES public.department ("Department Name") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT graduate_student_fkey FOREIGN KEY (g_ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.graduate
    OWNER to postgres;
	
-- Table: public.lab

-- DROP TABLE public.lab;

CREATE TABLE public.lab
(
    lab_id integer NOT NULL,
    class_id integer NOT NULL,
    location character varying(40) COLLATE pg_catalog."default" NOT NULL,
    days character varying(40) COLLATE pg_catalog."default" NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT "Lab_pkey" PRIMARY KEY (lab_id),
    CONSTRAINT "Lab_class_id_fkey" FOREIGN KEY (class_id)
        REFERENCES public.class (class_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lab
    OWNER to postgres;
	
-- Table: public.masters

-- DROP TABLE public.masters;

CREATE TABLE public.masters
(
    project character varying(40) COLLATE pg_catalog."default" NOT NULL,
    m_ssn integer NOT NULL,
    CONSTRAINT masters_pkey PRIMARY KEY (m_ssn),
    CONSTRAINT masters_m_ssn_fkey FOREIGN KEY (m_ssn)
        REFERENCES public.graduate (g_ssn) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.masters
    OWNER to postgres;
	
	
-- Table: public.masters_degree

-- DROP TABLE public.masters_degree;

CREATE TABLE public.masters_degree
(
    id integer NOT NULL,
    degree_name character varying(40) COLLATE pg_catalog."default" NOT NULL,
    concentration character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Masters_Degree_pkey" PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.masters_degree
    OWNER to postgres;
	
-- Table: public.pay_dues

-- DROP TABLE public.pay_dues;

CREATE TABLE public.pay_dues
(
    ssn integer NOT NULL,
    fee_id integer NOT NULL,
    CONSTRAINT "Pay_Dues_pkey" PRIMARY KEY (ssn, fee_id),
    CONSTRAINT "Pay_Dues_fee_id_fkey" FOREIGN KEY (fee_id)
        REFERENCES public.fees (fee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT pay_dues_student_fkey FOREIGN KEY (ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.pay_dues
    OWNER to postgres;
	
-- Table: public.phd

-- DROP TABLE public.phd;

CREATE TABLE public.phd
(
    advisor character varying(40) COLLATE pg_catalog."default" NOT NULL,
    p_ssn integer NOT NULL,
    CONSTRAINT phd_pkey PRIMARY KEY (p_ssn),
    CONSTRAINT "PHD_advisor_fkey" FOREIGN KEY (advisor)
        REFERENCES public.faculty (faculty_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT phd_p_ssn_fkey FOREIGN KEY (p_ssn)
        REFERENCES public.graduate (g_ssn) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.phd
    OWNER to postgres;
	
-- Table: public.pre_candidacy

-- DROP TABLE public.pre_candidacy;

CREATE TABLE public.pre_candidacy
(
    research_topic character varying(40) COLLATE pg_catalog."default" NOT NULL,
    p_ssn integer NOT NULL,
    CONSTRAINT pre_candidacy_pkey PRIMARY KEY (p_ssn),
    CONSTRAINT pre_candidacy_p_ssn_fkey FOREIGN KEY (p_ssn)
        REFERENCES public.phd (p_ssn) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.pre_candidacy
    OWNER to postgres;
	
-- Table: public.prerequisites

-- DROP TABLE public.prerequisites;

CREATE TABLE public.prerequisites
(
    course_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pre_req character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Prerequisites_pkey" PRIMARY KEY (course_number, pre_req),
    CONSTRAINT pre_req_course_entry_fkey FOREIGN KEY (pre_req)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT prerequisites_course_entry_fkey FOREIGN KEY (course_number)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.prerequisites
    OWNER to postgres;
	
-- Table: public.probation

-- DROP TABLE public.probation;

CREATE TABLE public.probation
(
    sid integer NOT NULL,
    probation_id integer NOT NULL,
    reason character varying(150) COLLATE pg_catalog."default" NOT NULL,
    start_time_frame date NOT NULL,
    end_time_frame date NOT NULL,
    CONSTRAINT "Attendence_pkey" PRIMARY KEY (probation_id),
    CONSTRAINT probation_student_fkey FOREIGN KEY (sid)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.probation
    OWNER to postgres;
	
-- Table: public.professor_committee

-- DROP TABLE public.professor_committee;

CREATE TABLE public.professor_committee
(
    id integer NOT NULL,
    professor character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Professor_Committee_pkey" PRIMARY KEY (id, professor),
    CONSTRAINT "Professor_Committee_id_fkey" FOREIGN KEY (id)
        REFERENCES public.thesis_committee (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Professor_Committee_professor_fkey" FOREIGN KEY (professor)
        REFERENCES public.faculty (faculty_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.professor_committee
    OWNER to postgres;
	
-- Table: public.review_session

-- DROP TABLE public.review_session;

CREATE TABLE public.review_session
(
    review_id integer NOT NULL,
    class_id integer NOT NULL,
    location character varying(40) COLLATE pg_catalog."default" NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT "Review_Session_pkey" PRIMARY KEY (review_id),
    CONSTRAINT "Review_Session_class_id_fkey" FOREIGN KEY (class_id)
        REFERENCES public.class (class_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.review_session
    OWNER to postgres;
	
-- Table: public.student

-- DROP TABLE public.student;

CREATE TABLE public.student
(
    ssn integer NOT NULL,
    id integer NOT NULL,
    "First Name" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "Middle Name" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "Last Name" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    residency character varying(30) COLLATE pg_catalog."default" NOT NULL,
    college character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Student_pkey" PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.student
    OWNER to postgres;
	
-- Table: public.student_degrees

-- DROP TABLE public.student_degrees;

CREATE TABLE public.student_degrees
(
    sid integer NOT NULL,
    type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    university character varying(80) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    CONSTRAINT "Student_Degrees_pkey" PRIMARY KEY (sid, year),
    CONSTRAINT "Student_Degrees_sid_fkey" FOREIGN KEY (sid)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.student_degrees
    OWNER to postgres;
	
-- Table: public.thesis_committee

-- DROP TABLE public.thesis_committee;

CREATE TABLE public.thesis_committee
(
    sid integer NOT NULL,
    title character varying(50) COLLATE pg_catalog."default" NOT NULL,
    id integer NOT NULL,
    CONSTRAINT "Thesis_Committee_pkey" PRIMARY KEY (id),
    CONSTRAINT "Thesis_Committee_sid_fkey" FOREIGN KEY (sid)
        REFERENCES public.graduate (g_ssn) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.thesis_committee
    OWNER to postgres;
	

	
-- Table: public.undergraduate

-- DROP TABLE public.undergraduate;

CREATE TABLE public.undergraduate
(
    u_ssn integer NOT NULL,
    major character varying(30) COLLATE pg_catalog."default" NOT NULL,
    minor character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Undergraduate_u_ssn_fkey" FOREIGN KEY (u_ssn)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT undergraduate_major_fkey FOREIGN KEY (major)
        REFERENCES public.degrees (degree_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT undergraduate_minor_fkey FOREIGN KEY (minor)
        REFERENCES public.degrees (degree_name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.undergraduate
    OWNER to postgres;
	
	
-- Table: public.waitlist

-- DROP TABLE public.waitlist;

CREATE TABLE public.waitlist
(
    class_id integer NOT NULL,
    sid integer NOT NULL,
    CONSTRAINT "Waitlist_pkey" PRIMARY KEY (class_id, sid),
    CONSTRAINT "Waitlist_class_id_fkey" FOREIGN KEY (class_id)
        REFERENCES public.class (class_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT waitlist_student_fkey FOREIGN KEY (sid)
        REFERENCES public.student (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.waitlist
    OWNER to postgres;
	
	
-- Table: public.masters_concentration_courses

-- DROP TABLE public.masters_concentration_courses;

CREATE TABLE public.masters_concentration_courses
(
    id integer NOT NULL,
    course character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Masters_Concentration_Courses_pkey" PRIMARY KEY (id, course),
    CONSTRAINT "Masters_Concentration_Courses_course_fkey" FOREIGN KEY (course)
        REFERENCES public.course_entry ("Course Number") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Masters_Concentration_Courses_id_fkey" FOREIGN KEY (id)
        REFERENCES public.masters_degree (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.masters_concentration_courses
    OWNER to postgres;