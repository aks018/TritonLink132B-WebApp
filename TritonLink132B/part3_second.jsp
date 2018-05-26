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
					int F_count=0;
					String course="";
					String name="";
					int other_count=0;
                     PreparedStatement pstmt = conn.prepareStatement("select * "+
                    "from CPG ct "+
                    "where ct.course = ? AND ct.faculty_name=?");
                    pstmt.setString(1, test[0]);
					pstmt.setString(2, test[1]);
					name = test[1];
					course = test[0]; 
                    myrs1 = pstmt.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Grades Over The Years for:  <%=test[1]%></th>
                    </tr>
                    <tr>
					<th>Faculty</th>
					<th>Course </th>
                    <th>A </th>
					<th>B </th>
					<th>C </th>
					<th>D </th>
					<th>F </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
						A_count=myrs1.getInt("A");
							B_count=myrs1.getInt("B");
							 C_count=myrs1.getInt("C");
							 D_count=myrs1.getInt("D");
							 F_count=myrs1.getInt("F");
							 name = myrs1.getString("faculty_name");
							course = myrs1.getString("course");
					}
					%>		
							 <tr>
						 <td>
                            <%=name%>
                        </td>
						 <td>
                            <%=course%>
                        </td>
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
                            <%=F_count%>
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
    <form action="part3_second.jsp" method="POST">
        
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
