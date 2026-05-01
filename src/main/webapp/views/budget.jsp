<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Budget Management</title>

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

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.2); }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-in {
            animation: fadeIn 0.5s ease forwards;
        }

        .progress-bar-container {
            width: 100%;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            overflow: hidden;
            height: 12px;
            margin-top: 8px;
        }
        .progress-bar-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.5s ease;
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
                <h1 class="text-4xl font-bold text-white tracking-tight">Budget Management</h1>
                <p class="text-gray-400 mt-2 font-light">Set limits and track your spending for <span class="text-yellow-400 font-medium">Month ${currentMonth}/${currentYear}</span>.</p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <!-- OVERALL BUDGET -->
            <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.1s">
                <h3 class="text-xl font-bold text-white tracking-tight mb-6">Overall Monthly Budget</h3>
                
                <c:choose>
                    <c:when test="${overallBudget != null}">
                        <div class="mb-6">
                            <div class="flex justify-between items-end mb-2">
                                <div>
                                    <p class="text-gray-400 text-sm">Spent</p>
                                    <p class="text-2xl font-bold text-white"><fmt:formatNumber value="${totalSpent}" type="currency" currencySymbol="$"/></p>
                                </div>
                                <div class="text-right">
                                    <p class="text-gray-400 text-sm">Budget</p>
                                    <p class="text-xl font-medium text-yellow-400"><fmt:formatNumber value="${overallBudget.amount}" type="currency" currencySymbol="$"/></p>
                                </div>
                            </div>
                            
                            <c:set var="percentSpent" value="${(totalSpent / overallBudget.amount) * 100}" />
                            <c:set var="barColor" value="${percentSpent > 100 ? '#ef4444' : (percentSpent > 80 ? '#f97316' : '#D4AF37')}" />
                            
                            <div class="progress-bar-container">
                                <div class="progress-bar-fill" style="width: ${percentSpent > 100 ? 100 : percentSpent}%; background-color: ${barColor};"></div>
                            </div>
                            
                            <c:if test="${percentSpent > 100}">
                                <p class="text-red-500 text-xs mt-2"><i data-lucide="alert-triangle" class="inline w-3 h-3"></i> You have exceeded your overall budget!</p>
                            </c:if>
                            <c:if test="${percentSpent > 80 && percentSpent <= 100}">
                                <p class="text-orange-500 text-xs mt-2"><i data-lucide="alert-circle" class="inline w-3 h-3"></i> You are approaching your overall budget limit.</p>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-400 text-sm mb-6">No overall budget set for this month.</p>
                    </c:otherwise>
                </c:choose>

                <form action="${pageContext.request.contextPath}/budget/setOverall" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-300 mb-2">Update Overall Budget Limit</label>
                        <input type="number" step="0.01" name="amount" required placeholder="0.00"
                               class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-yellow-400 focus:ring-1 focus:ring-yellow-400 transition-all">
                    </div>
                    <button type="submit" class="w-full bg-yellow-400 text-black py-3 rounded-xl font-bold hover:bg-yellow-500 transition-colors">
                        Save Overall Budget
                    </button>
                </form>
            </div>

            <!-- CATEGORY BUDGETS -->
            <div class="glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.2s">
                <h3 class="text-xl font-bold text-white tracking-tight mb-6">Set Category Budget</h3>
                
                <form action="${pageContext.request.contextPath}/budget/setCategory" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-300 mb-2">Category</label>
                        <select name="categoryId" required class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-yellow-400 focus:ring-1 focus:ring-yellow-400 transition-all">
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-300 mb-2">Budget Limit</label>
                        <input type="number" step="0.01" name="amount" required placeholder="0.00"
                               class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-yellow-400 focus:ring-1 focus:ring-yellow-400 transition-all">
                    </div>
                    <button type="submit" class="w-full bg-white/10 text-white border border-white/20 py-3 rounded-xl font-bold hover:bg-white/20 transition-colors">
                        Save Category Budget
                    </button>
                </form>
            </div>

        </div>

        <!-- CATEGORY BUDGETS LIST -->
        <div class="mt-8 glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.3s">
            <h3 class="text-xl font-bold text-white tracking-tight mb-6">Category Budgets Status</h3>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="b" items="${budgets}">
                    <c:if test="${b.category != null}">
                        <div class="bg-white/5 border border-white/10 rounded-2xl p-5">
                            <h4 class="text-lg font-semibold text-white mb-4">${b.category.name}</h4>
                            
                            <c:set var="spent" value="${categorySpentMap[b.category.id] != null ? categorySpentMap[b.category.id] : 0}" />
                            <div class="flex justify-between items-end mb-2">
                                <div>
                                    <p class="text-gray-400 text-xs">Spent</p>
                                    <p class="text-lg font-bold text-white"><fmt:formatNumber value="${spent}" type="currency" currencySymbol="$"/></p>
                                </div>
                                <div class="text-right">
                                    <p class="text-gray-400 text-xs">Limit</p>
                                    <p class="text-sm font-medium text-yellow-400"><fmt:formatNumber value="${b.amount}" type="currency" currencySymbol="$"/></p>
                                </div>
                            </div>
                            
                            <c:set var="catPercentSpent" value="${b.amount > 0 ? (spent / b.amount) * 100 : 0}" />
                            <c:set var="catBarColor" value="${catPercentSpent > 100 ? '#ef4444' : (catPercentSpent > 80 ? '#f97316' : '#D4AF37')}" />
                            
                            <div class="progress-bar-container">
                                <div class="progress-bar-fill" style="width: ${catPercentSpent > 100 ? 100 : catPercentSpent}%; background-color: ${catBarColor};"></div>
                            </div>
                            
                            <c:if test="${catPercentSpent > 100}">
                                <p class="text-red-500 text-[10px] mt-2"><i data-lucide="alert-triangle" class="inline w-3 h-3"></i> Exceeded</p>
                            </c:if>
                        </div>
                    </c:if>
                </c:forEach>
                
                <c:if test="${budgets.size() == 0 || (budgets.size() == 1 && overallBudget != null)}">
                    <p class="text-gray-400 text-sm col-span-3">No category budgets set for this month.</p>
                </c:if>
            </div>
        </div>

    </main>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>
