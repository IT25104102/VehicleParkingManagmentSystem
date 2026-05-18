<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Slots — MyParking</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-container { padding: 2rem 5%; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin: 0 0 0.3rem; }
        .page-subtitle { color: var(--text-dim); font-size: 0.82rem; margin-bottom: 1.5rem; }

        .manage-layout {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media(max-width:900px){ .manage-layout{ grid-template-columns:1fr; } }

        .card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px;
            overflow: hidden;
        }
        .card-header {
            padding: 14px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--text-main);
        }
        .card-body { padding: 20px; }

        .form-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--cyan);
            margin-bottom: 6px;
        }
        .form-control, .form-select {
            width: 100%;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(26,217,240,0.2);
            border-radius: 8px;
            padding: 10px 14px;
            color: var(--text-main);
            font-family: 'Montserrat', sans-serif;
            font-size: 0.85rem;
            outline: none;
            margin-bottom: 14px;
            transition: 0.2s;
        }
        .form-control:focus, .form-select:focus { border-color: var(--cyan); }
        .form-select option { background: #0a1128; }

        .btn-add {
            width: 100%; padding: 10px;
            background: var(--btn-neon); border: none;
            border-radius: 20px; color: #0a1128;
            font-family: 'Montserrat', sans-serif;
            font-weight: 800; font-size: 0.85rem;
            cursor: pointer; transition: 0.2s;
        }
        .btn-add:hover { box-shadow: 0 0 15px var(--btn-neon); }

        .legend-box {
            margin-top: 20px; padding: 16px 20px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(26,217,240,0.2);
            border-radius: 12px;
            font-size: 0.78rem;
            line-height: 1.9;
            color: var(--text-dim);
        }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            padding: 10px 16px;
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--text-dim);
            border-bottom: 1px solid rgba(255,255,255,0.06);
            text-align: left;
        }
        tbody td {
            padding: 10px 16px;
            font-size: 0.85rem;
            border-bottom: 1px solid rgba(255,255,255,0.04);
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.03); }

        .type-badge {
            font-size: 0.72rem; font-weight: 700;
            padding: 3px 9px; border-radius: 20px;
            background: rgba(26,217,240,0.12);
            color: var(--cyan);
            border: 1px solid rgba(26,217,240,0.3);
            text-transform: uppercase;
        }
        .badge {
            display: inline-block; padding: 3px 10px;
            border-radius: 20px; font-size: 0.7rem; font-weight: 700;
        }
        .badge-available  { background: rgba(55,255,139,0.1);  color: #37ff8b; border: 1px solid rgba(55,255,139,0.3); }
        .badge-occupied   { background: rgba(255,76,76,0.1);   color: #ff4c4c; border: 1px solid rgba(255,76,76,0.3); }
        .badge-pending    { background: rgba(255,215,0,0.1);   color: #ffd700; border: 1px solid rgba(255,215,0,0.3); }
        .badge-pre_reserved { background: rgba(205,133,63,0.1); color: #cd853f; border: 1px solid rgba(205,133,63,0.3); }

        .action-row { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn-toggle {
            padding: 5px 14px; font-size: 0.75rem; font-weight: 700;
            border-radius: 20px; background: transparent;
            border: 1px solid rgba(26,217,240,0.4); color: var(--cyan);
            font-family: 'Montserrat', sans-serif; cursor: pointer; transition: 0.2s;
        }
        .btn-toggle:hover { background: rgba(26,217,240,0.1); }
        .btn-danger-sm {
            padding: 5px 14px; font-size: 0.75rem; font-weight: 700;
            border-radius: 20px; background: transparent;
            border: 1px solid rgba(255,76,76,0.4); color: #ff4c4c;
            font-family: 'Montserrat', sans-serif; cursor: pointer; transition: 0.2s;
        }
        .btn-danger-sm:hover { background: rgba(255,76,76,0.1); }

        .empty-state { padding: 32px; text-align: center; color: var(--text-dim); font-size: 0.85rem; }

        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.7); z-index: 200;
            align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal-box {
            background: #0a1128;
            border: 1px solid rgba(255,76,76,0.4);
            border-radius: 12px; padding: 32px 36px;
            max-width: 400px; width: 90%;
            text-align: center;
        }
        .modal-box h3 { color: #ff4c4c; font-size: 1.1rem; margin-bottom: 10px; }
        .modal-box p  { color: var(--text-dim); font-size: 0.88rem; margin-bottom: 24px; }
        .modal-actions { display: flex; gap: 12px; justify-content: center; }
    </style>
</head>
<body>

<!-- Header -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo">
            <span class="logo-icon">&#10018;</span> MyParking
        </div>
        <div class="header-controls">
            <span class="btn-sm" style="cursor:default;">Admin Panel</span>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="btn-sm login">Log out</button>
            </a>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/price">Pricing</a></li>
            <li><a href="${pageContext.request.contextPath}/slots/manage" class="active">Manage Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">Manage Users</a></li>
        </ul>
    </nav>
</header>

<div class="page-container">

    <div style="margin-bottom:1.5rem;">
        <h1 class="page-title">⚙️ Manage Parking Slots</h1>
        <p class="page-subtitle">Add new slots, toggle availability, or remove unused slots</p>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✅ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">❌ ${errorMsg}</div>
    </c:if>

    <div class="manage-layout">

        <!-- LEFT: Add Slot Form -->
        <div>
            <div class="card">
                <div class="card-header">➕ Add New Slot</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/slots/add">
                        <label class="form-label" for="slotNumber">Slot Number</label>
                        <input type="text" id="slotNumber" name="slotNumber"
                               class="form-control"
                               placeholder="e.g. A1, B3, VIP-01"
                               required maxlength="10"
                               pattern="[A-Za-z0-9\-]+"
                               title="Letters, numbers and hyphens only">

                        <label class="form-label" for="slotType">Vehicle Type</label>
                        <select id="slotType" name="slotType" class="form-select" required>
                            <option value="" disabled selected>Select type…</option>
                            <c:forEach var="type" items="${slotTypes}">
                                <option value="${type}">${type}</option>
                            </c:forEach>
                        </select>

                        <label class="form-label" for="slotDate">Date</label>
                        <input type="date" id="slotDate" name="date"
                               class="form-control"
                               value="${today}"/>

                        <button type="submit" class="btn-add">＋ Add Slot</button>
                    </form>
                </div>
            </div>

            <div class="legend-box">
                <strong style="color:var(--cyan);display:block;margin-bottom:6px;">🔑 Slot Types</strong>
                🏍 BIKE — motorcycles<br>
                🛺 THREE_WHEELER — tuk-tuks<br>
                🚗 CAR — standard cars<br>
                🚐 VAN — vans & SUVs<br>
                ⭐ VIP — premium / reserved bays
            </div>
        </div>

        <!-- RIGHT: Slot Table -->
        <div class="card">
            <div class="card-header">
                📋 All Slots
                <span style="color:var(--text-dim);font-size:0.78rem;font-weight:500;margin-left:10px;">
                    ${slots.size()} total
                </span>
            </div>
            <div class="card-body" style="padding:0;">
                <c:choose>
                    <c:when test="${empty slots}">
                        <div class="empty-state">🅿 No slots yet. Add one using the form on the left.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Slot #</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="slot" items="${slots}">
                                    <tr>
                                        <td><strong>${slot.slotNumber}</strong></td>
                                        <td><span class="type-badge">${slot.slotType}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${slot.status == 'AVAILABLE'}">
                                                    <span class="badge badge-available">Available</span>
                                                </c:when>
                                                <c:when test="${slot.status == 'OCCUPIED'}">
                                                    <span class="badge badge-occupied">Occupied</span>
                                                </c:when>
                                                <c:when test="${slot.status == 'PENDING'}">
                                                    <span class="badge badge-pending">Pending</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-pre_reserved">Pre-Reserved</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="color:var(--text-dim);font-size:0.78rem;">${slot.date}</td>
                                        <td>
                                            <div class="action-row">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/slots/toggle/${slot.id}">
                                                    <input type="hidden" name="from" value="manage">
                                                    <button type="submit" class="btn-toggle">
                                                        <c:choose>
                                                            <c:when test="${slot.status == 'AVAILABLE'}">🔴 Set Occupied</c:when>
                                                            <c:otherwise>🟢 Set Available</c:otherwise>
                                                        </c:choose>
                                                    </button>
                                                </form>
                                                <button class="btn-danger-sm"
                                                        onclick="confirmDelete('${slot.id}','${slot.slotNumber}','${slot.status}')">
                                                    🗑 Delete
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

</div>

<!-- Delete Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <h3>⚠️ Delete Slot?</h3>
        <p id="modalMsg">This action cannot be undone.</p>
        <div class="modal-actions">
            <form id="deleteForm" method="post">
                <button type="submit" class="btn-danger-sm">Yes, Delete</button>
            </form>
            <button class="btn-toggle" onclick="closeModal()">Cancel</button>
        </div>
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

<script>
function confirmDelete(id, number, status) {
    const modal = document.getElementById('deleteModal');
    const form  = document.getElementById('deleteForm');
    const msg   = document.getElementById('modalMsg');
    form.action = '${pageContext.request.contextPath}/slots/delete/' + id;
    if (status !== 'AVAILABLE') {
        msg.innerHTML = '<strong style="color:#ff4c4c">Cannot delete!</strong><br>'
            + 'Slot <strong>' + number + '</strong> is currently <strong>' + status + '</strong>.<br>'
            + 'Only AVAILABLE slots can be removed.';
        form.querySelector('button').disabled = true;
    } else {
        msg.textContent = 'Are you sure you want to remove slot ' + number + '?';
        form.querySelector('button').disabled = false;
    }
    modal.classList.add('open');
}
function closeModal() {
    document.getElementById('deleteModal').classList.remove('open');
}
document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
</script>

</body>
</html>
