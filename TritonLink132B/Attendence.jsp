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
                        // INSERT the Attendence attributes INTO the Attendence table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Attendence VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Attendence_ID")));
                        pstmt.setString(3, request.getParameter("Start_Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Start_Year")));
						pstmt.setString(5, request.getParameter("End_Quarter"));
						pstmt.setInt(6, Integer.parseInt(request.getParameter("End_Year")));

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
                        // UPDATE the Attendence attributes in the Attendence table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Attendence SET ID = ?, First Name = ?, " +
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
                        // DELETE the Attendence FROM the Attendence table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Attendence WHERE SSN = ?");

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
                    // the Attendence attributes FROM the Attendence table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Attendence");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>Attendence_ID</th>
			<th>Start_Quarter</th>
                        <th>Start_Year</th>
                        <th>End_Quarter</th>
                        <th>End_Year</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Attendence.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SID" size="10"></th>
                            <th><input value="" name="Attendence_ID" size="10"></th>
			    <th><input value="" name="Start_Quarter" size="15"></th>
                            <th><input value="" name="Start_Year" size="15"></th>
							 <th><input value="" name="End_Quarter" size="15"></th>
                            <th><input value="" name="End_Year" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Attendence.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("SID") %>" 
                                    name="SID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("Attendence_ID") %>" 
                                    name="Attendence_ID" size="10">
                            </td>
    
                       
    
                            <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getString("Start_Quarter") %>" 
                                    name="Start_Quarter" size="15">
                            </td>
    
			    <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getInt("Start_Year") %>" 
                                    name="Start_Year" size="15">
                            </td>
							 <td>
                                <input value="<%= rs.getString("End_Quarter") %>" 
                                    name="End_Quarter" size="15">
                            </td>
    
			    <%-- Get the Last Name --%>
                            <td>
                                <input value="<%= rs.getInt("End_Year") %>" 
                                    name="End_Year" size="15">
                            </td>

                          
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Attendence.jsp" method="get">
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
