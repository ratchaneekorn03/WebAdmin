<%-- 
    Document   : dashboard
    Created on : Nov 30, 2022, 6:44:19 PM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
        <head>
                <title>Dashboard</title>
                <jsp:include page="common/head.jsp"></jsp:include>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
                <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

                <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
                <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
                <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
                <style>
                        #section {
                                border-radius: 15px; 
                                padding-top: 20px;
                                padding-bottom: 20px;
                                  

/*                                padding-right: 20px;
                                padding-left: 20px;*/
                                background-color: #ddd;
/*                                margin: 0 -5px;*/
/*                                margin-left: 1px;
                                margin-right: 1px*/
                        }
                        #center {
                                text-align: center;
                        }
                        /*.row {margin: 0 -5px;}*/
/*                        #ddd {
                            height: 200px;
                            width: 50%;
                            background-color: powderblue;
                        }*/
                  </style>
        </head>

<body>
        <jsp:include page="common/header.jsp"></jsp:include>
        <div class="container">
        <%
                String username = null;

                if (request.getSession().getAttribute("username") == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    System.out.println("getSession null username");
                } else {
                    username = request.getSession().getAttribute("username").toString();
                    System.out.println("/Admin Dashboard : " + username);
                }
                
                String sd =  request.getParameter("sd"); 
                String ed =  request.getParameter("ed"); 
                System.out.println("sd : " + sd);
                System.out.println("ed : " + ed);
                
                Connection conn = null;
                int num_windows = 0;
                int num_ubuntu = 0;
                int num_total = 0;
                int num = 0;
                StringBuilder sb = new StringBuilder();
                List<String> labels_minute = new ArrayList<String>();
                List<Integer> data_minute = new ArrayList<Integer>();
                List<String> labels_server_name = new ArrayList<String>();
                List<Integer> data_server_name = new ArrayList<Integer>();
                
                try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
