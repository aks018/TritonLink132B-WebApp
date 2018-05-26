<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="query_forms.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {  
                    // Load Oracle Driver Faculty_Teaching file 
                    DriverManager.registerDriver(new org.postgresql.Driver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                    ("jdbc:postgresql:cse132b?user=postgres&password=admin");

            %>
			<%
				String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("submit")) {
                    ResultSet myrs1 = null;
					ResultSet myrs2 = null;
					ResultSet myrs3 = null;
					ResultSet myrs4 = null;
					ResultSet myrs5 = null;
					ResultSet myrs6 = null;
					ResultSet myrs7 = null;

					
					int AI=0;
					int Databases=0;
					int Systems=0; 
					int final_AI =8; 
					int final_Databases=4;
					int final_Systems=4; 
					boolean AI_DONE = false;
					boolean DATABASES_DONE=false;
					boolean SYSTEMS_DONE=false; 
					double AI_GPA=3.1;
					double DATABASES_GPA = 3.0;
					double SYSTEMS_GPA = 3.3; 
                    Statement stmt = null;
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select distinct ct.SSN, c.course_number, ct.quarter, ct.year, c.class_name "+
                    "from Class_Taken ct, Student s, Schedule_Class c "+
                    "where ct.ssn = ? AND s.ssn=ct.ssn AND c.course_number=ct.course ORDER BY ct.quarter, ct.year ");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
                    myrs1 = pstmt.executeQuery();
					
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Completed Concentrations For <%=request.getParameter("SSN_value")%></th>
                    </tr>
                    <tr>
                    <th>AI </th>
                    <th>Systems</th>
					<th>Databases </th>
					
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
						PreparedStatement pstmt2 = conn.prepareStatement("SELECT DISTINCT course from Masters_Concentration_Courses WHERE course = ? AND category = 'Databases'",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt2.setString(1, myrs1.getString("course_number"));
						myrs2 = pstmt2.executeQuery();
						if(myrs2.absolute(1)) 
						{
							Databases+=4; 
						}
						PreparedStatement pstmt3 = conn.prepareStatement("SELECT DISTINCT course from Masters_Concentration_Courses WHERE course = ? AND category = 'AI'",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt3.setString(1, myrs1.getString("course_number"));
						myrs3 = pstmt3.executeQuery();
						if(myrs3.absolute(1)) 
						{
							AI+=4; 
						}
						PreparedStatement pstmt4 = conn.prepareStatement("SELECT DISTINCT course from Masters_Concentration_Courses WHERE course = ? AND category = 'Systems'",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt4.setString(1, myrs1.getString("course_number"));
						myrs4 = pstmt4.executeQuery();
						if(myrs4.absolute(1)) 
						{
							Systems+=4; 
						}
						if(Databases==final_Databases)
						{
							PreparedStatement pstmt5 = conn.prepareStatement("select distinct ct.quarter, ct.year, avg(NUMBER_GRADE) as average_grade "+
							"from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Class_Quarter_Offered cqo "+
							"where ct.ssn = ? AND s.ssn=ct.ssn AND ct.course='CSE232A' AND gc.LETTER_GRADE = ct.grade GROUP BY ct.quarter, ct.year ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt5.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							myrs5 = pstmt5.executeQuery();
							myrs5.next(); 
							if(myrs5.getDouble("average_grade") >= DATABASES_GPA)
							{
							DATABASES_DONE=true;
							}
							
							
						}
						if(AI==final_AI)
						{
							PreparedStatement pstmt6 = conn.prepareStatement("select distinct ct.quarter, ct.year, avg(NUMBER_GRADE) as average_grade "+
							"from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Masters_Concentration_Courses mcc "+
							"where ct.ssn = ? AND mcc.category='AI' AND s.ssn=ct.ssn AND c.course_number=ct.course AND c.course_number=mcc.course AND gc.LETTER_GRADE = ct.grade GROUP BY ct.quarter, ct.year ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt6.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							myrs6 = pstmt6.executeQuery();
							myrs6.next(); 
							if(myrs6.getDouble("average_grade") >= AI_GPA)
							{
							AI_DONE=true;
							}
						}
						if(Systems==final_Systems)
						{
							PreparedStatement pstmt7 = conn.prepareStatement("select distinct ct.quarter, ct.year, avg(NUMBER_GRADE) as average_grade "+
							"from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Class_Quarter_Offered cqo "+
							"where ct.ssn = ? AND s.ssn=ct.ssn AND ct.course='CSE221' AND gc.LETTER_GRADE = ct.grade GROUP BY ct.quarter, ct.year ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt7.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							myrs7 = pstmt7.executeQuery();
							myrs7.next(); 
							if(myrs7.getDouble("average_grade") >= SYSTEMS_GPA)
							{
							SYSTEMS_DONE=true;
							}
						}
						}
						
                    %>
                    <tr>
                        <td>
                            <%=AI_DONE%>
                        </td> <td>
                            <%=SYSTEMS_DONE%>
                        </td>
						<td>
                            <%=DATABASES_DONE%>
                        </td>
			       </tr>
                    <%
					
                    %>
                    </table>
					<%
					ResultSet myrs8 = null;
					PreparedStatement pstmt8 = conn.prepareStatement("select distinct mcc.course, sc.next_offered "+
							"from Masters_Concentration_Courses mcc, Schedule_Class sc "+
							"where mcc.category = 'AI' AND sc.course_number=mcc.course AND mcc.course NOT IN (select c.course from Class_Taken c where c.ssn=?)",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt8.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							
							myrs8 = pstmt8.executeQuery();
					%>
					<table border="1">
					 <tr>
                        <th>A.I Courses left to take for <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    
                    </tr>
					<% while(myrs8.next())
					{
						
						%>
						<tr>

						
						<td>
                            <%=myrs8.getString("course")%>
                        </td>
						<td>
                            <%=myrs8.getString("next_offered")%>
                        </td>
						
                       
                       
                    </tr>
					<%
					}
					%>
					</table>
					<%
					ResultSet myrs9 = null;
					PreparedStatement pstmt9 = conn.prepareStatement("select distinct mcc.course, sc.next_offered "+
							"from Masters_Concentration_Courses mcc, Schedule_Class sc "+
							"where mcc.category = 'Systems' AND sc.course_number=mcc.course AND mcc.course NOT IN (select c.course from Class_Taken c where c.ssn=?)",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt9.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							myrs9 = pstmt9.executeQuery();
					%>
					<table border="1">
					 <tr>
                        <th>Systems Courses left to take for <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    
                    </tr>
					<% while(myrs9.next())
					{
						
						%>
						<tr>
                       
					
						
						<td>
                            <%=myrs9.getString("course")%>
                        </td>
						<td>
                            <%=myrs9.getString("next_offered")%>
                        </td>
						
                       
                       
                    </tr>
					<%
					}
					%>
					</table>
					<%
					ResultSet myrs10 = null;
					PreparedStatement pstmt10 = conn.prepareStatement("select distinct mcc.course, sc.next_offered "+
							"from Masters_Concentration_Courses mcc, Schedule_Class sc "+
							"where mcc.category = 'Databases' AND sc.course_number=mcc.course AND mcc.course NOT IN (select c.course from Class_Taken c where c.ssn=?)",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt10.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							
							myrs10 = pstmt10.executeQuery();
					%>
					<table border="1">
					 <tr>
                        <th>Databases Courses left to take for <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    
                    </tr>
					<% while(myrs10.next())
					{
						
						%>
						<tr>
                       
					
						
						<td>
                            <%=myrs10.getString("course")%>
                        </td>
						<td>
                            <%=myrs10.getString("next_offered")%>
                        </td>
						
                       
                       
                    </tr>
					<%
					}
					%>
					</table>
                    <%
					

                }
				%>
             <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
                ResultSet myrs = null;
                conn.setAutoCommit(false);
               // PreparedStatement pstmt2 = conn.prepareStatement("select g.g_ssn, s.first_name, s.middle_name, s.last_name " +
                 //                               "from Class_Taking ct, Graduate g, Student s");
                myrs = statement.executeQuery("select distinct g.g_ssn,s.first_name, s.middle_name, s.last_name from Class_Taking ct, Graduate g, Student s WHERE ct.ssn=g.g_ssn AND ct.ssn=s.ssn AND s.ssn=g.g_ssn");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="fifth_query.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getInt("g_ssn")%>'>
                            <%=myrs.getInt("g_ssn")%>  <%=myrs.getString("first_name")%>  <%=myrs.getString("middle_name")%>  <%=myrs.getString("last_name")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
           <%
                 // Select all possible undergrad degrees to go witho our student X
                myrs = statement.executeQuery("select d.degree_name, d.department_name " +
                                                "from Degrees d "+
                                                "where d.lower_div_units = 0 ");
                
            %>
            <hr>

            <br />
        <div>
            Select Degree:
            <select name="Degree">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getString("degree_name")%>'>
                            <%=myrs.getString("degree_name")%> from <%=myrs.getString("department_name")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
        
       
        <button type="submit" name="action" value="submit">Submit</button>
        
    </form>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    myrs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();

                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
