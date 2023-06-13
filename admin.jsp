   <%-- 
    Document   : usertest
    Created on : 29 Oct 2022, 16:24:12
    Author     : acer
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin</title>
        <jsp:include page="common/head.jsp"></jsp:include>
        <script>
            function sleep(ms) {
                return new Promise((resolve) => setTimeout(resolve, ms));
            }
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
        <style>
            .footer {
                position: relative;
                margin-top: -85px; /* negative value of footer height */
                height: 85px;
                clear:both;
            } 
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        <div class="container">
            <%
                int total = 0;
                int id = 0;
                String username = null, admin = null;
                String role = "";
                String password = null;
                String status = null;
                Connection conn = null;;
                
                if (request.getSession().getAttribute("username") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    System.out.println("getSession null username");
                } else {
                    username = request.getSession().getAttribute("username").toString();
                    System.out.println("/admin getSession : " + username);
                }
                
                String message = null;
                
                if (request.getSession().getAttribute("add_user") != null) {  //add_user
                    message = request.getSession().getAttribute("add_user").toString();
                    System.out.println("Add getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Add user success");
                        <%} else if ((message.equals("Duplicate")) ){ %>
                            Swal.fire({
                                position: 'center',
                                icon: 'error',
                                title: 'Error',
                                text: 'Duplicate Username!!"',
                                showConfirmButton: true
                            }).then(function() {
                                window.location = "add_user.jsp";
                            });
                            
                        <%} else { %>
                            alertError("Add user fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("add_user", null);
                } else if (request.getSession().getAttribute("edit_user") != null) { //edit_user
                    message = request.getSession().getAttribute("edit_user").toString();
                    System.out.println("Edit getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Edit user success");
                        <%} else if ((message.equals("Duplicate")) ){ %>
                            alertError("Duplicate username!!");
                        <%} else {%>
                            alertError("Edit user fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("edit_user", null);                  
                } else if (request.getSession().getAttribute("delete_user") != null) { //delete_user
                    message = request.getSession().getAttribute("delete_user").toString();
                    System.out.println("Delete getsession : " + message);
                    %>
                    <script>
                        <% if (message.equals("success")) { %>
                            alertSuccess("Delete user success"); 
                        <%} else if(message.equals("alert")) {%>
                            alertError("Sure Delete ?");
                        <%} else {%>
                            alertError("Delete user fail");
                        <%}%>
                    </script>
                    <%
                    request.getSession().setAttribute("delete_user", null);
                }
                    request.getSession().setAttribute("add_user", null);
                    request.getSession().setAttribute("delete_user", null);
                    request.getSession().setAttribute("edit_user", null); 
                    request.getSession().removeAttribute("add_user");
                    request.getSession().removeAttribute("delete_user");
                    request.getSession().removeAttribute("edit_user");
                    request.getSession().removeAttribute("delete_server");
                
                List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
                ResultSet rs = null;
                
                try {
                    String SQL_SELECT = "SELECT * FROM `users` ORDER BY `users`.`id` ASC";

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
                            map.put("id" , rs.getInt("id"));
                            map.put("username" , rs.getString("username"));
                            map.put("password" , rs.getString("password"));
                            map.put("role" , rs.getString("role"));
                            map.put("status" , rs.getString("status"));
                            list.add(map);
                            total++;
                        }
                        System.out.println("total :" + total);
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
                    <a href="add_user.jsp" class="btn btn-success btn-sm">+Add User</a>
                    <br> 
                    </br>
                    <table class="table table-striped text-center">
                        <thead>
                            <tr>
                                <th class="col">#</th>
                                <th class="col">Username</th>
                                <th class="col">Password</th>
                                <th class="col">Roles</th>
                                <th class="col">Status</th>
                                <th class="col">Action</th>
                            </tr>
                        </thead>
    
                        <tbody>
                            <% for (int i=0; i<list.size();i++) {
                                    Map<String,Object> map = list.get(i);
                                    id = (int) map.get("id");
                                    username = (String) map.get("username");
                                    password = (String) map.get("password");
                                    role = (String) map.get("role");
                                    status = (String) map.get("status");
                            %>
                            <tr>                      
                                <td><%= i+1 %></td>
                                <td><%= username %></td>
                                <td>******</td>
                                <td><%= role %></td>
                                <td><%= status %></td>
                                <td class="text-center">
                                    <a href="edit_user.jsp?id=<%= id %>" class="btn btn-warning btn-sm">Edit</a>                                    
                                    <a href="delete_user.jsp?id=<%= id %>" class="btn btn-danger btn-sm" 
                                       onclick="return confirm('ยืนยันต้องการลบผู้ใช้งาน ?');"
                                       >Delete</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>      
                    </table>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>

    </body>
        <script>
            function ConfirmDelete(){
                return confirm("Are you sure you want to delete?");
            }
        </script>
</html>
