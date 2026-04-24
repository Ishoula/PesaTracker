<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Pesa Tracker - Login</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h2 { color: #2c3e50; text-align: center; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; color: #666; }
        input { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 0.75rem; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; }
        button:hover { background-color: #2980b9; }
        .error { color: #e74c3c; background: #fadbd8; padding: 0.5rem; border-radius: 4px; margin-bottom: 1rem; text-align: center; }
        .msg { color: #27ae60; background: #d4efdf; padding: 0.5rem; border-radius: 4px; margin-bottom: 1rem; text-align: center; }
        .footer { text-align: center; margin-top: 1rem; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Pesa Tracker</h2>

        <%-- Displaying messages from Controller --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("registered")) { %>
            <div class="msg">Registration successful! Please login.</div>
        <% } %>

        <form action="<c:url value='/auth/login'/>" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Sign In</button>
        </form>

        <div class="footer">
            Don&apos;t have an account? <a href="<c:url value='/auth/register'/>">Register here</a>
        </div>
    </div>
</body>
</html>