<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Payment History</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 1.8rem; font-weight: 800; margin-bottom: 6px; }
        .page-sub { color: var(--text-dim); font-size: 0.85rem; margin-bottom: 30px; }
        .card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 24px; margin-bottom: 20px; }
        .card-title { font-size: 0.75rem; font-weight: 600; color: var(--text-dim); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 16px; }
        table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
        thead tr { border-bottom: 1px solid rgba(26,217,240,0.3); }
        thead th { padding: 12px 10px; color: var(--text-dim); font-weight: 600; text-align: left; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; }
        tbody tr { border-bottom: 1px solid rgba(255,255,255,0.05); transition: 0.2s; }
        tbody tr:hover { background: rgba(255,255,255,0.03); }
        tbody td { padding: 12px 10px; color: var(--text-main); }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 0.7rem; font-weight: 700; }
        .badge-pending   { background: rgba(239,159,39,0.15); color: #EF9F27; border: 1px solid rgba(239,159,39,0.3); }
        .badge-completed { background: rgba(55,255,139,0.12); color: #37ff8b; border: 1px solid rgba(55,255,139,0.3); }
        .action-form { display: inline; }
        .btn-update { background: rgba(26,217,240,0.1); border: 1px solid rgba(26,217,240,0.3); border-radius: 8px; padding: 5px 10px; font-family: 'Montserrat',sans-serif; font-size: 0.75rem; color: #1ad9f0; cursor: pointer; transition: 0.3s; }
        .btn-update:hover { background: rgba(26,217,240,0.2); }
        .btn-delete { background: rgba(220,53,69,0.1); border: 1px solid rgba(220,53,69,0.3); border-radius: 8px; padding: 5px 10px; font-family: 'Montserrat',sans-serif; font-size: 0.75rem; color: #ff6b6b; cursor: pointer; transition: 0.3s; margin-top: 6px; }
        .btn-delete:hover { background: rgba(220,53,69,0.2); }
        select { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; padding: 4px 8px; color: var(--text-main); font-family: 'Montserrat',sans-serif; font-size: 0.75rem; }
        select option { background: #0a1128; }
        .empty-state { text-align: center; padding: 40px; color: var(--text-dim); }
        .empty-state .empty-icon { font-size: 3rem; margin-bottom: 16px; }
    </style>
</head>
<body>

<!-- Header -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <c:choose>
                <c:when test="${userRole == 'ADMIN'}">
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
            <c:when test="${userRole == 'ADMIN'}">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/price">Pricing</a></li>
                    <li><a href="${pageContext.request.contextPath}/slots/manage">Manage Slots</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users">Manage Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/payment/history" class="active">Payments</a></li>
                    <li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
                </ul>
            </c:when>
            <c:otherwise>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/slots">Parking Slots</a></li>
                    <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
                    <li><a href="${pageContext.request.contextPath}/payment/history" class="active">Payments</a></li>
                </ul>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<div class="container">
    <div class="page-title">
        <c:choose>
            <c:when test="${userRole == 'ADMIN'}">All Payments</c:when>
            <c:otherwise>My Payment History</c:otherwise>
        </c:choose>
    </div>
    <div class="page-sub">
        <c:choose>
            <c:when test="${userRole == 'ADMIN'}">View and manage all customer payment records</c:when>
            <c:otherwise>View your parking payment records</c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <div class="card-title">
            <c:choose>
                <c:when test="${userRole == 'ADMIN'}">All Payments</c:when>
                <c:otherwise>My Payments</c:otherwise>
            </c:choose>
        </div>

        <c:choose>
            <c:when test="${empty payments}">
                <div class="empty-state">
                    <div class="empty-icon">&#128184;</div>
                    <p>No payment records found</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Ticket ID</th>
                            <th>Amount</th>
                            <th>Method</th>
                            <th>Status</th>
                            <th>Date</th>
                            <c:if test="${userRole == 'ADMIN'}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="payment" items="${payments}">
                            <tr>
                                <td>${payment.id}</td>
                                <td>${payment.ticketId}</td>
                                <td style="color:#37ff8b;font-weight:700">Rs. ${payment.amount}</td>
                                <td>${payment.method}</td>
                                <td>
                                    <span class="badge ${payment.status == 'COMPLETED' ? 'badge-completed' : 'badge-pending'}">
                                        ${payment.status}
                                    </span>
                                </td>
                                <td>${payment.createdAt}</td>
                                <c:if test="${userRole == 'ADMIN'}">
                                    <td>
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/payment/updateStatus"
                                              class="action-form">
                                            <input type="hidden" name="id" value="${payment.id}"/>
                                            <select name="status">
                                                <option value="PENDING"   ${payment.status=='PENDING'   ?'selected':''}>Pending</option>
                                                <option value="COMPLETED" ${payment.status=='COMPLETED' ?'selected':''}>Completed</option>
                                            </select>
                                            <button type="submit" class="btn-update">Update</button>
                                        </form>
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/payment/delete"
                                              class="action-form" style="margin-top:6px">
                                            <input type="hidden" name="id" value="${payment.id}"/>
                                            <button type="submit" class="btn-delete"
                                                onclick="return confirm('Delete this payment?')">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Role based footer -->
<c:choose>
    <c:when test="${userRole == 'ADMIN'}">
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
    </c:when>
    <c:otherwise>
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
                    <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
                </div>
                <div class="f-col contact-info">
                    <strong>Contact us:</strong>
                    <p>ParkCity@gmail.com</p>
                    <p>0712345678</p>
                </div>
            </div>
            <p class="footer-copy">&copy; 2026 ParkCity Smart System. All rights reserved.</p>
        </footer>
    </c:otherwise>
</c:choose>

</body>
</html>
