package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DB.DB;

public class ShadowLinkServlet extends HttpServlet {
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    HttpSession session = req.getSession();
    String currentUser = (String) session.getAttribute("username");
    String userIdParam = req.getParameter("user_id"); // <-- matches your form

    if (currentUser == null || userIdParam == null) {
      res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp");
      return;
    }

    int targetUserId = Integer.parseInt(userIdParam);

    try (Connection conn = DB.connect()) {
      // get current user's id
      int currentUserId;
      try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM GhostUser WHERE username=?")) {
        ps.setString(1, currentUser);
        try (ResultSet rs = ps.executeQuery()) {
          if (!rs.next()) {
            res.sendRedirect(req.getContextPath() + "/view/darkstream.jsp");
            return;
          }
          currentUserId = rs.getInt("id");
        }
      }

      // toggle follow
      boolean alreadyFollowing = false;
      try (PreparedStatement chk = conn.prepareStatement(
          "SELECT 1 FROM ShadowLink WHERE follower_id=? AND followed_id=?")) {
        chk.setInt(1, currentUserId);
        chk.setInt(2, targetUserId);
        try (ResultSet r = chk.executeQuery()) { alreadyFollowing = r.next(); }
      }

      if (alreadyFollowing) {
        try (PreparedStatement del = conn.prepareStatement(
            "DELETE FROM ShadowLink WHERE follower_id=? AND followed_id=?")) {
          del.setInt(1, currentUserId);
          del.setInt(2, targetUserId);
          del.executeUpdate();
        }
      } else {
        try (PreparedStatement ins = conn.prepareStatement(
            "INSERT INTO ShadowLink(follower_id, followed_id) VALUES(?,?)")) {
          ins.setInt(1, currentUserId);
          ins.setInt(2, targetUserId);
          ins.executeUpdate();
        }
      }

      res.sendRedirect(req.getContextPath() + "/view/holo_feed.jsp?user_id=" + targetUserId);

    } catch (SQLException e) {
      throw new ServletException(e);
    }
  }
}
