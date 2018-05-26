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
					ResultSet myrs3 = null;
					ResultSet myrs4 = null;
					ResultSet myrs5 = null;
                    Statement stmt = null;
					int first_value=0;
					int second_value=0;
					int last_value=0;
					int answer =0; 
					int lower_div_units=0;;
					int upper_div_units=0;
					int tech_units =0; 
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement 
                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select ct.ssn, sum(ct.units) as UNITS "+
                    "from Class_Taken ct "+
                    "where ct.ssn = ? GROUP BY ct.ssn, ct.units "); 
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
                    myrs1 = pstmt.executeQuery();
					
					PreparedStatement pstmt3 = conn.prepareStatement("select distinct d.total_units "+
                    "from Degrees d, Student s, Class_Taken ct "+
                    "where s.ssn = ? AND d.degree_name =? AND s.degree=d.degree_name AND s.ssn=ct.ssn");
                    pstmt3.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
					pstmt3.setString(2, request.getParameter("Degree"));
                    myrs3 = pstmt3.executeQuery();

					boolean value = true; 
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %>
                    <table border="1">
                  
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (myrs1.next()) {
							first_value = myrs1.getInt("UNITS");
                    %>
                   
                    <%
                        }
                    %>
                    </table>
					<table border="1">
					<tr>
                        <th>Total Units Required to Graduate with <%=request.getParameter("Degree")%></th>
                    </tr>
                    <tr>
                    <th>Total Units Left</th>
					<th>Total Units Required</th>
					<th>Units Completed </th>
					<% 
					
					while(myrs3.next())
						
						
					{
						last_value = myrs3.getInt("total_units");
						answer = last_value - first_value; 
						%>
						<tr>
                       
						<td>
                            <%=answer%>
                        </td> 
						<td>
                            <%=last_value%>
                        </td> 
						<td>
                            <%=first_value%>
                        </td> 
                       
                       
                    </tr>
					<%
					}
					%>
					</table>
					
                    <%
					
					PreparedStatement pstmt4 = conn.prepareStatement("select distinct d.lower_div_units, d.upper_div_units, d.tech_units  "+
                    "from Degrees d, Student s, Class_Taken ct "+
                    "where s.ssn = ? AND d.degree_name =? AND s.degree=d.degree_name AND s.ssn=ct.ssn ");
                    pstmt4.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
					pstmt4.setString(2, request.getParameter("Degree"));
                    myrs4 = pstmt4.executeQuery();
					%>
					<table border="1">
					
					<% while(myrs4.next())
						
					{
						lower_div_units = myrs4.getInt("lower_div_units");
						upper_div_units = myrs4.getInt("upper_div_units");
						tech_units = myrs4.getInt("tech_units"); 
						%>
						<tr>
                    
                    </tr>
					<%
					}
					%>
					</table>
                     <%
					
					PreparedStatement pstmt5 = conn.prepareStatement("select ct.course, ct.units "+
                    "from Class_Taken ct "+
                    "where ct.ssn = ? GROUP BY ct.ssn, ct.units, ct.course");
                    pstmt5.setInt(1, Integer.parseInt(request.getParameter("SSN_value")));
					
                    myrs5 = pstmt5.executeQuery();
					ResultSet myrs6 = null;
					ResultSet myrs7 = null;
					ResultSet myrs8 = null;
					ResultSet myrs9 = null;
					%>
					<table border="1">
				
					<% while(myrs5.next())
					{
						PreparedStatement pstmt6 = conn.prepareStatement("SELECT Lower_Div from Lower_Div_Course WHERE Lower_Div = ? ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt6.setString(1, myrs5.getString("course"));
						myrs6 = pstmt6.executeQuery();
						if(myrs6.absolute(1)) 
						{
							lower_div_units = lower_div_units - myrs5.getInt("units");
						}
						PreparedStatement pstmt7 = conn.prepareStatement("SELECT Upper_Div from Upper_Div_Course WHERE Upper_Div = ? ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt7.setString(1, myrs5.getString("course"));
						myrs7 = pstmt7.executeQuery();
						if(myrs7.absolute(1)) 
						{
							upper_div_units = upper_div_units - myrs5.getInt("units");
						}
						PreparedStatement pstmt8 = conn.prepareStatement("SELECT course from technical_elective WHERE course = ? ",ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 
						pstmt8.setString(1, myrs5.getString("course"));
						myrs8 = pstmt8.executeQuery();
						if(myrs8.absolute(1)) 
						{
							tech_units = tech_units - myrs5.getInt("units");
						}
						%>
						<tr>
                       
				
						
					
                    </tr>
					<%
					} 
					%>
					</table>
					<table border="1">
                    <tr>
                        <th>Minimum Units Required per Category</th>
                    </tr>
                    <tr>
                    <th>Lower Div</th>
                   
					<th>Upper Div</th> 
					
					<th>Technical </th> 
                    </tr>
                    <%
                        // Iterate over the ResultSet
						
						if(lower_div_units<0)
						{
							lower_div_units=0;
						}
						if(upper_div_units<0)
						{
							upper_div_units=0;
							
						}
						if(tech_units<0)
						{
							tech_units=0; 
						}
                   
                    %>
                    <tr>
					<td>
                            <%=lower_div_units%>
                        </td> 
						<td>
                            <%=upper_div_units%>
                        </td> 
						<td>
                            <%=tech_units%>
                        </td> 
						
                       
                       
                    </tr>
                    <%
                        
                    %>
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
                 //                               "from Student");
                myrs = statement.executeQuery("select distinct s.ID, s.First_Name, s.Middle_Name, s.Last_Name from Student s, Undergraduate u where u.u_ssn = s.ssn ORDER BY ID");
                
                //myrs = pstmt2.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="fourth_query.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_value">
                <%
                    while(myrs.next()){
                        %>
                        <option value='<%=myrs.getInt("ID")%>'>
                            <%=myrs.getInt("ID")%>, <%=myrs.getString("First_Name")%> <%=myrs.getString("Last_Name")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
		 <%
                 // Select all possible undergrad degrees to go witho our student X
                myrs = statement.executeQuery("select d.degree_name, d.department_name " +
                                                "from Degrees d "+
                                                "where d.lower_div_units > 0 ");
                
            %>
            <hr>

            <br />
        <div>
            Select Degree:
            <select name="Degree">
                <%
                    while(myrs.next()){
						
                        %>
                        <option value='<%=myrs.getString("degree_name")%>'>
                            <%=myrs.getString("degree_name")%> from <%=myrs.getString("department_name")%>
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
