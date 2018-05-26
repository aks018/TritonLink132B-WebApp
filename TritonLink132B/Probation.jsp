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
                        // INSERT the Probation attributes INTO the Probation table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Probation VALUES (?, ?, ?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Probation_ID")));
                        pstmt.setString(3, request.getParameter("Reason"));
                       pstmt.setDate(4, java.sql.Date.valueOf(request.getParameter("Start_Time_Frame")));
                        pstmt.setDate(5, java.sql.Date.valueOf(request.getParameter("End_Time_Frame")));
                        
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
                        // UPDATE the Probation attributes in the Probation table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Probation SET ID = ?, First Name = ?, " +
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
                        // DELETE the Probation FROM the Probation table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Probation WHERE SSN = ?");

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
                    // the Probation attributes FROM the Probation table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Probation");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>Probation_ID</th>
                        <th>Reason</th>
			<th>Start_Time_Frame</th>
                        <th>End_Time_Frame</th>
                        
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SID" size="10"></th>
                            <th><input value="" name="Probation_ID" size="10"></th>
                            <th><input value="" name="Reason" size="80"></th>
			    <th><input value="" name="Start_Time_Frame" size="15"></th>
                            <th><input value="" name="End_Time_Frame" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Probation.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("SID") %>" 
                                    name="SID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("Probation_ID") %>" 
                                    name="Probation_ID" size="10">
                            </td>
    
                            <%-- Get the First Name --%>
                            <td>
                                <input value="<%= rs.getString("Reason") %>"
                                    name="Reason" size="80">
                            </td>
    
                            <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getDate("Start_Time_Frame") %>" 
                                    name="Start_Time_Frame" size="15">
                            </td>
    
			    <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getDate("End_Time_Frame") %>" 
                                    name="End_Time_Frame" size="15">
                            </td>

                          
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Probation.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("SID") %>" name="SID">
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
										out.println("Made it"); 

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
