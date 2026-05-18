<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Tickets</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-wrap { padding: 50px 5%; max-width: 1400px; margin: 0 auto; }
        .page-hero { margin-bottom: 40px; }
        .page-hero h1 { font-size: 2.8rem; color: white; margin-bottom: 10px; }
        .page-hero h1 span { color: var(--btn-neon); }
        .page-hero p { color: var(--text-dim); font-size: 0.88rem; }

        .stats-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; padding: 24px 28px; position: relative; overflow: hidden; transition: 0.3s; }
        .stat-card:hover { background: rgba(255,255,255,0.06); box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .stat-card::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 2px; }
        .stat-card.green::before  { background: var(--btn-neon); box-shadow: 0 0 10px var(--btn-neon); }
        .stat-card.cyan::before   { background: var(--cyan);     box-shadow: 0 0 10px var(--cyan); }
        .stat-card.orange::before { background: #f0a500;         box-shadow: 0 0 10px #f0a500; }
        .stat-label { color: var(--text-dim); font-size: .7rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 10px; }
        .stat-value { font-size: 2.4rem; font-weight: 800; }
        .stat-card.green .stat-value  { color: var(--btn-neon); }
        .stat-card.cyan .stat-value   { color: var(--cyan); }
        .stat-card.orange .stat-value { color: #f0a500; }
        .stat-icon { position: absolute; right: 22px; top: 50%; transform: translateY(-50%); font-size: 2.8rem; opacity: 0.1; }

        .alert { padding: 13px 20px; border-radius: 10px; margin-bottom: 22px; font-size: .82rem; font-weight: 600; }
        .alert-success { background: rgba(55,255,139,0.08); border: 1px solid rgba(55,255,139,0.4); color: var(--btn-neon); }
        .alert-error   { background: rgba(255,77,109,0.08);  border: 1px solid rgba(255,77,109,0.4);  color: #ff4d6d; }

        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
        .btn-generate-top { padding: 10px 24px; background: var(--btn-neon); color: #0c1a12; border: none; border-radius: 20px; font-family: Montserrat,sans-serif; font-weight: 800; font-size: .82rem; cursor: pointer; transition: 0.3s; text-decoration: none; display: inline-block; }
        .btn-generate-top:hover { transform: translateY(-2px); box-shadow: 0 0 15px var(--btn-neon); }

        .table-wrap { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: rgba(26,217,240,0.05); }
        th { padding: 14px 16px; text-align: left; font-size: .7rem; font-weight: 700; color: var(--cyan); letter-spacing: 1px; text-transform: uppercase; border-bottom: 1px solid rgba(255,255,255,0.06); }
        td { padding: 14px 16px; font-size: .82rem; border-bottom: 1px solid rgba(255,255,255,0.04); color: var(--text-dim); }
        tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: rgba(255,255,255,0.03); }
        .ticket-id   { font-family: monospace; color: var(--cyan); font-size: .78rem; font-weight: 700; }
        .vehicle-num { font-weight: 700; color: var(--text-main); }
        .slot-num    { color: #f0a500; font-weight: 700; }
        .badge { padding: 4px 12px; border-radius: 20px; font-size: .68rem; font-weight: 700; display: inline-block; }
        .badge-active { background: rgba(55,255,139,0.1); color: var(--btn-neon); border: 1px solid rgba(55,255,139,0.3); }
        .action-btns { display: flex; gap: 6px; }
        .btn-action { padding: 6px 13px; border: none; border-radius: 15px; font-family: Montserrat,sans-serif; font-weight: 700; font-size: .68rem; cursor: pointer; transition: 0.3s; text-transform: uppercase; text-decoration: none; display: inline-block; }
        .btn-view { background: rgba(26,217,240,0.1);  color: var(--cyan);  border: 1px solid rgba(26,217,240,0.3); }
        .btn-edit { background: rgba(240,165,0,0.1);   color: #f0a500;      border: 1px solid rgba(240,165,0,0.3); }
        .btn-void { background: rgba(255,77,109,0.1);  color: #ff4d6d;      border: 1px solid rgba(255,77,109,0.3); }
        .btn-action:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
        .empty-row td { text-align: center; color: var(--text-dim); padding: 60px; font-size: .85rem; }
    </style>
</head>
<body>

<!-- Header — shows admin nav if admin, customer nav if customer -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <c:choose>
                <c:when test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                    <span class="btn-sm" style="cursor:default;">Admin Panel</span>
                    <a href="${pageContext.request.contextPath}/logout">
                        <button class="btn-sm login">Log out</button>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/profile">
                        <button class="btn-sm">${sessionScope.loggedInUser.name}</button>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">
                        <button class="btn-sm login">Log out</button>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <nav class="full-width-nav">
        <c:choose>
            <c:when test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/price">Pricing</a></li>
                    <li><a href="${pageContext.request.contextPath}/slots/manage">Manage Slots</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users">Manage Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
                    <li><a href="${pageContext.request.contextPath}/tickets" class="active">Tickets</a></li>
                </ul>
            </c:when>
            <c:otherwise>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/slots">Parking Slots</a></li>
                    <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
                    <li><a href="${pageContext.request.contextPath}/tickets" class="active">Tickets</a></li>
                    <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
                </ul>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<div class="page-wrap">
    <div class="page-hero">
        <h1>Check-in &amp; <span>Ticketing</span></h1>
        <p>Generate digital parking tickets, manage active slots, and void tickets instantly.</p>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">${errorMsg}</div>
    </c:if>

    <div class="stats-row">
        <div class="stat-card green">
            <div class="stat-label">Active Tickets</div>
            <div class="stat-value">${activeCount}</div>
            <div class="stat-icon">&#127915;</div>
        </div>
        <div class="stat-card cyan">
            <div class="stat-label">Total Generated</div>
            <div class="stat-value">${totalCount}</div>
            <div class="stat-icon">&#128203;</div>
        </div>
        <div class="stat-card orange">
            <div class="stat-label">Voided Tickets</div>
            <div class="stat-value">${voidedCount}</div>
            <div class="stat-icon">&#128465;</div>
        </div>
    </div>

    <div class="toolbar">
        <h2 style="color:white;font-size:1.1rem;">Active Tickets</h2>
        <%-- Only admin can generate ticket manually --%>
        <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/tickets/new"
               class="btn-generate-top">+ Generate Ticket</a>
        </c:if>
    </div>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Ticket ID</th>
                    <th>Vehicle Number</th>
                    <th>Vehicle ID</th>
                    <th>Slot</th>
                    <th>Check-In Time</th>
                    <th>Status</th>
                    <%-- Actions only for admin --%>
                    <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                        <th>Actions</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="t" items="${tickets}">
                    <tr>
                        <td><span class="ticket-id">${t.id}</span></td>
                        <td><span class="vehicle-num">${t.vehicleNumber}</span></td>
                        <td>${t.vehicleId}</td>
                        <td><span class="slot-num">&#128205; ${t.slotId}</span></td>
                        <td>${t.checkInTime}</td>
                        <td><span class="badge badge-active">${t.status}</span></td>
                        <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                            <td>
                                <div class="action-btns">
                                    <a href="${pageContext.request.contextPath}/tickets/${t.id}"
                                       class="btn-action btn-view">View</a>
                                    <a href="${pageContext.request.contextPath}/tickets/${t.id}/edit"
                                       class="btn-action btn-edit">Edit Slot</a>
                                    <form action="${pageContext.request.contextPath}/tickets/${t.id}/void"
                                          method="post" style="display:inline"
                                          onsubmit="return confirm('Void this ticket?')">
                                        <button type="submit" class="btn-action btn-void">Void</button>
                                    </form>
                                </div>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                <c:if test="${empty tickets}">
                    <tr class="empty-row">
                        <td colspan="7">No active tickets found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

 <footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
            <a href="${pageContext.request.contextPath}/admin/price">Pricing</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/slots/manage">Manage Slots</a>
            <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
            <a href="${pageContext.request.contextPath}/tickets">Tickets</a>
        </div>
        <div class="f-col contact-info">
            <strong>Contact us:</strong>
            <p>ParkCity@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
    <p class="footer-copy">&copy; 2026 ParkCity Smart System. All rights reserved.</p>
</footer>

</body>
</html>
