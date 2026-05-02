<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Dashboard</title>

    <!-- Scripts -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <h1 class="text-4xl font-bold text-white tracking-tight">Overview</h1>
                <p class="text-gray-400 mt-2 font-light">Welcome back, <span class="text-yellow-400 font-medium">${sessionScope.user.username}</span>. Here's your financial summary.</p>
            </div>

            <a href="<c:url value='/expenses/add'/>" 
               class="group flex items-center gap-2 bg-white text-black px-6 py-3 rounded-xl font-semibold hover:bg-yellow-400 transition-all duration-300 shadow-lg hover:shadow-yellow-400/20 active:scale-95">
                <i data-lucide="plus" class="w-5 h-5 group-hover:rotate-90 transition-transform duration-300"></i>
                New Expense
            </a>
        </div>

        <!-- STATS GRID -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            
            <div class="glass-card p-6 rounded-3xl animate-in" style="animation-delay: 0.1s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-yellow-400/10 rounded-2xl border border-yellow-400/20">
                        <i data-lucide="banknote" class="text-yellow-400 w-6 h-6"></i>
                    </div>
                    <span class="text-[10px] font-bold text-yellow-400 bg-yellow-400/10 px-2 py-1 rounded-full uppercase">Monthly</span>
                </div>
                <p class="text-gray-400 text-sm font-medium">Total Expenditure</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">
                    <fmt:formatNumber value="${totalSpending}" type="currency" currencySymbol="$"/>
                </h2>
                <div class="mt-4 flex items-center gap-2 text-xs text-gray-500">
                    <i data-lucide="trending-up" class="w-3 h-3 text-yellow-400"></i>
                    <span class="text-yellow-400 font-medium">+12.5%</span> from last month
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl animate-in" style="animation-delay: 0.2s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-white/10 rounded-2xl border border-white/20">
                        <i data-lucide="activity" class="text-white w-6 h-6"></i>
                    </div>
                </div>
                <p class="text-gray-400 text-sm font-medium">Transactions</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">${expenses.size()}</h2>
                <div class="mt-4 flex items-center gap-2 text-xs text-gray-500">
                    <i data-lucide="check-circle-2" class="w-3 h-3 text-gray-300"></i>
                    All transactions synced
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl animate-in" style="animation-delay: 0.3s">
                <div class="flex items-center justify-between mb-4">
                    <div class="p-3 bg-yellow-600/10 rounded-2xl border border-yellow-600/20">
                        <i data-lucide="layers" class="text-yellow-600 w-6 h-6"></i>
                    </div>
                </div>
                <p class="text-gray-400 text-sm font-medium">Categories Used</p>
                <h2 class="text-3xl font-bold text-white mt-2 tracking-tight">${chartData.size()}</h2>
                <div class="mt-4 flex items-center gap-2 text-xs text-gray-500">
                    <i data-lucide="info" class="w-3 h-3 text-yellow-600"></i>
                    Diversified spending
                </div>
            </div>

        </div>

        <!-- CONTENT GRID -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <!-- RECENT TRANSACTIONS -->
            <div class="lg:col-span-2 glass-card p-8 rounded-3xl animate-in" style="animation-delay: 0.4s">
                
                <div class="flex justify-between items-center mb-8">
                    <h3 class="text-xl font-bold text-white tracking-tight">Recent Transactions</h3>
                    <button class="text-yellow-400 text-sm font-medium hover:underline">View All</button>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead>
                            <tr class="text-gray-500 text-[10px] uppercase tracking-widest border-b border-white/5">
                                <th class="pb-4 font-bold">Transaction</th>
                                <th class="pb-4 font-bold text-center">Category</th>
                                <th class="pb-4 font-bold text-center">Type</th>
                                <th class="pb-4 font-bold text-right">Amount</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-white/5">
                            <c:forEach var="exp" items="${expenses}">
                                <tr class="group hover:bg-white/[0.02] transition-colors">
                                    <td class="py-5">
                                        <div class="flex items-center gap-4">
                                            <div class="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center group-hover:bg-yellow-400/10 transition-colors">
                                                <i data-lucide="shopping-bag" class="w-5 h-5 text-gray-400 group-hover:text-yellow-400 transition-colors"></i>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-white">${exp.description}</p>
                                                <p class="text-[10px] text-gray-500 mt-0.5">${exp.date}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-5 text-center">
                                        <span class="text-xs text-gray-300 bg-white/5 px-3 py-1 rounded-full">${exp.category.name}</span>
                                        <c:if test="${not empty exp.tags}">
                                            <div class="flex flex-wrap gap-1 justify-center mt-1">
                                                <c:forEach var="tag" items="${exp.tags}">
                                                    <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] border border-white/20 text-gray-300" style="background-color: ${tag.colorCode}20; border-color: ${tag.colorCode}40;">
                                                        <span class="w-1 h-1 rounded-full" style="background-color: ${tag.colorCode};"></span>
                                                        ${tag.name}
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td class="py-5 text-center">
                                        <span class="px-3 py-1 rounded-full text-[10px] font-bold tracking-wider uppercase
                                            ${exp['class'].simpleName.contains('Business') 
                                            ? 'bg-white/10 text-white border border-white/20' 
                                            : 'bg-yellow-400/10 text-yellow-400 border border-yellow-400/20'}">
                                            ${exp['class'].simpleName.contains('Business') ? 'Business' : 'Personal'}
                                        </span>
                                    </td>
                                    <td class="py-5 text-right">
                                        <p class="text-sm font-bold text-white">
                                            <fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="$"/>
                                        </p>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- SPENDING CHART -->
            <div class="glass-card p-8 rounded-3xl flex flex-col animate-in" style="animation-delay: 0.5s">
                <div class="mb-8">
                    <h3 class="text-xl font-bold text-white tracking-tight">Analytics</h3>
                    <p class="text-xs text-gray-500 mt-1">Spending by Category</p>
                </div>

                <div class="flex-1 relative min-h-[300px]">
                    <canvas id="categoryChart"></canvas>
                </div>

                <div class="mt-8 space-y-4">
                    <c:forEach var="entry" items="${chartData}" varStatus="status">
                        <c:if test="${status.index < 4}">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-2 h-2 rounded-full" style="background-color: ${['#D4AF37', '#eab308', '#ca8a04', '#a16207', '#854d0e'][status.index]}"></div>
                                    <span class="text-xs text-gray-400">${entry.key}</span>
                                </div>
                                <span class="text-xs font-bold text-white"><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="$"/></span>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

        </div>

    </main>

    <!-- CHART SCRIPT -->
    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Chart Data
        const chartLabels = [];
        const chartValues = [];

        <c:forEach var="entry" items="${chartData}">
            chartLabels.push("${entry.key}");
            chartValues.push(${entry.value});
        </c:forEach>

        const ctx = document.getElementById('categoryChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: chartLabels,
                datasets: [{
                    data: chartValues,
                    backgroundColor: [
                        '#D4AF37', '#eab308', '#ca8a04', '#a16207', '#854d0e', '#713f12', '#422006'
                    ],
                    hoverOffset: 15,
                    borderWidth: 0,
                    borderRadius: 5,
                    spacing: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        titleFont: { size: 14, family: 'Outfit' },
                        bodyFont: { size: 13, family: 'Outfit' },
                        displayColors: false,
                        callbacks: {
                            label: function(context) {
                                return ' $' + context.raw.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>

</body>
</html>