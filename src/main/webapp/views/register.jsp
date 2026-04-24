<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pesa Tracker - Register</title>

<script src="https://cdn.tailwindcss.com"></script>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

<style>
body {
    font-family: 'Inter', sans-serif;
}

/* floating animation */
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

<body class="bg-gradient-to-br from-black via-gray-900 to-black text-gray-200 min-h-screen flex items-center justify-center">

<!-- BACKGROUND GLOW -->
<div class="absolute w-[400px] h-[400px] bg-yellow-500/20 blur-3xl rounded-full top-10 left-10"></div>
<div class="absolute w-[300px] h-[300px] bg-yellow-500/10 blur-3xl rounded-full bottom-10 right-10"></div>

<!-- REGISTER CARD -->
<div class="relative w-full max-w-md p-8 rounded-2xl bg-white/10 backdrop-blur-lg border border-white/10 shadow-2xl float">

    <h2 class="text-3xl font-bold text-center text-white mb-6">
        Create Account
    </h2>

    <!-- ERROR -->
    <c:if test="${not empty error}">
        <div class="bg-red-500/20 text-red-300 p-3 rounded-lg mb-4 text-center">
            ${error}
        </div>
    </c:if>

    <!-- FORM -->
    <form action="<c:url value='/auth/register'/>" method="POST" class="space-y-4">

        <div>
            <label class="text-sm text-gray-400">Username</label>
            <input type="text" name="username" required
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 outline-none text-white">
        </div>

        <div>
            <label class="text-sm text-gray-400">Password</label>
            <input type="password" name="password" minlength="6" required
                   class="w-full mt-1 p-3 rounded-lg bg-black/40 border border-gray-700 focus:border-yellow-400 outline-none text-white">
        </div>

        <button type="submit"
                class="w-full bg-yellow-400 text-black font-semibold py-3 rounded-lg hover:bg-yellow-300 transition shadow-lg">
            Register
        </button>
    </form>

    <!-- FOOTER -->
    <div class="text-center mt-6 text-sm text-gray-400">
        Already have an account?
        <a href="<c:url value='/auth/login'/>" class="text-yellow-400 hover:underline">
            Login here
        </a>
    </div>

</div>

</body>
</html>