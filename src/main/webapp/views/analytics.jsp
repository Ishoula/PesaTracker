<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Analytics</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #050505; }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.08); }
        .premium-gradient { background-color: #050505; background-image: radial-gradient(circle at top right, rgba(212,175,55,0.15), transparent 50%); }
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
            <a href="<c:url value='/analytics/dashboard'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-yellow-400 text-black font-medium text-sm"><i data-lucide="bar-chart-2" class="w-4 h-4"></i>Analytics</a>
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
        <div class="mb-12">
            <h1 class="text-4xl font-bold text-white tracking-tight">Advanced Analytics</h1>
            <p class="text-gray-400 mt-2">Deep insights into your spending patterns.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="glass-card p-6 rounded-3xl">
                <p class="text-gray-400 text-sm">Monthly Total</p>
                <h2 class="text-3xl font-bold text-white mt-2"><fmt:formatNumber value="${weeklyComparison.totalSpent}" type="currency" currencySymbol="$"/></h2>
            </div>
            <div class="glass-card p-6 rounded-3xl">
                <p class="text-gray-400 text-sm">Daily Average</p>
                <h2 class="text-3xl font-bold text-yellow-400 mt-2"><fmt:formatNumber value="${weeklyComparison.dailyAverage}" type="currency" currencySymbol="$"/></h2>
            </div>
            <div class="glass-card p-6 rounded-3xl">
                <p class="text-gray-400 text-sm">MoM Change</p>
                <h2 class="text-3xl font-bold ${trends.monthOverMonthChange >= 0 ? 'text-red-400' : 'text-green-400'} mt-2">
                    <fmt:formatNumber value="${trends.monthOverMonthChange}" pattern="#0.0"/>%
                </h2>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-xl font-bold text-white mb-6">Top Categories</h3>
                <div class="relative h-64">
                    <canvas id="topCategoriesChart"></canvas>
                </div>
            </div>
            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-xl font-bold text-white mb-6">6-Month Trend</h3>
                <div class="relative h-64">
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
        </div>

        <div class="glass-card p-8 rounded-3xl">
            <h3 class="text-xl font-bold text-white mb-6">Top Spending Categories</h3>
            <div class="space-y-4">
                <c:forEach var="cat" items="${topCategories.topCategories}" varStatus="status">
                    <div class="flex items-center justify-between p-4 bg-white/5 rounded-xl">
                        <div class="flex items-center gap-4">
                            <div class="w-8 h-8 rounded-lg bg-yellow-400/20 text-yellow-400 flex items-center justify-center font-bold">${status.count}</div>
                            <span class="text-white font-medium">${cat.name}</span>
                        </div>
                        <span class="text-white font-bold"><fmt:formatNumber value="${cat.total}" type="currency" currencySymbol="$"/></span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>

    <script>
        lucide.createIcons();

        const topCats = [];
        const topCatValues = [];
        <c:forEach var="cat" items="${topCategories.topCategories}">
            topCats.push("${cat.name}");
            topCatValues.push(${cat.total});
        </c:forEach>

        new Chart(document.getElementById('topCategoriesChart'), {
            type: 'doughnut',
            data: {
                labels: topCats,
                datasets: [{
                    data: topCatValues,
                    backgroundColor: ['#D4AF37', '#eab308', '#ca8a04', '#a16207', '#854d0e']
                }]
            },
            options: { responsive: true, maintainAspectRatio: false, cutout: '70%', plugins: { legend: { position: 'right', labels: { color: '#9ca3af' } } } }
        });

        const trendMonths = [];
        const trendValues = [];
        <c:forEach var="m" items="${trends.monthlyTrends}">
            trendMonths.push("${m.month} ${m.year}");
            trendValues.push(${m.total});
        </c:forEach>

        new Chart(document.getElementById('trendChart'), {
            type: 'line',
            data: {
                labels: trendMonths,
                datasets: [{
                    label: 'Spending',
                    data: trendValues,
                    borderColor: '#D4AF37',
                    backgroundColor: 'rgba(212,175,55,0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { ticks: { color: '#9ca3af' }, grid: { color: 'rgba(255,255,255,0.05)' } }, x: { ticks: { color: '#9ca3af' }, grid: { display: false } } }, plugins: { legend: { display: false } } }
        });
    </script>
</body>
</html>
