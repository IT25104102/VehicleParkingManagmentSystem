<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MyParking | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

    <!-- ── Top header (same as smartparking.html) ── -->
    <header class="main-header">
        <div class="top-bar">
            <div class="logo">
                <span class="logo-icon">&#10018;</span> MyParking
            </div>
            <div class="header-controls">
                <a href="${pageContext.request.contextPath}/profile">
                    <button class="btn-sm">${user.name}</button>
                </a>
                <a href="${pageContext.request.contextPath}/logout">
                    <button class="btn-sm login">Log out</button>
                </a>
            </div>
        </div>
        <nav class="full-width-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home" class="active">Home</a></li>
                <li><a href="#">Parking Slots</a></li>
                <li><a href="#">My Vehicles</a></li>
                <li><a href="#">Tickets</a></li>
                <li><a href="#">Payments</a></li>
                <c:if test="${user.role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/admin/users">Manage Users</a></li>
                </c:if>
            </ul>
        </nav>
    </header>

    <!-- ── Sidebar + main layout ── -->
    <div class="dash-layout">

        <aside class="sidebar">
            <div class="sb-brand">
                <span class="sb-icon">&#10018;</span>
                <h2>MYPARKING</h2>
            </div>
            <nav class="sb-nav">
                <a href="${pageContext.request.contextPath}/home"    class="nav-item active">
                    <i class="nav-icon">&#127968;</i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="nav-item">
                    <i class="nav-icon">&#128100;</i> My Profile
                </a>
                <a href="#" class="nav-item">
                    <i class="nav-icon">&#128663;</i> Parking Slots
                </a>
                <a href="#" class="nav-item">
                    <i class="nav-icon">&#127765;</i> My Vehicles
                </a>
                <a href="#" class="nav-item">
                    <i class="nav-icon">&#127915;</i> Tickets
                </a>
                <a href="#" class="nav-item">
                    <i class="nav-icon">&#128179;</i> Payments
                </a>
                <c:if test="${user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                    <i class="nav-icon">&#128101;</i> Manage Users
                </a>
                </c:if>
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

            <!-- Welcome banner (same card style as feature-card) -->
            <div class="welcome-banner animate-blur staggered-1">
                <div class="wb-avatar">${user.name.charAt(0)}</div>
                <div class="wb-text">
                    <h2>Welcome back, ${user.name}!</h2>
                    <p>MyParking Smart System &nbsp;&middot;&nbsp; ${user.role} &nbsp;&middot;&nbsp; ID: ${user.id}</p>
                </div>
            </div>

            <!-- Stats row -->
            <div class="stats-grid animate-blur staggered-2">
                <div class="stat-card">
                    <div class="stat-lbl">Account ID</div>
                    <div class="stat-val" style="font-size:1.1rem;">${user.id}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-lbl">Role</div>
                    <div class="stat-val" style="font-size:1.1rem;">${user.role}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-lbl">Member Since</div>
                    <div class="stat-val" style="font-size:1rem;">${user.createdAt}</div>
                </div>
            </div>

            <!-- Quick actions (same feature-card grid style) -->
            <p style="font-size:0.8rem;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-dim);margin-bottom:1rem;">
                Quick Actions
            </p>
            <div class="quick-grid animate-blur staggered-3">
                <a href="${pageContext.request.contextPath}/profile" class="quick-card">
                    <div class="qc-icon">&#128100;</div>
                    <div>
                        <div class="qc-title">My Profile</div>
                        <div class="qc-desc">View and edit your personal details</div>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="quick-card">
                    <div class="qc-icon">&#128274;</div>
                    <div>
                        <div class="qc-title">Security</div>
                        <div class="qc-desc">Update password and contact number</div>
                    </div>
                </a>
                <a href="#" class="quick-card">
                    <div class="qc-icon">&#128663;</div>
                    <div>
                        <div class="qc-title">Find Parking</div>
                        <div class="qc-desc">Browse and book available slots</div>
                    </div>
                </a>
                <a href="#" class="quick-card">
                    <div class="qc-icon">&#128179;</div>
                    <div>
                        <div class="qc-title">Payments</div>
                        <div class="qc-desc">View billing history and receipts</div>
                    </div>
                </a>
                <c:if test="${user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/users" class="quick-card">
                    <div class="qc-icon">&#128101;</div>
                    <div>
                        <div class="qc-title">Manage Users</div>
                        <div class="qc-desc">View and delete driver accounts</div>
                    </div>
                </a>
                </c:if>
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
