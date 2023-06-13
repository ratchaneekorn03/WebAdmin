<header>
	<nav class="navbar navbar-expand-md navbar-dark"
		style="background-color: #2ECC71">
		<div>
			 Remote Admin
		</div>

		<ul class="navbar-nav navbar-collapse justify-content-center">
                        <li><a href="<%= request.getContextPath() %>/admin.jsp" class="nav-link">Admin</a></li>
                        <li><a href="<%= request.getContextPath() %>/server.jsp" class="nav-link">Server</a></li>
                        <li><a href="<%= request.getContextPath() %>/login_history.jsp" class="nav-link">Login History</a></li>
			<li><a href="<%= request.getContextPath() %>/logout.jsp" class="nav-link">Logout</a></li>
		</ul>
	</nav>
</header>