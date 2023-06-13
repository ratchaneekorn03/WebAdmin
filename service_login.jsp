<%-- 
    Document   : newjsp
    Created on : Nov 26, 2022, 7:22:11 PM
    Author     : acer
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String method = request.getMethod();
    System.out.println("method : " + method);
    String action = request.getParameter("action");
    System.out.println("action : " + action);
    
    String username = request.getParameter("username");
    System.out.println("username : " + username);
    
    String password = request.getParameter("password");
    System.out.println("password : " + password);
    
    boolean isSuccess = false;
    Connection conn = null;
    //
   
    try {
        String SQL = "SELECT * FROM users WHERE username = ? and status = 'ACTIVE' ";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
//        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
        PreparedStatement stmt = conn.prepareStatement(SQL);

        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
            while (rs.next()) {

                String dbusername = rs.getString("username");
                String dbpassword = rs.getString("password");
                String dbstatus = rs.getString("status"); 

                if ( username.equals(dbusername) && password.equals(dbpassword)) {
                    if( dbstatus.equals("ACTIVE") ){
                        request.getSession().setAttribute("username", username);
                        System.out.println("newjsp login : " + username +"  status : " + dbstatus);
                        isSuccess = true;
                        
                    }
                } else {
                    System.out.println("login fail" );
                }
            }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    
    if (request.getMethod().equals("POST") && request.getParameter("action").equals("authen") && isSuccess) {
        out.write("success");
    } else {
        out.write("fail");
    }
%>
