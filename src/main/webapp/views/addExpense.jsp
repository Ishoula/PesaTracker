<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Expense | Pesa Tracker</title>
    <style>
        :root { --primary: #2ecc71; --dark: #2c3e50; --bg: #f4f7f6; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .form-card { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; margin-bottom: 0.5rem; font-weight: 600; color: var(--dark); }
        input, select, textarea { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .type-toggle { display: flex; gap: 10px; margin-bottom: 1.5rem; }
        .type-toggle label { flex: 1; text-align: center; padding: 10px; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; transition: 0.3s; }
        .type-toggle input { display: none; }
        .type-toggle input:checked + span { background: var(--primary); color: white; display: block; width: 100%; margin: -10px; padding: 10px; border-radius: 5px; }
        .hidden { display: none; }
        .btn-submit { width: 100%; padding: 1rem; background: var(--primary); color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; }
        .btn-back { display: block; text-align: center; margin-top: 1rem; color: #7f8c8d; text-decoration: none; }
    </style>
</head>
<body>

<div class="form-card">
    <h2 style="text-align: center; margin-top: 0;">Record New Expense</h2>

    <form action="<c:url value='/expenses/save'/>" method="POST">

        <div class="form-group">
            <label>Expense Type</label>
            <div class="type-toggle">
                <label>
                    <input type="radio" name="expenseType" value="PERSONAL" checked onclick="toggleFields('PERSONAL')">
                    <span>Personal</span>
                </label>
                <label>
                    <input type="radio" name="expenseType" value="BUSINESS" onclick="toggleFields('BUSINESS')">
                    <span>Business</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label>Amount</label>
            <input type="number" step="0.01" name="amount" required placeholder="0.00">
        </div>

        <div class="form-group">
            <label>Category</label>
            <input type="text" name="categoryName" list="categoryOptions" required placeholder="Type or select a category...">
            <datalist id="categoryOptions">
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.name}">
                </c:forEach>
            </datalist>
        </div>

        <div class="form-group">
            <label>Date</label>
            <input type="date" name="date" required id="expenseDate">
        </div>

        <div id="personalFields" class="form-group">
            <label>Occasion</label>
            <input type="text" name="occasion" placeholder="e.g. Birthday, Vacation">
        </div>

        <div id="businessFields" class="form-group hidden">
            <label>Company Name</label>
            <input type="text" name="companyName" placeholder="e.g. Acme Corp">
            <label style="margin-top:10px">Tax ID / Reference</label>
            <input type="text" name="taxId" placeholder="TAX-12345">
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="2"></textarea>
        </div>

        <button type="submit" class="btn-submit">Save Expense</button>
        <a href="<c:url value='/expenses/dashboard'/>"class="btn-back">Cancel</a>
    </form>
</div>

<script>
    // Set default date to today
    document.getElementById('expenseDate').valueAsDate = new Date();

    // Toggle specific fields based on selection
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