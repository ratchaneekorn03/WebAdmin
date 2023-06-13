<%-- 
    Document   : newjsp
    Created on : 29 Oct 2022, 21:58:01
    Author     : acer
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<%
                String username = null;
                if (request.getSession().getAttribute("username") == null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        System.out.println("getSession null username");
                }
                
              List<String> username_db = new ArrayList<String>();
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
               //     Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");

                    String sql_user = "SELECT username FROM student.remote_log group by username";
                    PreparedStatement stmt_username = conn.prepareStatement(sql_user);
                    
                    ResultSet rs_username = stmt_username.executeQuery();
                    while ( rs_username.next() ) {                            
                             username_db.add( rs_username.getString("username"));
                     }
                     System.out.println("username_db : " + username_db.toString());
 
                        String sql = "SELECT * FROM remote_log ";

                        username = (String) request.getParameter("username");
                        boolean isSearchByUsername = username != null;
                        if (isSearchByUsername) {
                               sql += " WHERE username = ? ";
                        }

                        sql += " ORDER BY log_id ASC ";
                        System.out.println("sql : " + sql);

                        PreparedStatement stmt = conn.prepareStatement(sql);
                        if (isSearchByUsername) {
                            stmt.setString(1, username);
                        }

                        ResultSet rs = stmt.executeQuery();
                        if (rs == null) {
                            out.println("No record");
                        } else {
 %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login history</title>
        <jsp:include page="common/head.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        
        <div class="container">
            <h2>Search by username</h2>
            <form class="form-inline" id="searchByUsername" action="login_history.jsp" method="POST">
              <div class="form-group">
                <label for="sel1">เลือกรายการ (เลือกอย่างใดอย่างหนึ่ง):</label>
                <select class="form-control" name="username" id="sel1" form="searchByUsername">
                     <%for (int i=0; i< username_db.size() ;i++) { %>
                     <option value="<%= username_db.get(i).toString() %>"><%= username_db.get(i).toString() %></option>
                     <%}%>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Search</button>
              </div>
            </form>
          </div>
                
         <div class="container" style="margin-top: 30px;">
                <table class="table table-striped text-center">
                    <thead>
                        <tr>
                            <th class="col">ID</th>
                            <th class="col">Username</th>
                            <th class="col">Source_IP</th>
                            <th class="col">destination_IP</th>
                            <th class="col">Port</th>
                            <th class="col">Start_time</th>
                            <th class="col">End_time</th>
                        </tr>
                    </thead>
                    <tbody>
                <% 
                    while (rs.next()) {
                %>
                        <tr>
                            <td><%= rs.getInt("log_id")%></td>
                            <td><%= rs.getString("username")%></td>
                            <td><%= rs.getString("source_ip")%></td>
                            <td><%= rs.getString("destination_ip") %></td>
                            <td><%= rs.getString("port_number") %></td>
                            <td><%= rs.getTimestamp("remote_start_time") %></td>
                            <td><%= rs.getTimestamp("remote_end_time") %></td>                    
                        </tr>      
                <% } %>
                    </tbody> 
                </table>
                <%
                }

            } catch (Exception e) {
                System.out.print(e);
                e.printStackTrace();
            }
        %>
            
    </div>
   </body>
</html>