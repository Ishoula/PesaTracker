package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import service.UserService;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/auth/*") // Using /auth/ as the base for clean URLs
public class UserController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        // Initializing with the service layer logic we built
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        // Redirect root /auth/ to /auth/login
        if (action == null || action.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        switch (action) {
            case "/register":
                showPage(req, resp, "register.jsp");
                break;
            case "/login":
                showPage(req, resp, "login.jsp");
                break;
            case "/logout":
                handleLogout(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        switch (action) {
            case "/register":
                handleRegister(req, resp);
                break;
            case "/login":
                handleLogin(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    /**
     * Clean URL Helper: Forwards to hidden JSPs in WEB-INF
     */
    private void showPage(HttpServletRequest req, HttpServletResponse resp, String jspName) throws ServletException, IOException {
        req.getRequestDispatcher("/views/" + jspName).forward(req, resp);
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String uname = req.getParameter("username");
        String pass = req.getParameter("password");

        boolean success = userService.registerUser(uname, pass);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/auth/login?msg=registered");
        } else {
            req.setAttribute("error", "Registration failed. Username might be taken.");
            showPage(req, resp, "register.jsp");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String uname = req.getParameter("username");
        String pass = req.getParameter("password");

        Optional<User> user = userService.login(uname, pass);

        if (user.isPresent()) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user.get());
            // Redirect to the ExpenseController's dashboard
            resp.sendRedirect(req.getContextPath() + "/expenses/dashboard");
        } else {
            req.setAttribute("error", "Invalid username or password");
            showPage(req, resp, "login.jsp");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}