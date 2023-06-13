<%-- 
    Document   : service_getserver
    Created on : Nov 27, 2022, 5:47:12 PM
    Author     : acer
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.myproject.encryption.AES_Encryption"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
    Connection conn = null;
    ResultSet rs = null;
    String result = "";

    try {
        String SQL_SELECT = "SELECT * FROM `server_info` WHERE server_status = 'ACTIVE' ORDER BY `server_info`.`server_id` ASC";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
//        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");

        PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);

        rs = stmt.executeQuery();
        if (rs == null) {
            out.println("No record");
        } else {
            int index = 1;
            while (rs.next()) {
                String server_name = rs.getString("server_name");
                String server_ip = rs.getString("server_ip");
                String server_port = rs.getString("server_port");
                
                if ( index > 1) {
                    result += ","; 
                }
                result += server_name + "|" + server_ip + "|" + server_port.split(",")[0] + "|" + server_port.split(",")[1] ;
                // A1|202.44.40.152|80|443,A2|202.44.40.153|80|443
                index++;
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
    out.write(AES_Encryption.encrypt(result));
%>
