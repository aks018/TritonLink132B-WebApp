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
                        // INSERT the course_entry attributes INTO the course_entry table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_entry VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setString(
                            1, request.getParameter("Course Number"));
                        pstmt.setString(2, request.getParameter("Grade Option"));
                       pstmt.setString(3, request.getParameter("Units"));
                        pstmt.setString(4, request.getParameter("Lab Option"));
                        pstmt.setString(5, request.getParameter("Discussion Option"));
						pstmt.setString(6, request.getParameter("Review Option"));
						pstmt.setString(7, request.getParameter("Department"));
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
                        // UPDATE the course_entry attributes in the course_entry table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE course_entry SET ID = ?, First Name = ?, " +
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
                        // DELETE the course_entry FROM the course_entry table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM course_entry WHERE SSN = ?");

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
                    // the course_entry attributes FROM the course_entry table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_entry");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Course Number</th>
                        <th>Grade Option</th>
			<th>Units</th>
                        <th>Lab Option</th>
                        <th>Discussion Option</th>
						<th>Review Option </th>
						<th>Department</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="course_entry.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course Number" size="10"></th>
                            <th><input value="" name="Grade Option" size="15"></th>
			    <th><input value="" name="Units" size="10"></th>
                            <th><input value="" name="Lab Option" size="10"></th>
                            <th><input value="" name="Discussion Option" size="10"></th>
							<th><input value="" name="Review Option" size="10"></th>
							<th><input value="" name="Department" size="35"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="course_entry.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("Course Number") %>" 
                                    name="Course Number" size="10">
                            </td>
    
                            
    
                            <%-- Get the First Name --%>
                            <td>
                                <input value="<%= rs.getString("Grade Option") %>"
                                    name="Grade Option" size="15">
                            </td>
    
                            <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getInt("Units") %>" 
                                    name="Units" size="15">
                            </td>
    
			    <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getString("Lab Option") %>" 
                                    name="Lab Option" size="15">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("Discussion Option") %>" 
                                    name="Discussion Option" size="15">
                            </td>
							 <td>
                                <input value="<%= rs.getString("Review Option") %>" 
                                    name="Discussion Option" size="15">
                            </td>
							<td>
                                <input value="<%= rs.getString("Department") %>" 
                                    name="Discussion Option" size="35">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course_entry.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("Course Number") %>" name="Course Number">
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
