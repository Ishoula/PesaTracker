package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Tag;
import models.User;
import service.TagService;

import java.io.IOException;
import java.util.List;

@WebServlet("/tags/*")
public class TagController extends HttpServlet {

    private TagService tagService;

    @Override
    public void init() {
        this.tagService = new TagService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Tag> tags = tagService.getTagsByUser(user.getId());
        req.setAttribute("tags", tags);
        req.getRequestDispatcher("/views/tags.jsp").forward(req, resp);
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

        if ("/save".equals(action)) {
            String name = req.getParameter("name");
            String color = req.getParameter("colorCode");
            tagService.getOrCreateTag(name, user, color);
        } else if ("/delete".equals(action)) {
            Long tagId = Long.parseLong(req.getParameter("id"));
            tagService.deleteTag(tagId);
        }

        resp.sendRedirect(req.getContextPath() + "/tags");
    }
}
