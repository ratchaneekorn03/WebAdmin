<%-- 
    Document   : newjsp
    Created on : Dec 3, 2022, 8:20:04 PM
    Author     : acer
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <title>Dash board</title>
        
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>

        <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
        <style>
                        #section {
/*                             padding:40px; border-radius: 15px; background-color: #ddd;*/
                                border-radius: 15px; 
                                padding-top: 30px;
                                padding-right: 40px;
                                padding-bottom: 30px;
                                padding-left: 40px;
                                background-color: #ddd;
                        }
                </style>
    </head>
    
    <body> 
    <div class="container">
    <%
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = null;
//        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student", "student", "uploadfile286");
        
//        String sql = "select rl.username, rl.destination_ip, si.server_name, count(*) count"
//                       + " from student.remote_log rl "
//                       + " left join student.server_info si on si.server_ip = rl.destination_ip "
//                       + " where month(rl.remote_start_time) = 7 and rl.username = 'Admin' "
//                       + " group by rl.username, si.server_name "
//                       + " order by rl.username,count desc";
//        System.out.println("sql : " + sql);
//        PreparedStatement stmt = conn.prepareStatement(sql);
//        
//        List<String> labels = new ArrayList<String>();
//        List<String> destination_ip = new ArrayList<String>();
//        List<String> Server_name = new ArrayList<String>();
//        List<String> data = new ArrayList<String>();
//        
//        ResultSet rs = stmt.executeQuery();
//        while ( rs.next() ){
////            labels_minute.add("'" + rs_minute.getString("username") + "'");
//        
//            labels.add("'" + rs.getString("username") + "'");
//            destination_ip.add("'" + rs.getString("destination_ip") + "'");
//            Server_name.add("'" + rs.getString("server_name") + "'");
//            data.add("'" + rs.getString("count") + "'");
//        }
//        
//        System.out.println("labes_username : " + labels.toString());
//        System.out.println("Server_ip : " + destination_ip.toString());
//        System.out.println("Server_name : " + Server_name.toString());
//        System.out.println("data_count : " + data.toString());
        
        String month = request.getParameter("month");
        String month_name = "";

            
        String sql = "SELECT username, COUNT(*) count  FROM student.remote_log ";
                sql += "where year(remote_start_time) = 2022 ";
                sql += "group by username order by count DESC ";

        PreparedStatement stmt = conn.prepareStatement(sql);
        if (month != null) {
            stmt.setInt(1, Integer.parseInt(month));
        }
        ResultSet rs = stmt.executeQuery();
        
        StringBuilder sb = new StringBuilder();
        while (rs.next()) {
            // { label: "Sugar - Maroon 5", y: 3.25 },
            sb.append("{ label: \"");
            sb.append(rs.getString("username") + " \"");
            sb.append(", y: " + rs.getInt("count") + " },");
            
        }
        
        sb = new StringBuilder(sb.substring(0, sb.length()));
        System.out.println("sb : " + sb.toString());
    %>
    
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6"><canvas id="bar-chart" width="200" height="80"></canvas></div>
        <div class="col-md-3"></div>
    </div>
    
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6"><canvas id="chart_div" width="500" height="80"></canvas></div>
        <div class="col-md-3"></div>
    </div>
    
    <div class="row">
                <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-6" id="section"> <div id="chartContainer" style="height: 400px; width: 100%;"></div></div>
                        <div class="col-md-3"></div>
                </div>
        </div>
    
    <div id="chartContainer" style="height: 370px; width: 100%;"></div>

<!--    <script type="text/javascript">
        var densityCanvas = document.getElementById("chart_div");

        var Data1 = {
         label: 'A',
          data: [3.7, 8.9, 9.8, 3.7, 23.1, 9.0, 8.7, 11.0],
          backgroundColor: 'rgba(99, 132, 0, 0.6)',
          borderColor: 'rgba(99, 132, 0, 1)',
          yAxisID: "y-axis-gravity";
        }
        var Data2 = {
         label: 'B',
          data: [3.7, 8.9, 9.8, 3.7, 23.1, 9.0, 8.7, 11.0],
          backgroundColor: 'rgba(99, 132, 0, 0.6)',
          borderColor: 'rgba(99, 132, 0, 1)',
          //yAxisID: "y-axis-gravity"
        }
        var Data3 = {
         label: 'C',
          data: [3.7, 8.9, 9.8, 3.7, 23.1, 9.0, 8.7, 11.0],
          backgroundColor: 'rgba(99, 132, 0, 0.6)',
          borderColor: 'rgba(99, 132, 0, 1)',
          //yAxisID: "y-axis-gravity"
        }
        
        
        
        var planetData = {
        labels: ["A", "B", "C"],
        datasets: [Data1,Data2, Data3 ]
        };

        var chartOptions = {
          scales: {
            xAxes: [{
              barPercentage: 1,
              categoryPercentage: 0.4
            }],
            yAxes: [{
              id: "y-axis-Registered"
            } 
            ]
            }
        };

        var barChart = new Chart(densityCanvas, {
          type: 'bar',
          data: planetData,
          options: chartOptions
        });
     
    
    </script>-->
    
    
    
    
    
    
    
<!--    <script type="text/javascript">
        new Chart(document.getElementById("bar-chart"), {
            type: 'bar',
            data: {
              labels: <= labels.toString() %>,
              datasets: [
                {
                  label: " labels_1 ",
                  backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#eaa840","#ea408d","#3e95cd", "#808080","#FF00FF","#FFFF00","#00FFFF","#008080","#00FF00","#29ca31","#fac7f0","#abc1f4"],
                  data: <= data.toString() %>
                }
              ]
            },
            options: {
              legend: { display: false },
              title: {
                display: true,
                text: " labels_2 "
              }
            }
        });
    </script>-->
    
    <script>
        window.onload = function () {

        var chart = new CanvasJS.Chart("chartContainer", {
          theme: "dark2", // "light1", "light2", "dark1"
          animationEnabled: true,
          exportEnabled: true,
          title: {
            text: "Top 10 Users Login Remote as of 2022"
          },
          axisX: {
            margin: 10,
            labelPlacement: "inside",
            tickPlacement: "inside"
          },
          axisY2: {
            title: "Views (in count)",
            titleFontSize: 14,
            includeZero: true,
            suffix: ""
          },
          data: [{
            type: "bar",
            axisYType: "secondary",
            yValueFormatString: "#,###.##",
            indexLabel: "{y}",
            dataPoints: [
              <%= sb.toString() %>
            ]
          }]
        });
        chart.render();

        }
        </script>
    

    </div>                  
    </body>

    
</html>
