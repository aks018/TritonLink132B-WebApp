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
                        // INSERT the Candidate attributes INTO the Candidate table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Candidate VALUES (?,?)");

                        pstmt.setInt(2, Integer.parseInt(request.getParameter("P_SSN")));
						pstmt.setString(1, request.getParameter("Thesis"));
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
                        // UPDATE the Candidate attributes in the Candidate table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Candidate SET ID = ?, First Name = ?, " +
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
                        // DELETE the Candidate FROM the Candidate table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Candidate WHERE SSN = ?");

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
                    // the Candidate attributes FROM the Candidate table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Candidate");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Candidate SSN</th>
                        <th> Thesis </th> 
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Candidate.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="P_SSN" size="30"></th>
							<th><input value="" name="Thesis" size="30"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Candidate.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("P_SSN") %>" 
                                    name="P_SSN size="30">
                            </td>
							 <td>
                                <input value="<%= rs.getString("Thesis") %>" 
                                    name="Thesis size="30">
                            </td>
                         
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Candidate.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("P_SSN") %>" name="P_SSN">
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
