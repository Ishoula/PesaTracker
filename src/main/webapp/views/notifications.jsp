<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Notifications</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #050505; }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.08); }
        .premium-gradient { background-color: #050505; background-image: radial-gradient(circle at top right, rgba(212,175,55,0.15), transparent 50%); }
        .notification-unread { border-left: 3px solid #D4AF37; }
    </style>
</head>
<body class="text-gray-200 min-h-screen premium-gradient">
    <aside class="fixed left-0 top-0 h-full w-64 bg-[#0a0a0a]/90 backdrop-blur-xl border-r border-white/5 p-6 z-50">
        <div class="flex items-center gap-3 mb-12 px-2">
            <div class="w-10 h-10 bg-yellow-400 rounded-xl flex items-center justify-center shadow-[0_0_20px_rgba(250,204,21,0.3)]">
                <i data-lucide="wallet" class="text-black w-6 h-6"></i>
            </div>
            <h2 class="text-xl font-bold tracking-tight text-white">PesaTracker</h2>
        </div>
        <nav class="space-y-1">
            <p class="text-gray-500 text-[10px] uppercase tracking-widest mb-4 px-2 font-semibold">Menu</p>
            <a href="<c:url value='/expenses/dashboard'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="layout-dashboard" class="w-4 h-4"></i>Dashboard</a>
            <a href="<c:url value='/budget'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="target" class="w-4 h-4"></i>Budgets</a>
            <a href="<c:url value='/tags'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="tag" class="w-4 h-4"></i>Tags</a>
            <a href="<c:url value='/recurring'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="repeat" class="w-4 h-4"></i>Recurring</a>
            <a href="<c:url value='/notifications'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-yellow-400 text-black font-medium text-sm"><i data-lucide="bell" class="w-4 h-4"></i>Notifications</a>
            <a href="<c:url value='/analytics/dashboard'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bar-chart-2" class="w-4 h-4"></i>Analytics</a>
            <a href="<c:url value='/analytics/calendar'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="calendar" class="w-4 h-4"></i>Calendar</a>
            <a href="<c:url value='/search'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="search" class="w-4 h-4"></i>Search</a>
            <a href="<c:url value='/export'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="download" class="w-4 h-4"></i>Export/Import</a>
            <a href="<c:url value='/expenses/add'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="plus-circle" class="w-4 h-4"></i>Add Expense</a>
            <div class="pt-10">
                <a href="<c:url value='/auth/logout'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition text-sm font-medium"><i data-lucide="log-out" class="w-4 h-4"></i>Sign Out</a>
            </div>
        </nav>
    </aside>

    <main class="ml-64 p-8 lg:p-12">
        <div class="flex justify-between items-center mb-12">
            <div>
                <h1 class="text-4xl font-bold text-white tracking-tight">Notifications</h1>
                <p class="text-gray-400 mt-2">Stay updated on your finances.</p>
            </div>
            <div class="flex gap-3">
                <form action="<c:url value='/notifications/checkAlerts'/>" method="POST" class="inline">
                    <button type="submit" class="bg-white/10 text-white border border-white/20 px-6 py-3 rounded-xl font-bold hover:bg-white/20 transition">
                        <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-2"></i>Check Alerts
                    </button>
                </form>
                <form action="<c:url value='/notifications/markRead'/>" method="POST" class="inline">
                    <button type="submit" class="bg-yellow-400 text-black px-6 py-3 rounded-xl font-bold hover:bg-yellow-300 transition">Mark All Read</button>
                </form>
            </div>
        </div>

        <div class="glass-card p-8 rounded-3xl">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-xl font-bold text-white">Your Notifications</h3>
                <span class="text-sm text-gray-400">${unreadCount} unread</span>
            </div>
            <div class="space-y-3">
                <c:forEach var="n" items="${notifications}">
                    <div class="bg-white/5 border border-white/10 rounded-2xl p-5 ${n.isRead ? '' : 'notification-unread'}">
                        <div class="flex items-start gap-4">
                            <div class="mt-1">
                                <c:choose>
                                    <c:when test="${n.notificationType eq 'BUDGET_EXCEEDED'}"><i data-lucide="alert-triangle" class="w-5 h-5 text-red-400"></i></c:when>
                                    <c:when test="${n.notificationType eq 'BUDGET_WARNING'}"><i data-lucide="alert-circle" class="w-5 h-5 text-yellow-400"></i></c:when>
                                    <c:when test="${n.notificationType eq 'UNUSUAL_SPENDING'}"><i data-lucide="trending-up" class="w-5 h-5 text-orange-400"></i></c:when>
                                    <c:otherwise><i data-lucide="bell" class="w-5 h-5 text-gray-400"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-1">
                                <p class="text-white font-semibold">${n.title} <c:if test="${!n.isRead}"><span class="ml-2 bg-yellow-400 text-black text-[10px] px-2 py-0.5 rounded-full">NEW</span></c:if></p>
                                <p class="text-gray-400 text-sm mt-1">${n.message}</p>
                                <p class="text-gray-500 text-xs mt-2"><fmt:formatDate value="${n.createdAt}" pattern="MMM dd, yyyy HH:mm"/></p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty notifications}">
                    <div class="text-center py-12">
                        <i data-lucide="bell-off" class="w-12 h-12 mx-auto text-gray-600 mb-4"></i>
                        <p class="text-gray-500">No notifications yet.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
    <script>lucide.createIcons();</script>
</body>
</html>
