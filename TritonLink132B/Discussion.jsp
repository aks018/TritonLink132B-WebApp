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
                    // Load Oracle Driver Discussion file 
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
                        // INSERT the Discussion attributes INTO the Discussion table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Discussion VALUES (?,?,?,?,?,?)");
						
						pstmt.setInt(1, Integer.parseInt(request.getParameter("Discussion_ID")));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("Class_ID")));
						pstmt.setString(3,request.getParameter("Location"));
						pstmt.setString(4,request.getParameter("Days"));
						pstmt.setTime(5,java.sql.Time.valueOf(request.getParameter("Start_Time")));
						pstmt.setTime(6,java.sql.Time.valueOf(request.getParameter("End_Time")));


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
                        // UPDATE the Discussion attributes in the Discussion table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Discussion SET ID = ?, First Name = ?, " +
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
                        // DELETE the Discussion FROM the Discussion table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Discussion WHERE SSN = ?");

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
                    // the Discussion attributes FROM the Discussion table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Discussion");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Discussion_ID</th>
						<th>Class_ID</th>
						<th>Location</th>
						<th>Days</th>
						<th>Start_Time</th>
						<th>End_Time</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Discussion.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Discussion_ID" size="30"></th>
							<th><input value="" name="Class_ID" size="30"></th>
							<th><input value="" name="Location" size="30"></th>
							<th><input value="" name="Days" size="10"></th>
							<th><input value="" name="Start_Time" size="30"></th>
							<th><input value="" name="End_Time" size="30"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Discussion.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("Discussion_ID") %>" 
                                    name="Discussion_ID size="30">
                            </td>
							<td>
                                <input value="<%= rs.getInt("Class_ID") %>" 
                                    name="Class_ID size="30">
                            </td>

							<td>
                                <input value="<%= rs.getString("Location") %>" 
                                    name="Location size="30">
                            </td>
							<td>
                                <input value="<%= rs.getString("Days") %>" 
                                    name="Days size="30">
                            </td>
							<td>
                                <input value="<%= rs.getTime("Start_Time") %>" 
                                    name="Start_Time size="30">
                            </td>
							<td>
                                <input value="<%= rs.getTime("End_Time") %>" 
                                    name="Start_Time size="30">
                            </td>
							
    
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Discussion.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("Discussion_ID") %>" name="Discussion_ID">
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
