<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Expense Reports | Pesa Tracker</title>

<script src="https://cdn.tailwindcss.com"></script>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

<style>
body { font-family: 'Inter', sans-serif; }

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-8px); }
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

    <h2 class="text-2xl font-bold text-yellow-400 mb-10">PesaTracker</h2>

    <nav class="space-y-3">

        <a href="<c:url value='/expenses/dashboard'/>"
           class="block px-3 py-2 rounded-lg hover:bg-white/10 transition">
            Dashboard
        </a>

        <a href="<c:url value='/expenses/add'/>"
           class="block px-3 py-2 rounded-lg hover:bg-white/10 transition">
            Add Expense
        </a>

        <a href="<c:url value='/expenses/report'/>"
           class="block px-3 py-2 rounded-lg bg-yellow-400 text-black font-semibold">
            Reports
        </a>

        <a href="<c:url value='/auth/logout'/>"
           class="block mt-10 text-red-400 hover:text-red-300">
            Logout
        </a>

    </nav>

</aside>

<!-- MAIN -->
<main class="ml-64 p-10">

    <h1 class="text-3xl font-bold text-white mb-8">Expense Reports</h1>

    <!-- FILTER CARD -->
    <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl mb-8">

        <form action="<c:url value='/expenses/report'/>" method="GET"
              class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">

            <div>
                <label class="text-sm text-gray-400">From</label>
                <input type="date" name="startDate" value="${param.startDate}"
                       class="w-full mt-1 p-2 rounded-lg bg-black/40 border border-gray-700 text-white focus:border-yellow-400 outline-none">
            </div>

            <div>
                <label class="text-sm text-gray-400">To</label>
                <input type="date" name="endDate" value="${param.endDate}"
                       class="w-full mt-1 p-2 rounded-lg bg-black/40 border border-gray-700 text-white focus:border-yellow-400 outline-none">
            </div>

            <div>
                <label class="text-sm text-gray-400">Category</label>
                <select name="categoryName"
                        class="w-full mt-1 p-2 rounded-lg bg-black/40 border border-gray-700 text-white focus:border-yellow-400 outline-none">

                    <option value="All">All</option>

                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.name}"
                            ${param.categoryName == cat.name ? 'selected' : ''}>
                            ${cat.name}
                        </option>
                    </c:forEach>

                </select>
            </div>

            <div class="flex gap-2">
                <button class="bg-yellow-400 text-black px-4 py-2 rounded-lg font-semibold hover:bg-yellow-300 transition w-full">
                    Generate
                </button>

                <a href="<c:url value='/expenses/report'/>"
                   class="border border-gray-700 px-4 py-2 rounded-lg text-center hover:border-yellow-400 hover:text-yellow-400 w-full">
                    Reset
                </a>
            </div>

        </form>
    </div>

    <!-- SUMMARY -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">

        <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl float">
            <p class="text-gray-400 text-sm">Filter Applied</p>
            <p class="text-white font-semibold mt-2">
                ${empty param.categoryName ? 'All Categories' : param.categoryName}
            </p>
        </div>

        <div class="bg-white/5 backdrop-blur-lg border border-white/10 p-6 rounded-2xl float">
            <p class="text-gray-400 text-sm">Total for Period</p>
            <h2 class="text-3xl font-bold text-yellow-400 mt-2">
                <fmt:formatNumber value="${reportTotal}" type="currency" currencySymbol="$"/>
            </h2>
        </div>

    </div>

    <!-- TABLE -->
    <div class="bg-white/5 backdrop-blur-lg border border-white/10 rounded-2xl overflow-hidden">

        <table class="w-full text-sm">

            <thead class="text-gray-400 border-b border-white/10">
                <tr>
                    <th class="text-left p-4">Date</th>
                    <th class="text-left">Description</th>
                    <th class="text-left">Category</th>
                    <th class="text-left">Type</th>
                    <th class="text-left">Amount</th>
                </tr>
            </thead>

            <tbody>

            <c:forEach var="exp" items="${expenses}">
                <tr class="border-b border-white/5 hover:bg-white/5 transition">

                    <td class="p-4">${exp.date}</td>

                    <td>${exp.description}</td>

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

            <c:if test="${empty expenses}">
                <tr>
                    <td colspan="5" class="text-center p-10 text-gray-500">
                        No expenses found for the selected filters.
                    </td>
                </tr>
            </c:if>

            </tbody>
        </table>

    </div>

    <!-- PRINT -->
    <div class="text-center mt-8">
        <button onclick="window.print()"
                class="border border-gray-700 px-5 py-2 rounded-lg hover:border-yellow-400 hover:text-yellow-400 transition">
            Print / Download PDF
        </button>
    </div>

</main>

</body>
</html>