<header>
    <nav class="navbar" style="background-color: #F49D1A;color: #f2f2f2;">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="<%= request.getContextPath() %>/admin.jsp">Remote Admin</a>
            </div>
        <ul class="nav navbar-nav">
            <li class="nav-item <%= request.getServletPath().endsWith("admin.jsp") ? "active" : "" %>"><a class="nav-link" href="<%= request.getContextPath() %>/admin.jsp">Admin</a></li>
            <li class="nav-item <%= request.getServletPath().endsWith("server.jsp") ? "active" : "" %>"><a class="nav-link" href="<%= request.getContextPath() %>/server.jsp">Server</a></li>
            <li class="nav-item <%= request.getServletPath().endsWith("login_history.jsp") ? "active" : "" %>"><a class="nav-link" href="<%= request.getContextPath() %>/login_history.jsp">Login History</a></li>
            <li class="nav-item <%= request.getServletPath().endsWith("dashboard.jsp") ? "active" : "" %>"><a class="nav-link" href="<%= request.getContextPath() %>/dashboard.jsp">Dashboard</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/logout.jsp"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
        </ul>
        </div>
    </nav>
</header>
        
<!--.topnav {
  overflow: hidden;
  background-color: #FF591E;;
}

.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #333;
  color: white;
}

.topnav a.active {
  background-color: #333;
  color: white;
}-->