<%-- 
    Document   : usertest
    Created on : 29 Oct 2022, 16:24:12
    Author     : acer
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.Instant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>    
        <title>Server</title>
        <jsp:include page="common/head.jsp"></jsp:include>
        <script>
            function alertError(text) {
		Swal.fire({
                    position: 'center',
                    icon: 'error',
                    title: 'Error',
                    text: text,
                    showConfirmButton: true
                });
            }
            function alertSuccess(text) {
		Swal.fire({
                    position: 'center',
                    icon: 'success',
                    title: 'Success',
                    text: text,
                    showConfirmButton: true
                });
            }
        </script>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        <br/> 
        <div class="container">
            <%
               
               int server_id = 0;
               String server_name = null;
               String server_ip = null;
               String server_port = null;
               String server_status = null; 
               Timestamp create_date; 
               Timestamp last_update;
                String username = null, admin = null;
                Connection conn = null;
                
                if (request.getSession().getAttribute("username") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    System.out.println("getSession null username");
                } else {
                    username = request.getSession().getAttribute("username").toString();
                }
                
                String message = null;
                
                if (request.getSession().getAttribute("add_server") != null) {
                    message = request.getSession().getAttribute("add_server").toString();
                    System.out.println("Add getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Add server success");
                        <%} else if ((message.equals("Duplicate")) ){ %>
                            Swal.fire({
                                position: 'center',
                                icon: 'error',
                                title: 'Error',
                                text: 'Duplicate Server Name!!',
                                showConfirmButton: true
                            }).then(function() {
                                window.location = "add_server.jsp";
                            });
                        <%} else { %>
                            alertError("Add server fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("add_server", null);
                } else if (request.getSession().getAttribute("edit_server") != null) {
                    message = request.getSession().getAttribute("edit_server").toString();
                    System.out.println("Edit getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Edit server success");
                        <%} else if ((message.equals("Duplicate")) ){ %>
                            alertError("Duplicate Server Name!!");
                        <%} else {%>
                            alertError("Edit server fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("edit_server", null);
                } else if (request.getSession().getAttribute("delete_server") != null) {
                    message = request.getSession().getAttribute("delete_server").toString();
                    System.out.println("Delete getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Delete server success");
                        <%} else {%>
                            alertError("Delete server fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("delete_server", null);
                }
                
                List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
                ResultSet rs = null;
                
                try {
                    String SQL_SELECT = "SELECT * FROM `server_info` ORDER BY `server_info`.`server_id` ASC";
                    Class.forName("com.mysql.cj.jdbc.Driver");
//                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                    conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
                    
                    PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);
                    
                    rs = stmt.executeQuery();
                    if (rs == null) {
                        out.println("No record");
                    } else {
                        while (rs.next()) {
                            Map<String, Object> map = new HashMap<String, Object>();
                            map.put("server_id" , rs.getInt("server_id"));
                            map.put("server_name" , rs.getString("server_name"));
                            map.put("server_ip" , rs.getString("server_ip"));
                            map.put("server_port" , rs.getString("server_port"));
                            map.put("server_status" , rs.getString("server_status"));
                            map.put("create_date" , rs.getTimestamp("create_date"));
                            map.put("last_update" , rs.getTimestamp("last_update"));
                            list.add(map);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (conn != null) {
                            conn.close();
                        }
                    } catch (Exception e) {
                    }
                }        
                    %>
                    <br> 
                    <!-- Button Add User-->
                    <a href="add_server.jsp" class="btn btn-success btn-sm">+Add Server</a> 
                    <br> 
                    </br>
                    <table class="table table-striped text-center">
                        <thead>
                            <tr>
                                <th class="col">#</th>
                                <th class="col">Server name</th>
                                <th class="col">Server IP</th>
                                <th class="col">Port</th>
                                <th class="col">Status</th>
                                <th class="col">Create Date</th>
                                <th class="col">Last Update</th>
                                <th class="col">Action</th>
                            </tr>
                        </thead>
    
                        <tbody>
                            <% for (int i=0; i<list.size();i++) {
                                    Map<String,Object> map = list.get(i);
                                    server_id = (int) map.get("server_id");
                                    server_name = (String) map.get("server_name");
                                    server_ip = (String) map.get("server_ip");
                                    server_port = (String) map.get("server_port");
                                    server_status = (String) map.get("server_status");
                                    create_date = (Timestamp) map.get("create_date");
                                    last_update = (Timestamp) map.get("last_update");
                            %>
                            <tr>                      
                                <td><%= i+1 %></td>
                                <td><%= server_name %></td>
                                <td><%= server_ip %></td>
                                <td><%= server_port %></td>
                                <td><%= server_status %></td>
                                <td><%= create_date %></td>
                                <td><%= last_update %></td>
                                <td class="text-center">
                                    <a href="edit_server.jsp?server_id=<%= server_id %>" class="btn btn-warning btn-sm">Edit</a>                                    
                                    <a href="delete_server.jsp?server_id=<%= server_id %>&server_name=<%= server_name %>" class="btn btn-danger btn-sm" onclick="return confirm('คุณต้องการลบใช่หรือไม่ ?');">Delete</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>        
                    </table>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    </body>
</html>
