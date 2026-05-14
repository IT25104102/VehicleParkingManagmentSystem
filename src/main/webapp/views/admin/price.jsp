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
    <title>ParkCity | Pricing</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Montserrat',sans-serif;background:radial-gradient(at top left,#1e3a8a 0%,#0a1128 50%),radial-gradient(at bottom right,#0d1117 0%,#010409 60%);background-attachment:fixed;color:#f0f6fc;min-height:100vh}
        a{text-decoration:none;color:inherit}
        .sidebar{position:fixed;top:0;left:0;width:240px;height:100vh;background:rgba(10,17,40,0.95);border-right:1px solid rgba(26,217,240,0.2);display:flex;flex-direction:column;z-index:100;backdrop-filter:blur(10px)}
        .sidebar-brand{padding:24px 20px;border-bottom:1px solid rgba(255,255,255,0.08)}
        .logo-icon{color:#37ff8b;font-size:1.5rem;margin-bottom:8px;display:block}
        .sidebar-brand h1{font-size:1.1rem;font-weight:800;color:#f0f6fc}
        .sidebar-brand p{font-size:0.75rem;color:#b8c7e0;margin-top:2px}
        .nav-section{padding:16px 12px 8px;font-size:0.65rem;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#b8c7e0}
        .nav-link{display:flex;align-items:center;gap:10px;padding:10px 16px;border-radius:8px;margin:2px 8px;color:#b8c7e0;font-size:0.85rem;font-weight:600;transition:0.3s}
        .nav-link:hover{background:rgba(255,255,255,0.05);color:#f0f6fc}
        .nav-link.active{background:rgba(55,255,139,0.1);color:#37ff8b;border:1px solid rgba(55,255,139,0.2)}
        .nav-link i{width:16px;text-align:center}
        .sidebar-footer{margin-top:auto;padding:16px;border-top:1px solid rgba(255,255,255,0.08);font-size:0.75rem;color:#b8c7e0}
        .main{margin-left:240px;min-height:100vh;padding:32px 36px}
        .page-header{margin-bottom:28px}
        .page-header h2{font-size:1.6rem;font-weight:800}
        .page-header p{font-size:0.85rem;color:#b8c7e0;margin-top:4px}
        .flash{padding:12px 16px;border-radius:10px;font-size:0.85rem;margin-bottom:20px;display:flex;align-items:center;gap:10px}
        .flash-success{background:rgba(55,255,139,0.08);border:1px solid rgba(55,255,139,0.2);color:#37ff8b}
        .flash-error{background:rgba(255,107,107,0.08);border:1px solid rgba(255,107,107,0.2);color:#ff6b6b}
        .content-wrap{max-width:680px}
        .current-price-card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:24px;display:flex;align-items:center;gap:20px;transition:0.3s}
        .current-price-card:hover{border-color:rgba(26,217,240,0.25)}
        .price-icon{width:56px;height:56px;background:rgba(55,255,139,0.08);border:1px solid rgba(55,255,139,0.2);border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;flex-shrink:0}
        .price-info h3{font-size:2rem;font-weight:800;color:#37ff8b}
        .price-info p{font-size:0.8rem;color:#b8c7e0;margin-top:2px}
        .form-card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:28px;margin-bottom:24px;transition:0.3s}
        .form-card:hover{border-color:rgba(26,217,240,0.25)}
        .form-card h5{font-size:0.95rem;font-weight:700;margin-bottom:6px;display:flex;align-items:center;gap:8px;color:#37ff8b}
        .form-card .subtitle{font-size:0.8rem;color:#b8c7e0;margin-bottom:24px;line-height:1.6}
        .form-label{font-size:0.75rem;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;color:#b8c7e0;margin-bottom:8px;display:block}
        .input-wrapper{display:flex;align-items:stretch}
        .input-prefix{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-right:none;border-radius:8px 0 0 8px;padding:0 14px;font-size:0.9rem;font-weight:700;color:#b8c7e0;display:flex;align-items:center}
        .input-suffix{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-left:none;border-radius:0 8px 8px 0;padding:0 14px;font-size:0.85rem;color:#b8c7e0;display:flex;align-items:center}
        .price-input{flex:1;background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.1);border-left:none;border-right:none;color:#f0f6fc;font-family:'Montserrat',sans-serif;font-size:1.1rem;font-weight:700;padding:12px 10px;outline:none;-moz-appearance:textfield}
        .price-input::-webkit-outer-spin-button,.price-input::-webkit-inner-spin-button{-webkit-appearance:none}
        .price-input:focus{background:rgba(26,217,240,0.04);border-color:#1ad9f0}
        .preset-btns{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
        .preset-btn{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);color:#b8c7e0;font-family:'Montserrat',sans-serif;font-size:0.8rem;padding:6px 14px;border-radius:20px;cursor:pointer;transition:0.3s;font-weight:600}
        .preset-btn:hover{background:rgba(55,255,139,0.08);border-color:rgba(55,255,139,0.3);color:#37ff8b}
        .btn-save{background:#37ff8b;color:#0c1a12;border:none;padding:12px 28px;border-radius:20px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;cursor:pointer;transition:0.3s;margin-top:20px}
        .btn-save:hover{transform:translateY(-2px);box-shadow:0 0 15px rgba(55,255,139,0.3)}
        .info-note{background:rgba(26,217,240,0.06);border:1px solid rgba(26,217,240,0.15);border-radius:10px;padding:14px 16px;font-size:0.8rem;color:#b8c7e0;line-height:1.6}
        .info-note strong{color:#1ad9f0}
    </style>
</head>
<body>

<nav class="sidebar">
    <div class="sidebar-brand">
        <span class="logo-icon">&#10018;</span>
        <h1>ParkCity</h1>
        <p>Admin Control Panel</p>
    </div>
    <div class="nav-section">Navigation</div>
    <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-link">
        <i class="fas fa-gauge-high"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/admin/reports" class="nav-link">
        <i class="fas fa-chart-bar"></i> System Reports
    </a>
    <a href="<%= request.getContextPath() %>/admin/price" class="nav-link active">
        <i class="fas fa-tag"></i> Pricing
    </a>
    <div class="sidebar-footer">&#128994; System Online | Admin</div>
</nav>

<main class="main">
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
                    <span style="font-size:0.75rem;color:#b8c7e0;align-self:center">Quick set:</span>
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
            Sathir's Payment module reads this file to calculate parking fees for each ticket.
        </div>
    </div>
</main>

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