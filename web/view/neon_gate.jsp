<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Neon Gate</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
  <style> h1 span { color: #7a0d0d; } </style>
</head>
<body>
  <h1><span></span> Jack Into Cyberspace <span></span></h1>

  <% if (request.getParameter("error") != null) { %>
    <p style="color:red;">❌ Invalid login. Try again.</p>
  <% } %>

  <% if (request.getParameter("registered") != null) { %>
    <p style="color:green;">✅ Registration successful!</p>
  <% } %>

  <form method="post" action="<%=request.getContextPath()%>/login">
    <input type="text" name="username" placeholder="Ghost ID" required><br>
    <input type="password" name="password" placeholder="Passcode" required><br>
    <button type="submit">Jack In</button>
  </form>

  <a href="<%=request.getContextPath()%>/view/register.jsp">New Ghost? Register</a>
</body>
</html>
