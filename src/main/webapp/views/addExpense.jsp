<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Expense | PesaTracker</title>

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
        }

        body { 
            font-family: 'Outfit', sans-serif;
            background-color: #050505;
        }

        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .premium-gradient {
            background-color: #050505;
            background-image: radial-gradient(circle at top right, rgba(212, 175, 55, 0.15), transparent 50%),
                        radial-gradient(circle at bottom left, rgba(212, 175, 55, 0.05), transparent 50%);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-up { animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1);
            opacity: 0.5;
            cursor: pointer;
        }

        .input-glow:focus {
            border-color: var(--primary);
            box-shadow: 0 0 15px var(--primary-glow);
        }
    </style>
</head>

<body class="text-gray-200 min-h-screen flex items-center justify-center premium-gradient p-6">

    <div class="relative w-full max-w-xl glass-card p-10 rounded-[2.5rem] animate-up">
        
        <div class="flex flex-col items-center mb-10 text-center">
            <div class="w-14 h-14 bg-yellow-400 rounded-2xl flex items-center justify-center shadow-[0_0_30px_rgba(250,204,21,0.2)] mb-6">
                <i data-lucide="plus-circle" class="text-black w-8 h-8"></i>
            </div>
            <h2 class="text-4xl font-bold text-white tracking-tight">Record Expense</h2>
            <p class="text-gray-400 mt-2 font-light">Add a new transaction to your tracker.</p>
        </div>

        <form action="<c:url value='/expenses/save'/>" method="POST" class="space-y-6">

            <!-- TYPE TOGGLE -->
            <div class="space-y-3">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Expense Category Type</label>
                <div class="grid grid-cols-2 gap-4 p-1.5 bg-white/5 rounded-2xl border border-white/5">
                    <label class="cursor-pointer group">
                        <input type="radio" name="expenseType" value="PERSONAL" checked onclick="toggleFields('PERSONAL')" class="hidden peer">
                        <div class="flex items-center justify-center gap-2 py-3 rounded-xl transition-all duration-300 peer-checked:bg-yellow-400 peer-checked:text-black text-gray-400 font-bold text-sm">
                            <i data-lucide="user" class="w-4 h-4"></i>
                            Personal
                        </div>
                    </label>
                    <label class="cursor-pointer group">
                        <input type="radio" name="expenseType" value="BUSINESS" onclick="toggleFields('BUSINESS')" class="hidden peer">
                        <div class="flex items-center justify-center gap-2 py-3 rounded-xl transition-all duration-300 peer-checked:bg-yellow-400 peer-checked:text-black text-gray-400 font-bold text-sm">
                            <i data-lucide="briefcase" class="w-4 h-4"></i>
                            Business
                        </div>
                    </label>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- AMOUNT -->
                <div class="space-y-2">
                    <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Amount</label>
                    <div class="relative group">
                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 font-bold group-focus-within:text-yellow-400">$</span>
                        <input type="number" step="0.01" name="amount" required
                               class="w-full pl-8 pr-4 py-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-bold"
                               placeholder="0.00">
                    </div>
                </div>

                <!-- DATE -->
                <div class="space-y-2">
                    <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Date</label>
                    <input type="date" id="expenseDate" name="date" required
                           class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium">
                </div>
            </div>

            <!-- CATEGORY -->
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Category</label>
                <div class="relative">
                    <input type="text" name="categoryName" list="categoryOptions" required
                           class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                           placeholder="What was this for?">
                    <i data-lucide="chevron-down" class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-600 w-4 h-4 pointer-events-none"></i>
                </div>
                <datalist id="categoryOptions">
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.name}">
                    </c:forEach>
                </datalist>
            </div>

            <!-- PERSONAL SPECIFIC -->
            <div id="personalFields" class="space-y-2 animate-up">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Occasion</label>
                <input type="text" name="occasion"
                       class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                       placeholder="e.g. Vacation, Birthday, Dinner">
            </div>

            <!-- BUSINESS SPECIFIC -->
            <div id="businessFields" class="hidden space-y-6 animate-up">
                <div class="space-y-2">
                    <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Company Name</label>
                    <input type="text" name="companyName"
                           class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                           placeholder="Acme Corp">
                </div>
                <div class="space-y-2">
                    <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Tax ID</label>
                    <input type="text" name="taxId"
                           class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                           placeholder="TAX-XXXXX">
                </div>
            </div>

            <!-- DESCRIPTION -->
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Description</label>
                <textarea name="description" rows="3"
                          class="w-full p-3.5 rounded-xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                          placeholder="Additional notes..."></textarea>
            </div>

            <!-- BUTTONS -->
            <div class="pt-6 space-y-4">
                <button type="submit"
                        class="w-full bg-yellow-400 text-black font-bold py-4 rounded-2xl hover:bg-yellow-300 transition-all shadow-lg hover:shadow-yellow-400/20 active:scale-[0.98] flex items-center justify-center gap-2">
                    <i data-lucide="check" class="w-5 h-5"></i>
                    Confirm & Save
                </button>

                <a href="<c:url value='/expenses/dashboard'/>"
                   class="flex items-center justify-center gap-2 w-full text-gray-500 hover:text-white transition-colors text-sm font-bold">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i>
                    Cancel & Go Back
                </a>
            </div>

        </form>
    </div>

    <script>
        lucide.createIcons();
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
