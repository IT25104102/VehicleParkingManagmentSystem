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
                <button class="btn-sm">${user.name}</button>
                <a href="${pageContext.request.contextPath}/logout">
                    <button class="btn-sm login">Log out</button>
                </a>
            </div>
        </div>
        <nav class="full-width-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="#">Parking Slots</a></li>
                <li><a href="#">My Vehicles</a></li>
                <li><a href="#">Tickets</a></li>
                <li><a href="#">Payments</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users" class="active">Manage Users</a></li>
            </ul>
        </nav>
    </header>

    <div class="dash-layout">

        <aside class="sidebar">
            <div class="sb-brand">
                <span class="sb-icon">&#10018;</span>
                <h2>MYPARKING</h2>
            </div>
            <nav class="sb-nav">
                <a href="${pageContext.request.contextPath}/home"    class="nav-item">
                    <i class="nav-icon">&#127968;</i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="nav-item">
                    <i class="nav-icon">&#128100;</i> My Profile
                </a>
                <a href="#" class="nav-item"><i class="nav-icon">&#128663;</i> Parking Slots</a>
                <a href="#" class="nav-item"><i class="nav-icon">&#127765;</i> My Vehicles</a>
                <a href="#" class="nav-item"><i class="nav-icon">&#127915;</i> Tickets</a>
                <a href="#" class="nav-item"><i class="nav-icon">&#128179;</i> Payments</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active">
                    <i class="nav-icon">&#128101;</i> Manage Users
                </a>
            </nav>
            <div class="sb-footer">
                <div class="user-mini">
                    <div class="u-avatar">${user.name.charAt(0)}</div>
                    <div>
                        <div class="u-name">${user.name}</div>
                        <div class="u-role">${user.role}</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Log out</a>
            </div>
        </aside>

        <main class="dash-main">

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
    </div>

    <footer class="layered-footer">
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
                <p>MyParking@gmail.com</p>
                <p>0712345678</p>
            </div>
        </div>
        <p class="footer-copy">&copy; 2026 MyParking Smart System. All rights reserved.</p>
    </footer>

</body>
</html>
