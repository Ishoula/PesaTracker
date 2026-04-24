<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pesa Tracker | Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #2ecc71;
            --dark: #2c3e50;
            --light-bg: #f4f7f6;
            --text-muted: #7f8c8d;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            margin: 0;
            display: flex;
        }

        /* Sidebar Navigation */
        .sidebar {
            width: 260px;
            background: var(--dark);
            color: white;
            height: 100vh;
            padding: 30px 20px;
            position: fixed;
        }
        .sidebar h2 {
            color: var(--primary);
            margin-bottom: 40px;
            font-size: 1.5rem;
            letter-spacing: 1px;
        }
        .user-info {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #3e4f5f;
        }
        .nav-links a {
            display: block;
            color: #bdc3c7;
            text-decoration: none;
            padding: 12px 15px;
            border-radius: 5px;
            transition: 0.3s;
            margin-bottom: 5px;
        }
        .nav-links a:hover, .nav-links a.active {
            background: #34495e;
            color: white;
        }

        /* Main Workspace */
        .main-content {
            margin-left: 260px;
            padding: 40px;
            width: calc(100% - 260px);
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .btn-add {
            background: var(--primary);
            color: white;
            padding: 10px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-add:hover { background: #27ae60; }

        /* KPI Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }
        .stat-card h4 { margin: 0; color: var(--text-muted); font-size: 0.85rem; text-transform: uppercase; }
        .stat-card .value { font-size: 2rem; font-weight: bold; margin: 10px 0 0; color: var(--dark); }

        /* Dashboard Layout (Chart + Table) */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 25px;
            align-items: start;
        }
        .content-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }
        .content-card h3 { margin-top: 0; margin-bottom: 20px; font-size: 1.1rem; }

        /* Table Styling */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; color: var(--text-muted); border-bottom: 2px solid #f4f7f6; font-size: 0.9rem; }
        td { padding: 15px 12px; border-bottom: 1px solid #f4f7f6; font-size: 0.95rem; }

        .badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .bg-business { background: #e3f2fd; color: #1976d2; }
        .bg-personal { background: #e8f5e9; color: #2e7d32; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <h2>PesaTracker</h2>
        <div class="user-info">
            <small style="color: var(--text-muted)">Logged in as</small><br>
            <strong>${sessionScope.user.username}</strong>
        </div>
        <nav class="nav-links">
            <a href="<c:url value='/expenses/dashboard'/>"class="active">Dashboard</a>
            <a href="<c:url value='/expenses/add'/>">Add Expense</a>
            <a href="<c:url value='/expenses/report'/>">Reports</a>
            <a href="<c:url value='/auth/logout'/>" style="margin-top: 50px; color: #e74c3c;">Sign Out</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="top-bar">
            <h1>Dashboard</h1>
            <a href="<c:url value='/expenses/add'/>" class="btn-add">+ New Expense</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h4>Total Expenditure</h4>
                <div class="value">
                    <fmt:formatNumber value="${totalSpending}" type="currency" currencySymbol="$"/>
                </div>
            </div>
            <div class="stat-card">
                <h4>Transaction Count</h4>
                <div class="value">${expenses.size()}</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="content-card">
                <h3>Recent Transactions</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Description</th>
                            <th>Category</th>
                            <th>Type</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="exp" items="${expenses}">
                            <tr>
                                <td>${exp.date}</td>
                                <td>
                                    ${exp.description}<br>
                                    <small style="color: var(--text-muted)">
                                        <c:choose>
                                            <c:when test="${exp['class'].simpleName == 'BusinessExpense'}">
                                                Corp: ${exp.companyName}
                                            </c:when>
                                            <c:otherwise>
                                                Occasion: ${exp.occasion}
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>
                                <td>${exp.category.name}</td>
                                <td>
                                    <span class="badge ${exp['class'].simpleName == 'BusinessExpense' ? 'bg-business' : 'bg-personal'}">
                                        ${exp['class'].simpleName == 'BusinessExpense' ? 'Business' : 'Personal'}
                                    </span>
                                </td>
                                <td style="font-weight: bold; color: var(--dark);">
                                    <fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="$"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="content-card">
                <h3>Spending by Category</h3>
                <canvas id="categoryChart" width="100" height="100"></canvas>
            </div>
        </div>
    </main>

    <script>
        // Data Extraction from Backend Map
        const chartLabels = [];
        const chartValues = [];

        <c:forEach var="entry" items="${chartData}">
            chartLabels.push("${entry.key}");
            chartValues.push(${entry.value});
        </c:forEach>

        // Initialize Chart.js
        const ctx = document.getElementById('categoryChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: chartLabels,
                datasets: [{
                    data: chartValues,
                    backgroundColor: [
                        '#2ecc71', '#3498db', '#9b59b6', '#f1c40f', '#e67e22', '#e74c3c', '#1abc9c'
                    ],
                    hoverOffset: 10,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true }
                    }
                }
            }
        });
    </script>
</body>
</html>