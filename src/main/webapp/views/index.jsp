<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pesa Tracker</title>

<script src="https://cdn.tailwindcss.com"></script>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

<style>
body {
    font-family: 'Inter', sans-serif;
}

/* GOLD COLOR */
:root {
    --gold: #d4af37;
}

/* FLOAT ANIMATIONS */
@keyframes float {
    0% { transform: translateY(0px) rotate(0deg); }
    50% { transform: translateY(-12px) rotate(1deg); }
    100% { transform: translateY(0px) rotate(0deg); }
}

@keyframes floatSlow {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-18px); }
    100% { transform: translateY(0px); }
}

@keyframes floatFast {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-8px); }
    100% { transform: translateY(0px); }
}

.float { animation: float 6s ease-in-out infinite; }
.floatSlow { animation: floatSlow 8s ease-in-out infinite; }
.floatFast { animation: floatFast 5s ease-in-out infinite; }
</style>
</head>

<body class="bg-gradient-to-br from-black via-gray-900 to-black text-gray-200">

<!-- NAVBAR -->
<header class="flex justify-between items-center px-[8%] py-6">
    <div class="text-2xl font-bold text-yellow-400">PesaTracker</div>

    <nav class="flex items-center space-x-6">
        <a href="#" class="hover:text-yellow-400">Features</a>
        <a href="#" class="hover:text-yellow-400">Pricing</a>
        <a href="<c:url value='/auth/login'/>">Login</a>
        <a href="<c:url value='/auth/register'/>"
           class="bg-yellow-400 text-black px-5 py-2 rounded-lg font-semibold hover:bg-yellow-300 transition">
           Get Started
        </a>
    </nav>
</header>

<!-- HERO -->
<section class="flex flex-wrap justify-between items-center px-[8%] py-24 min-h-screen">

    <!-- LEFT -->
    <div class="max-w-lg">
        <h1 class="text-5xl font-bold leading-tight text-white">
            Track your money <br> with clarity.
        </h1>

        <p class="mt-6 text-gray-400 text-lg">
            Simple, powerful expense tracking with beautiful insights.
        </p>

        <div class="mt-6 flex space-x-4">
            <a href="<c:url value='/auth/register'/>"
               class="bg-yellow-400 text-black px-6 py-3 rounded-xl font-semibold hover:bg-yellow-300 transition shadow">
               Get Started
            </a>

            <a href="#"
               class="border border-gray-700 px-6 py-3 rounded-xl hover:border-yellow-400 hover:text-yellow-400 transition">
               Live Demo
            </a>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="relative w-[450px] h-[350px] mt-10 md:mt-0">

        <!-- MAIN CARD -->
        <div class="absolute top-10 left-20 w-[280px] h-[200px] p-5 rounded-2xl backdrop-blur-lg bg-white/10 border border-white/10 shadow-2xl float">
            <h4 class="font-semibold text-yellow-400">Spending Overview</h4>

            <div class="flex items-end gap-3 h-[120px] mt-5">
                <span class="w-6 bg-yellow-400 rounded" style="height:70%"></span>
                <span class="w-6 bg-yellow-400 rounded" style="height:90%"></span>
                <span class="w-6 bg-yellow-400 rounded" style="height:50%"></span>
                <span class="w-6 bg-yellow-400 rounded" style="height:95%"></span>
            </div>
        </div>

        <!-- SMALL CARD 1 -->
        <div class="absolute top-0 left-0 p-4 rounded-2xl backdrop-blur-lg bg-white/10 border border-white/10 shadow-xl floatSlow">
            <p class="text-sm text-gray-400">Balance</p>
            <h3 class="text-xl font-bold text-yellow-400">$2,450</h3>
        </div>

        <!-- SMALL CARD 2 -->
        <div class="absolute bottom-0 right-0 p-4 rounded-2xl backdrop-blur-lg bg-white/10 border border-white/10 shadow-xl floatFast">
            <p class="text-sm text-gray-400">This Month</p>
            <h3 class="text-xl font-bold text-yellow-400">$620</h3>
        </div>

    </div>

</section>

<!-- CTA -->
<section class="text-center py-20 px-4">
    <h2 class="text-3xl font-bold text-white">Start Managing Your Money Today</h2>
    <p class="text-gray-400 mt-3">No credit card required. Get started in minutes.</p>

    <a href="<c:url value='/auth/register'/>"
       class="inline-block mt-6 bg-yellow-400 text-black px-8 py-3 rounded-xl font-semibold hover:bg-yellow-300 transition shadow">
       Create Account
    </a>
</section>

<!-- FOOTER -->
<footer class="text-center py-6 text-gray-500">
    © 2026 PesaTracker. All rights reserved.
</footer>

<!-- PARALLAX -->
<script>
document.addEventListener("mousemove", (e) => {
    const cards = document.querySelectorAll(".float, .floatSlow, .floatFast");
    const x = (window.innerWidth / 2 - e.pageX) / 30;
    const y = (window.innerHeight / 2 - e.pageY) / 30;

    cards.forEach((card, index) => {
        card.style.transform = `translate(${x * (index+1)}px, ${y * (index+1)}px)`;
    });
});
</script>

</body>
</html>