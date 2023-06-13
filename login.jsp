<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
                #section {
                        border-radius: 15px; 
                        padding-top: 30px;
                        padding-bottom: 30px;
                        padding-right: 60px;
                        padding-left: 60px;
                        background-color: #ddd;
                }
                #center {
                        text-align: center;
                }
         </style>
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
        
            
        </script>
    </head>
    <body>
        
    <%
        if (request.getSession().getAttribute("username") != null) {
            System.out.println("username  : " + request.getSession().getAttribute("username") + " already logedin.");
            response.sendRedirect("admin.jsp");
        }
        
        if (request.getMethod().equals("POST") && request.getParameter("action") != null) {
            out.write("true");
            return;
        }
        

        boolean login = false;
        Connection conn = null;
        String username = request.getParameter("usernametxt");
        //String password = request.getParameter("passwordtxt");
       // String username = "admin";
        String password = "123456";
        try {
            System.out.println("usernametxt: " + username + " : " + password);

            String SQL = "SELECT * FROM users WHERE username = ? and status = 'ACTIVE' and role = 'ADMIN' ";
            Class.forName("com.mysql.cj.jdbc.Driver");
//            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
            conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
            PreparedStatement stmt = conn.prepareStatement(SQL);

            stmt.setString(1, username);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                int id = rs.getInt("id");
                String dbusername = rs.getString("username");
                String dbpassword = rs.getString("password");
                String dbrole = rs.getString("role"); 

                if ( username.equals(dbusername) && password.equals(dbpassword)) {
                    if( dbrole.equals("ADMIN") ){
                        request.getSession().setAttribute("username", username);
                        request.getSession().setAttribute("id", id);
                        System.out.println("/login setSession : " + username +"  Role : " + dbrole);

                        response.sendRedirect("admin.jsp");
                    }
                } else {
                    System.out.println("login fail" );
                    %>
                        <script>
                            alertError("Invalid Credentials!");
                        </script>
                    <%
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
    <div class="container" style="margin-top:60px;" id="section">
        <section>
            <div class="row mb-3 center">
                <div class="col-3"> </div>
                <div class="col-6"> 
                    <form action="login.jsp" method="POST">

                            <div class="form-group center">
                                <h2>LOGIN REMOTE FOR ADMIN </h2>
                            </div>

                            <br/> 
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="usernametxt" class="form-control" id="usernametxt" />
                            </div>

                            <br/> 
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" name="passwordtxt" class="form-control"id="passwordtxt" />
                            </div>

                            <br/> 
                            <div class="form-group center">
                                <button type="submit" class="btn btn-success">Submit</button>
                            </div>
                    </form>
                </div> 
                <div class="col-3"> </div>
            </div>
            </section>
        </div>
        

         <!--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>-->
    </body>
</html>