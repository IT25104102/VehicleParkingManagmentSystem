<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Double bikeRate         = (Double) request.getAttribute("bikeRate");
    Double threeWheelerRate = (Double) request.getAttribute("threeWheelerRate");
    Double carRate          = (Double) request.getAttribute("carRate");
    Double vanRate          = (Double) request.getAttribute("vanRate");
    Double vipRate          = (Double) request.getAttribute("vipRate");

    if (bikeRate == null)         bikeRate = 200.0;
    if (threeWheelerRate == null) threeWheelerRate = 250.0;
    if (carRate == null)          carRate = 350.0;
    if (vanRate == null)          vanRate = 550.0;
    if (vipRate == null)          vipRate = 800.0;

    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg   = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Pricing</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .page-content { padding: 2rem 5%; max-width: 1000px; margin: 0 auto; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 1.6rem; font-weight: 800; }
        .page-header p { font-size: 0.85rem; color: var(--text-dim); margin-top: 4px; }
        .flash { padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .flash-success { background: rgba(55,255,139,0.08); border: 1px solid rgba(55,255,139,0.2); color: #37ff8b; }
        .flash-error { background: rgba(255,107,107,0.08); border: 1px solid rgba(255,107,107,0.2); color: #ff6b6b; }
        .rate-chart { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; padding: 28px; margin-bottom: 24px; }
        .rate-chart-title { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.12em; color: var(--text-dim); margin-bottom: 20px; }
        .rate-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 8px; }
        .rate-item { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 1.2rem; text-align: center; transition: 0.2s; }
        .rate-item:hover { border-color: rgba(26,217,240,0.3); }
        .rate-type { font-size: 0.78rem; color: var(--text-dim); margin-bottom: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.08em; }
        .rate-input-wrap { display: flex; align-items: center; justify-content: center; gap: 4px; }
        .rate-prefix { font-size: 0.85rem; color: var(--btn-neon); font-weight: 700; }
        .rate-input {
            width: 80px; background: rgba(255,255,255,0.06);
            border: 1px solid rgba(55,255,139,0.3); border-radius: 8px;
            padding: 6px 8px; color: var(--btn-neon);
            font-family: 'Montserrat', sans-serif; font-size: 1.1rem;
            font-weight: 800; text-align: center; outline: none; transition: 0.2s;
            -moz-appearance: textfield;
        }
        .rate-input::-webkit-outer-spin-button,
        .rate-input::-webkit-inner-spin-button { -webkit-appearance: none; }
        .rate-input:focus { border-color: var(--btn-neon); box-shadow: 0 0 8px rgba(55,255,139,0.2); }
        .rate-suffix { font-size: 0.75rem; color: var(--text-dim); font-weight: 600; }
        .info-note { background: rgba(26,217,240,0.06); border: 1px solid rgba(26,217,240,0.15); border-radius: 10px; padding: 14px 16px; font-size: 0.8rem; color: var(--text-dim); line-height: 1.6; margin-bottom: 20px; }
        .info-note strong { color: #1ad9f0; }
        .btn-save { background: var(--btn-neon); color: #0c1a12; border: none; padding: 12px 40px; border-radius: 20px; font-family: 'Montserrat', sans-serif; font-size: 0.9rem; font-weight: 800; cursor: pointer; transition: 0.3s; display: block; margin: 0 auto; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 0 15px rgba(55,255,139,0.3); }
        @media(max-width:700px) { .rate-grid { grid-template-columns: repeat(2,1fr); } }
    </style>
</head>
<body>

<!-- Header -->
<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <span class="btn-sm" style="cursor:default;">Admin Panel</span>
            <a href="<%= request.getContextPath() %>/logout">
                <button class="btn-sm login">Log out</button>
            </a>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/reports">Reports</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/price" class="active">Pricing</a></li>
            <li><a href="<%= request.getContextPath() %>/slots/manage">Manage Slots</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/users">Manage Users</a></li>
            <li><a href="<%= request.getContextPath() %>/payment/history">Payments</a></li>
            <li><a href="<%= request.getContextPath() %>/tickets">Tickets</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="page-header">
        <h2>Parking Price Settings</h2>
        <p>Update the hourly parking rates for each vehicle type.</p>
    </div>

    <% if (successMsg != null) { %>
        <div class="flash flash-success">
            <i class="fas fa-check-circle"></i> <%= successMsg %>
        </div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="flash flash-error">
            <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
        </div>
    <% } %>

    <div class="info-note">
        <strong><i class="fas fa-info-circle"></i> How pricing works:</strong><br>
        Edit any rate below and click <strong>Save All Rates</strong>.
        These rates are used in the ticket form to calculate the total parking fee.
    </div>

    <form method="post" action="<%= request.getContextPath() %>/admin/price">

        <div class="rate-chart">
            <div class="rate-chart-title">Rate Chart — Edit & Save</div>
            <div class="rate-grid">

                <div class="rate-item">
                    <div class="rate-type">🏍 Bike</div>
                    <div class="rate-input-wrap">
                        <span class="rate-prefix">Rs.</span>
                        <input type="number" name="bikerate" class="rate-input"
                               value="<%= bikeRate.intValue() %>"
                               min="1" step="1" required/>
                        <span class="rate-suffix">/hr</span>
                    </div>
                </div>

                <div class="rate-item">
                    <div class="rate-type">🛺 Three Wheeler</div>
                    <div class="rate-input-wrap">
                        <span class="rate-prefix">Rs.</span>
                        <input type="number" name="threewheelerrate" class="rate-input"
                               value="<%= threeWheelerRate.intValue() %>"
                               min="1" step="1" required/>
                        <span class="rate-suffix">/hr</span>
                    </div>
                </div>

                <div class="rate-item">
                    <div class="rate-type">🚗 Car</div>
                    <div class="rate-input-wrap">
                        <span class="rate-prefix">Rs.</span>
                        <input type="number" name="carrate" class="rate-input"
                               value="<%= carRate.intValue() %>"
                               min="1" step="1" required/>
                        <span class="rate-suffix">/hr</span>
                    </div>
                </div>

                <div class="rate-item">
                    <div class="rate-type">🚐 Van</div>
                    <div class="rate-input-wrap">
                        <span class="rate-prefix">Rs.</span>
                        <input type="number" name="vanrate" class="rate-input"
                               value="<%= vanRate.intValue() %>"
                               min="1" step="1" required/>
                        <span class="rate-suffix">/hr</span>
                    </div>
                </div>

                <div class="rate-item">
                    <div class="rate-type">⭐ VIP Vehicle</div>
                    <div class="rate-input-wrap">
                        <span class="rate-prefix">Rs.</span>
                        <input type="number" name="viprate" class="rate-input"
                               value="<%= vipRate.intValue() %>"
                               min="1" step="1" required/>
                        <span class="rate-suffix">/hr</span>
                    </div>
                </div>

            </div>
        </div>

        <button type="submit" class="btn-save">
            <i class="fas fa-save"></i> Save All Rates
        </button>

    </form>

</div>

<!-- Footer -->
<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/reports">Reports</a>
            <a href="<%= request.getContextPath() %>/admin/price">Pricing</a>
        </div>
        <div class="f-col">
            <a href="<%= request.getContextPath() %>/slots/manage">Manage Slots</a>
            <a href="<%= request.getContextPath() %>/admin/users">Manage Users</a>
            <a href="<%= request.getContextPath() %>/payment/history">Payments</a>
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
