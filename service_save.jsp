<%-- 
    Document   : service_getserver
    Created on : Nov 27, 2022, 5:47:12 PM
    Author     : acer
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page import="com.myproject.encryption.AES_Encryption"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String action = request.getParameter("action");
    String username = request.getParameter("username");
    String source_ip = request.getParameter("ip");
    String destination_ip = request.getParameter("server_ip");
    String port_number = request.getParameter("server_port");
    String log_id = request.getParameter("log_id");

    Connection conn = null;
    ResultSet rs = null;
    int id = 0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
//        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");

        if ("start".equals(action)) {
            String sql_save_start = "INSERT INTO remote_log (username, source_ip, destination_ip, port_number, remote_start_time) "
                        + "VALUES (?, ?, ?, ?, NOW())";
            System.out.println("[insertLogStartTime] SQL : " + sql_save_start);

            PreparedStatement stmt = conn.prepareStatement(sql_save_start, new String[]{"log_id"});
            stmt.setString(1, username);
            stmt.setString(2, source_ip);
            stmt.setString(3, destination_ip);
            stmt.setString(4, port_number);

            stmt.executeUpdate();
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                id = rs.getInt(1);
            }

            System.out.println("[insertLogStartTime] log_id : " + id);
        } else if ("end".equals(action)) {
            String sql_save_end = "UPDATE remote_log SET remote_end_time = NOW() WHERE log_id = ? ";
            System.out.println("[saveLogEndTime] SQL : " + sql_save_end);

            PreparedStatement stmt = conn.prepareStatement(sql_save_end);
            stmt.setInt(1, Integer.parseInt(log_id));

            id = stmt.executeUpdate();
            System.out.println(id + " records updated");
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
    
    out.write(AES_Encryption.encrypt(String.valueOf(id)));
%>
