<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Expense | Pesa Tracker</title>

<script src="https://cdn.tailwindcss.com"></script>

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

<body class="bg-gradient-to-br from-black via-gray-900 to-black min-h-screen flex items-center justify-center text-gray-200">

<!-- BACKGROUND GLOW -->
<div class="absolute w-[400px] h-[400px] bg-yellow-500/20 blur-3xl rounded-full top-10 left-10"></div>
<div class="absolute w-[300px] h-[300px] bg-yellow-500/10 blur-3xl rounded-full bottom-10 right-10"></div>

<!-- FORM CARD -->
<div class="relative w-full max-w-xl p-8 rounded-2xl bg-white/10 backdrop-blur-lg border border-white/10 shadow-2xl float">

    <h2 class="text-3xl font-bold text-center text-white mb-6">
        Record New Expense
    </h2>

    <form action="<c:url value='/expenses/save'/>" method="POST" class="space-y-5">

        <!-- TYPE TOGGLE -->
        <div>
            <label class="text-sm text-gray-400">Expense Type</label>

            <div class="grid grid-cols-2 gap-3 mt-2">

                <label class="cursor-pointer">
                    <input type="radio" name="expenseType" value="PERSONAL"
                           checked onclick="toggleFields('PERSONAL')" class="hidden peer">

                    <div class="text-center py-2 rounded-lg border border-gray-700 peer-checked:bg-yellow-400 peer-checked:text-black">
                        Personal
                    </div>
                </label>

                <label class="cursor-pointer">
                    <input type="radio" name="expenseType" value="BUSINESS"
                           onclick="toggleFields('BUSINESS')" class="hidden peer">

                    <div class="text-center py-2 rounded-lg border border-gray-700 peer-checked:bg-yellow-400 peer-checked:text-black">
                        Business
                    </div>
                </label>

            </div>
        </div>

        <!-- AMOUNT -->
        <div>
            <label class="text-sm text-gray-400">Amount</label>
            <input type="number" step="0.01" name="amount" required
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"
                   placeholder="0.00">
        </div>

        <!-- CATEGORY -->
        <div>
            <label class="text-sm text-gray-400">Category</label>

            <input type="text" name="categoryName" list="categoryOptions" required
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"
                   placeholder="Select category">

            <datalist id="categoryOptions">
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.name}">
                </c:forEach>
            </datalist>
        </div>

        <!-- DATE -->
        <div>
            <label class="text-sm text-gray-400">Date</label>
            <input type="date" id="expenseDate" name="date" required
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none">
        </div>

        <!-- PERSONAL -->
        <div id="personalFields">
            <label class="text-sm text-gray-400">Occasion</label>
            <input type="text" name="occasion"
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"
                   placeholder="Birthday, Vacation...">
        </div>

        <!-- BUSINESS -->
        <div id="businessFields" class="hidden space-y-3">
            <div>
                <label class="text-sm text-gray-400">Company Name</label>
                <input type="text" name="companyName"
                       class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"
                       placeholder="Acme Corp">
            </div>

            <div>
                <label class="text-sm text-gray-400">Tax ID</label>
                <input type="text" name="taxId"
                       class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"
                       placeholder="TAX-12345">
            </div>
        </div>

        <!-- DESCRIPTION -->
        <div>
            <label class="text-sm text-gray-400">Description</label>
            <textarea name="description" rows="2"
                      class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 text-white outline-none"></textarea>
        </div>

        <!-- BUTTONS -->
        <button type="submit"
                class="w-full bg-yellow-400 text-black font-semibold py-3 rounded-lg hover:bg-yellow-300 transition shadow-lg">
            Save Expense
        </button>

        <a href="<c:url value='/expenses/dashboard'/>"
           class="block text-center text-gray-400 hover:text-yellow-400 mt-3">
            Cancel
        </a>

    </form>
</div>

<script>
document.getElementById('expenseDate').valueAsDate = new Date();

function toggleFields(type) {
    const personal = document.getElementById('personalFields');
    const business = document.getElementById('businessFields');

    if (type === 'BUSINESS') {
        personal.classList.add('hidden');
        business.classList.remove('hidden');
    } else {
        personal.classList.remove('hidden');
        business.classList.add('hidden');
    }
}
</script>

</body>
</html>