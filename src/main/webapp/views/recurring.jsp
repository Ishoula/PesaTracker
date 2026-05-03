<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Recurring Expenses</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; background-color: #050505; }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.08); }
        .premium-gradient { background-color: #050505; background-image: radial-gradient(circle at top right, rgba(212,175,55,0.15), transparent 50%); }
    </style>
</head>
<body class="text-gray-200 min-h-screen premium-gradient">

    <!-- MOBILE TOP BAR -->
    <div class="md:hidden fixed top-0 left-0 right-0 z-50 bg-[#0a0a0a]/95 backdrop-blur-xl border-b border-white/5 px-4 py-3 flex items-center gap-3">
        <button onclick="toggleSidebar()" class="text-gray-400 hover:text-white transition-colors">
            <i data-lucide="menu" class="w-6 h-6"></i>
        </button>
        <div class="w-8 h-8 bg-yellow-400 rounded-xl flex items-center justify-center">
            <i data-lucide="wallet" class="text-black w-4 h-4"></i>
        </div>
        <span class="text-white font-bold">PesaTracker</span>
    </div>

    <!-- SIDEBAR OVERLAY -->
    <div id="sidebarOverlay" onclick="toggleSidebar()" class="hidden fixed inset-0 bg-black/60 z-40 md:hidden"></div>

    <aside id="sidebar" class="fixed left-0 top-0 h-full w-72 md:w-64 bg-[#0a0a0a]/95 backdrop-blur-xl border-r border-white/5 p-6 z-50 -translate-x-full md:translate-x-0 transition-transform duration-300 ease-in-out overflow-y-auto">
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
            <a href="<c:url value='/recurring'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-yellow-400 text-black font-medium text-sm"><i data-lucide="repeat" class="w-4 h-4"></i>Recurring</a>
            <a href="<c:url value='/notifications'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bell" class="w-4 h-4"></i>Notifications</a>
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

    <main class="md:ml-64 p-4 pt-20 md:pt-8 lg:p-12">
        <div class="flex justify-between items-center mb-12">
            <div>
                <h1 class="text-2xl md:text-4xl font-bold text-white tracking-tight">Recurring Expenses</h1>
                <p class="text-gray-400 mt-2">Set up automatic expense tracking.</p>
            </div>
            <form action="<c:url value='/recurring/process'/>" method="POST" class="inline">
                <button type="submit" class="bg-white/10 text-white border border-white/20 px-6 py-3 rounded-xl font-bold hover:bg-white/20 transition">
                    <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-2"></i>Process Due
                </button>
            </form>
        </div>

        <div class="glass-card p-8 rounded-3xl mb-8">
            <h3 class="text-lg md:text-xl font-bold text-white mb-6">Create Recurring Expense</h3>
            <form action="<c:url value='/recurring/save'/>" method="POST" class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Description</label>
                    <input type="text" name="description" required class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Amount</label>
                    <input type="number" step="0.01" name="amount" required class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Category</label>
                    <select name="categoryId" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                        <c:forEach var="cat" items="${categories}"><option value="${cat.id}">${cat.name}</option></c:forEach>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Interval</label>
                    <select name="interval" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                        <option value="DAILY">Daily</option>
                        <option value="WEEKLY">Weekly</option>
                        <option value="MONTHLY" selected>Monthly</option>
                        <option value="YEARLY">Yearly</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Start Date</label>
                    <input type="date" name="startDate" required class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">End Date (Optional)</label>
                    <input type="date" name="endDate" class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white focus:border-yellow-400 outline-none">
                </div>
                <div class="col-span-2">
                    <button type="submit" class="w-full bg-yellow-400 text-black py-3 rounded-xl font-bold hover:bg-yellow-300 transition">Create Recurring Expense</button>
                </div>
            </form>
        </div>

        <div class="glass-card p-8 rounded-3xl">
            <h3 class="text-lg md:text-xl font-bold text-white mb-6">Active Recurring Expenses</h3>
            <div class="space-y-4">
                <c:forEach var="re" items="${recurringExpenses}">
                    <div class="bg-white/5 border border-white/10 rounded-2xl p-4 flex items-center justify-between">
                        <div>
                            <p class="text-white font-semibold">${re.description}</p>
                            <p class="text-gray-400 text-sm"><fmt:formatNumber value="${re.amount}" type="currency" currencySymbol="$"/> • ${re.recurrenceInterval} • Next: ${re.nextOccurrence}</p>
                        </div>
                        <div class="flex gap-2">
                            <form action="<c:url value='/recurring/toggle'/>" method="POST" class="inline">
                                <input type="hidden" name="id" value="${re.id}">
                                <button type="submit" class="text-gray-400 hover:text-yellow-400 transition"><i data-lucide="${re.isActive ? 'pause' : 'play'}" class="w-5 h-5"></i></button>
                            </form>
                            <form action="<c:url value='/recurring/delete'/>" method="POST" class="inline">
                                <input type="hidden" name="id" value="${re.id}">
                                <button type="submit" class="text-gray-400 hover:text-red-400 transition"><i data-lucide="trash-2" class="w-5 h-5"></i></button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty recurringExpenses}">
                    <p class="text-gray-500 text-center py-8">No recurring expenses set up.</p>
                </c:if>
            </div>
        </div>
    </main>
    <script>
        lucide.createIcons();
        document.querySelector('input[name=startDate]').valueAsDate = new Date();
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
            document.getElementById('sidebarOverlay').classList.toggle('hidden');
        }
    </script>
</body>
</html>
