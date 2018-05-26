<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {  
                    // Load Oracle Driver class file 
                    DriverManager.registerDriver(new org.postgresql.Driver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                    ("jdbc:postgresql:cse132b?user=postgres&password=admin");

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to 
                        // INSERT the Class attributes INTO the Class table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Class VALUES (?,?,?,?,?,?,?,?)");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("class_id")));
                        pstmt.setString(2, request.getParameter("course_number"));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
						pstmt.setString(4, request.getParameter("days"));
						pstmt.setTime(5, java.sql.Time.valueOf(request.getParameter("start_time")));
						pstmt.setTime(6, java.sql.Time.valueOf(request.getParameter("end_time")));
						pstmt.setString(7, request.getParameter("quarter"));
						pstmt.setInt(8, Integer.parseInt(request.getParameter("enroll_limit")));
                        int rowCount = pstmt.executeUpdate();
 
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the Class attributes in the Class table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Class SET ID = ?, First Name = ?, " +
                            "Middle Name = ?, Last Name = ?, Residency = ? WHERE SSN = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setString(2, request.getParameter("First Name"));
                        pstmt.setString(3, request.getParameter("Middle Name"));
                        pstmt.setString(4, request.getParameter("Last Name"));
                        pstmt.setString(5, request.getParameter("Residency"));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("SSN")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the Class FROM the Class table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Class WHERE SSN = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SSN")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the Class attributes FROM the Class table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Class");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>class_id</th>
                        <th>course_number</th>
                        <th>year</th>
						<th>days</th>
                        <th>start_time</th>
                        <th>end_time</th>
						<th>quarter</th>
						<th>enroll_limit</th>
                        <th>Action</th>
						
                    </tr>
                    <tr>
                        <form action="Class.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="class_id" size="10"></th>
                            <th><input value="" name="course_number" size="10"></th>
                            <th><input value="" name="year" size="15"></th>
							<th><input value="" name="days" size="15"></th>
                            <th><input value="" name="start_time" size="15"></th>
                            <th><input value="" name="end_time" size="15"></th>
							<th><input value="" name="quarter" size="15"></th>
							<th><input value="" name="enroll_limit" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet 
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Class.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("class_id") %>" 
                                    name="class_id" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("course_number") %>" 
                                    name="course_number" size="10">
                            </td>
    
                            <%-- Get the First Name --%>
                            <td>
                                <input value="<%= rs.getInt("year") %>"
                                    name="year" size="15">
                            </td>
    
                            <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getString("days") %>" 
                                    name="days" size="15">
                            </td>
    
			    <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getTime("start_time") %>" 
                                    name="start_time" size="15">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getTime("end_time") %>" 
                                    name="end_time" size="15">
                            </td>
							 <td>
                                <input value="<%= rs.getString("quarter") %>" 
                                    name="quarter" size="15">
                            </td>
							<td>
                                <input value="<%= rs.getInt("enroll_limit") %>" 
                                    name="enroll_limit" size="15">
                            </td>
    
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Class.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("class_id") %>" name="SSN">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
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