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
                    PreparedStatement pstmt = conn.prepareStatement("select distinct s.ssn, s.first_name, s.middle_name, s.last_name, ct.units, ct.grade_option "+
                    "from Class c, Class_Taking ct, Student s,Schedule_Class sc "+
                    "where sc.class_name = ? AND sc.course_number = c.course_number AND ct.course=c.class_id AND s.ssn=ct.SSN "); 
                    pstmt.setString(1, request.getParameter("SSN_value"));
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Course: <%=request.getParameter("SSN_value")%></th>
                    </tr>
                    <tr>
                    <th>SSN </th>
                    <th>First Name</th>
                    <th>Middle Name </th>
                    <th>Last Name</th>
					<th>Units</th>
					<th>Grade Option</th>
					
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=myrs1.getInt("SSN")%>
                        </td>
						 <td>
                            <%=myrs1.getString("first_name")%>
                        </td>
						 <td>
                            <%=myrs1.getString("middle_name")%>
                        </td>
						 <td>
                            <%=myrs1.getString("last_name")%>
                        </td>
						<td>
                            <%=myrs1.getInt("units")%>
                        </td>
						<td>
                            <%=myrs1.getString("grade_option")%>
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
               // PreparedStatement pstmt2 = conn.prepareStatement("select unique Course_Number, Quarter, Year, class_id " +
                 //                               "from Class");
                myrs = statement.executeQuery("select distinct s.class_name, c.Course_Number, c.Quarter, c.Year from Class c, Schedule_Class s where s.course_number = c.Course_Number ORDER BY Course_Number");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="second_query.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getString("class_name")%>'>
                            <%=myrs.getString("Course_Number")%>, <%=myrs.getString("Quarter")%>, <%=myrs.getString("Year")%>
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
