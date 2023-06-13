<%
    String username;

    if (request.getSession().getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        System.out.println("getSession null username");
    } else {
        username = request.getSession().getAttribute("username").toString();
        session.invalidate();
        System.out.println("/logout getSession : " + username);
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
%>