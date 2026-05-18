<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container{max-width:700px;margin:40px auto;padding:0 20px}
        .page-title{font-size:1.8rem;font-weight:800;margin-bottom:6px}
        .page-sub{color:var(--text-dim);font-size:0.85rem;margin-bottom:30px}
        .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px;transition:0.3s}
        .card:hover{border-color:rgba(26,217,240,0.25)}
        .card-title{font-size:0.75rem;font-weight:600;color:var(--text-dim);text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
        .amount-badge{text-align:center;padding:20px 0}
        .amount-badge .total-label{font-size:0.8rem;color:var(--text-dim);margin-bottom:6px}
        .amount-badge .total-amt{font-size:2.5rem;font-weight:800;color:#37ff8b}
        .pay-options{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-top:10px}
        .pay-btn{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:24px;text-align:center;cursor:pointer;transition:0.3s;text-decoration:none;display:block}
        .pay-btn:hover{border-color:#37ff8b;background:rgba(55,255,139,0.06);transform:translateY(-3px)}
        .pay-icon{font-size:2rem;margin-bottom:10px}
        .pay-label{font-size:1rem;font-weight:700;color:#f0f6fc}
        .pay-desc{font-size:0.75rem;color:var(--text-dim);margin-top:4px}
        .btn-outline{width:100%;background:transparent;border:1px solid #37ff8b;border-radius:20px;padding:13px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:700;color:#37ff8b;cursor:pointer;transition:0.3s;margin-top:8px;display:block;text-align:center}
        .btn-outline:hover{background:rgba(55,255,139,0.08)}
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <a href="${pageContext.request.contextPath}/profile">
                <button class="btn-sm">${sessionScope.loggedInUser.name}</button>
            </a>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="btn-sm login">Log out</button>
            </a>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/slots">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history" class="active">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="page-title">Payment</div>
    <div class="page-sub">Choose your preferred payment method</div>

    <div class="card">
        <div class="amount-badge">
            <div class="total-label">Total Amount to Pay</div>
            <div class="total-amt">Rs. ${payment.amount}</div>
        </div>
    </div>

    <div class="card">
        <div class="card-title">Select Payment Method</div>
        <div class="pay-options">
            <%-- Pass slotId to cash and card pages --%>
            <a href="${pageContext.request.contextPath}/payment/cash?id=${payment.id}&slotId=${slotId}"
               class="pay-btn">
                <div class="pay-icon">&#128181;</div>
                <div class="pay-label">Cash</div>
                <div class="pay-desc">Pay at counter</div>
            </a>
            <a href="${pageContext.request.contextPath}/payment/card?id=${payment.id}&slotId=${slotId}"
               class="pay-btn">
                <div class="pay-icon">&#128179;</div>
                <div class="pay-label">Card</div>
                <div class="pay-desc">Debit / Credit</div>
            </a>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/payment/create" class="btn-outline">&#8592; Back</a>
</div>

<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/slots">Parking Slots</a>
            <a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a>
            <a href="${pageContext.request.contextPath}/tickets">Tickets</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
        </div>
        <div class="f-col contact-info">
            <strong>Contact us:</strong>
            <p>ParkCity@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
</footer>

</body>
</html>
