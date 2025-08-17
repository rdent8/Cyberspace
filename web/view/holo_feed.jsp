<%@ page import="java.sql.*, DB.DB" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String sessionUser = (String) session.getAttribute("username");
  if (sessionUser == null) {
    response.sendRedirect(request.getContextPath() + "/view/neon_gate.jsp");
    return;
  }

  String viewedUserId = request.getParameter("user_id");
  String usernameParam = request.getParameter("username");

  Connection conn = DB.connect();

  int resolvedUserId = -1;
  String resolvedUsername = null;

  if (viewedUserId != null) {
    PreparedStatement userStmt = conn.prepareStatement(
      "SELECT id, username FROM GhostUser WHERE id = ?"
    );
    userStmt.setInt(1, Integer.parseInt(viewedUserId));
    ResultSet userRs = userStmt.executeQuery();
    if (userRs.next()) {
      resolvedUserId = userRs.getInt("id");
      resolvedUsername = userRs.getString("username");
    }
  } else if (usernameParam != null) {
    PreparedStatement userStmt = conn.prepareStatement(
      "SELECT id, username FROM GhostUser WHERE username = ?"
    );
    userStmt.setString(1, usernameParam);
    ResultSet userRs = userStmt.executeQuery();
    if (userRs.next()) {
      resolvedUserId = userRs.getInt("id");
      resolvedUsername = userRs.getString("username");
    }
  }

  if (resolvedUserId == -1) {
    response.sendRedirect(request.getContextPath() + "/view/darkstream.jsp");
    return;
  }

  // Check follow state (only if viewing someone else)
  boolean isFollowing = false;
  if (!sessionUser.equals(resolvedUsername)) {
    PreparedStatement psFollow = conn.prepareStatement(
      "SELECT 1 FROM ShadowLink " +
      "WHERE follower_id = (SELECT id FROM GhostUser WHERE username = ?) " +
      "AND followed_id = ?"
    );
    psFollow.setString(1, sessionUser);
    psFollow.setInt(2, resolvedUserId);
    ResultSet rsFollow = psFollow.executeQuery();
    isFollowing = rsFollow.next();
  }

  // Fetch posts for this user, include like_count and whether *you* liked it
  PreparedStatement ps = conn.prepareStatement(
    "SELECT dp.*, gu.username, " +
    "  (SELECT COUNT(*) FROM Voltage v WHERE v.pulse_id = dp.id) AS like_count, " +
    "  (SELECT COUNT(*) FROM Voltage vv " +
    "     WHERE vv.pulse_id = dp.id AND vv.user_id = (SELECT id FROM GhostUser WHERE username=?)) AS liked " +
    "FROM DataPulse dp " +
    "JOIN GhostUser gu ON dp.user_id = gu.id " +
    "WHERE dp.user_id = ? " +
    "ORDER BY dp.timestamp DESC"
  );
  ps.setString(1, sessionUser);   // for 'liked' subquery
  ps.setInt(2, resolvedUserId);
  ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
  <title>👤 HoloFeed - <%= resolvedUsername %></title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>

  <div style="position: absolute; top: 10px; right: 10px;">
    <form action="<%=request.getContextPath()%>/logout" method="get">
      <button type="submit">🚪 Logout</button>
    </form>
  </div>

  <h1>👤 <%= resolvedUsername %>'s Feed</h1>
  <a href="<%=request.getContextPath()%>/view/darkstream.jsp">⬅ Back to Main Feed</a>

  <!-- Optional bio spot -->
  <p><i>[Bio coming soon]</i></p>

  <% if (!sessionUser.equals(resolvedUsername)) { %>
    <form action="<%=request.getContextPath()%>/follow" method="post">
      <input type="hidden" name="user_id" value="<%= resolvedUserId %>">
      <button type="submit"><%= isFollowing ? "Unfollow" : "Follow" %></button>
    </form>
  <% } %>

  <% while (rs.next()) { 
       boolean youLiked = rs.getInt("liked") > 0; %>
    <!-- Anchor so redirect lands back on this post -->
    <div id="pulse<%= rs.getInt("id") %>">
      <strong><%= rs.getString("username") %>:</strong>
      <p><%= rs.getString("content") %></p>
      <% if (rs.getString("image_path") != null) { %>
        <img src="<%=request.getContextPath()%>/datauploads/<%= rs.getString("image_path") %>" width="200">
      <% } %>
      <p><small>🕒 <%= rs.getTimestamp("timestamp") %></small></p>

      <form action="<%=request.getContextPath()%>/like" method="post">
        <input type="hidden" name="pulse_id" value="<%= rs.getInt("id") %>">
        <button type="submit"><%= youLiked ? "⚡ Liked" : "⚡ Like" %> (<%= rs.getInt("like_count") %>)</button>
      </form>
    </div>
  <% } %>
</body>
</html>
