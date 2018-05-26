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
                    Statement stmt = null;
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select distinct ct.course, c.course_number, ct.units, ct.grade_option, c.year, c.days, c.quarter, c.start_time, c.end_time, sc.class_name "+
                    "from Class_Taking ct, Class c, Student s, Discussion d, Schedule_Class sc "+
                    "where s.ssn = ? AND ct.SSN = s.ssn AND ct.course=c.class_id AND sc.course_number = c.course_number");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Courses For Student <%=request.getParameter("SSN_value")%></th>
                    </tr> 
                    <tr>
                    <th>Class </th>
                    <th>Class Name </th>
					<th>Course Name </th>
                    <th>Units </th>
                    <th>Grade Option</th>
					<th>Year</th>
					<th>Days</th>
					<th>Quarter</th>
					<th>Start TIme</th>
					<th>End Time</th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=myrs1.getInt("course")%>
                        </td>
						<td>
                            <%=myrs1.getString("course_number")%>
                        </td>
						<td>
                            <%=myrs1.getString("class_name")%>
                        </td>
						<td>
                            <%=myrs1.getInt("units")%>
                        </td>
						<td>
                            <%=myrs1.getString("grade_option")%>
                        </td>
						<td>
                            <%=myrs1.getInt("year")%>
                        </td>
						<td>
                            <%=myrs1.getString("days")%>
                        </td>
						<td>
                            <%=myrs1.getString("quarter")%>
                        </td>
						<td>
                            <%=myrs1.getTime("start_time")%>
                        </td>
						<td>
                            <%=myrs1.getTime("end_time")%>
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
                myrs = statement.executeQuery("select distinct s.ID, s.First_Name, s.Middle_Name, s.Last_Name from Student s, Class_Taking c where c.SSN = s.ID ORDER BY ID");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="first_query.jsp" method="POST">
        
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
