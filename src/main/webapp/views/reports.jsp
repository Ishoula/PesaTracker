<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Reports | PesaTracker</title>
    
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

        .nav-item { transition: all 0.2s ease; }
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

        .animate-in { animation: fadeIn 0.5s ease forwards; }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
            opacity: 0.5;
            cursor: pointer;
        }

        @media print {
            aside, .filter-card, .print-btn, .nav-item { display: none !important; }
            main { margin-left: 0 !important; width: 100% !important; padding: 0 !important; }
            body { background: white !important; color: black !important; }
            .glass-card { background: white !important; border: 1px solid #eee !important; color: black !important; backdrop-filter: none !important; }
            .text-white, .text-gray-400, .text-gray-200 { color: black !important; }
            .text-yellow-400 { color: #b8860b !important; }
        }
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
        
        <a href="<c:url value='/expenses/dashboard'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm">
            <i data-lucide="layout-dashboard" class="w-4 h-4"></i>
            Dashboard
        </a>

        <a href="<c:url value='/budget'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm">
            <i data-lucide="target" class="w-4 h-4"></i>
            Budgets
        </a>

        <a href="<c:url value='/insights'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm">
            <i data-lucide="lightbulb" class="w-4 h-4"></i>
            Insights
        </a>

        <a href="<c:url value='/expenses/add'/>" class="nav-item flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm">
            <i data-lucide="plus-circle" class="w-4 h-4"></i>
            Add Expense
        </a>

        <a href="<c:url value='/expenses/report'/>" class="nav-item active flex items-center gap-3 px-4 py-3 rounded-xl font-medium text-sm">
            <i data-lucide="pie-chart" class="w-4 h-4"></i>
            Reports
        </a>

        <div class="pt-10">
            <a href="<c:url value='/auth/logout'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition text-sm font-medium">
                <i data-lucide="log-out" class="w-4 h-4"></i>
                Sign Out
            </a>
        </div>
    </nav>
</aside>

<main class="ml-64 p-8 lg:p-12">
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-12 gap-6 animate-in">
        <div>
            <h1 class="text-4xl font-bold text-white tracking-tight">Financial Analytics</h1>
            <p class="text-gray-400 mt-2 font-light">Deep dive into your spending habits and trends.</p>
        </div>
        <div class="text-right glass-card px-6 py-4 rounded-2xl">
            <p class="text-gray-500 text-[10px] uppercase tracking-widest font-bold mb-1">Total Period Spending</p>
            <h2 class="text-3xl font-bold text-yellow-400 tracking-tight">
                <fmt:formatNumber value="${reportTotal}" type="currency" currencySymbol="$"/>
            </h2>
        </div>
    </div>

    <!-- FILTERS -->
    <div class="filter-card glass-card p-6 rounded-3xl mb-10 animate-in" style="animation-delay: 0.1s">
        <form action="<c:url value='/expenses/report'/>" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-6 items-end">
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">From</label>
                <input type="date" name="startDate" value="${param.startDate}" 
                       class="w-full p-3 rounded-xl bg-white/5 border border-white/10 text-white focus:border-yellow-400 outline-none transition-colors text-sm">
            </div>
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">To</label>
                <input type="date" name="endDate" value="${param.endDate}" 
                       class="w-full p-3 rounded-xl bg-white/5 border border-white/10 text-white focus:border-yellow-400 outline-none transition-colors text-sm">
            </div>
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Category</label>
                <select name="categoryName" 
                        class="w-full p-3 rounded-xl bg-white/5 border border-white/10 text-white focus:border-yellow-400 outline-none transition-colors text-sm appearance-none">
                    <option value="All" class="bg-[#0a0a0a]">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.name}" ${param.categoryName == cat.name ? 'selected' : ''} class="bg-[#0a0a0a]">${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex gap-3">
                <button type="submit" class="flex-1 bg-yellow-400 text-black px-4 py-3 rounded-xl font-bold hover:bg-yellow-300 transition-all active:scale-95 text-sm">
                    Apply Filters
                </button>
                <a href="<c:url value='/expenses/report'/>" 
                   class="flex items-center justify-center px-4 py-3 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all text-sm text-gray-400 hover:text-white">
                    <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                </a>
            </div>
        </form>
    </div>

    <!-- CHARTS GRID -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div class="glass-card p-6 rounded-3xl h-96 flex flex-col animate-in" style="animation-delay: 0.2s">
            <h3 class="text-gray-500 text-[10px] uppercase font-bold tracking-widest mb-6">By Category</h3>
            <div class="flex-1 relative min-h-0">
                <canvas id="categoryChart"></canvas>
            </div>
        </div>

        <div class="glass-card p-6 rounded-3xl h-96 flex flex-col animate-in" style="animation-delay: 0.3s">
            <h3 class="text-gray-500 text-[10px] uppercase font-bold tracking-widest mb-6">Monthly Comparison</h3>
            <div class="flex-1 relative min-h-0">
                <canvas id="typeChart"></canvas>
            </div>
        </div>

        <div class="glass-card p-6 rounded-3xl h-96 flex flex-col animate-in" style="animation-delay: 0.4s">
            <h3 class="text-gray-500 text-[10px] uppercase font-bold tracking-widest mb-6">Monthly Distribution</h3>
            <div class="flex-1 relative min-h-0">
                <canvas id="trendChart"></canvas>
            </div>
        </div>
    </div>

    <!-- DATA TABLE -->
    <div class="glass-card rounded-3xl overflow-hidden animate-in" style="animation-delay: 0.5s">
        <div class="p-6 border-b border-white/5 flex justify-between items-center">
            <h3 class="text-xl font-bold text-white tracking-tight">Records Found</h3>
            <span class="text-[10px] font-bold text-gray-500 bg-white/5 px-3 py-1 rounded-full uppercase tracking-widest">${expenses.size()} Transactions</span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead>
                    <tr class="text-gray-500 text-[10px] uppercase tracking-widest bg-white/[0.02]">
                        <th class="p-5 font-bold">Date</th>
                        <th class="p-5 font-bold">Description</th>
                        <th class="p-5 font-bold text-center">Category</th>
                        <th class="p-5 font-bold text-center">Type</th>
                        <th class="p-5 font-bold text-right">Amount</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-white/5">
                    <c:forEach var="exp" items="${expenses}">
                        <tr class="group hover:bg-white/[0.02] transition-colors">
                            <td class="p-5 text-sm text-gray-400 font-medium">${exp.date}</td>
                            <td class="p-5 text-sm font-semibold text-white">${exp.description}</td>
                            <td class="p-5 text-center">
                                <span class="text-[10px] font-bold text-gray-400 bg-white/5 px-3 py-1 rounded-full border border-white/5">${exp.category.name}</span>
                            </td>
                            <td class="p-5 text-center">
                                <span class="px-3 py-1 rounded-full text-[10px] font-bold tracking-wider uppercase
                                    ${exp['class'].simpleName.contains('Business') 
                                    ? 'bg-white/10 text-white border border-white/20' 
                                    : 'bg-yellow-400/10 text-yellow-400 border border-yellow-400/20'}">
                                    ${exp['class'].simpleName.contains('Business') ? 'Business' : 'Personal'}
                                </span>
                            </td>
                            <td class="p-5 text-right font-bold text-white text-sm">
                                <fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="$"/>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty expenses}">
                        <tr>
                            <td colspan="5" class="text-center p-20 text-gray-500 font-light italic">
                                <i data-lucide="search-x" class="w-12 h-12 mx-auto mb-4 opacity-20"></i>
                                No records found for current filters.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="text-center mt-12 print-btn animate-in" style="animation-delay: 0.6s">
        <button onclick="window.print()" 
                class="inline-flex items-center gap-2 border border-white/10 px-8 py-3 rounded-xl hover:bg-white hover:text-black transition-all font-bold text-sm">
            <i data-lucide="download" class="w-4 h-4"></i>
            Export Report (PDF)
        </button>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        lucide.createIcons();

        const catData = {};
        const trendData = {};

        // Process JSTL data
        <c:forEach var="exp" items="${expenses}">
            (function() {
                const amount = parseFloat("${exp.amount != null ? exp.amount : 0}");
                const category = "${exp.category != null ? exp.category.name : 'Uncategorized'}";
                const isBusiness = ${exp['class'].simpleName.contains('Business')};
                const dateVal = "${exp.date}";

                catData[category] = (catData[category] || 0) + amount;

                if (dateVal) {
                    const d = new Date(dateVal);
                    if (!isNaN(d.getTime())) {
                        const sortKey = d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, '0');
                        const displayKey = d.toLocaleString('default', { month: 'short', year: '2-digit' });
                        
                        if (!trendData[sortKey]) {
                            trendData[sortKey] = { label: displayKey, business: 0, personal: 0, total: 0 };
                        }
                        
                        if (isBusiness) {
                            trendData[sortKey].business += amount;
                        } else {
                            trendData[sortKey].personal += amount;
                        }
                        trendData[sortKey].total += amount;
                    }
                }
            })();
        </c:forEach>

        const commonOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
                legend: { 
                    position: 'bottom', 
                    labels: { color: '#6B7280', font: { size: 10, family: 'Outfit' }, usePointStyle: true, padding: 20 } 
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14, family: 'Outfit' },
                    bodyFont: { size: 13, family: 'Outfit' },
                    displayColors: true
                }
            }
        };

        // 1. Category Doughnut
        if (Object.keys(catData).length > 0) {
            new Chart(document.getElementById('categoryChart'), {
                type: 'doughnut',
                data: {
                    labels: Object.keys(catData),
                    datasets: [{
                        data: Object.values(catData),
                        backgroundColor: ['#D4AF37', '#eab308', '#ca8a04', '#a16207', '#854d0e', '#713f12', '#422006'],
                    }]
                },
                options: { ...commonOptions, cutout: '70%' }
            });
        }

        // 2. Monthly Comparison (Grouped Bar)
        const sortedTrendKeys = Object.keys(trendData).sort();
        if (sortedTrendKeys.length > 0) {
            new Chart(document.getElementById('typeChart'), {
                type: 'bar',
                data: {
                    labels: sortedTrendKeys.map(k => trendData[k].label),
                    datasets: [
                        {
                            label: 'Business',
                            data: sortedTrendKeys.map(k => trendData[k].business),
                            backgroundColor: '#ffffff',
                            borderRadius: 6,
                            borderWidth: 0
                        },
                        {
                            label: 'Personal',
                            data: sortedTrendKeys.map(k => trendData[k].personal),
                            backgroundColor: '#D4AF37',
                            borderRadius: 6,
                            borderWidth: 0
                        }
                    ]
                },
                options: {
                    ...commonOptions,
                    scales: {
                        y: { 
                            ticks: { color: '#6B7280', font: { size: 10 } }, 
                            grid: { color: 'rgba(255,255,255,0.03)' },
                            beginAtZero: true
                        },
                        x: { 
                            ticks: { color: '#6B7280', font: { size: 10 } }, 
                            grid: { display: false } 
                        }
                    }
                }
            });
        }

        // 3. Monthly Trend Line
        if (sortedTrendKeys.length > 0) {
            new Chart(document.getElementById('trendChart'), {
                type: 'line',
                data: {
                    labels: sortedTrendKeys.map(k => trendData[k].label),
                    datasets: [{
                        label: 'Total Spent ($)',
                        data: sortedTrendKeys.map(k => trendData[k].total),
                        borderColor: '#D4AF37',
                        backgroundColor: 'rgba(212, 175, 55, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 2,
                        pointBackgroundColor: '#D4AF37',
                        pointBorderColor: '#000',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6
                    }]
                },
                options: {
                    ...commonOptions,
                    plugins: { ...commonOptions.plugins, legend: { display: false } },
                    scales: {
                        y: { 
                            ticks: { color: '#6B7280', font: { size: 10 } }, 
                            grid: { color: 'rgba(255,255,255,0.03)' }, 
                            beginAtZero: true 
                        },
                        x: { 
                            ticks: { color: '#6B7280', font: { size: 10 } }, 
                            grid: { display: false } 
                        }
                    }
                }
            });
        }
    });
</script>

</body>
</html>