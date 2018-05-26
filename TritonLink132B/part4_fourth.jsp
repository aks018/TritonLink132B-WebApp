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
					int gpa_count=0;
					double double_average_gpa =0; 
                    PreparedStatement pstmt = conn.prepareStatement("select distinct ft.course_number,ft.year,ft.faculty_name,ft.quarter "+
                    "from Faculty_Teaching ft "+
                    "where ft.course_number=? AND ft.faculty_name=?");
                    pstmt.setString(1, test[0]);
					pstmt.setString(2, test[1]);
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Average GPA Over The Years for:  <%=test[1]%></th>
                    </tr>
                    <tr>
                    <th>Average GPA</th>
					
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
						PreparedStatement pstmt2 = conn.prepareStatement("select distinct ct.course, ct.quarter, ct.year, gc.number_grade "+
						"from Class_Taken ct, Grade_Conversion gc "+
						"where ct.course = ? AND ct.quarter=? AND ct.year = ? AND gc.LETTER_GRADE=ct.grade GROUP BY ct.course, ct.quarter, ct.year, gc.number_grade ");
						pstmt2.setString(1, myrs1.getString("course_number"));
						pstmt2.setString(2, myrs1.getString("quarter"));
						pstmt2.setInt(3, myrs1.getInt("year"));
						myrs2 = pstmt2.executeQuery();
						while (myrs2.next()) {
							
								double_average_gpa+=myrs2.getDouble("number_grade"); 
								gpa_count++;
                        }
					}
					%>		
							 <tr>
                        
						<td>
                            <%=double_average_gpa/gpa_count%>
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
                myrs = statement.executeQuery("select distinct s.course_number, s.faculty_name from Faculty_Teaching s where s.section=11");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="part4_fourth.jsp" method="POST">
        
        <div>
            Select Student: 
            <select name="Course_Number">
                <%
                    while(myrs.next()){
						String combined_value = myrs.getString("course_number") + "," + myrs.getString("faculty_name"); 
                        %>
                        <option value='<%=combined_value%>'>
                            <%=myrs.getString("course_number")%>, <%=myrs.getString("faculty_name")%> 
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
