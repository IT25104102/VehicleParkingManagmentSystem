<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Slots — Smart Parking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parking.css">
    <style>
        /* Layout: form left, table right on large screens */
        .manage-layout {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media(max-width:900px){ .manage-layout{ grid-template-columns:1fr; } }

        .type-badge {
            font-size:0.72rem; font-weight:700;
            padding:3px 9px; border-radius:20px;
            background:rgba(26,217,240,0.12);
            color:var(--cyan); border:1px solid var(--cyan);
            letter-spacing:0.05em; text-transform:uppercase;
        }
        .action-row { display:flex; gap:8px; flex-wrap:wrap; }

        /* confirm modal */
        .modal-overlay {
            display:none; position:fixed; inset:0;
            background:rgba(0,0,0,0.7); z-index:200;
            align-items:center; justify-content:center;
        }
        .modal-overlay.open { display:flex; }
        .modal-box {
            background:var(--bg-card);
            border:1px solid var(--red);
            border-radius:12px;
            padding:32px 36px;
            max-width:400px; width:90%;
            text-align:center;
            box-shadow:0 0 30px rgba(255,76,76,0.25);
        }
        .modal-box h3 { color:var(--red); font-size:1.1rem; margin-bottom:10px; }
        .modal-box p  { color:var(--text-muted); font-size:0.88rem; margin-bottom:24px; }
        .modal-actions { display:flex; gap:12px; justify-content:center; }
    </style>
</head>
<body>

<!-- ═══ Navbar ═══════════════════════════════════════════════════════════ -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo">
            ✦ MyParking
        </div>
        <div class="header-controls">
            <button class="btn-sm">Sign up</button>
            <button class="btn-sm login">Log in</button>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/slots" class="active">Parking Slots</a></li>
            <li><a href="#">My Vehicles</a></li>
            <li><a href="#">Tickets</a></li>
            <li><a href="#">Payments</a></li>
        </ul>
    </nav>
</header>

<!-- ═══ Page ══════════════════════════════════════════════════════════════ -->
<div class="page-container">

    <div class="page-header">
        <h1 class="page-title">⚙️ Manage Parking Slots</h1>
        <p class="page-subtitle">Add new slots, toggle availability, or remove unused slots</p>
    </div>

    <!-- Flash alerts -->
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✅ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">❌ ${errorMsg}</div>
    </c:if>

    <div class="manage-layout">

        <!-- ── LEFT: Add Slot Form (CREATE) ──────────────────────────────── -->
        <div>
            <div class="card">
                <div class="card-header">➕ Add New Slot</div>
                <div class="card-body">
                    <form method="post"
                          action="${pageContext.request.contextPath}/slots/add">

                        <div class="form-group">
                            <label class="form-label" for="slotNumber">Slot Number</label>
                            <input  type="text"
                                    id="slotNumber"
                                    name="slotNumber"
                                    class="form-control"
                                    placeholder="e.g. A1, B3, VIP-01"
                                    required
                                    maxlength="10"
                                    pattern="[A-Za-z0-9\-]+"
                                    title="Letters, numbers and hyphens only">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="slotType">Vehicle Type</label>
                            <select id="slotType" name="slotType" class="form-select" required>
                                <option value="" disabled selected>Select type…</option>
                                <c:forEach var="type" items="${slotTypes}">
                                    <option value="${type}">${type}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">
                            ＋ Add Slot
                        </button>
                    </form>
                </div>
            </div>

            <!-- Quick legend -->
            <div style="margin-top:20px;padding:16px 20px;background:var(--bg-card);
                        border:1px solid rgba(26,217,240,0.25);border-radius:var(--radius);
                        font-size:0.78rem;line-height:1.9;color:var(--text-muted);">
                <strong style="color:var(--cyan);display:block;margin-bottom:6px;">
                    🔑 Slot Types
                </strong>
                🏍 BIKE — motorcycles<br>
                🛺 THREE_WHEELER — tuk-tuks<br>
                🚗 CAR — standard cars<br>
                🚐 VAN — vans & SUVs<br>
                ⭐ VIP — premium / reserved bays
            </div>
        </div>

        <!-- ── RIGHT: Slot Table (READ + UPDATE + DELETE) ─────────────────── -->
        <div class="card">
            <div class="card-header">
                📋 All Slots
                <span style="color:var(--text-muted);font-size:0.78rem;font-weight:500;margin-left:10px;">
                    ${slots.size()} total
                </span>
            </div>
            <div class="card-body" style="padding:0;">
                <c:choose>
                    <c:when test="${empty slots}">
                        <div class="empty-state">
                            <div class="empty-icon">🅿</div>
                            <p>No slots yet. Add one using the form on the left.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Slot #</th>
                                    <th>Type</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="slot" items="${slots}">
                                <tr>
                                    <td><strong>${slot.slotNumber}</strong></td>

                                    <td>
                                        <span class="type-badge">
                                            ${slot.typeIcon} ${slot.slotType}
                                        </span>
                                    </td>

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

                                    <td style="color:var(--text-muted);font-size:0.78rem;">
                                        ${slot.createdAt}
                                    </td>

                                    <td>
                                        <div class="action-row">

                                            <%-- UPDATE: toggle Available ↔ Occupied --%>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/slots/toggle/${slot.id}">
                                                <input type="hidden" name="from" value="manage">
                                                <button type="submit" class="btn btn-toggle btn-sm">
                                                    <c:choose>
                                                        <c:when test="${slot.status == 'AVAILABLE'}">🔴 Set Occupied</c:when>
                                                        <c:otherwise>🟢 Set Available</c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </form>

                                            <%-- DELETE: only safe for AVAILABLE --%>
                                            <button class="btn btn-danger btn-sm"
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

    </div><!-- /manage-layout -->

</div><!-- /page-container -->

<!-- ═══ Delete Confirmation Modal ════════════════════════════════════════ -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <h3>⚠️ Delete Slot?</h3>
        <p id="modalMsg">This action cannot be undone.</p>
        <div class="modal-actions">
            <form id="deleteForm" method="post">
                <button type="submit" class="btn btn-danger">Yes, Delete</button>
            </form>
            <button class="btn btn-toggle" onclick="closeModal()">Cancel</button>
        </div>
    </div>
</div>

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
        msg.textContent = 'Are you sure you want to remove slot ' + number + '? This cannot be undone.';
        form.querySelector('button').disabled = false;
    }
    modal.classList.add('open');
}

function closeModal() {
    document.getElementById('deleteModal').classList.remove('open');
}

// Close on backdrop click
document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
</script>
<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/slots">Parking Slots</a>
            <a href="#">My Vehicles</a>
            <a href="#">Tickets</a>
            <a href="#">Payments</a>
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
