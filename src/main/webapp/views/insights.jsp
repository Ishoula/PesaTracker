<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Smart Insights</title>

    <!-- Scripts -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        yellow: { 300: '#E4CC66', 400: '#D4AF37', 500: '#C5A017', 600: '#AA8C2C' }
                    }
                }
            }
        }
    </script>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #D4AF37;
            --primary-glow: rgba(212, 175, 55, 0.2);
            --card-bg: rgba(255, 255, 255, 0.03);
            --card-border: rgba(255, 255, 255, 0.08);
            --sidebar-bg: rgba(10, 10, 10, 0.8);
        }

        body { 
            font-family: 'Outfit', sans-serif;
            background-color: #050505;
        }

        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            border-color: rgba(212, 175, 55, 0.3);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
        }

        .nav-item {
            transition: all 0.2s ease;
        }

        .nav-item.active {
            background: var(--primary);
            color: #000;
            box-shadow: 0 0 15px var(--primary-glow);
        }

        .nav-item:not(.active):hover {
            background: rgba(255, 255, 255, 0.05);
            transform: translateX(5px);
        }

        .premium-gradient {
            background-color: #050505;
            background-image: radial-gradient(circle at top right, rgba(212, 175, 55, 0.15), transparent 50%),
                        radial-gradient(circle at bottom left, rgba(212, 175, 55, 0.05), transparent 50%);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-in {
            animation: fadeIn 0.5s ease forwards;
        }
    </style>
</head>

<body class="text-gray-200 min-h-screen premium-gradient">

    <!-- SIDEBAR -->
    <aside class="fixed left-0 top-0 h-full w-64 bg-[#0a0a0a]/90 backdrop-blur-xl border-r border-white/5 p-6 z-50">
        <div class="flex items-center gap-3 mb-12 px-2">
            <div class="w-10 h-10 bg-yellow-400 rounded-xl flex items-center justify-center shadow-[0_0_20px_rgba(250,204,21,0.3)]">
                <i data-lucide="wallet" class="text-black w-6 h-6"></i>
            </div>
            <h2 class="text-xl font-bold tracking-tight text-white">PesaTracker</h2>
        </div>
        <nav class="space-y-1">
            <p class="text-gray-500 text-[10px] uppercase tracking-widest mb-4 px-2 font-semibold">Menu</p>
            <a href="<c:url value='/expenses/dashboard'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="layout-dashboard" class="w-4 h-4"></i>Dashboard
            </a>
            <a href="<c:url value='/budget'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="target" class="w-4 h-4"></i>Budgets
            </a>
            <a href="<c:url value='/tags'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="tag" class="w-4 h-4"></i>Tags
            </a>
            <a href="<c:url value='/recurring'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="repeat" class="w-4 h-4"></i>Recurring
            </a>
            <a href="<c:url value='/notifications'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="bell" class="w-4 h-4"></i>Notifications
            </a>
            <a href="<c:url value='/analytics/dashboard'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="bar-chart-2" class="w-4 h-4"></i>Analytics
            </a>
            <a href="<c:url value='/analytics/calendar'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="calendar" class="w-4 h-4"></i>Calendar
            </a>
            <a href="<c:url value='/search'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="search" class="w-4 h-4"></i>Search
            </a>
            <a href="<c:url value='/export'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="download" class="w-4 h-4"></i>Export/Import
            </a>
            <a href="<c:url value='/expenses/add'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5">
                <i data-lucide="plus-circle" class="w-4 h-4"></i>Add Expense
            </a>
            <div class="pt-10">
                <a href="<c:url value='/auth/logout'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition text-sm font-medium">
                    <i data-lucide="log-out" class="w-4 h-4"></i>Sign Out
                </a>
            </div>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="ml-64 p-8 lg:p-12">
        
        <!-- HEADER -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-12 gap-6 animate-in">
            <div>
                <h1 class="text-4xl font-bold text-white tracking-tight">Smart Insights</h1>
                <p class="text-gray-400 mt-2 font-light">AI-driven analysis of your spending patterns to help you save.</p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-10">
            
            <!-- SPENDING TREND -->
            <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.1s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-white/10 rounded-2xl border border-white/20">
                        <i data-lucide="trending-up" class="text-white w-6 h-6"></i>
                    </div>
                </div>
                <p class="text-gray-400 text-sm font-medium">Month-over-Month Trend</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">
                    <c:choose>
                        <c:when test="${insights.trendPercentage > 0}">
                            <span class="text-red-500">+<fmt:formatNumber value="${insights.trendPercentage}" pattern="#,##0.0"/>%</span>
                        </c:when>
                        <c:when test="${insights.trendPercentage < 0}">
                            <span class="text-green-500"><fmt:formatNumber value="${insights.trendPercentage}" pattern="#,##0.0"/>%</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-gray-400">0%</span>
                        </c:otherwise>
                    </c:choose>
                </h2>
                <div class="mt-4 text-xs text-gray-500">
                    <fmt:formatNumber value="${insights.currentMonthTotal}" type="currency" currencySymbol="$"/> spent this month
                </div>
            </div>

            <!-- HIGHEST CATEGORY -->
            <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.2s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-yellow-600/10 rounded-2xl border border-yellow-600/20">
                        <i data-lucide="award" class="text-yellow-600 w-6 h-6"></i>
                    </div>
                </div>
                <p class="text-gray-400 text-sm font-medium">Highest Spending Category</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">${insights.highestCategory}</h2>
                <div class="mt-4 text-xs text-gray-500 font-bold text-yellow-400">
                    <fmt:formatNumber value="${insights.highestAmount}" type="currency" currencySymbol="$"/>
                </div>
            </div>

            <!-- SAVINGS POTENTIAL -->
            <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.3s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-yellow-400/10 rounded-2xl border border-yellow-400/20">
                        <i data-lucide="piggy-bank" class="text-yellow-400 w-6 h-6"></i>
                    </div>
                </div>
                <p class="text-gray-400 text-sm font-medium">Actionable Suggestions</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">${insights.suggestions.size()}</h2>
                <div class="mt-4 text-xs text-gray-500">
                    Suggestions to review below
                </div>
            </div>

        </div>

        <!-- SUGGESTIONS LIST -->
        <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.4s">
            <h3 class="text-xl font-bold text-white tracking-tight mb-6">Your Personalized Insights</h3>
            
            <div class="space-y-4">
                <c:forEach var="suggestion" items="${insights.suggestions}">
                    <div class="bg-white/5 border border-white/10 rounded-2xl p-5 flex gap-4 items-start hover:bg-white/10 transition-colors">
                        <div class="mt-1">
                            <i data-lucide="sparkles" class="w-5 h-5 text-yellow-400"></i>
                        </div>
                        <div>
                            <p class="text-gray-300 text-sm leading-relaxed">${suggestion}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </main>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>
