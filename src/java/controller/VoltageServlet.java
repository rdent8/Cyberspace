package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DB.DB;

public class VoltageServlet extends HttpServlet {
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    String pulseIdStr = req.getParameter("pulse_id");
    HttpSession session = req.getSession(false);
    String username = (session != null) ? (String) session.getAttribute("username") : null;

    // Must be logged in and have a pulse_id
    if (username == null || pulseIdStr == null) {
      res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp");
      return;
    }

    int pulseId;
    try {
      pulseId = Integer.parseInt(pulseIdStr);
    } catch (NumberFormatException e) {
      res.sendRedirect(req.getContextPath() + "/view/darkstream.jsp");
      return;
    }

    try (Connection conn = DB.connect()) {
      // Resolve current user id
      Integer userId = null;
      try (PreparedStatement u = conn.prepareStatement(
          "SELECT id FROM GhostUser WHERE username=?")) {
        u.setString(1, username);
        try (ResultSet r = u.executeQuery()) {
          if (r.next()) userId = r.getInt("id");
        }
      }
      if (userId == null) {
        res.sendRedirect(req.getContextPath() + "/view/darkstream.jsp");
        return;
      }

     
      boolean alreadyLiked = false;
      try (PreparedStatement chk = conn.prepareStatement(
          "SELECT 1 FROM Voltage WHERE pulse_id=? AND user_id=?")) {
        chk.setInt(1, pulseId);
        chk.setInt(2, userId);
        try (ResultSet r = chk.executeQuery()) {
          alreadyLiked = r.next();
        }
      }

      if (alreadyLiked) {
        try (PreparedStatement del = conn.prepareStatement(
            "DELETE FROM Voltage WHERE pulse_id=? AND user_id=?")) {
          del.setInt(1, pulseId);
          del.setInt(2, userId);
          del.executeUpdate();
        }
      } else {
        try (PreparedStatement ins = conn.prepareStatement(
            "INSERT INTO Voltage(pulse_id, user_id) VALUES (?, ?)")) {
          ins.setInt(1, pulseId);
          ins.setInt(2, userId);
          ins.executeUpdate();
        }
      }

     
      String ref = req.getHeader("Referer");
      String base = (ref != null ? ref : (req.getContextPath() + "/view/darkstream.jsp"));
      base = base.replaceAll("#.*$", ""); 
      res.sendRedirect(base + "#pulse" + pulseId);

    } catch (SQLException e) {
      throw new ServletException(e);
    }
  }
}
