<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>ParkCity | Sign In</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

    <!-- Header — no nav on login page -->
    <header class="main-header">
        <div class="top-bar">
            <div class="logo">
                <span class="logo-icon">&#10018;</span> ParkCity
            </div>
            <div class="header-controls">
                <a href="${pageContext.request.contextPath}/register">
                    <button class="btn-sm">Sign up</button>
                </a>
                <button class="btn-sm login">Log in</button>
            </div>
        </div>
    </header>

    <!-- Auth card -->
    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-logo">
                <span class="logo-big">&#10018;</span>
                <h2>ParkCity</h2>
                <p>Smart Parking System</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <p class="auth-title">Sign In to Your Account</p>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email"
                           placeholder="you@example.com" required autocomplete="email"/>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="••••••••" required autocomplete="current-password"/>
                </div>
                <button type="submit" class="btn-form">LOG IN</button>
            </form>

            <div class="auth-divider"></div>
            <div class="auth-switch">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Register here</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="layered-footer">
        <div class="footer-grid">
            <div class="f-col">
                <a href="#">Home</a>
                <a href="#">About</a>
                <a href="#">Help</a>
            </div>
            <div class="f-col">
                <a href="${pageContext.request.contextPath}/register">Register</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
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
