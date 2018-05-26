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
                        // INSERT the Masters_Degree attributes INTO the Masters_Degree table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Masters_Degree VALUES (?,?,?)");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
						pstmt.setString(2, request.getParameter("Degree_Name")); 
						
                        pstmt.setString(3, request.getParameter("Concentration"));
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
                        // UPDATE the Masters_Degree attributes in the Masters_Degree table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Masters_Degree SET ID = ?, First Name = ?, " +
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
                        // DELETE the Masters_Degree FROM the Masters_Degree table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Masters_Degree WHERE SSN = ?");

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
                    // the Masters_Degree attributes FROM the Masters_Degree table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Masters_Degree");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>ID</th>
						<th>Degree_Name</th>
                        <th>Concentration</th>
                    </tr>
                    <tr>
                        <form action="Masters_Degree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ID" size="30"></th>
							<th><input value="" name="Degree_Name" size="30"></th>
							<th><input value="" name="Concentration" size="30"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Masters_Degree.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("ID") %>" 
                                    name="ID size="30">
                            </td>
							<td>
                                <input value="<%= rs.getString("Degree_Name") %>" 
                                    name="Degree_Name size="30">
                            </td>
							<td>
                                <input value="<%= rs.getString("Concentration") %>" 
                                    name="Concentration size="30">
                            </td>
    
                         
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Masters_Degree.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("ID") %>" name="Degree_Name">
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
