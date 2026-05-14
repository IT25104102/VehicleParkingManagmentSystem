<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MyParking | Register</title>
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
                <button class="btn-sm">Sign up</button>
                <a href="${pageContext.request.contextPath}/login">
                    <button class="btn-sm login">Log in</button>
                </a>
            </div>
        </div>
        <nav class="full-width-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="#">Parking Slots</a></li>
                <li><a href="#">My Vehicles</a></li>
                <li><a href="#">Tickets</a></li>
                <li><a href="#">Payments</a></li>
            </ul>
        </nav>
    </header>

    <div class="auth-page">
        <div class="auth-card auth-card-wide">

            <div class="auth-logo">
                <span class="logo-big">&#10018;</span>
                <h2>MYPARKING</h2>
                <p>Create a Driver Account</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <p class="auth-title">Register as a Driver</p>

            <form action="${pageContext.request.contextPath}/register" method="post">

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name"
                           placeholder="John Silva" required maxlength="100"/>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email"
                           placeholder="you@example.com" required/>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password"
                               placeholder="Min. 6 characters" required minlength="6"
                               autocomplete="new-password"/>
                        <p class="field-hint">At least 6 characters</p>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone"
                               placeholder="07XXXXXXXX" required
                               pattern="[0-9]{10}" maxlength="10"/>
                        <p class="field-hint">10-digit mobile number</p>
                    </div>
                </div>

                <button type="submit" class="btn-form">SIGN UP</button>
            </form>

            <div class="auth-divider"></div>
            <div class="auth-switch">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Sign in here</a>
            </div>

        </div>
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

