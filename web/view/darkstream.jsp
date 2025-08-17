<%@ page import="java.sql.*, DB.DB" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String user = (String) session.getAttribute("username");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/view/neon_gate.jsp");
    return;
  }

  Connection conn = DB.connect();
  PreparedStatement ps = conn.prepareStatement(
    "SELECT dp.*, gu.username, gu.id AS user_id, " +
    "  (SELECT COUNT(*) FROM Voltage v WHERE v.pulse_id = dp.id) AS like_count, " +
    "  (SELECT COUNT(*) FROM Voltage vv " +
    "     WHERE vv.pulse_id = dp.id AND vv.user_id = (SELECT id FROM GhostUser WHERE username=?)) AS liked " +
    "FROM DataPulse dp " +
    "JOIN GhostUser gu ON dp.user_id = gu.id " +
    "WHERE dp.user_id IN ( " +
    "  SELECT followed_id FROM ShadowLink " +
    "  WHERE follower_id = (SELECT id FROM GhostUser WHERE username = ?) " +
    ") OR gu.username = ? " +
    "ORDER BY dp.timestamp DESC"
  );
  ps.setString(1, user); // liked check
  ps.setString(2, user); // followed
  ps.setString(3, user); // your own
  ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
  <title> DarkStream</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

  <div style="position: absolute; top: 10px; right: 10px;">
    <form action="<%=request.getContextPath()%>/logout" method="get">
      <button type="submit">🚪 Logout</button>
    </form>
  </div>

  <h1> DarkStream Feed</h1>

  <form action="<%=request.getContextPath()%>/view/holo_feed.jsp" method="get">
    <input type="text" name="username" placeholder="Search for a user..." required>
    <button type="submit">Search</button>
  </form>

  <form action="<%=request.getContextPath()%>/upload" method="post" enctype="multipart/form-data">
    <textarea name="content" placeholder="Broadcast your DataPulse..."></textarea><br>
    <input type="file" name="image"><br>
    <button type="submit">Send Pulse</button>
  </form>

  <% while (rs.next()) { 
       boolean youLiked = rs.getInt("liked") > 0; %>
    <!-- Anchor so redirect lands back on this post -->
    <div id="pulse<%= rs.getInt("id") %>">
      <strong>
        <a href="<%=request.getContextPath()%>/view/holo_feed.jsp?user_id=<%= rs.getInt("user_id") %>">
          <%= rs.getString("username") %>
        </a>:
      </strong>
      <p><%= rs.getString("content") %></p>
      <% if (rs.getString("image_path") != null) { %>
        <img src="<%=request.getContextPath()%>/datauploads/<%= rs.getString("image_path") %>" width="200">
      <% } %>
      <p><small>🕒 <%= rs.getTimestamp("timestamp") %></small></p>

      <form action="<%=request.getContextPath()%>/like" method="post">
        <input type="hidden" name="pulse_id" value="<%= rs.getInt("id") %>">
        <button type="submit">
          <%= youLiked ? "⚡ Liked" : "⚡ Like" %> (<%= rs.getInt("like_count") %>)
        </button>
      </form>
    </div>
  <% } %>
</body>
</html>
