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
			<%@ page import="java.io.BufferedReader" %>
			<%@ page import="java.util.HashMap" %>
			<%@ page import="java.sql.Time" %>
			<%@ page import="java.util.ArrayList" %>
			
			
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
					ResultSet myrs3= null;
					ResultSet myrs4= null;
					ResultSet myrs5= null; 
                    Statement stmt = null;
					int first_day=0;
					int second_day=0; 
					 HashMap<String,Time> st=new HashMap<String,Time>();  
					 ArrayList d_and_t = new ArrayList<>(); 
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select d.number_day from Day_To_Int d WHERE d.day = ?");
                    pstmt.setString(1, request.getParameter("First_Day"));
                    myrs1 = pstmt.executeQuery();
					
					PreparedStatement pstmt2 = conn.prepareStatement("select d.number_day from Day_To_Int d WHERE d.day = ?");
                    pstmt2.setString(1, request.getParameter("Second_Day"));
                    myrs2 = pstmt2.executeQuery();
					
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Courses For Student <%=request.getParameter("SSN_value")%></th>
						
                    </tr>
                    <tr>
                    
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
							first_day = myrs1.getInt("number_day"); 
                        }
                    %>
					<%
					while (myrs2.next()) {
							second_day = myrs2.getInt("number_day"); 
                        }
						
					%>
                    </table>
                    <%
					
					PreparedStatement pstmt3 = conn.prepareStatement("select ct.ssn "+
							"from Class_Taking ct, Class c "+
							"where c.class_id = ? AND ct.course = c.class_id ORDER BY ct.ssn",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt3.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							
							myrs3 = pstmt3.executeQuery();
					%>
                    <table border="1">
                    <tr>
                        <th>Select All Students for section:  <%=request.getParameter("SSN_value")%></th>
						
                    </tr>
                    <tr>
                    <th>Class </th>
                    <th>Class Name </th>
					<th>Days</th>
					<th>Quarter</th>
					<th>Start TIme</th>
					<th>End Time</th>
					<th>First Name</th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs3.next()) {
						PreparedStatement pstmt4 = conn.prepareStatement("select distinct ct.course, c.course_number, c.days, c.quarter, c.start_time, c.end_time, s.first_name "+
						"from Class_Taking ct, Class c, Student s, Discussion d "+
						"where s.ssn = ? AND ct.SSN = s.ssn AND ct.course=c.class_id ");
						pstmt4.setInt(1, myrs3.getInt("ssn"));
						myrs4 = pstmt4.executeQuery();
						
					
						while(myrs4.next())
						{
							if(myrs4.getString("days").equals("MWF"))
							{
								if(!d_and_t.contains("M " + myrs4.getTime("start_time").toString()))
								{
								d_and_t.add("M " + myrs4.getTime("start_time").toString()); 
								d_and_t.add("W " + myrs4.getTime("start_time").toString()); 
								d_and_t.add("F " + myrs4.getTime("start_time").toString()); 
								}
							}
							else if(myrs4.getString("days").equals("TuTh"))
							{
								if(!d_and_t.contains("Tu " + myrs4.getTime("start_time").toString()))
								{
								d_and_t.add("Tu " + myrs4.getTime("start_time").toString()); 
								d_and_t.add("Th " + myrs4.getTime("start_time").toString()); 
								}
							}
							
							
						%>
						<tr>
                       
							<td>
								<%=myrs4.getString("course")%>
							</td>
							<td>
								<%=myrs4.getString("course_number")%>
							</td>
							<td>
								<%=myrs4.getString("days")%>
							</td>
							<td>
								<%=myrs4.getString("quarter")%>
							</td>
							<td>
								<%=myrs4.getTime("start_time")%>
							</td>
							<td>
								<%=myrs4.getTime("end_time")%>
							</td>
							<td>
								<%=myrs4.getString("first_name")%>
							</td>
							
						
						
						</tr>
                    <%
						}
						}
					%>
                    </table>
                    <%
					int x=0;
					%>
					<table border="1">
					 <tr>
                        <th>Possible Review Session Days For Section: <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    
                    </tr>
					<% 
					{
						PreparedStatement pstmt6 = conn.prepareStatement("select ct.ssn "+
							"from Class_Taking ct, Class c "+
							"where c.class_id = ? AND ct.course = c.class_id ORDER BY ct.ssn",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
							pstmt6.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
							
							myrs3 = pstmt6.executeQuery();
					   while(myrs3.next()){
						PreparedStatement pstmt5 = conn.prepareStatement("select distinct ct.course, c.course_number, c.days, c.quarter, c.start_time, c.end_time, s.first_name,d.days as DAYS2,d.start_time AS TIME2 "+
						"from Class_Taking ct, Class c, Student s, Discussion d "+
						"where s.ssn = ? AND ct.SSN = s.ssn AND ct.course=c.class_id AND c.class_id=d.class_id ");
						pstmt5.setInt(1, myrs3.getInt("ssn"));
						myrs5 = pstmt5.executeQuery();
						while(myrs5.next()){
						    d_and_t.add(myrs5.getString("DAYS2") + " " + myrs5.getTime("TIME2").toString()); 
						}
					   }
						String time="";
						String display_time="";
						int time_value = 0; 
						for(int i=first_day; i<=second_day;i++)
						{
							time_value = 8; 
							for(int j=0; j<12;j++)
							{
								if(i==0)
								{
									
									time = "M " +Integer.toString(time_value) + ":00:00"; 
									if(!d_and_t.contains(time))
										{
											display_time = time + " - " + Integer.toString(time_value+1) + ":00:00";;
										}
										else
										{
										display_time="";
										}
									
									
								}
								if(i==1)
								{
									
									
									time = "Tu " +Integer.toString(time_value) + ":00:00"; 
									if(!d_and_t.contains(time))
										{
											display_time = time + " - " + Integer.toString(time_value+1) + ":00:00";;
										}
										else
										{
										display_time="";
										}
									
								}
								if(i==2)
								{
									
									time = "W " +Integer.toString(time_value) + ":00:00"; 
									if(!d_and_t.contains(time))
										{
											display_time = time + " - " + Integer.toString(time_value+1) + ":00:00";;
										}
										else
										{
										display_time="";
										}
									
								}
								if(i==3)
								{
									
									time = "Th " +Integer.toString(time_value) + ":00:00"; 
									if(!d_and_t.contains(time))
										{
											display_time = time + " - " + Integer.toString(time_value+1) + ":00:00";;
										}
										else
										{
										display_time="";
										}
									
								}
								if(i==4)
								{
									
									
									time = "F " +Integer.toString(time_value) + ":00:00"; 
									if(!d_and_t.contains(time))
										{
											display_time = time + " - " + Integer.toString(time_value+1) + ":00:00";;
										}
										else
										{
											display_time="";
										}
									
								}
								%>
								<tr>
                       
					
						
								<td>
									<%=display_time%>
								</td>
						
                       
                       
								</tr>
								<%
								time_value++; 
							}
						}
						
					x++;
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
               
                myrs = statement.executeQuery("select distinct c.class_ID, sc.class_name " +
				"from Class c, Schedule_Class sc where c.course_number = sc.course_number ORDER BY c.class_ID");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="seventh_query.jsp" method="POST">
        
        <div>
            Select Course:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getInt("class_ID")%>'>
                            <%=myrs.getInt("class_ID")%>, <%=myrs.getString("class_name")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
         <%
                 // Select all possible undergrad degrees to go witho our student X
                myrs = statement.executeQuery("select d.day " +
                                                "from Day_To_Int d");
                
            %>
            <hr>

            <br />
        <div>
            Select First Day:
            <select name="First_Day">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getString("day")%>'>
                            <%=myrs.getString("day")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
		 <%
                 // Select all possible undergrad degrees to go witho our student X
                myrs = statement.executeQuery("select d.day " +
                                                "from Day_To_Int d");
                
            %>
            <hr>

            <br />
        <div>
            Select Second Day:
            <select name="Second_Day">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getString("day")%>'>
                            <%=myrs.getString("day")%>  
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
