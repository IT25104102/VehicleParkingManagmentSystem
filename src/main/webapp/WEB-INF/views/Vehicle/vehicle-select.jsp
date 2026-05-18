<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyParking | Select Vehicle</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-content { padding: 2rem 5%; max-width: 900px; margin: 0 auto; }
        .slot-info-bar {
            background: rgba(26,217,240,0.08);
            border: 1px solid rgba(26,217,240,0.3);
            border-radius: 12px; padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;
        }
        .slot-badge {
            background: var(--btn-neon); color: #0a1128;
            padding: 4px 16px; border-radius: 20px;
            font-weight: 800; font-size: 1rem;
        }
        .date-badge {
            background: rgba(26,217,240,0.15); color: var(--cyan);
            padding: 4px 16px; border-radius: 20px;
            font-weight: 700; font-size: 0.85rem;
            border: 1px solid rgba(26,217,240,0.3);
        }
        .section-title {
            font-size: 0.72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.12em;
            color: var(--cyan); margin-bottom: 1rem;
        }
        .vehicle-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 1.2rem 1.5rem;
            margin-bottom: 0.8rem;
            display: flex; align-items: center;
            justify-content: space-between; transition: border-color 0.2s;
        }
        .vehicle-card:hover { border-color: rgba(55,255,139,0.4); }
        .vehicle-info { display: flex; align-items: center; gap: 1rem; }
        .vehicle-plate {
            border: 1.5px solid var(--btn-neon); color: var(--btn-neon);
            padding: 4px 14px; border-radius: 20px;
            font-size: 0.88rem; font-weight: 800; letter-spacing: 1px;
        }
        .vehicle-details { font-size: 0.82rem; color: var(--text-dim); }
        .vehicle-details strong { color: var(--text-main); }
        .btn-select {
            background: var(--btn-neon); border: none; color: #0a1128;
            padding: 8px 24px; border-radius: 20px;
            font-weight: 800; font-size: 0.8rem;
            font-family: 'Montserrat', sans-serif;
            cursor: pointer; text-decoration: none; transition: box-shadow 0.2s;
        }
        .btn-select:hover { box-shadow: 0 0 15px var(--btn-neon); }
        .divider-text {
            text-align: center; color: var(--text-dim);
            font-size: 0.78rem; margin: 1.5rem 0; position: relative;
        }
        .divider-text::before, .divider-text::after {
            content: ''; position: absolute; top: 50%;
            width: 45%; height: 1px; background: rgba(255,255,255,0.08);
        }
        .divider-text::before { left: 0; }
        .divider-text::after  { right: 0; }
        .btn-add-new {
            width: 100%; padding: 1rem;
            background: rgba(255,255,255,0.03);
            border: 2px dashed rgba(26,217,240,0.3);
            border-radius: 12px; color: var(--cyan);
            font-size: 0.88rem; font-weight: 700;
            font-family: 'Montserrat', sans-serif;
            cursor: pointer; transition: 0.2s;
            text-decoration: none; display: block; text-align: center;
        }
        .btn-add-new:hover { background: rgba(26,217,240,0.06); border-color: var(--cyan); }
        .empty-msg { text-align: center; color: var(--text-dim); padding: 2rem; font-size: 0.88rem; }
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
            <li><a href="${pageContext.request.contextPath}/slots" class="active">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="page-hdr" style="margin-bottom:1.5rem;">
        <h1>Select Vehicle</h1>
        <p>Choose a registered vehicle or add a temporary one</p>
    </div>

    <!-- Slot + Date info bar -->
    <div class="slot-info-bar">
        <span class="slot-badge">${slotNumber}</span>
        <span class="date-badge">📅 ${date}</span>
        <p style="color:var(--text-dim);margin:0;">
            Type: <strong style="color:var(--text-main);">${slotType}</strong>
        </p>
    </div>

    <!-- Existing vehicles -->
    <div class="section-title">Your Registered Vehicles</div>

    <c:choose>
        <c:when test="${empty vehicles}">
            <div class="empty-msg">No vehicles registered yet. Add one below.</div>
        </c:when>
        <c:otherwise>
            <c:forEach var="v" items="${vehicles}">
                <div class="vehicle-card">
                    <div class="vehicle-info">
                        <span class="vehicle-plate">${v.licensePlate}</span>
                        <div class="vehicle-details">
                            <strong>${v.ownerName}</strong><br/>
                            ${v.vehicleType} &nbsp;·&nbsp; ${v.contactNumber}
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/tickets/new?vehicleId=${v.vehicleId}&slotId=${slotId}&slotNumber=${slotNumber}&vehicleNumber=${v.licensePlate}&ownerName=${v.ownerName}&date=${date}"
                       class="btn-select">Select →</a>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="divider-text">or</div>

    <a href="${pageContext.request.contextPath}/vehicle/add?slotId=${slotId}&slotNumber=${slotNumber}&slotType=${slotType}&date=${date}"
       class="btn-add-new">
        ＋ Add Temporary Vehicle
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
