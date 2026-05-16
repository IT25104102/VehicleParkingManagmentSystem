<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Tickets</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root { --text-main:#f0f6fc; --text-dim:#b8c7e0; --btn-neon:#37ff8b; --cyan:#1ad9f0; --orange:#f0a500; --red:#ff4d6d; }
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:Montserrat,sans-serif; color:var(--text-main);
               background:radial-gradient(at top left,#1e3a8a 0%,#0a1128 50%),radial-gradient(at bottom right,#0d1117 0%,#010409 60%);
               background-attachment:fixed; min-height:100vh; }
        a { text-decoration:none; color:inherit; transition:0.3s; }

        /* Header */
        .main-header { width:100%; z-index:1000; position:sticky; top:0; }
        .top-bar { display:flex; justify-content:space-between; align-items:center; padding:15px 5%; background:rgba(10,17,40,0.8); backdrop-filter:blur(10px); }
        .logo { font-weight:800; font-size:1.15rem; }
        .logo-icon { color:var(--cyan); margin-right:6px; }
        .header-controls { display:flex; gap:10px; }
        .btn-sm { padding:5px 18px; font-size:0.7rem; font-weight:700; border-radius:15px; background:transparent; border:1px solid var(--btn-neon); color:var(--btn-neon); cursor:pointer; font-family:Montserrat,sans-serif; transition:0.3s; }
        .btn-sm.login:hover { background:var(--btn-neon); color:#0c1a12; }
        .full-width-nav { width:100%; background:#0d1117; border-bottom:2px solid var(--cyan); box-shadow:0 4px 15px rgba(0,0,0,0.3); }
        .full-width-nav ul { display:flex; justify-content:center; list-style:none; padding:12px 0; }
        .full-width-nav li a { text-transform:uppercase; font-size:0.8rem; font-weight:600; padding:0 20px; }
        .full-width-nav li a:hover, .full-width-nav li a.active { color:var(--btn-neon); text-shadow:0 0 10px var(--btn-neon); }

        /* Page */
        .page-wrap { padding:50px 5%; max-width:1400px; margin:0 auto; }
        .page-hero { margin-bottom:40px; }
        .page-hero h1 { font-size:2.8rem; color:white; margin-bottom:10px; }
        .page-hero h1 span { color:var(--btn-neon); }
        .page-hero p { color:var(--text-dim); font-size:0.88rem; }

        /* Stats */
        .stats-row { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:40px; }
        .stat-card { background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.05); border-radius:12px; padding:24px 28px; position:relative; overflow:hidden; transition:0.3s; animation:blurClear 1s ease-out both; }
        .stat-card:hover { background:rgba(255,255,255,0.06); box-shadow:0 10px 30px rgba(0,0,0,0.3); }
        .stat-card::before { content:""; position:absolute; top:0; left:0; right:0; height:2px; }
        .stat-card.green::before  { background:var(--btn-neon); box-shadow:0 0 10px var(--btn-neon); }
        .stat-card.cyan::before   { background:var(--cyan);     box-shadow:0 0 10px var(--cyan); }
        .stat-card.orange::before { background:var(--orange);   box-shadow:0 0 10px var(--orange); }
        .stat-label { color:var(--text-dim); font-size:.7rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; margin-bottom:10px; }
        .stat-value { font-size:2.4rem; font-weight:800; }
        .stat-card.green .stat-value  { color:var(--btn-neon); }
        .stat-card.cyan .stat-value   { color:var(--cyan); }
        .stat-card.orange .stat-value { color:var(--orange); }
        .stat-icon { position:absolute; right:22px; top:50%; transform:translateY(-50%); font-size:2.8rem; opacity:0.1; }

        /* Alert */
        .alert { padding:13px 20px; border-radius:10px; margin-bottom:22px; font-size:.82rem; font-weight:600; }
        .alert-success { background:rgba(55,255,139,0.08); border:1px solid rgba(55,255,139,0.4); color:var(--btn-neon); }
        .alert-error   { background:rgba(255,77,109,0.08);  border:1px solid rgba(255,77,109,0.4);  color:var(--red); }

        /* Toolbar */
        .toolbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:18px; }
        .btn-generate-top { padding:10px 24px; background:var(--btn-neon); color:#0c1a12; border:none; border-radius:20px; font-family:Montserrat,sans-serif; font-weight:800; font-size:.82rem; cursor:pointer; transition:0.3s; text-decoration:none; display:inline-block; }
        .btn-generate-top:hover { transform:translateY(-2px); box-shadow:0 0 15px var(--btn-neon); }

        /* Table */
        .table-wrap { background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.06); border-radius:12px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead tr { background:rgba(26,217,240,0.05); }
        th { padding:14px 16px; text-align:left; font-size:.7rem; font-weight:700; color:var(--cyan); letter-spacing:1px; text-transform:uppercase; border-bottom:1px solid rgba(255,255,255,0.06); }
        td { padding:14px 16px; font-size:.82rem; border-bottom:1px solid rgba(255,255,255,0.04); color:var(--text-dim); }
        tr:last-child td { border-bottom:none; }
        tbody tr:hover td { background:rgba(255,255,255,0.03); }
        .ticket-id   { font-family:monospace; color:var(--cyan); font-size:.78rem; font-weight:700; }
        .vehicle-num { font-weight:700; color:var(--text-main); }
        .slot-num    { color:var(--orange); font-weight:700; }
        .badge { padding:4px 12px; border-radius:20px; font-size:.68rem; font-weight:700; display:inline-block; }
        .badge-active { background:rgba(55,255,139,0.1); color:var(--btn-neon); border:1px solid rgba(55,255,139,0.3); }
        .action-btns { display:flex; gap:6px; }
        .btn-action { padding:6px 13px; border:none; border-radius:15px; font-family:Montserrat,sans-serif; font-weight:700; font-size:.68rem; cursor:pointer; transition:0.3s; text-transform:uppercase; text-decoration:none; display:inline-block; }
        .btn-view { background:rgba(26,217,240,0.1);  color:var(--cyan);   border:1px solid rgba(26,217,240,0.3); }
        .btn-edit { background:rgba(240,165,0,0.1);   color:var(--orange); border:1px solid rgba(240,165,0,0.3); }
        .btn-void { background:rgba(255,77,109,0.1);  color:var(--red);    border:1px solid rgba(255,77,109,0.3); }
        .btn-action:hover { transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.3); }
        .empty-row td { text-align:center; color:var(--text-dim); padding:60px; font-size:.85rem; }

        /* Footer */
        footer { background:rgba(13,17,23,0.8); padding:40px 5%; border-top:1px solid rgba(255,255,255,0.05); margin-top:60px; }
        .footer-grid { display:flex; justify-content:center; gap:40px; }
        .f-col { display:flex; flex-direction:column; font-size:0.8rem; }
        .f-col a { color:var(--text-dim); padding-bottom:5px; }
        .f-col a:hover { color:var(--btn-neon); }
        .contact-info { color:var(--text-dim); }

        @keyframes blurClear { from { filter:blur(8px); opacity:0; transform:translateY(10px); } to { filter:blur(0); opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <button class="btn-sm">Sign up</button>
            <button class="btn-sm login">Log in</button>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Parking Slots</a></li>
            <li><a href="#">My Vehicles</a></li>
            <li><a href="/tickets" class="active">Tickets</a></li>
            <li><a href="#">Payments</a></li>
        </ul>
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
        <a href="/tickets/new" class="btn-generate-top">+ Generate Ticket</a>
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
                    <th>Actions</th>
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
                    <td>
                        <div class="action-btns">
                            <a href="/tickets/${t.id}" class="btn-action btn-view">View</a>
                            <a href="/tickets/${t.id}/edit" class="btn-action btn-edit">Edit Slot</a>
                            <form action="/tickets/${t.id}/void" method="post" style="display:inline"
                                  onsubmit="return confirm('Void this ticket?')">
                                <button type="submit" class="btn-action btn-void">Void</button>
                            </form>
                        </div>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty tickets}">
                    <tr class="empty-row">
                        <td colspan="7">No active tickets found. Click Generate Ticket to create one.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<footer>
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">My Vehicles</a>
            <a href="#">Parking Slots</a>
            <a href="#">Tickets</a>
            <a href="#">Payments</a>
        </div>
        <div class="footer-grid">
            <div class="f-col">
                <a href="#">Home</a>
                <a href="#">About</a>
                <a href="#">Help</a>
            </div>
            <div class="f-col contact-info">
                <strong>Contact us:</strong>
                <p>ParkCity@gmail.com</p>
                <p>0712345678</p>
            </div>
        </div>
    </div>
</footer>
</body>
</html>