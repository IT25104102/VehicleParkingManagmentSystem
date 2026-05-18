<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MyParking | Manage Users</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

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
            <li><a href="${pageContext.request.contextPath}/slots/manage">Manage Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="active">Manage Users</a></li>
        </ul>
    </nav>
</header>

<main style="padding: 2rem 5%; max-width: 1400px; margin: 0 auto;">

    <div class="page-hdr">
        <h1>Manage Users</h1>
        <p>View and remove unauthorised driver accounts</p>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">&#10004; ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">&#9888; ${error}</div>
    </c:if>

    <div class="admin-wrap animate-blur staggered-1">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Created</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty users}">
                        <tr>
                            <td colspan="7" style="text-align:center;color:var(--text-dim);padding:2rem;">
                                No users found.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.name}</td>
                                <td>${u.email}</td>
                                <td>${u.phone}</td>
                                <td>
                                    <span class="role-badge role-${u.role}">${u.role}</span>
                                </td>
                                <td>${u.createdAt}</td>
                                <td>
                                    <c:if test="${u.id != user.id}">
                                        <form action="${pageContext.request.contextPath}/admin/delete"
                                              method="post" style="margin:0;"
                                              onsubmit="return confirm('Delete ${u.name}?')">
                                            <input type="hidden" name="userId" value="${u.id}"/>
                                            <button type="submit" class="btn-danger"
                                                    style="padding:4px 16px;font-size:0.72rem;">
                                                Delete
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${u.id == user.id}">
                                        <span style="color:var(--text-dim);font-size:0.74rem;">You</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</main>

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
