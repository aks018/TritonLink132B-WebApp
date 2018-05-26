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
                        // INSERT the Class_Taken attributes INTO the Class_Taken table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Class_Taken VALUES (?,?,?,?,?,?,?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN")));
						pstmt.setString(2, request.getParameter("Course"));
						pstmt.setString(3, request.getParameter("Grade"));
						pstmt.setString(4, request.getParameter("Quarter"));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("Year")));
						pstmt.setInt(6, Integer.parseInt(request.getParameter("Units")));
						pstmt.setString(7, request.getParameter("Grade_Option"));
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
                        // UPDATE the Class_Taken attributes in the Class_Taken table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Class_Taken SET Grade=? " +
                            " WHERE SSN = ? AND Course=? AND Quarter=? AND Year=?");

						
						pstmt.setString(1, request.getParameter("Grade"));
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("SSN")));
						pstmt.setString(3, request.getParameter("Course"));
						pstmt.setString(4, request.getParameter("Quarter"));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("Year")));
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
                        // DELETE the Class_Taken FROM the Class_Taken table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Class_Taken WHERE SSN = ?");

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
                    // the Class_Taken attributes FROM the Class_Taken table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Class_Taken");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
						<th>Course</th>
						<th>Grade</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Units</th>
						<th>Grade_Option</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Class_Taken.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
							<th><input value="" name="Course" size="30"></th>
							<th><input value="" name="Grade" size="5"></th>
							<th><input value="" name="Quarter" size="30"></th>
							<th><input value="" name="Year" size="10"></th>
							<th><input value="" name="Units" size="10"></th>
							<th><input value="" name="Grade_Option" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Class_Taken.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="30">
                            </td>
							<td>
                                <input value="<%= rs.getString("Course") %>" 
                                    name="Course" size="30">
                            </td>
							<td>
                                <input value="<%= rs.getString("Grade") %>" 
                                    name="Grade" size="5">
                            </td>
							<td>
                                <input value="<%= rs.getString("Quarter") %>" 
                                    name="Quarter" size="30">
                            </td>
							<td>
                                <input value="<%= rs.getInt("Year") %>" 
                                    name="Year" size="10">
                            </td>
							<td>
                                <input value="<%= rs.getInt("Units") %>" 
                                    name="Units" size="10">
                            </td>
							<td>
                                <input value="<%= rs.getString("Grade_Option") %>" 
                                    name="Grade_Option" size="5">
                            </td>
                         
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Class_Taken.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("SSN") %>" name="SSN">
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
