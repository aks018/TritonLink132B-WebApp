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
					ResultSet myrs2 = null;
                    Statement stmt = null;
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
					String value =  request.getParameter("Course_Number"); 
					String[] test; 
					test = value.split(","); 
					int A_count=0;
					int B_count=0;
					int C_count=0;
					int D_count=0; 
					int other_count=0;
                   PreparedStatement pstmt = conn.prepareStatement("select distinct ct.course, ct.quarter, ct.year, ct.ssn, ct.grade "+
                    "from Class_Taken ct "+
                    "where ct.course = ?");
                    pstmt.setString(1, request.getParameter("Course_Number"));
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Grades Over The Years for:  <%=request.getParameter("Course_Number")%></th>
                    </tr>
                    <tr>
                    <th>A </th>
					<th>B </th>
					<th>C </th>
					<th>D </th>
					<th>Other </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
						
						
							String grade = myrs1.getString("grade"); 
							if(grade.equals("A") || grade.equals("A-") || grade.equals("A+"))
							{
								A_count++;
								
							}
							if(grade.equals("B") || grade.equals("B-") || grade.equals("B+"))
							{
								B_count++;
								
							}
							if(grade.equals("C+") || grade.equals("C-") || grade.equals("C"))
							{
								C_count++;
								
							}
							if(grade.equals("D") || grade.equals("D-") || grade.equals("D"))
							{
								D_count++;
								
							}
							if(grade.equals("F"))
							{
								other_count++;
								
							}
								
                  
                        
					}
					%>		
							 <tr>
                        <td>
                            <%=A_count%>
                        </td>
						<td>
                            <%=B_count%>
                        </td><td>
                            <%=C_count%>
                        </td>
						<td>
                            <%=D_count%>
                        </td>
						<td>
                            <%=other_count%>
                        </td>
						  
						
                       
                       
                    </tr>
                   
                    
					
                  
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
                 //                               "from Faculty_Teaching");
                myrs = statement.executeQuery("select distinct s.course_number from Faculty_Teaching s where s.section=11");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="part3_third.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="Course_Number">
                <%
                    while(myrs.next()){
						String combined_value = myrs.getString("course_number"); 
                        %>
                        <option value='<%=combined_value%>'>
                            <%=myrs.getString("course_number")%> 
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
