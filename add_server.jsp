<%-- 
    Document   : addserver
    Created on : Nov 14, 2022, 10:39:20 AM
    Author     : acer
--%>

<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.Instant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<%
    String username = null;
    if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            System.out.println("getSession null username");
    } else {
            username = request.getSession().getAttribute("username").toString();
            System.out.println("/add server getSession : " + username);         
    }
    int server_id = 0;
    String server_name = request.getParameter("server_name");
    String server_ip = request.getParameter("server_ip");
    String port1 = request.getParameter("port1");
    String port2 = request.getParameter("port2");
    String server_status = request.getParameter("server_status"); 
    String server_port = port1 + "," + port2;
    Connection conn = null;
    
    try {
        String SQL_CHECK = "SELECT * FROM server_info WHERE server_name = ?";
        Class.forName("com.mysql.cj.jdbc.Driver");
//        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
        
        PreparedStatement stmt_check = conn.prepareStatement(SQL_CHECK);
        stmt_check.setString(1, server_name);
  
        ResultSet rs_check = stmt_check.executeQuery();
        if (rs_check.next() == false) {
            String SQL_INSERT = "INSERT INTO server_info(server_name, server_ip, server_port, server_status, create_date)" + "VALUES (?,?,?,?,NOW())";
     
            PreparedStatement stmt = conn.prepareStatement(SQL_INSERT,Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, server_name);
            stmt.setString(2, server_ip);
            stmt.setString(3, server_port);
            stmt.setString(4, server_status);
           
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                server_id = rs.getInt(1);
            }

            System.out.println("server_id : " + server_id);
            if (server_id > 0) {
                System.out.println("server_name : " + server_name);
                System.out.println("server_ip : " + server_ip);
                System.out.println("server_port : " + server_port);
                System.out.println("server_status : " + server_status);
            
                System.out.println("Add server success : " + server_name);
                request.getSession().setAttribute("add_server", "success"); 
            } else {
                System.out.println("Add server fail");
                request.getSession().setAttribute("add_server", "fail"); 
            }
            //response.sendRedirect("server.jsp");
        } else {
            System.out.println("Duplicate Server Name : " + server_name);
            request.getSession().setAttribute("add_server", "Duplicate"); 
        }
        response.sendRedirect("server.jsp");
    } catch (Exception e) {
        System.out.println(e);
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
<!DOCTYPE html>
<html>
    <head>
        <title>Add Server</title>
        <jsp:include page="common/head.jsp"></jsp:include>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
    </head>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        <div class="container">
        <h2>Add Server</h2>

        <form class="form-horizontal" action="add_server.jsp" method="POST" id="add_server">
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_name">Server Name:</label>
              <div class="col-sm-10">
                  <input type="text" class="form-control" id="server_name" name="server_name" minlength="5" required="">
              </div>
            </div>
            
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_ip">Server IP:</label>
              <div class="col-sm-10">          
                  <input type="text" class="form-control" id="server_ip" name="server_ip" required="">
              </div>
            </div>
            
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_port">Server Port1:</label>
                <div class="col-sm-10">          
                  <span class="inline">
                      <input type="number" class="form-control" id="port1" name="port1" max="65535" required="">
                  </span>
                </div>
            </div>
            <div class="form-group">
              <label class="control-label col-sm-2" for="server_port">Server Port2:</label>
                <div class="col-sm-10" >          
                  <span class="inline">
                      <input type="number" class="form-control" id="port2" name="port2" max="65535" required="">
                  </span>
                </div>
            </div>
            
            <div class="form-group"> 
            <label class="control-label col-sm-2" for="server_status">Server Status:</label>
                <div class="col-sm-10">
                  <div class="radio">
                    <label><input type="radio" name="server_status" value="ACTIVE" checked required />ACTIVE</label>
                    <label style="margin-left:2em"><input type="radio" name="server_status" value="INACTIVE" required />INACTIVE</label>
                  </div>
                </div>
            </div>
            
            <div class="form-group">        
              <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-success btn-sm">Add Server</button>
              </div>
            </div>
        </form>
      </div>
    <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>-->
    </body>
    <script>
        $('#server_name').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
        
        $('#server_ip').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
        
        $('#port1').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
        
        $('#port2').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
        
    </script>
</html>
