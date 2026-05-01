<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | PesaTracker</title>

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
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--card-border);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .premium-gradient {
            background-color: #050505;
            background-image: radial-gradient(circle at top right, rgba(212, 175, 55, 0.15), transparent 50%),
                        radial-gradient(circle at bottom left, rgba(212, 175, 55, 0.05), transparent 50%);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-fade { animation: fadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards; }

        .input-glow:focus {
            border-color: var(--primary);
            box-shadow: 0 0 20px var(--primary-glow);
        }
    </style>
</head>

<body class="text-gray-200 min-h-screen flex items-center justify-center premium-gradient p-6">

    <div class="relative w-full max-w-md glass-card p-10 rounded-[2.5rem] animate-fade">
        
        <div class="flex flex-col items-center mb-10 text-center">
            <div class="w-16 h-16 bg-yellow-400 rounded-2xl flex items-center justify-center shadow-[0_0_40px_rgba(250,204,21,0.3)] mb-6">
                <i data-lucide="wallet" class="text-black w-10 h-10"></i>
            </div>
            <h2 class="text-4xl font-bold text-white tracking-tight">PesaTracker</h2>
            <p class="text-gray-400 mt-2 font-light">Secure Access to Your Finances</p>
        </div>

        <!-- MESSAGES -->
        <c:if test="${not empty error}">
            <div class="flex items-center gap-3 bg-white/5 border border-yellow-400/50 text-white p-4 rounded-xl mb-6 text-sm animate-fade">
                <i data-lucide="alert-circle" class="w-5 h-5 flex-shrink-0 text-yellow-400"></i>
                <p>${error}</p>
            </div>
        </c:if>

        <c:if test="${param.msg == 'registered'}">
            <div class="flex items-center gap-3 bg-white/5 border border-yellow-400/50 text-white p-4 rounded-xl mb-6 text-sm animate-fade">
                <i data-lucide="check-circle" class="w-5 h-5 flex-shrink-0 text-yellow-400"></i>
                <p>Welcome! Registration successful. Please login.</p>
            </div>
        </c:if>

        <form action="<c:url value='/auth/login'/>" method="POST" class="space-y-6">

            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Username</label>
                <div class="relative group">
                    <i data-lucide="user" class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 w-5 h-5 group-focus-within:text-yellow-400 transition-colors"></i>
                    <input type="text" name="username" required
                           class="w-full pl-12 pr-4 py-4 rounded-2xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                           placeholder="your_username">
                </div>
            </div>

            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-500 uppercase tracking-widest ml-1">Password</label>
                <div class="relative group">
                    <i data-lucide="lock" class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 w-5 h-5 group-focus-within:text-yellow-400 transition-colors"></i>
                    <input type="password" name="password" required
                           class="w-full pl-12 pr-4 py-4 rounded-2xl bg-white/5 border border-white/10 text-white outline-none input-glow transition-all text-sm font-medium"
                           placeholder="••••••••">
                </div>
            </div>

            <button type="submit"
                    class="w-full bg-yellow-400 text-black font-bold py-4 rounded-2xl hover:bg-yellow-300 transition-all shadow-xl hover:shadow-yellow-400/20 active:scale-[0.98] mt-4 flex items-center justify-center gap-2">
                Sign In
                <i data-lucide="arrow-right" class="w-5 h-5"></i>
            </button>
        </form>

        <div class="text-center mt-10">
            <p class="text-gray-500 text-sm">
                Don't have an account? 
                <a href="<c:url value='/auth/register'/>" class="text-yellow-400 font-bold hover:underline ml-1">
                    Join PesaTracker
                </a>
            </p>
        </div>

    </div>

    <script>
        lucide.createIcons();
    </script>

</body>
</html>