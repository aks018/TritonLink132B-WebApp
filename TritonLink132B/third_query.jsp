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
                    Statement stmt = null;
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select distinct ct.SSN, c.course_number, ct.quarter, ct.year, c.class_name, ct.grade, ct.units "+
                    "from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Class_Quarter_Offered cqo "+
                    "where ct.ssn = ? AND s.ssn=ct.ssn AND c.course_number=ct.course ORDER BY ct.quarter, ct.year ");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
                    myrs1 = pstmt.executeQuery();
					
					PreparedStatement pstmt2 = conn.prepareStatement("select distinct ct.quarter, ct.year, avg(NUMBER_GRADE) as average_grade "+
                    "from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Class_Quarter_Offered cqo "+
                    "where ct.ssn = ? AND s.ssn=ct.ssn AND c.course_number=ct.course AND gc.LETTER_GRADE = ct.grade GROUP BY ct.quarter, ct.year ");
					pstmt2.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
					myrs2 = pstmt2.executeQuery();
					
					PreparedStatement pstmt3 = conn.prepareStatement("select avg(NUMBER_GRADE) as average_grade "+
                    "from Class_Taken ct, Student s, Schedule_Class c, Grade_Conversion gc, Class_Quarter_Offered cqo "+
                    "where ct.ssn = ? AND s.ssn=ct.ssn AND c.course_number=ct.course AND gc.LETTER_GRADE = ct.grade ");
					pstmt3.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
					myrs3 = pstmt3.executeQuery();
                   
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Courses For Student <%=request.getParameter("SSN_value")%></th>
                    </tr>
                    <tr>
                    <th>SSN </th>
                    <th>Course Number </th>
					<th>Quarter </th>
					<th>Year </th>
					<th>Class Name </th>
					<th>Grade </th>
					<th>Units </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=myrs1.getInt("ssn")%>
                        </td> <td>
                            <%=myrs1.getString("course_number")%>
                        </td>
						<td>
                            <%=myrs1.getString("quarter")%>
                        </td>
						<td>
                            <%=myrs1.getInt("year")%>
                        </td>
						<td>
                            <%=myrs1.getString("class_name")%>
                        </td>
						<td>
                            <%=myrs1.getString("grade")%>
                        </td>
						<td>
                            <%=myrs1.getInt("units")%>
                        </td>
						
                       
                       
                    </tr>
                    <%
                        }
                    %>
                    </table>
					<table border="1">
					 <tr>
                        <th>Displaying GPA Per Quarter For Student <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    <th>Quarter </th>
                    <th>Year</th>
					<th>GPA </th>
					
                    </tr>
					<% while(myrs2.next())
					{
						%>
						<tr>
                       
						<td>
                            <%=myrs2.getString("quarter")%>
                        </td>
						<td>
                            <%=myrs2.getInt("year")%>
                        </td>
						<td>
                            <%=myrs2.getDouble("average_grade")%>
                        </td>
						
                       
                       
                    </tr>
					<%
					}
					%>
					</table>
					<table border="1">
					 <tr>
                        <th>Displaying Cummlative GPA For Student <%=request.getParameter("SSN_value")%></th>
                    </tr>
					<tr>
                    <th>Cummlative GPA </th>
                   
					
                    </tr>
					<% while(myrs3.next())
					{
						%>
						<tr>
                       
					
						<td>
                            <%=myrs3.getDouble("average_grade")%>
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
               // PreparedStatement pstmt2 = conn.prepareStatement("select ID, First_Name, Middle_Name, Last_Name " +
                 //                               "from Student");
                myrs = statement.executeQuery("select distinct s.ID, s.First_Name, s.Middle_Name, s.Last_Name from Student s, Class_Taken ct WHERE ct.ssn=s.ssn ORDER BY ID");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="third_query.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getInt("ID")%>'>
                            <%=myrs.getInt("ID")%>, <%=myrs.getString("First_Name")%>  <%=myrs.getString("Last_Name")%>
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
