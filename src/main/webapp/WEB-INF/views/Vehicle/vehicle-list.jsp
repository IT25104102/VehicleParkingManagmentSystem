<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Vehicle Registry</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-deep: #0a1128;
            --text-main: #f0f6fc;
            --text-dim: #b8c7e0;
            --btn-neon: #37ff8b;
            --icon-glow: rgba(26, 217, 240, 0.4);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Montserrat', sans-serif;
            color: var(--text-main);
            background: radial-gradient(at top left, #1e3a8a 0%, #0a1128 50%),
            radial-gradient(at bottom right, #0d1117 0%, #010409 60%);
            background-attachment: fixed;
            min-height: 100vh;
        }
        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* ── Header ── */
        .main-header { width: 100%; position: sticky; top: 0; z-index: 1000; }
        .top-bar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 5%;
            background: rgba(10, 17, 40, 0.85);
            backdrop-filter: blur(10px);
        }
        .logo { font-weight: 800; font-size: 1.15rem; color: var(--text-main); }
        .logo span { color: var(--btn-neon); }
        .header-controls { display: flex; gap: 10px; }
        .btn-sm {
            padding: 5px 18px; font-size: 0.7rem; font-weight: 700;
            border-radius: 15px; background: transparent;
            border: 1px solid var(--btn-neon); color: var(--btn-neon); cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-sm:hover { background: var(--btn-neon); color: #0c1a12; }

        .full-width-nav {
            width: 100%; background: #0d1117;
            border-bottom: 2px solid #1ad9f0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        .full-width-nav ul {
            display: flex; justify-content: center;
            list-style: none; padding: 12px 0; margin: 0; gap: 0;
        }
        .full-width-nav li a {
            text-transform: uppercase; font-size: 0.8rem;
            font-weight: 600; padding: 0 20px; color: var(--text-dim);
        }
        .full-width-nav li a:hover,
        .full-width-nav li a.active { color: var(--btn-neon); text-shadow: 0 0 10px var(--btn-neon); }

        /* ── Page Content ── */
        .page-content { padding: 50px 5%; max-width: 1400px; margin: 0 auto; }

        .page-title { font-size: 2.5rem; font-weight: 800; margin-bottom: 0.3rem; }
        .page-title span { color: var(--btn-neon); }
        .page-subtitle { color: var(--text-dim); font-size: 0.9rem; margin-bottom: 2rem; }

        /* ── Stats Card ── */
        .stats-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        .stats-number { font-size: 3rem; font-weight: 800; color: var(--btn-neon); line-height: 1; }
        .stats-label {
            font-size: 0.7rem; color: var(--text-dim);
            letter-spacing: 2px; text-transform: uppercase; margin-top: 0.5rem;
        }

        /* ── Search Box ── */
        .search-box {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex; gap: 1rem; align-items: center;
        }
        .search-input {
            background: rgba(10,17,40,0.8);
            border: 1px solid rgba(26,217,240,0.2);
            color: white; padding: 0.5rem 1rem;
            border-radius: 8px; flex: 1; font-size: 0.85rem;
            font-family: 'Montserrat', sans-serif;
        }
        .search-input:focus { outline: none; border-color: var(--btn-neon); }
        .search-input::placeholder { color: #555; }
        .btn-search-go {
            background: var(--btn-neon); border: none; color: #000;
            padding: 0.5rem 1.5rem; border-radius: 8px;
            font-weight: 700; font-size: 0.8rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-search-go:hover { box-shadow: 0 0 15px var(--btn-neon); }
        .btn-clear {
            background: transparent; border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-dim); padding: 0.5rem 1.2rem;
            border-radius: 8px; font-size: 0.8rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-clear:hover { border-color: #1ad9f0; color: white; }

        /* ── Section Header ── */
        .section-header {
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 1rem;
        }
        .section-title {
            font-size: 0.7rem; letter-spacing: 2px;
            text-transform: uppercase; color: var(--text-dim); font-weight: 600;
        }
        .btn-add {
            background: var(--btn-neon); border: none; color: #000;
            padding: 0.5rem 1.5rem; border-radius: 20px;
            font-weight: 700; font-size: 0.8rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-add:hover { box-shadow: 0 0 15px var(--btn-neon); color: #000; }

        /* ── Table ── */
        .table-wrapper {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; overflow: hidden;
        }
        .custom-table { width: 100%; border-collapse: collapse; }
        .custom-table thead tr {
            background: rgba(13,17,23,0.8);
            border-bottom: 1px solid rgba(26,217,240,0.2);
        }
        .custom-table thead th {
            padding: 1rem 1.2rem; font-size: 0.7rem;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--text-dim); font-weight: 600;
        }
        .custom-table tbody tr {
            border-bottom: 1px solid rgba(255,255,255,0.04);
            transition: background 0.2s;
        }
        .custom-table tbody tr:hover { background: rgba(255,255,255,0.04); }
        .custom-table tbody td {
            padding: 1rem 1.2rem; font-size: 0.85rem;
            color: var(--text-dim); vertical-align: middle;
        }

        /* ── Plate Badge ── */
        .plate-badge {
            border: 1.5px solid var(--btn-neon); color: var(--btn-neon);
            padding: 3px 12px; border-radius: 20px;
            font-size: 0.78rem; font-weight: 700; letter-spacing: 1px;
        }

        /* ── Type Badge ── */
        .type-badge {
            background: rgba(255,255,255,0.06); color: var(--text-dim);
            padding: 3px 12px; border-radius: 6px; font-size: 0.78rem;
        }

        /* ── Status Badge ── */
        .badge-auth {
            color: var(--btn-neon); font-size: 0.78rem; font-weight: 600;
        }
        .badge-unauth { color: #ff4d4d; font-size: 0.78rem; font-weight: 600; }

        /* ── Action Buttons ── */
        .btn-edit {
            background: transparent; border: 1px solid #f59e0b;
            color: #f59e0b; padding: 4px 14px; border-radius: 6px;
            font-size: 0.78rem; font-weight: 600; margin-right: 4px;
            font-family: 'Montserrat', sans-serif; cursor: pointer;
        }
        .btn-edit:hover { background: #f59e0b; color: #000; }
        .btn-remove {
            background: #dc2626; border: none; color: white;
            padding: 4px 14px; border-radius: 6px;
            font-size: 0.78rem; font-weight: 600;
            font-family: 'Montserrat', sans-serif; cursor: pointer;
        }
        .btn-remove:hover { background: #b91c1c; box-shadow: 0 0 10px rgba(220,38,38,0.5); }

        .empty-msg { text-align: center; color: #555; padding: 3rem; font-size: 0.9rem; }

        /* ── Footer ── */
        footer {
            background: rgba(13,17,23,0.8); padding: 40px 5%;
            border-top: 1px solid rgba(255,255,255,0.05); margin-top: 4rem;
        }
        .footer-grid { display: flex; justify-content: center; gap: 40px; }
        .f-col { display: flex; flex-direction: column; font-size: 0.8rem; }
        .f-col a { color: var(--text-dim); padding-bottom: 5px; }
        .f-col a:hover { color: var(--btn-neon); }
        .contact-info { color: var(--text-dim); }
        .contact-info p { margin: 3px 0; }
    </style>
</head>
<body>

<!-- ── Header ── -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <button class="btn-sm">Sign up</button>
            <button class="btn-sm">Log in</button>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/?action=list" class="active">My Vehicles</a></li>
            <li><a href="#">Tickets</a></li>
            <li><a href="#">Payments</a></li>
        </ul>
    </nav>
</header>

<!-- ── Page Content ── -->
<div class="page-content">

    <div class="page-title">Vehicle <span>Registry</span></div>
    <div class="page-subtitle">Manage all registered vehicles in the ParkCity system</div>

    <!-- Stats -->
    <div class="stats-card">
        <div class="stats-number">${vehicles.size()}</div>
        <div class="stats-label">Total Vehicles</div>
    </div>

    <!-- Search -->
    <form method="get" action="${pageContext.request.contextPath}/vehicle/" class="search-box">
        <input type="hidden" name="action" value="list">
        <input type="text" name="search" class="search-input"
               placeholder="Search by license plate or owner name..."
               value="${search}">
        <button type="submit" class="btn-search-go">🔍 Search</button>
        <a href="${pageContext.request.contextPath}/vehicle/?action=list" class="btn-clear">Clear</a>
    </form>

    <!-- Table -->
    <div class="section-header">
        <div class="section-title">Registered Vehicles</div>
        <a href="${pageContext.request.contextPath}/vehicle/?action=add" class="btn-add">+ Add Vehicle</a>
    </div>

    <div class="table-wrapper">
        <table class="custom-table">
            <thead>
            <tr>
                <th>Plate Number</th>
                <th>Vehicle ID</th>
                <th>Owner Name</th>
                <th>Type</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${vehicles}">
                <tr>
                    <td><span class="plate-badge">${v.licensePlate}</span></td>
                    <td>${v.vehicleId}</td>
                    <td>${v.ownerName}</td>
                    <td><span class="type-badge">${v.vehicleType}</span></td>
                    <td>${v.contactNumber}</td>
                    <td>
                        <c:choose>
                            <c:when test="${v.status == 'Authorized'}">
                                <span class="badge-auth">✓ Authorized</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-unauth">✕ Unauthorized</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/vehicle/?action=edit&id=${v.vehicleId}"
                           class="btn-edit">✏️ Edit</a>
                        <a href="${pageContext.request.contextPath}/vehicle/?action=delete&id=${v.vehicleId}"
                           class="btn-remove"
                           onclick="return confirm('Remove ${v.licensePlate}?')">🗑 Remove</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty vehicles}">
                <tr>
                    <td colspan="7" class="empty-msg">No vehicles registered yet.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- ── Footer ── -->
<footer>
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">My Vehicles</a>
            <a href="#">Parking Slots</a>
            <a href="#">Tickets</a>
            <a href="#">Payments</a>
        </div>
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
</footer>

</body>
</html>