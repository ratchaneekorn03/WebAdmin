<%-- 
    Document   : adduser
    Created on : 30 Oct 2022, 02:30:08
    Author     : acer
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<%
    if (request.getParameter("id") == null) response.sendRedirect("admin.jsp");
    int id = 0;
    try { 
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("admin.jsp");
    }
    
    String username = null;
    String password = null;
    String role = null;
    String status = null;
    Connection conn = null;
    ResultSet rs = null;
    
    if (request.getSession().getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        System.out.println("getSession null username");
    } else {
        username = request.getSession().getAttribute("username").toString();
        System.out.println("/edit admin getSession : " + username);         
    }
    
    if (request.getMethod().equals("GET")) {
        try {
            String SQL = "SELECT * FROM users WHERE id=?";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
//            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
            conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
            PreparedStatement stmt = conn.prepareStatement(SQL);

            stmt.setInt(1, id);

            rs = stmt.executeQuery();
            while (rs.next()) {
                username = rs.getString("username");
                password = rs.getString("password");
                role = rs.getString("role");
                status = rs.getString("status");
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
            username = request.getParameter("username");
            password = request.getParameter("password");
            role = request.getParameter("role");
            status = request.getParameter("status");

            System.out.println("username = " + username);
            System.out.println("password = " + password);
            System.out.println("role = " + role);
            System.out.println("status = " + status);
            
            String SQL_CHECK = "SELECT * FROM users WHERE username = ?";
            System.out.println("SQL_CHECK : " + SQL_CHECK);
            Class.forName("com.mysql.cj.jdbc.Driver");
            //conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
			conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
            String SQL_UPDATE = "UPDATE users SET password=?, role=?, status=? WHERE id=?";
            System.out.println("SQL_UPDATE :" + SQL_UPDATE);
            Class.forName("com.mysql.cj.jdbc.Driver");
//            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
              conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
            PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE);

            stmt.setString(1, password);
            stmt.setString(2, role);
            stmt.setString(3, status);
            stmt.setInt(4, id);

            int result = stmt.executeUpdate();
            System.out.println("result = " + result);
            if (result > 0) {
                System.out.println("Edit success : " + result + " " + username);
                request.getSession().setAttribute("edit_user", "success");
            } else {
                System.out.println("Edit fail");
                request.getSession().setAttribute("edit_user", "fail");
            } 
            response.sendRedirect("admin.jsp");
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
        <title>Edit User</title>
        <jsp:include page="common/head.jsp"></jsp:include>
    </head>
    <body>

        <jsp:include page="common/header.jsp"></jsp:include>
        <div class="container">
        <h2>Edit User</h2>

        <form class="form-horizontal" action="edit_user.jsp" method="POST">
              <input type="hidden" name="id" value="<%=id%>" />
          <div class="form-group">
            <label class="control-label col-sm-2" for="username">Username:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="username" name="username" value="<%= username%>" disabled="">
            </div>
          </div>
          <div class="form-group">
            <label class="control-label col-sm-2" for="password">Password:</label>
            <div class="col-sm-10">          
                <input type="password" class="form-control" id="password" name="password" minlength="6" value="<%= password%>" required="">
            </div>
          </div>
          <div class="form-group">        
            <label class="control-label col-sm-2" for="role">Role:</label>
            <div class="col-sm-10">
              <div class="radio">
                        <label><input type="radio" name="role" id="role" value="ADMIN" <%= role.equals("ADMIN") ? "checked" : "" %> required />ADMIN</label>
                        <label style="margin-left:2em"><input type="radio" name="role" id="role" value="USER" <%= role.equals("USER") ? "checked" : "" %> required />USER</label>
                      </div>
            </div>
          </div>
              <div class="form-group"> 
            <label class="control-label col-sm-2" for="role">Status:</label>
            <div class="col-sm-10">
              <div class="radio">
                <label><input type="radio" name="status" value="ACTIVE" <%= status.equals("ACTIVE") ? "checked" : "" %> required />ACTIVE</label>
                <label style="margin-left:2em"><input type="radio" name="status" value="INACTIVE" <%= status.equals("INACTIVE") ? "checked" : "" %> required />INACTIVE</label>
              </div>
            </div>
          </div>
          <div class="form-group">        
            <div class="col-sm-offset-2 col-sm-10">
              <button type="submit" class="btn btn-success btn-sm">Edit User</button>
            </div>
          </div>
        </form>
      </div>                      
       
    <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>-->
    </body>
</html>
