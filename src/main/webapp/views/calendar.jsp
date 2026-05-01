<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Calendar</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #050505; }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.08); }
        .premium-gradient { background-color: #050505; background-image: radial-gradient(circle at top right, rgba(212,175,55,0.15), transparent 50%); }
        .calendar-day { min-height: 100px; }
        .calendar-day:hover { background: rgba(255,255,255,0.05); }
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
            <a href="<c:url value='/notifications'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bell" class="w-4 h-4"></i>Notifications</a>
            <a href="<c:url value='/analytics/dashboard'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bar-chart-2" class="w-4 h-4"></i>Analytics</a>
            <a href="<c:url value='/analytics/calendar'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-yellow-400 text-black font-medium text-sm"><i data-lucide="calendar" class="w-4 h-4"></i>Calendar</a>
            <a href="<c:url value='/search'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="search" class="w-4 h-4"></i>Search</a>
            <a href="<c:url value='/export'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="download" class="w-4 h-4"></i>Export/Import</a>
            <a href="<c:url value='/expenses/add'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="plus-circle" class="w-4 h-4"></i>Add Expense</a>
            <div class="pt-10">
                <a href="<c:url value='/auth/logout'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition text-sm font-medium"><i data-lucide="log-out" class="w-4 h-4"></i>Sign Out</a>
            </div>
        </nav>
    </aside>

    <main class="ml-64 p-8 lg:p-12">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-4xl font-bold text-white tracking-tight">Calendar View</h1>
                <p class="text-gray-400 mt-2">Track your spending by day.</p>
            </div>
            <div class="flex items-center gap-4">
                <a href="<c:url value='/analytics/calendar?month=${currentMonth > 1 ? currentMonth - 1 : 12}&year=${currentMonth > 1 ? currentYear : currentYear - 1}'/>" class="p-2 rounded-xl bg-white/5 hover:bg-white/10 text-white"><i data-lucide="chevron-left" class="w-5 h-5"></i></a>
                <span class="text-xl font-semibold text-white">${currentMonth}/${currentYear}</span>
                <a href="<c:url value='/analytics/calendar?month=${currentMonth < 12 ? currentMonth + 1 : 1}&year=${currentMonth < 12 ? currentYear : currentYear + 1}'/>" class="p-2 rounded-xl bg-white/5 hover:bg-white/10 text-white"><i data-lucide="chevron-right" class="w-5 h-5"></i></a>
            </div>
        </div>

        <div class="glass-card p-6 rounded-3xl">
            <div class="grid grid-cols-7 gap-2 mb-4">
                <div class="text-center text-gray-500 text-sm py-2">Sun</div>
                <div class="text-center text-gray-500 text-sm py-2">Mon</div>
                <div class="text-center text-gray-500 text-sm py-2">Tue</div>
                <div class="text-center text-gray-500 text-sm py-2">Wed</div>
                <div class="text-center text-gray-500 text-sm py-2">Thu</div>
                <div class="text-center text-gray-500 text-sm py-2">Fri</div>
                <div class="text-center text-gray-500 text-sm py-2">Sat</div>
            </div>
            <div class="grid grid-cols-7 gap-2">
                <c:forEach var="day" items="${calendarData}">
                    <div class="calendar-day p-3 rounded-xl border border-white/5 ${day.isCurrentMonth ? 'bg-white/5' : 'bg-transparent opacity-50'} ${day.isToday ? 'ring-2 ring-yellow-400' : ''}">
                        <div class="flex justify-between items-start">
                            <span class="text-sm ${day.isToday ? 'text-yellow-400 font-bold' : 'text-gray-400'}">${day.dayOfMonth}</span>
                        </div>
                        <c:if test="${day.spending > 0}">
                            <div class="mt-2 text-right">
                                <span class="text-xs text-yellow-400 font-medium">$<fmt:formatNumber value="${day.spending}" pattern="#0.00"/></span>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
    <script>lucide.createIcons();</script>
</body>
</html>
