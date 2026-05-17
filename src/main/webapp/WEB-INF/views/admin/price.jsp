<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Double currentPrice = (Double) request.getAttribute("currentPrice");
    if (currentPrice == null) currentPrice = 150.0;
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
    <title>MyParking | Pricing</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .page-content { padding: 2rem 5%; max-width: 1400px; margin: 0 auto; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 1.6rem; font-weight: 800; }
        .page-header p { font-size: 0.85rem; color: var(--text-dim); margin-top: 4px; }
        .flash { padding: 12px 16px; border-radius: 10px; font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .flash-success { background: rgba(55,255,139,0.08); border: 1px solid rgba(55,255,139,0.2); color: #37ff8b; }
        .flash-error { background: rgba(255,107,107,0.08); border: 1px solid rgba(255,107,107,0.2); color: #ff6b6b; }
        .content-wrap { max-width: 680px; }
        .current-price-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 24px; margin-bottom: 24px; display: flex; align-items: center; gap: 20px; transition: 0.3s; }
        .current-price-card:hover { border-color: rgba(26,217,240,0.25); }
        .price-icon { width: 56px; height: 56px; background: rgba(55,255,139,0.08); border: 1px solid rgba(55,255,139,0.2); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0; }
        .price-info h3 { font-size: 2rem; font-weight: 800; color: #37ff8b; }
        .price-info p { font-size: 0.8rem; color: var(--text-dim); margin-top: 2px; }
        .form-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 28px; margin-bottom: 24px; transition: 0.3s; }
        .form-card:hover { border-color: rgba(26,217,240,0.25); }
        .form-card h5 { font-size: 0.95rem; font-weight: 700; margin-bottom: 6px; display: flex; align-items: center; gap: 8px; color: #37ff8b; }
        .form-card .subtitle { font-size: 0.8rem; color: var(--text-dim); margin-bottom: 24px; line-height: 1.6; }
        .form-label { font-size: 0.75rem; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase; color: var(--text-dim); margin-bottom: 8px; display: block; }
        .input-wrapper { display: flex; align-items: stretch; }
        .input-prefix { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-right: none; border-radius: 8px 0 0 8px; padding: 0 14px; font-size: 0.9rem; font-weight: 700; color: var(--text-dim); display: flex; align-items: center; }
        .input-suffix { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-left: none; border-radius: 0 8px 8px 0; padding: 0 14px; font-size: 0.85rem; color: var(--text-dim); display: flex; align-items: center; }
        .price-input { flex: 1; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-left: none; border-right: none; color: var(--text-main); font-family: 'Montserrat',sans-serif; font-size: 1.1rem; font-weight: 700; padding: 12px 10px; outline: none; -moz-appearance: textfield; }
        .price-input::-webkit-outer-spin-button, .price-input::-webkit-inner-spin-button { -webkit-appearance: none; }
        .price-input:focus { background: rgba(26,217,240,0.04); border-color: #1ad9f0; }
        .preset-btns { margin-top: 14px; display: flex; gap: 8px; flex-wrap: wrap; }
        .preset-btn { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); color: var(--text-dim); font-family: 'Montserrat',sans-serif; font-size: 0.8rem; padding: 6px 14px; border-radius: 20px; cursor: pointer; transition: 0.3s; font-weight: 600; }
        .preset-btn:hover { background: rgba(55,255,139,0.08); border-color: rgba(55,255,139,0.3); color: #37ff8b; }
        .btn-save { background: #37ff8b; color: #0c1a12; border: none; padding: 12px 28px; border-radius: 20px; font-family: 'Montserrat',sans-serif; font-size: 0.9rem; font-weight: 800; cursor: pointer; transition: 0.3s; margin-top: 20px; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 0 15px rgba(55,255,139,0.3); }
        .info-note { background: rgba(26,217,240,0.06); border: 1px solid rgba(26,217,240,0.15); border-radius: 10px; padding: 14px 16px; font-size: 0.8rem; color: var(--text-dim); line-height: 1.6; }
        .info-note strong { color: #1ad9f0; }
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
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="page-header">
        <h2>Parking Price Settings</h2>
        <p>Update the global hourly parking rate.</p>
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

    <div class="content-wrap">
        <div class="current-price-card">
            <div class="price-icon">&#128176;</div>
            <div class="price-info">
                <h3>Rs.<%= String.format("%.2f", currentPrice) %></h3>
                <p>Current rate per hour · Saved in config.txt</p>
            </div>
        </div>

        <div class="form-card">
            <h5><i class="fas fa-edit"></i> Update Price Per Hour</h5>
            <p class="subtitle">Enter the new hourly rate. This will be saved to config.txt and used by the Payment module.</p>

            <form method="post" action="<%= request.getContextPath() %>/admin/price" id="priceForm">
                <label class="form-label">New Price (Rs. per hour)</label>
                <div class="input-wrapper">
                    <span class="input-prefix">Rs.</span>
                    <input type="number" name="price" id="priceInput"
                           class="price-input" min="1" step="0.01"
                           value="<%= String.format("%.2f", currentPrice) %>" required>
                    <span class="input-suffix">/hour</span>
                </div>
                <div class="preset-btns">
                    <span style="font-size:0.75rem;color:var(--text-dim);align-self:center">Quick set:</span>
                    <button type="button" class="preset-btn" onclick="setPrice(100)">Rs.100</button>
                    <button type="button" class="preset-btn" onclick="setPrice(150)">Rs.150</button>
                    <button type="button" class="preset-btn" onclick="setPrice(200)">Rs.200</button>
                    <button type="button" class="preset-btn" onclick="setPrice(250)">Rs.250</button>
                    <button type="button" class="preset-btn" onclick="setPrice(300)">Rs.300</button>
                </div>
                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Save New Price
                </button>
            </form>
        </div>

        <div class="info-note">
            <strong><i class="fas fa-info-circle"></i> How pricing works:</strong><br>
            When you save a new price, it is written to <strong>config.txt</strong>.
            The Payment module reads this file to calculate parking fees for each ticket.
        </div>
    </div>

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
        </div>
        <div class="f-col contact-info">
            <strong>Contact us:</strong>
            <p>MyParking@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
    <p class="footer-copy">&copy; 2026 MyParking Smart System. All rights reserved.</p>
</footer>

<script>
function setPrice(val) {
    document.getElementById('priceInput').value = val.toFixed(2);
}
document.getElementById('priceForm').addEventListener('submit', function(e) {
    const newVal  = parseFloat(document.getElementById('priceInput').value);
    const current = <%= currentPrice %>;
    if (Math.abs(newVal - current) > 100) {
        const ok = confirm('Large price change from Rs.' + current.toFixed(2) +
            ' to Rs.' + newVal.toFixed(2) + '. Are you sure?');
        if (!ok) e.preventDefault();
    }
});
</script>

</body>
</html>
