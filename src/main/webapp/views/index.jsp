<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PesaTracker | Smart Financial Management</title>
    
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
            color: #e5e7eb;
            overflow-x: hidden;
        }

        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .glass-card:hover {
            border-color: rgba(212, 175, 55, 0.3);
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
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

        .btn-glow:hover {
            box-shadow: 0 0 20px var(--primary-glow);
        }

        .parallax-wrap {
            perspective: 1000px;
        }
    </style>
</head>

<body class="premium-gradient min-h-screen">

    <!-- NAVBAR -->
    <header class="fixed top-0 left-0 w-full z-50 px-[8%] py-6 backdrop-blur-md border-b border-white/5 flex justify-between items-center">
        <div class="flex items-center gap-3">
            <div class="w-8 h-8 bg-yellow-400 rounded-lg flex items-center justify-center">
                <i data-lucide="wallet" class="text-black w-5 h-5"></i>
            </div>
            <div class="text-xl font-bold tracking-tight text-white">PesaTracker</div>
        </div>

        <nav class="hidden md:flex items-center gap-10">
            <a href="#" class="text-sm font-medium text-gray-400 hover:text-white transition">Features</a>
            <a href="#" class="text-sm font-medium text-gray-400 hover:text-white transition">About</a>
            <a href="<c:url value='/auth/login'/>" class="text-sm font-medium text-gray-400 hover:text-white transition">Sign In</a>
            <a href="<c:url value='/auth/register'/>"
               class="bg-white text-black px-6 py-2.5 rounded-full font-bold text-sm hover:bg-yellow-400 transition-all active:scale-95 btn-glow shadow-xl">
               Get Started
            </a>
        </nav>

        <button class="md:hidden text-white">
            <i data-lucide="menu"></i>
        </button>
    </header>

    <!-- HERO SECTION -->
    <section class="relative pt-40 pb-20 px-[8%] min-h-screen flex flex-wrap lg:flex-nowrap items-center gap-20">
        
        <!-- LEFT CONTENT -->
        <div class="w-full lg:w-1/2 space-y-8 animate-fade">
            <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-yellow-400/10 border border-yellow-400/20 text-yellow-400 text-xs font-bold uppercase tracking-widest">
                <i data-lucide="sparkles" class="w-3 h-3"></i>
                Modern Expense Tracking
            </div>
            
            <h1 class="text-5xl lg:text-7xl font-bold text-white tracking-tight leading-[1.1]">
                Master your <br> <span class="text-yellow-400">money</span> with <br> elegance.
            </h1>

            <p class="text-xl text-gray-400 font-light leading-relaxed max-w-lg">
                The most sophisticated way to track expenses, analyze trends, and achieve your financial goals with beautiful, actionable insights.
            </p>

            <div class="flex flex-wrap gap-4 pt-4">
                <a href="<c:url value='/auth/register'/>"
                   class="flex items-center gap-2 bg-yellow-400 text-black px-8 py-4 rounded-2xl font-bold hover:bg-yellow-300 transition-all active:scale-95 shadow-2xl shadow-yellow-400/20">
                    Get Started Free
                    <i data-lucide="arrow-right" class="w-5 h-5"></i>
                </a>

                <a href="#"
                   class="flex items-center gap-2 border border-white/10 px-8 py-4 rounded-2xl font-bold hover:bg-white/5 transition-all">
                    <i data-lucide="play-circle" class="w-5 h-5 text-yellow-400"></i>
                    View Demo
                </a>
            </div>

            <div class="flex items-center gap-6 pt-10 border-t border-white/5">
                <div class="flex -space-x-3">
                    <div class="w-10 h-10 rounded-full border-2 border-black bg-yellow-600 flex items-center justify-center font-bold text-xs text-black">JS</div>
                    <div class="w-10 h-10 rounded-full border-2 border-black bg-yellow-500 flex items-center justify-center font-bold text-xs text-black">AK</div>
                    <div class="w-10 h-10 rounded-full border-2 border-black bg-yellow-400 flex items-center justify-center font-bold text-xs text-black">MT</div>
                </div>
                <p class="text-sm text-gray-500"><span class="text-white font-bold">1,000+</span> users tracking daily</p>
            </div>
        </div>

        <!-- RIGHT VISUALS -->
        <div class="w-full lg:w-1/2 relative parallax-wrap animate-fade" style="animation-delay: 0.2s">
            
            <!-- DECORATIVE BLURS -->
            <div class="absolute -top-20 -right-20 w-64 h-64 bg-yellow-400/20 blur-[100px] rounded-full"></div>
            <div class="absolute -bottom-20 -left-20 w-64 h-64 bg-yellow-600/20 blur-[100px] rounded-full"></div>

            <!-- MAIN PREVIEW CARD -->
            <div class="relative glass-card p-8 rounded-[2.5rem] shadow-2xl overflow-hidden group">
                <div class="flex justify-between items-center mb-8">
                    <div>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-widest">Monthly Spending</p>
                        <h3 class="text-3xl font-bold text-white mt-1">$4,250.00</h3>
                    </div>
                    <div class="w-12 h-12 bg-white/5 rounded-2xl flex items-center justify-center group-hover:bg-yellow-400 transition-all duration-500">
                        <i data-lucide="trending-up" class="text-yellow-400 group-hover:text-black w-6 h-6 transition-colors duration-500"></i>
                    </div>
                </div>

                <div class="flex items-end gap-3 h-[180px] mt-10">
                    <div class="flex-1 bg-white/5 rounded-t-xl group-hover:bg-yellow-400/20 transition-all duration-700 delay-[0ms]" style="height:40%"></div>
                    <div class="flex-1 bg-white/5 rounded-t-xl group-hover:bg-yellow-400/40 transition-all duration-700 delay-[100ms]" style="height:70%"></div>
                    <div class="flex-1 bg-yellow-400 rounded-t-xl transition-all duration-700" style="height:90%"></div>
                    <div class="flex-1 bg-white/5 rounded-t-xl group-hover:bg-yellow-400/20 transition-all duration-700 delay-[200ms]" style="height:50%"></div>
                    <div class="flex-1 bg-white/5 rounded-t-xl group-hover:bg-yellow-400/60 transition-all duration-700 delay-[300ms]" style="height:85%"></div>
                    <div class="flex-1 bg-white/5 rounded-t-xl group-hover:bg-yellow-400/30 transition-all duration-700 delay-[400ms]" style="height:60%"></div>
                </div>
            </div>

            <!-- FLOATING SMALL CARDS -->
            <div class="absolute -top-10 -left-10 glass-card p-5 rounded-3xl flex items-center gap-4 animate-bounce" style="animation-duration: 5s">
                <div class="w-10 h-10 bg-yellow-400/20 rounded-xl flex items-center justify-center">
                    <i data-lucide="check" class="text-yellow-400 w-5 h-5"></i>
                </div>
                <div>
                    <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest">Saved</p>
                    <p class="text-sm font-bold text-white">$1,200</p>
                </div>
            </div>

            <div class="absolute -bottom-10 -right-10 glass-card p-5 rounded-3xl flex items-center gap-4 animate-bounce" style="animation-duration: 7s">
                <div class="w-10 h-10 bg-yellow-400/10 rounded-xl flex items-center justify-center border border-yellow-400/20">
                    <i data-lucide="credit-card" class="text-yellow-400 w-5 h-5"></i>
                </div>
                <div>
                    <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest">Limit</p>
                    <p class="text-sm font-bold text-white">$5,000</p>
                </div>
            </div>

        </div>

    </section>

    <!-- FOOTER -->
    <footer class="px-[8%] py-12 border-t border-white/5 flex flex-col md:flex-row justify-between items-center gap-8">
        <div class="flex items-center gap-3">
            <div class="w-6 h-6 bg-yellow-400 rounded-md flex items-center justify-center">
                <i data-lucide="wallet" class="text-black w-4 h-4"></i>
            </div>
            <div class="text-lg font-bold tracking-tight text-white">PesaTracker</div>
        </div>
        
        <p class="text-sm text-gray-500">© 2026 PesaTracker. Built with premium precision.</p>

        <div class="flex gap-6">
            <a href="#" class="text-gray-500 hover:text-white transition"><i data-lucide="twitter" class="w-5 h-5"></i></a>
            <a href="#" class="text-gray-500 hover:text-white transition"><i data-lucide="github" class="w-5 h-5"></i></a>
            <a href="#" class="text-gray-500 hover:text-white transition"><i data-lucide="linkedin" class="w-5 h-5"></i></a>
        </div>
    </footer>

    <script>
        lucide.createIcons();

        // Subtle Parallax effect
        document.addEventListener("mousemove", (e) => {
            const wrap = document.querySelector(".parallax-wrap");
            if (!wrap) return;
            
            const x = (window.innerWidth / 2 - e.pageX) / 40;
            const y = (window.innerHeight / 2 - e.pageY) / 40;
            
            wrap.style.transform = `rotateY(${x}deg) rotateX(${-y}deg)`;
        });
    </script>

</body>
</html>
>