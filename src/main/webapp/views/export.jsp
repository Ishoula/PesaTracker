<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Export/Import</title>
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
            <a href="<c:url value='/recurring'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="repeat" class="w-4 h-4"></i>Recurring</a>
            <a href="<c:url value='/notifications'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bell" class="w-4 h-4"></i>Notifications</a>
            <a href="<c:url value='/analytics/dashboard'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="bar-chart-2" class="w-4 h-4"></i>Analytics</a>
            <a href="<c:url value='/analytics/calendar'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="calendar" class="w-4 h-4"></i>Calendar</a>
            <a href="<c:url value='/search'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="search" class="w-4 h-4"></i>Search</a>
            <a href="<c:url value='/export'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-yellow-400 text-black font-medium text-sm"><i data-lucide="download" class="w-4 h-4"></i>Export/Import</a>
            <a href="<c:url value='/expenses/add'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white font-medium text-sm hover:bg-white/5"><i data-lucide="plus-circle" class="w-4 h-4"></i>Add Expense</a>
            <div class="pt-10">
                <a href="<c:url value='/auth/logout'/>" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-white hover:bg-white/5 transition text-sm font-medium"><i data-lucide="log-out" class="w-4 h-4"></i>Sign Out</a>
            </div>
        </nav>
    </aside>

    <main class="md:ml-64 p-4 pt-20 md:pt-8 lg:p-12">
        <div class="mb-12">
            <h1 class="text-2xl md:text-4xl font-bold text-white tracking-tight">Export & Import</h1>
            <p class="text-gray-400 mt-2">Backup and restore your expense data.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-lg md:text-xl font-bold text-white mb-6">Export Data</h3>
                <p class="text-gray-400 mb-6">Download your expenses as CSV or HTML.</p>
                <div class="space-y-4">
                    <form action="<c:url value='/export'/>" method="GET">
                        <input type="hidden" name="format" value="csv">
                        <button type="submit" class="w-full bg-yellow-400 text-black py-3 rounded-xl font-bold hover:bg-yellow-300 transition flex items-center justify-center gap-2">
                            <i data-lucide="download" class="w-4 h-4"></i>Export as CSV
                        </button>
                    </form>
                    <form action="<c:url value='/export'/>" method="GET">
                        <input type="hidden" name="format" value="pdf">
                        <button type="submit" class="w-full bg-white/10 text-white border border-white/20 py-3 rounded-xl font-bold hover:bg-white/20 transition flex items-center justify-center gap-2">
                            <i data-lucide="file-text" class="w-4 h-4"></i>Export as HTML
                        </button>
                    </form>
                </div>
            </div>

            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-lg md:text-xl font-bold text-white mb-6">Import Data</h3>
                <p class="text-gray-400 mb-6">Upload expenses from a CSV file.</p>
                <p class="text-xs text-gray-500 mb-4">Format: Date,Description,Amount,Category,Type</p>
                <form action="<c:url value='/export/import'/>" method="POST" enctype="multipart/form-data" class="space-y-4">
                    <input type="file" name="csvFile" accept=".csv" required class="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-white">
                    <button type="submit" class="w-full bg-yellow-400 text-black py-3 rounded-xl font-bold hover:bg-yellow-300 transition flex items-center justify-center gap-2">
                        <i data-lucide="upload" class="w-4 h-4"></i>Import CSV
                    </button>
                </form>
                <c:if test="${not empty sessionScope.importMessage}">
                    <p class="mt-4 text-green-400 text-sm">${sessionScope.importMessage}</p>
                    <% session.removeAttribute("importMessage"); %>
                </c:if>
            </div>
        </div>

        <div class="glass-card p-8 rounded-3xl mt-8">
            <h3 class="text-lg md:text-xl font-bold text-white mb-6">Sample CSV Format</h3>
            <pre class="bg-black/50 p-4 rounded-xl text-gray-400 text-sm overflow-x-auto">Date,Description,Amount,Category,Type
2024-01-15,Groceries,150.00,Food,Personal
2024-01-16,Gas,45.00,Transport,Personal
2024-01-17,Office Supplies,23.50,Business,Personal</pre>
        </div>
    </main>
    <script>
        lucide.createIcons();
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
            document.getElementById('sidebarOverlay').classList.toggle('hidden');
        }
    </script>
</body>
</html>
