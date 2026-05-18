<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyParking | Vehicle Registry</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-content { padding: 50px 5%; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 2.5rem; font-weight: 800; margin-bottom: 0.3rem; }
        .page-title span { color: var(--btn-neon); }
        .page-subtitle { color: var(--text-dim); font-size: 0.9rem; margin-bottom: 2rem; }
        .stats-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 2rem;
            text-align: center; margin-bottom: 2rem;
        }
        .stats-number { font-size: 3rem; font-weight: 800; color: var(--btn-neon); line-height: 1; }
        .stats-label { font-size: 0.7rem; color: var(--text-dim); letter-spacing: 2px; text-transform: uppercase; margin-top: 0.5rem; }
        .search-box {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 1rem 1.5rem;
            margin-bottom: 1.5rem; display: flex; gap: 1rem; align-items: center;
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
        .btn-clear {
            background: transparent; border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-dim); padding: 0.5rem 1.2rem;
            border-radius: 8px; font-size: 0.8rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .section-title { font-size: 0.7rem; letter-spacing: 2px; text-transform: uppercase; color: var(--text-dim); font-weight: 600; }
        .btn-add {
            background: var(--btn-neon); border: none; color: #000;
            padding: 0.5rem 1.5rem; border-radius: 20px;
            font-weight: 700; font-size: 0.8rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif; text-decoration: none;
        }
        .table-wrapper { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; overflow: hidden; }
        .custom-table { width: 100%; border-collapse: collapse; }
        .custom-table thead tr { background: rgba(13,17,23,0.8); border-bottom: 1px solid rgba(26,217,240,0.2); }
        .custom-table thead th { padding: 1rem 1.2rem; font-size: 0.7rem; letter-spacing: 1.5px; text-transform: uppercase; color: var(--text-dim); font-weight: 600; }
        .custom-table tbody tr { border-bottom: 1px solid rgba(255,255,255,0.04); transition: background 0.2s; }
        .custom-table tbody tr:hover { background: rgba(255,255,255,0.04); }
        .custom-table tbody td { padding: 1rem 1.2rem; font-size: 0.85rem; color: var(--text-dim); vertical-align: middle; }
        .plate-badge { border: 1.5px solid var(--btn-neon); color: var(--btn-neon); padding: 3px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
        .type-badge { background: rgba(255,255,255,0.06); color: var(--text-dim); padding: 3px 12px; border-radius: 6px; font-size: 0.78rem; }
        .badge-auth { color: var(--btn-neon); font-size: 0.78rem; font-weight: 600; }
        .badge-unauth { color: #ff4d4d; font-size: 0.78rem; font-weight: 600; }
        .btn-edit { background: transparent; border: 1px solid #f59e0b; color: #f59e0b; padding: 4px 14px; border-radius: 6px; font-size: 0.78rem; font-weight: 600; margin-right: 4px; font-family: 'Montserrat', sans-serif; cursor: pointer; text-decoration: none; }
        .btn-remove { background: #dc2626; border: none; color: white; padding: 4px 14px; border-radius: 6px; font-size: 0.78rem; font-weight: 600; font-family: 'Montserrat', sans-serif; cursor: pointer; text-decoration: none; }
        .empty-msg { text-align: center; color: #555; padding: 3rem; font-size: 0.9rem; }
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
            <li><a href="${pageContext.request.contextPath}/vehicle/list" class="active">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="page-title">Vehicle <span>Registry</span></div>
    <div class="page-subtitle">Manage all registered vehicles in the MyParking system</div>

    <div class="stats-card">
        <div class="stats-number">${vehicles.size()}</div>
        <div class="stats-label">Total Vehicles</div>
    </div>

    <!-- Search -->
    <form method="get" action="${pageContext.request.contextPath}/vehicle/search" class="search-box">
        <input type="text" name="query" class="search-input"
               placeholder="Search by license plate or owner name..."
               value="${param.query}">
        <button type="submit" class="btn-search-go">🔍 Search</button>
        <a href="${pageContext.request.contextPath}/vehicle/list" class="btn-clear">Clear</a>
    </form>

    <div class="section-header">
        <div class="section-title">Registered Vehicles</div>
        <a href="${pageContext.request.contextPath}/vehicle/add" class="btn-add">+ Add Vehicle</a>
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
                            <a href="${pageContext.request.contextPath}/vehicle/update?id=${v.vehicleId}" class="btn-edit">✏️ Edit</a>
                            <form action="${pageContext.request.contextPath}/vehicle/delete" method="post" style="display:inline;" onsubmit="return confirm('Remove ${v.licensePlate}?')">
                                <input type="hidden" name="id" value="${v.vehicleId}"/>
                                <button type="submit" class="btn-remove">🗑 Remove</button>
                            </form>
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

<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a>
            <a href="${pageContext.request.contextPath}/slots">Parking Slots</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
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
