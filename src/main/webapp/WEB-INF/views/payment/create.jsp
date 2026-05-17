<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyParking | Booking Summary</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 1.8rem; font-weight: 800; margin-bottom: 6px; }
        .page-sub { color: var(--text-dim); font-size: 0.85rem; margin-bottom: 30px; }
        .card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px; padding: 24px; margin-bottom: 20px;
        }
        .card-title {
            font-size: 0.75rem; font-weight: 600;
            color: var(--text-dim); text-transform: uppercase;
            letter-spacing: 1px; margin-bottom: 16px;
        }
        .summary-row {
            display: flex; justify-content: space-between;
            align-items: center; padding: 12px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            font-size: 0.9rem;
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row .label { color: var(--text-dim); }
        .summary-row .value { font-weight: 600; color: var(--text-main); }
        .total-display {
            background: rgba(55,255,139,0.06);
            border: 1px solid rgba(55,255,139,0.2);
            border-radius: 10px; padding: 16px;
            text-align: center; margin-bottom: 20px;
        }
        .total-display .t-label {
            font-size: 0.75rem; color: var(--text-dim); margin-bottom: 4px;
        }
        .total-display .t-amount {
            font-size: 2rem; font-weight: 800; color: var(--btn-neon);
        }
        .phone-group {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px; padding: 24px; margin-bottom: 20px;
        }
        .phone-group label {
            display: block; font-size: 0.75rem; font-weight: 600;
            color: var(--cyan); text-transform: uppercase;
            letter-spacing: 1px; margin-bottom: 10px;
        }
        .phone-group input {
            width: 100%; background: rgba(255,255,255,0.05);
            border: 1px solid rgba(26,217,240,0.25);
            border-radius: 8px; padding: 12px 14px;
            color: var(--text-main); font-family: 'Montserrat', sans-serif;
            font-size: 0.9rem; outline: none; transition: 0.3s;
        }
        .phone-group input:focus {
            border-color: var(--cyan);
            box-shadow: 0 0 12px rgba(26,217,240,0.2);
        }
        .phone-group input::placeholder { color: rgba(255,255,255,0.2); }
        .phone-hint {
            font-size: 0.72rem; color: var(--text-dim); margin-top: 6px;
        }
        .btn-primary {
            width: 100%; background: var(--btn-neon); border: none;
            border-radius: 20px; padding: 14px;
            font-family: 'Montserrat', sans-serif; font-size: 0.9rem;
            font-weight: 800; color: #0c1a12; cursor: pointer;
            transition: 0.3s;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 0 20px var(--btn-neon); }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> MyParking</div>
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
    <div class="page-title">Booking Summary</div>
    <div class="page-sub">Review your booking details before proceeding to payment</div>

    <!-- Booking Details Card -->
    <div class="card">
        <div class="card-title">Booking Details</div>

        <div class="summary-row">
            <span class="label">Owner Name</span>
            <span class="value">${param.ownerName}</span>
        </div>
        <div class="summary-row">
            <span class="label">Vehicle Number</span>
            <span class="value">${param.vehicleNumber}</span>
        </div>
        <div class="summary-row">
            <span class="label">Vehicle Type</span>
            <span class="value">${param.vehicleType}</span>
        </div>
        <div class="summary-row">
            <span class="label">Slot Number</span>
            <span class="value">${param.slotNumber}</span>
        </div>
        <div class="summary-row">
            <span class="label">Duration</span>
            <span class="value">${param.hours} hour(s)</span>
        </div>
        <div class="summary-row">
            <span class="label">Date</span>
            <span class="value">${param.date}</span>
        </div>
    </div>

    <!-- Total Amount -->
    <div class="total-display">
        <div class="t-label">Total Amount to Pay</div>
        <div class="t-amount">Rs. ${param.totalAmount}</div>
    </div>

    <!-- Phone number — only field customer fills -->
    <form method="post" action="${pageContext.request.contextPath}/payment/create">

        <div class="phone-group">
            <label>Contact Phone Number</label>
            <input type="tel" name="phone"
                   placeholder="e.g. 0771234567"
                   maxlength="10"
                   pattern="[0-9]{10}"
                   value="${param.phone}"
                   required/>
            <p class="phone-hint">Enter the number you want to be contacted on (may differ from registered number)</p>
        </div>

        <!-- All other details passed as hidden fields -->
        <input type="hidden" name="ticketId"      value="${param.ticketId}"/>
        <input type="hidden" name="vehicleId"     value="${param.vehicleId}"/>
        <input type="hidden" name="ownerName"     value="${param.ownerName}"/>
        <input type="hidden" name="vehicleNumber" value="${param.vehicleNumber}"/>
        <input type="hidden" name="vehicleType"   value="${param.vehicleType}"/>
        <input type="hidden" name="slotNumber"    value="${param.slotNumber}"/>
        <input type="hidden" name="slotId"        value="${param.slotId}"/>
        <input type="hidden" name="hours"         value="${param.hours}"/>
        <input type="hidden" name="date"          value="${param.date}"/>
        <input type="hidden" name="totalAmount"   value="${param.totalAmount}"/>

        <button type="submit" class="btn-primary">
            Proceed to Payment &rarr;
        </button>
    </form>

    <a href="${pageContext.request.contextPath}/tickets"
       style="display:block;text-align:center;margin-top:16px;color:var(--text-dim);font-size:0.82rem;">
        &#8592; Back to Tickets
    </a>
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
            <p>MyParking@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
</footer>

</body>
</html>
