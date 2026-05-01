package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Notification;
import models.User;
import service.NotificationService;

import java.io.IOException;
import java.util.List;

@WebServlet("/notifications/*")
public class NotificationController extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() {
        this.notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Notification> notifications = notificationService.getNotificationsByUser(user.getId());
        long unreadCount = notificationService.getUnreadCount(user.getId());

        req.setAttribute("notifications", notifications);
        req.setAttribute("unreadCount", unreadCount);
        req.getRequestDispatcher("/views/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getPathInfo();

        if ("/markRead".equals(action)) {
            notificationService.markAllRead(user.getId());
        } else if ("/checkAlerts".equals(action)) {
            notificationService.checkBudgetAlerts(user);
            notificationService.checkUnusualSpending(user);
        }

        resp.sendRedirect(req.getContextPath() + "/notifications");
    }
}
