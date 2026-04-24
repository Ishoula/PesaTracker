<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Reports - Pesa Tracker</title>
    <style>
        .filter-section { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 15px; align-items: flex-end; }
        .report-header { display: flex; justify-content: space-between; align-items: center; }
        .print-btn { background: #34495e; color: white; padding: 10px; border-radius: 5px; cursor: pointer; text-decoration: none; }
        @media print { .filter-section, .sidebar, .print-btn { display: none; } }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="report-header">
            <h1>Expense Reports</h1>
            <a href="javascript:window.print()" class="print-btn">Print PDF</a>
        </div>

        <form action="${pageContext.request.contextPath}/expenses/reports" method="GET" class="filter-section">
            <div>
                <label>Start Date</label><br>
                <input type="date" name="startDate" value="${param.startDate}">
            </div>
            <div>
                <label>End Date</label><br>
                <input type="date" name="endDate" value="${param.endDate}">
            </div>
            <div>
                <label>Category</label><br>
                <select name="categoryName">
                    <option value="All">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.name}" ${param.categoryName == cat.name ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" style="background: var(--primary); color: white; border: none; padding: 10px 20px; border-radius: 5px;">Filter</button>
        </form>

        <div class="content-card">
            <h3>Summary Total: <fmt:formatNumber value="${reportTotal}" type="currency" currencySymbol="$"/></h3>
            <table border="1" width="100%" style="border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8f9fa;">
                        <th>Date</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="exp" items="${expenses}">
                        <tr>
                            <td>${exp.date}</td>
                            <td>${exp.category.name}</td>
                            <td>${exp.description}</td>
                            <td><fmt:formatNumber value="${exp.amount}" type="currency" currencySymbol="$"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>