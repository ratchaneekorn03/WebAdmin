
<%-- 
    Document   : delete
    Created on : 29 Oct 2022, 23:00:51
    Author     : acer
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin</title>
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
            }
        </script>
    </head>
 </html>   
<%
    if (request.getParameter("id") == null) response.sendRedirect("admin.jsp");
    int id = 0;
    
    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("admin.jsp");
    }
    System.out.println("id : " + id);
    
    Connection conn = null;
    String username = null;
    
    if (request.getSession().getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        System.out.println("getSession null username");
    } else {
        username = request.getSession().getAttribute("username").toString();
        System.out.println("/admin getSession : " + username);         
    }
    
    
    try {
    
        Class.forName("com.mysql.cj.jdbc.Driver");
//        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
        
        int session_id = (int) request.getSession().getAttribute("id");
        
        if (id == session_id) {
            request.getSession().setAttribute("delete_user", "count_fail");
            
            response.sendRedirect("admin.jsp");
        } else {
            String SQL = "DELETE FROM users WHERE id=?";

            PreparedStatement preparedStatement = conn.prepareStatement(SQL);

            preparedStatement.setInt(1, id);

            int row = preparedStatement.executeUpdate();

            if ( row > 0) {
                System.out.println("delete success row : " + row + " " + username);
                request.getSession().setAttribute("delete_user", "success");
            } else {
                System.out.println("delete fail");
                request.getSession().setAttribute("delete_user", "fail");
            }
        }
        response.sendRedirect("admin.jsp");
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
%>