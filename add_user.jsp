<%-- 
    Document   : adduser
    Created on : 30 Oct 2022, 02:30:08
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Add User</title> 
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
<%
    request.getSession().setAttribute("add_user", null);
    String username = null;
    //check user == null
    if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            System.out.println("getSession null username");
    } else {
            username = request.getSession().getAttribute("username").toString();
            System.out.println("/add user getSession : " + username);         
    }
    int id = 0;
    username = request.getParameter("username");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    String status = request.getParameter("status");
    if (request.getMethod().equals("POST") && (request.getParameter("username") == null
                                                || request.getParameter("password") == null
                                                || request.getParameter("role") == null
                                                || request.getParameter("status") == null)) {
        
        request.getSession().setAttribute("add_user", "fail"); 
        response.sendRedirect("admin.jsp");
    }

    Connection conn = null;
    
    if (request.getMethod().equals("POST")) {
        try {
            String SQL_CHECK = "SELECT * FROM users WHERE username = ?";
            Class.forName("com.mysql.cj.jdbc.Driver");
//            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
            conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");

            PreparedStatement stmt_check = conn.prepareStatement(SQL_CHECK);
            stmt_check.setString(1, username);

            ResultSet rs_check = stmt_check.executeQuery();
            if (rs_check.next() == false) {
                String SQL_INSERT = "INSERT INTO users(username, password, role, status)" + "VALUES (?,?,?,?)";

                PreparedStatement stmt = conn.prepareStatement(SQL_INSERT,Statement.RETURN_GENERATED_KEYS);

                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, role);
                stmt.setString(4, status);

                stmt.executeUpdate();
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    id = rs.getInt(1);
                }

                System.out.println("id : " + id);
                if (id > 0) {
                    System.out.println("username : " + username);
                    System.out.println("password : " + password);
                    System.out.println("role : " + role);
                    System.out.println("status : " + status);

                    System.out.println("Add user success : " + username);
                    request.getSession().setAttribute("add_user", "success"); 

                } else {
                    System.out.println("Add user fail");
                    request.getSession().setAttribute("add_user", "fail"); 
                }
            } else {
                System.out.println("Duplicate username : " + username);
                request.getSession().setAttribute("add_user", "Duplicate"); 
            }
            response.sendRedirect("admin.jsp");
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
    }
%>
    <body>
        <jsp:include page="common/header.jsp"></jsp:include>
        
        <div class="container">
        <h2>Add User</h2>

        <form class="form-horizontal" action="add_user.jsp" method="POST">
          <div class="form-group">
            <label class="control-label col-sm-2" for="username">Username:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="username" name="username" minlength="5" required="">
            </div>
          </div>
          <div class="form-group">
            <label class="control-label col-sm-2" for="password">Password:</label>
            <div class="col-sm-10">          
                <input type="password" class="form-control" id="password" name="password" minlength="6" required="">
            </div>
          </div>
          <div class="form-group">        
            <label class="control-label col-sm-2" for="role">Role:</label>
            <div class="col-sm-10">
              <div class="radio">
                <label><input type="radio" name="role" id="role" value="ADMIN" checked required="" />ADMIN</label>
                <label style="margin-left:2em"><input type="radio" name="role" value="USER" required="" />USER</label>
              </div>
            </div>
          </div>
              <div class="form-group"> 
            <label class="control-label col-sm-2" for="role">Status:</label>
            <div class="col-sm-10">
              <div class="radio">
                <label><input type="radio" name="status" value="ACTIVE" checked required />ACTIVE</label>
                <label style="margin-left:2em"><input type="radio" name="status" value="INACTIVE" required />INACTIVE</label>
              </div>
            </div>
          </div>
          <div class="form-group">        
            <div class="col-sm-offset-2 col-sm-10">
              <button type="submit" class="btn btn-success btn-sm">Add User</button>
            </div>
          </div>
        </form>
      </div>               
    <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>-->
    </body>
    <script>
        $('#username').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
        
        $('#password').on('keyup',function(e) {
            $( this ).val($( this ).val().replace(/\s/g, ''));
        });
    </script>
</html>
