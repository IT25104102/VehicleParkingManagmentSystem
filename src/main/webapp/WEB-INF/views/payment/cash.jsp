<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Cash Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container{max-width:700px;margin:40px auto;padding:0 20px}
        .page-title{font-size:1.8rem;font-weight:800;margin-bottom:6px}
        .page-sub{color:var(--text-dim);font-size:0.85rem;margin-bottom:30px}
        .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px;transition:0.3s}
        .card:hover{border-color:rgba(26,217,240,0.25)}
        .card-title{font-size:0.75rem;font-weight:600;color:var(--text-dim);text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
        .confirm-item{display:flex;justify-content:space-between;padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.05);font-size:0.88rem}
        .confirm-item:last-child{border-bottom:none}
        .c-label{color:var(--text-dim)}
        .c-val{font-weight:600}
        .badge-pending{display:inline-block;padding:4px 12px;border-radius:12px;font-size:0.75rem;font-weight:700;background:rgba(239,159,39,0.15);color:#EF9F27;border:1px solid rgba(239,159,39,0.3)}
        .info-note{background:rgba(26,217,240,0.06);border:1px solid rgba(26,217,240,0.15);border-radius:10px;padding:14px;font-size:0.8rem;color:var(--text-dim);margin-top:16px;text-align:center;line-height:1.6}
        .info-note strong{color:#1ad9f0}
        .btn-primary{width:100%;background:#37ff8b;border:none;border-radius:20px;padding:14px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;margin-top:16px;display:block;text-align:center}
        .btn-primary:hover{transform:translateY(-2px)}
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
            <li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history" class="active">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="page-title">Confirm Booking</div>
    <div class="page-sub">Review and confirm your cash payment</div>

    <div class="card">
        <div class="card-title">Booking Confirmation</div>
        <div class="confirm-item">
            <span class="c-label">Booking ID</span>
            <span class="c-val">${payment.id}</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Ticket ID</span>
            <span class="c-val">${payment.ticketId}</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Amount</span>
            <span class="c-val" style="color:#37ff8b;font-size:1.1rem">
                Rs. ${payment.amount}
            </span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Payment Method</span>
            <span class="c-val">&#128181; Cash</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Status</span>
            <span class="c-val"><span class="badge-pending">Pending</span></span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Date</span>
            <span class="c-val">${payment.createdAt}</span>
        </div>
    </div>

    <div class="info-note">
        &#128680; Please pay <strong>Rs. ${payment.amount}</strong>
        at the parking counter when you arrive.
        Show your QR ticket to the officer.
    </div>

    <%-- Pass slotId to confirmCash --%>
    <form method="post" action="${pageContext.request.contextPath}/payment/confirmCash">
        <input type="hidden" name="id"     value="${payment.id}"/>
        <input type="hidden" name="slotId" value="${slotId}"/>
        <button type="submit" class="btn-primary">
            Confirm &amp; Generate Ticket &rarr;
        </button>
    </form>

    <a href="${pageContext.request.contextPath}/payment/history" class="btn-outline">&#8592; Back</a>
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
