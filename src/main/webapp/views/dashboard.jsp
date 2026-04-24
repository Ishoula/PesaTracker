<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pesa Tracker | Dashboard</title>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

<style>
body { font-family: 'Inter', sans-serif; }

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.float {
    animation: float 6s ease-in-out infinite;
}
</style>
</head>

<body class="bg-gradient-to-br from-black via-gray-900 to-black text-gray-200">

<!-- SIDEBAR -->
<aside class="fixed left-0 top-0 h-full w-64 bg-white/5 backdrop-blur-lg border-r border-white/10 p-6">

    <h2 class="text-2xl font-bold text-yellow-400 mb-8">PesaTracker</h2>

    <div class="mb-8">
        <p class="text-gray-400 text-sm">Logged in as</p>
        <p class="font-semibold text-white">${sessionScope.user.username}</p>
    </div>

    <nav class="space-y-3">
        <a href="<c:url value='/expenses/dashboard'/>"
           class="block px-3 py-2 rounded-lg bg-yellow-400 text-black font-semibold">
           Dashboard
        </a>

        <a href="<c:url value='/expenses/add'/>"
           class="block px-3 py-2 rounded-lg hover:bg-white/10 transition">
           Add Expense
        </a>

        <a href="<c:url value='/expenses/report'/>"
           class="block px-3 py-2 rounded-lg hover:bg-white/10 transition">
           Reports
        </a>

        <a href="<c:url value='/auth/logout'/>"
           class="block mt-10 text-red-400 hover:text-red-300">
           Sign Out
        </a>
    </nav>

</aside>

<!-- MAIN -->
<main class="ml-64 p-10">

    <!-- HEADER -->
    <div class="flex justify-between items-center mb-10">
        <h1 class="text-3xl font-bold text-white">Dashboard</h1>

        <a href="<c:url value='/expenses/add'/>"
           class="bg-yellow-400 text-black px-5 py-2 rounded-lg font-semibold hover:bg-yellow-300 transition">
           + New Expense
        </a>
    </div>

    <!-- STATS -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-10">

        <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl float">
            <p class="text-gray-400 text-sm">Total Expenditure</p>
            <h2 class="text-3xl font-bold text-yellow-400 mt-2">
                <fmt:formatNumber value="${totalSpending}" type="currency" currencySymbol="$"/>
            </h2>
        </div>

        <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl float">
            <p class="text-gray-400 text-sm">Transactions</p>
            <h2 class="text-3xl font-bold text-white mt-2">${expenses.size()}</h2>
        </div>

    </div>

    <!-- CONTENT GRID -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- TABLE -->
        <div class="lg:col-span-2 bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl">

            <h3 class="text-xl font-semibold mb-4 text-white">Recent Transactions</h3>

            <div class="overflow-x-auto">
            <table class="w-full text-sm">

                <thead class="text-gray-400 border-b border-white/10">
                    <tr>
                        <th class="text-left py-3">Date</th>
                        <th class="text-left">Description</th>
                        <th class="text-left">Category</th>
                        <th class="text-left">Type</th>
                        <th class="text-left">Amount</th>
                    </tr>
                </thead>

                <tbody>
                <c:forEach var="exp" items="${expenses}">
                    <tr class="border-b border-white/5 hover:bg-white/5 transition">

                        <td class="py-4">${exp.date}</td>

                        <td>
                            ${exp.description}<br>
                            <span class="text-gray-500 text-xs">
                                <c:choose>
                                    <c:when test="${exp['class'].simpleName == 'BusinessExpense'}">
                                        Corp: ${exp.companyName}
                                    </c:when>
                                    <c:otherwise>
                                        Occasion: ${exp.occasion}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </td>

                        <td>${exp.category.name}</td>

                        <td>
                            <span class="px-3 py-1 rounded-full text-xs font-semibold
                                ${exp['class'].simpleName == 'BusinessExpense'
                                ? 'bg-blue-500/20 text-blue-300'
                                : 'bg-green-500/20 text-green-300'}">
                                ${exp['class'].simpleName == 'BusinessExpense' ? 'Business' : 'Personal'}
                            </span>
                        </td>

                        <td class="text-yellow-400 font-bold">
                            <fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="$"/>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>

            </table>
            </div>

        </div>

        <!-- CHART -->
        <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl float">

            <h3 class="text-xl font-semibold mb-4 text-white">Spending by Category</h3>

            <canvas id="categoryChart"></canvas>

        </div>

    </div>

</main>

<!-- CHART SCRIPT -->
<script>
const chartLabels = [];
const chartValues = [];

<c:forEach var="entry" items="${chartData}">
chartLabels.push("${entry.key}");
chartValues.push(${entry.value});
</c:forEach>

new Chart(document.getElementById('categoryChart'), {
    type: 'doughnut',
    data: {
        labels: chartLabels,
        datasets: [{
            data: chartValues,
            backgroundColor: [
                '#facc15', '#eab308', '#ca8a04', '#fde047', '#d4af37'
            ],
            borderWidth: 0
        }]
    },
    options: {
        plugins: {
            legend: {
                position: 'bottom',
                labels: { color: '#ccc' }
            }
        }
    }
});
</script>

</body>
</html>