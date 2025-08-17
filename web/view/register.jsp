<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title> Ghost Initialization </title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
  <style> h1 span { color: #7a0d0d; } </style>
</head>
<body>
  <h1><span></span> Create Your GhostUser <span></span></h1>

  <% String err = request.getParameter("error");
     if ("1".equals(err)) { %>
    <p style="color:red;">❌ Username already taken. Try again.</p>
  <% } %>

  <form action="<%=request.getContextPath()%>/register" method="post">
    <input name="username" placeholder="Ghost ID" required><br>
    <input type="password" name="password" placeholder="Passcode" required><br>
    <button type="submit">Create Ghost</button>
  </form>

  <a href="<%=request.getContextPath()%>/view/neon_gate.jsp">🔙 Back to Login</a>
</body>
</html>