//                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student", "root", "");
                        conn = DriverManager.getConnection("jdbc:mysql://192.168.4.2/student?userUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetime=false&serverTimezone=UTC", "student", "uploadfile286");

                        //Server
                        String sql_server_name = "select si.server_name, count(*) cnt "
                                                            + "from student.remote_log rl, student.server_info si "                                                  
                                                            + "where rl.destination_ip = si.server_ip ";
                        if (sd != null && ed != null ) {
                                sql_server_name += "AND date_format(remote_start_time, '%Y%m%d') between ? and ? ";
                         }  
                                sql_server_name += "group by si.server_name order by cnt desc";
                        System.out.println("[sql_server_name] : " + sql_server_name);
                        System.out.println("start date - end date : " + sd + " : " + ed);

                        PreparedStatement statement = conn.prepareStatement(sql_server_name);
                        if (sd != null && ed != null ) {
                                statement.setString(1, sd.replaceAll("-", ""));
                                statement.setString(2, ed.replaceAll("-", ""));
                        }
                        ResultSet resultSet = statement.executeQuery();
                        while (resultSet.next()) {
                                String server_name = resultSet.getString("server_name");
                                int count = resultSet.getInt("cnt");
                                System.out.println("labels_server_name : " + server_name + " , count = " + count);
                                labels_server_name.add("'" + server_name + "'");
                                data_server_name.add(count);

                                if (server_name.toLowerCase().contains("windows")) {
                                        num_windows += count;
                                } else if (server_name.toLowerCase().contains("ubuntu")) {
                                        num_ubuntu += count;
                                }
                                num_total += count;
                        }
                        System.out.println("labels_server_name : " + labels_server_name.toString());
                        System.out.println("data_server_name : " + data_server_name.toString());
                        System.out.println("num_windows : " + num_windows);
                        System.out.println("num_ubuntu : " + num_ubuntu);
                        System.out.println("num_total : " + num_total + "\n");


                        //Minute
                        String sql_minute = "SELECT username, sum(TIMESTAMPDIFF(MINUTE, remote_start_time, remote_end_time))";
                                sql_minute   += "as total_minutes FROM remote_log ";
                        if (sd != null && ed != null ) {
                                sql_minute += "WHERE date_format(remote_start_time, '%Y%m%d') between ? and ? ";
                        }
                                sql_minute += "group by username order by total_minutes desc";
                        System.out.println("[sql_minute] : " + sql_minute);
                        System.out.println("start date - end date : " + sd + " : " + ed);

                        PreparedStatement stmt_minute = conn.prepareStatement(sql_minute);
                        if (sd != null && ed != null ) {
                                stmt_minute.setString(1, sd.replaceAll("-", ""));
                                stmt_minute.setString(2, ed.replaceAll("-", ""));
                        }
                        ResultSet rs_minute = stmt_minute.executeQuery();
                        while (rs_minute.next()) {
                            labels_minute.add("'" + rs_minute.getString("username") + "'");
                            data_minute.add(rs_minute.getInt("total_minutes"));
                        }
                        System.out.println("labels_minute: " + labels_minute.toString());
                        System.out.println("data_minute : " + data_minute.toString() + "\n");


                        //https://www.codeply.com/p/zU0EWDmIfn
                        //User
                        String sql_user = "SELECT username, COUNT(*) cnt  FROM student.remote_log ";

                        if (sd != null && ed != null ) {
                                sql_user += "WHERE date_format(remote_start_time, '%Y%m%d') between ? and ? ";
                        }
                        sql_user += " group by username order by cnt DESC";
                        System.out.println("[sql_user] : " + sql_user);

                        PreparedStatement stmt_user = conn.prepareStatement(sql_user);
                        if (sd != null && ed != null ) {
                            stmt_user.setString(1, sd.replaceAll("-", ""));  //2022-07-01  -->  20220701
                            stmt_user.setString(2, ed.replaceAll("-", ""));
                        }
                        ResultSet rs_user = stmt_user.executeQuery();

                        while (rs_user.next()) {
                            // { label: "Sugar - Maroon 5", y: 3.25 },
                            sb.append("{ label: \"");
                            sb.append(rs_user.getString("username") + " \"");
                            sb.append(", y: " + rs_user.getInt("cnt") + " },");

                        }
                        sb = new StringBuilder(sb.substring(0, sb.length()));
                        System.out.println("sb : " + sb.toString());


                        //จำนวนผู้ใช้งานทั้งหมด
                        String sql_num_user = "SELECT count(*) count FROM student.users";
                        System.out.println("[sql_num_user] : " + sql_num_user);
                        System.out.println("start date - end date : " + sd + " : " + ed);

                        PreparedStatement stmt_num_user = conn.prepareStatement(sql_num_user);
                        ResultSet rs_num_user = stmt_num_user.executeQuery();
                        while( rs_num_user.next() ) {
                            num = rs_num_user.getInt("count");
                        }
                        System.out.println("num :" + num);
                        System.out.println("\n");
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

            <br><!-- comment -->
            <div class="row">
                   <div class="col-md-3">
                          <div class="panel panel-default">
                                 <div class="panel-body" style="background-color: #FFBF00">
                                         <h1> <%= num_total %> </h1>
                                         <p>จำนวนการเข้าใช้งานทั้งหมด (ครั้ง)</p>
                                 </div>
                          </div>
                   </div>
                   <div class="col-md-3">
                          <div class="panel panel-default">
                                  <div class="panel-body" style="background-color: #5fa8d3">
                                         <h1> <%= num_windows %> </h1>
                                         <p>จำนวนการเข้าใช้งาน Windows (ครั้ง)</p>
                                  </div>
                          </div>
                   </div>
                   <div class="col-md-3">
                          <div class="panel panel-default">
                                 <div class="panel-body" style="background-color: #00CC99">
                                         <h1> <%= num_ubuntu %> </h1>
                                         <p>จำนวนการเข้าใช้งาน Ubuntu (ครั้ง)</p>
                                 </div>
                            </div>
                    </div>
                    <div class="col-md-3">
                          <div class="panel panel-default">
                                  <div class="panel-body" style="background-color: #ff5d8f">
                                         <h1> <%= num %> </h1>
                                         <p>จำนวนผู้ใช้งานทั้งหมด (คน)</p>
                                  </div>
                          </div>
                    </div>
            </div>

            <div class="container shadow min-vh-100 py-2">
                    
                    <div class="row justify-content-center">
                            <h4>เลือกช่วงเวลา วัน/เดือน/ปี :</h4>
                            <div class="col-lg-3 col-sm-6">
                                    <label for="startDate">วัน/เดือน/ปี เริ่มต้น</label>
                                    <input id="startDate" class="form-control" type="date" />
                                    <span id="startDateSelected"></span>
                            </div>
                            <div class="col-lg-3 col-sm-6">
                                    <label for="endDate">วัน/เดือน/ปี สิ้นสุด</label>
                                    <input id="endDate" class="form-control" type="date" />
                                    <span id="endDateSelected"></span>
                            </div>
                            <div class="col-lg-3 col-sm-6" id="center">
                                    <h5> วัน/เดือน/ปี เริ่มต้น : <%= sd %> </h5>
                                    <h5> วัน/เดือน/ปี สิ้นสุด : <%= ed %> </h5>
                            </div>
                    </div>  
            </div>  
   
        <div class="row" style="margin-top: 30px;margin-bottom: 20px;">
            <div class="col-md-6" >
                <div id="section" style="padding:20px;">
                    <canvas id="bar-chart_minute_test" style="height: 370px;width: 100%;"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <div id="section" style="padding:20px;">
                    <div id="chart_user_test" style="height: 370px; width: 100%;"></div>
                </div>
            </div>
        </div>

        <div class="row" style="margin-top: 30px;margin-bottom: 20px;">
            <!--Server Name-->
            <div class="col-md-6">
               <div style="padding:30px;" id="section">
                   <div style="height: 495px; ">
                        <canvas id="bar-chart_server_name" style="width: 90%;"></canvas>
                    </div>
               </div>
            </div>
         </div>
            
            
        </div>
