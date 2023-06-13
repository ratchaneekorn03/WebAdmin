<%-- 
    Document   : delete_server
    Created on : Nov 14, 2022, 3:47:38 PM
    Author     : acer
--%>

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
    System.out.println("server_id : " + server_id);

    Connection conn = null;
    String username = null;
    String server_name = request.getParameter("server_name");
    System.out.println("server_name : " + server_name);
    
    if (request.getSession().getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        System.out.println("getSession null username");
    } else {
        username = request.getSession().getAttribute("username").toString(); 
    }
    
    try {
        String SQL = "DELETE FROM server_info WHERE server_id=?";

        Class.forName("com.mysql.cj.jdbc.Driver");
//        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
        PreparedStatement preparedStatement = conn.prepareStatement(SQL);

        preparedStatement.setInt(1, server_id);
            
        int row = preparedStatement.executeUpdate();
        if( row > 0 ){
            System.out.println("delete success row : " + row + " " + server_name);
            request.getSession().setAttribute("delete_server", "success"); 
        } else {
            System.out.println("delete fail");
            request.getSession().setAttribute("delete_server", "fail");
        }
        response.sendRedirect("server.jsp");
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