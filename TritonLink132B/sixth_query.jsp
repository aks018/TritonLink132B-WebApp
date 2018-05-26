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
					ResultSet myrs3 = null;
					ResultSet myrs4 = null;
					
                    Statement stmt = null;
					ArrayList courseName = new ArrayList<>(); 
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select distinct ct.course, c.start_time, c.end_time, c.days, sc.class_name, c.course_number "+
                    "from Class_Taking ct, Student s, Class c, Schedule_Class sc "+
                    "where s.ssn = ? AND ct.SSN = s.ssn AND c.class_id=ct.course AND sc.course_number=c.course_number ");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Courses That Conflict For Student <%=request.getParameter("SSN_value")%></th>
                    </tr>
                    <tr>
                   
					<th>Course Number</th>
					<th>Class Name</th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
							PreparedStatement pstmt2 = conn.prepareStatement("select distinct ct.course, c.start_time, c.end_time, c.days, sc.class_name, c.course_number "+
							"from Class_Taking ct, Class c,Schedule_Class sc "+
							"where c.start_time=? AND c.days LIKE ? AND ct.course=c.class_id AND c.course_number=sc.course_number");
							
							pstmt2.setTime(1, myrs1.getTime("start_time"));
							pstmt2.setString(2, myrs1.getString("days"));
							
							
							myrs2 = pstmt2.executeQuery(); 
							
							
							while(myrs2.next())
							{
								PreparedStatement pstmt3 = conn.prepareStatement("select count(c.course_number) as COUNTING from Class c where c.course_number =?");
								pstmt3.setString(1, myrs2.getString("course_number"));
								myrs3 = pstmt3.executeQuery();
								myrs3.next();

								//intTrack=myrs3.getInt("COUNTING");
								if(myrs3.getInt("COUNTING")==1){
                    %>
                    <tr>
						<td>
                            <%=myrs2.getString("course_number")%>
                        </td>
						<td>
                            <%=myrs2.getString("class_name")%>
                        </td>

                    </tr> 
                    <%
								}
								else if(myrs1.getString("course_number").equals(myrs2.getString("course_number")))
								{
									courseName.add(myrs2.getString("course_number"));
								}
							}
						} 
                    %>
                    </table>
					 <table border="1">
                    <tr>
                        <th>Displaying Courses That Conflict For Student <%=request.getParameter("SSN_value")%></th>
                    </tr>
                    <tr>
                   
					<th>Course Number</th>
					<th>Class Name</th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
					  
                       for(int i=0; i<courseName.size(); i++)
					   {
						   PreparedStatement pstmt4 = conn.prepareStatement("select distinct c.course_number, sc.class_name from Class c, Schedule_Class sc where c.course_number =? AND sc.course_number=c.course_number");
						   pstmt4.setString(1, courseName.get(i).toString());
						   myrs4 = pstmt4.executeQuery();
						   while(myrs4.next())
						   {
                    %>
                    <tr>
						<td>
                            <%=myrs4.getString("course_number")%>
                        </td>
						<td>
                            <%=myrs4.getString("class_name")%>
                        </td>

                    </tr> 
                    <%
						   }
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
               // PreparedStatement pstmt2 = conn.prepareStatement("select ID, First_Name, Middle_Name, Last_Name " +
                 //                               "from Student");
                myrs = statement.executeQuery("select distinct s.ID, s.First_Name, s.Middle_Name, s.Last_Name from Student s, Class_Taking c where c.SSN = s.ID ORDER BY ID");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="sixth_query.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getInt("ID")%>'>
                            <%=myrs.getInt("ID")%>, <%=myrs.getString("First_Name")%> <%=myrs.getString("Last_Name")%>
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
 EXCEPT 