</body>

        <!-- User -->
        <script>
        window.onload = function () {
        var chart_test = new CanvasJS.Chart("chart_user_test", {
          theme: "dark2", // "light1", "light2", "dark1"
          animationEnabled: true,
          exportEnabled: true,
          title: {
            //text: "Top 10 Users Login Remote as of 2022"
          },
          axisX: {
            margin: 10,
            labelPlacement: "inside",
            tickPlacement: "inside"
          },
          axisY2: {
            title: "ผู้ใช้งานที่มีการเข้าใช้งานมากที่สุด",
            titleFontSize: 16,
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
        chart_test.render();

        }
        </script>

    
    </body>
    <!-- นาที -->
    <script type="text/javascript">
        new Chart(document.getElementById("bar-chart_minute_test"), {
            type: 'bar',
            data: {
              labels: <%= labels_minute.toString() %>,
              datasets: [
                {
                  //label: "Longest login Remote user July (total minute) ",
                  backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#eaa840","#ea408d","#3e95cd", "#808080","#FF00FF","#FFFF00","#00FFFF","#008080","#00FF00","#29ca31","#fac7f0","#abc1f4"],
                  data: <%= data_minute.toString() %>
                }
              ]
            },
            options: {
              responsive:true,
              title: {
                display: true,
                text: 'จำนวนผู้ใช้งานที่มีการเข้าใช้งานนานที่สุด (นาที)'
              }
            }
        });
    </script>

    <!-- Server -->
        <script type="text/javascript">
        new Chart(document.getElementById("bar-chart_server_name"), {
                type: 'pie',
                data: {
                        labels: <%= labels_server_name.toString() %>,
                        datasets: [
                                {
                                        //label: '<= label_server_name %>',
                                        //label: 'mmจำนวน Server ที่มีการใช้งานมากที่สุด ',
                                        backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#eaa840","#ea408d","#abc1f4", "#808080","#FF00FF","#FFFF00","#00FFFF","#008080","#00FF00","#29ca31","#fac7f0","#abc1f4"],
                                        data: <%= data_server_name.toString() %>
                                }
                        ]
                },
                options: {
                        legend: { display: true, position: 'right' },
                        title: {
                                display: true,
                                font: { size: 18 },
                               // text: '<= label_server_name %>'
                                text: 'จำนวน Server ที่มีการใช้งานมากที่สุด '
                        }
                }
        });
        </script>

        <script>
        let startDate = document.getElementById('startDate')
        let endDate = document.getElementById('endDate')
        var sd = '';
        var ed = '';

        startDate.addEventListener('change', (e) => {
                let startDateVal = e.target.value
                sd = startDateVal
                document.getElementById('startDateSelected').innerText = startDateVal
                
                if (sd && ed) {
                        test(sd,ed)
                }
        })

        endDate.addEventListener('change', (e) => {
                let endDateVal = e.target.value
                ed = endDateVal
                document.getElementById('endDateSelected').innerText = endDateVal
                
                if (sd && ed) {
                    test(sd,ed)
                }
        })

        function test(asd, aed) {
                window.location = 'dashboard.jsp?sd=' + asd + '&ed=' + aed ;
        }
        </script>

</html>
