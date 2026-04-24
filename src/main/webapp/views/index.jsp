<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Pesa Tracker</title>
    <style>
        :root {
            --primary: #2ecc71;
            --dark: #2c3e50;
            --light: #ecf0f1;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            color: var(--dark);
            background-color: #fff;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 10%;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary);
        }
        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            margin-left: 2rem;
            font-weight: 500;
        }
        .btn-login {
            background-color: var(--primary);
            color: white !important;
            padding: 0.6rem 1.5rem;
            border-radius: 5px;
            transition: 0.3s;
        }
        .btn-login:hover {
            background-color: #27ae60;
        }
        .hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 5rem 10%;
            background: linear-gradient(135deg, #f9f9f9 0%, #e8f5e9 100%);
        }
        .hero-content {
            max-width: 500px;
        }
        .hero-content h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            line-height: 1.2;
        }
        .hero-content p {
            font-size: 1.2rem;
            color: #7f8c8d;
            margin-bottom: 2rem;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            padding: 4rem 10%;
            text-align: center;
        }
        .feature-card {
            padding: 2rem;
            border-radius: 10px;
            background: white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }
        .feature-card i {
            font-size: 2rem;
            color: var(--primary);
            display: block;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

    <header>
        <div class="logo">PesaTracker</div>
        <nav class="nav-links">
            <a href="<c:url value='/auth/login'/>">Login</a>
            <a href="<c:url value='/auth/register'/>" class="btn-login">Get Started</a>
        </nav>
    </header>

    <section class="hero">
        <div class="hero-content">
            <h1>Master Your Money, Effortlessly.</h1>
            <p>Track personal and business expenses with Jakarta EE precision. Real-time insights, beautifully visualized.</p>
            <a href="<c:url value='/auth/register'/>" class="btn-login" style="padding: 1rem 2rem; font-size: 1.1rem;">Start Free Today</a>
        </div>
        <div class="hero-image">
            <div style="width: 400px; height: 300px; background: #fff; border-radius: 20px; box-shadow: 20px 20px 60px #d9d9d9;">
                <div style="padding: 20px; border-bottom: 1px solid #eee; font-weight: bold;">Monthly Spending</div>
                <div style="display: flex; align-items: flex-end; height: 200px; justify-content: space-around; padding: 20px;">
                    <div style="width: 40px; height: 60%; background: var(--primary); border-radius: 5px 5px 0 0;"></div>
                    <div style="width: 40px; height: 85%; background: var(--primary); border-radius: 5px 5px 0 0;"></div>
                    <div style="width: 40px; height: 40%; background: var(--primary); border-radius: 5px 5px 0 0;"></div>
                    <div style="width: 40px; height: 95%; background: var(--primary); border-radius: 5px 5px 0 0;"></div>
                </div>
            </div>
        </div>
    </section>

    <section class="features">
        <div class="feature-card">
            <h3>Categorized Tracking</h3>
            <p>Separate Business from Personal expenses using Hibernate inheritance mapping.</p>
        </div>
        <div class="feature-card">
            <h3>Fast Performance</h3>
            <p>Blazing fast data retrieval thanks to Hibernate Second-Level Cache.</p>
        </div>
        <div class="feature-card">
            <h3>Visual Reports</h3>
            <p>Analyze trends with JFreeChart-powered data visualization.</p>
        </div>
    </section>

</body>
</html>