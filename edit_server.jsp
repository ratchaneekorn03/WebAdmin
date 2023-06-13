<%-- 
    Document   : editserver
    Created on : Nov 14, 2022, 2:56:25 PM
    Author     : acer
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<%
    if (request.getParameter("server_id") == null) response.sendRedirect("server.jsp");
    int server_id = 0;
    try {
        server_id = Integer.parseInt(request.getParameter("server_id"));
    } catch (Exception e) {
        response.sendRedirect("server.jsp");
    }
    
    String username = null;
    String server_name = null;
    String server_ip = null;
    String server_port1 = null;
    String server_port2 = null;
    String port1 = null;
    String port2 = null;
    String server_port = null;
    String server_status = null; 
    Timestamp create_date; 
    Timestamp last_update;
    Connection conn = null;
    ResultSet rs = null;
	
    if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            System.out.println("getSession null username");
    } else {
            username = request.getSession().getAttribute("username").toString();
            System.out.println("/edit server getSession : " + username);         
    }
    
    if (request.getMethod().equals("GET")) {
        try {         
                String SQL = "SELECT * FROM server_info WHERE server_id=?";
            
                Class.forName("com.mysql.cj.jdbc.Driver");
//                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
                PreparedStatement stmt = conn.prepareStatement(SQL);

                stmt.setInt(1, server_id);

                rs = stmt.executeQuery();
                while (rs.next()) {
                    server_name = rs.getString("server_name");
                    server_ip = rs.getString("server_ip");
                    server_port = rs.getString("server_port");
                        port1 = server_port.split(",")[0];
                        port2 = server_port.split(",")[1];
                    server_status = rs.getString("server_status");
                }
        } catch(Exception e){
            System.out.print(e);
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    } else if (request.getMethod().equals("POST")) {
        try {
             //server_name = request.getParameter("server_name");
             server_ip = request.getParameter("server_ip");
             //server_port = request.getParameter("server_port");
             port1 = request.getParameter("port1");
             port2 = request.getParameter("port2");
             server_status = request.getParameter("server_status");
            
            server_port = port1 + "," + port2;
            
            System.out.println("server_name : " + server_name);
            System.out.println("server_ip : " + server_ip);
            System.out.println("server_port : " + server_port);
            System.out.println("server_status : " + server_status);

//            Class.forName("com.mysql.cj.jdbc.Driver");
//            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");

                String SQL_UPDATE = "UPDATE server_info SET server_ip=?, server_port=?, server_status=?, last_update = NOW() WHERE server_id=?";
                System.out.println("SQL_UPDATE :" + SQL_UPDATE);

                Class.forName("com.mysql.cj.jdbc.Driver");
//                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
                PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE);

                stmt.setString(1, server_ip);
                stmt.setString(2, server_port);
                stmt.setString(3, server_status);
                stmt.setInt(4, server_id);

                int result = stmt.executeUpdate();
                System.out.println("result : " + result);
                if (result > 0) {
                    System.out.println("Edit success : " + result + " " + server_name);
                    request.getSession().setAttribute("edit_server", "success");
                } else {
                    System.out.println("Edit fail");
                    request.getSession().setAttribute("edit_server", "fail");
                }
            response.sendRedirect("server.jsp");
        } catch ( Exception e) {
            System.out.print(e);
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }   
    } 
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Server</title>
        <jsp:include page="common/head.jsp"></jsp:include>
    </head>
    <body>

        <jsp:include page="common/header.jsp"></jsp:include>
        <div class="container">
        <h2>Edit Server</h2>

        <form class="form-horizontal" action="edit_server.jsp" method="POST">
            <input type="hidden" name="server_id" value="<%=server_id%>" />
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_name">Server Name:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="server_name" name="server_name" value="<%= server_name%>" disabled="">
              </div>
            </div>
              
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_ip">Server IP:</label> 
              <div class="col-sm-10">          
                  <input type="text" class="form-control" id="server_ip" name="server_ip" value="<%= server_ip %>" required="">
              </div>
            </div>
              
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_port">Server Port1:</label>
                <div class="col-sm-10">          
                  <span class="inline">
                      <input type="number" class="form-control" id="port1" name="port1" max="65535" value="<%= port1 %>"  required="">
                  </span>
                </div>
            </div>
            
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_port">Server Port2:</label>
                <div class="col-sm-10" >          
                  <span class="inline">
                      <input type="number" class="form-control" id="port2" name="port2" max="65535" value="<%= port2 %>" required="">
                  </span>
                </div>
            </div>
                  
            <div class="form-group"> 
            <label class="control-label col-sm-2" for="server_status">Server Status:</label>
                <div class="col-sm-10">
                  <div class="radio">
                    <label><input type="radio" name="server_status" value="ACTIVE" <%= server_status.equals("ACTIVE") ? "checked" : "" %> required />ACTIVE</label>
                    <label style="margin-left:2em"><input type="radio" name="server_status" value="INACTIVE"  <%= server_status.equals("INACTIVE") ? "checked" : "" %>required />INACTIVE</label>
                  </div>
                </div>
            </div>
                  
            <div class="form-group">        
              <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-success btn-sm">Edit Server</button>
              </div>
            </div>
        </form>
       
    <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>-->
    </body>
</html>

