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
    <title>Pricing — Smart Parking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bg: #0d1117; --surface: #161b22; --border: #30363d;
            --accent: #f78166; --accent2: #79c0ff;
            --accent3: #56d364; --accent4: #e3b341;
            --text: #e6edf3; --muted: #8b949e;
            --font: 'Space Grotesk', sans-serif; --mono: 'DM Mono', monospace;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--bg); color: var(--text); font-family: var(--font); }

        .sidebar {
            position: fixed; top: 0; left: 0; width: 240px; height: 100vh;
            background: var(--surface); border-right: 1px solid var(--border);
            display: flex; flex-direction: column; z-index: 100;
        }
        .sidebar-brand { padding: 24px 20px 20px; border-bottom: 1px solid var(--border); }
        .sidebar-brand .logo-icon { width: 36px; height: 36px; background: var(--accent); border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px; font-size: 18px; }
        .sidebar-brand h1 { font-size: 15px; font-weight: 700; }
        .sidebar-brand p  { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .nav-section { padding: 16px 12px 8px; font-size: 10px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--muted); }
        .nav-link { display: flex; align-items: center; gap: 10px; padding: 9px 12px; border-radius: 6px; margin: 1px 8px; color: var(--muted); font-size: 13.5px; font-weight: 500; text-decoration: none; transition: all 0.15s; }
        .nav-link:hover { background: rgba(255,255,255,0.05); color: var(--text); }
        .nav-link.active { background: rgba(227,179,65,0.15); color: var(--accent4); }
        .nav-link i { width: 16px; text-align: center; font-size: 13px; }
        .sidebar-footer { margin-top: auto; padding: 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--muted); }

        .main { margin-left: 240px; min-height: 100vh; padding: 32px 36px; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 22px; font-weight: 700; }
        .page-header p  { font-size: 13px; color: var(--muted); margin-top: 4px; }

        .flash { padding: 12px 16px; border-radius: 8px; font-size: 13.5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .flash-success { background: rgba(86,211,100,0.12); border: 1px solid rgba(86,211,100,0.3); color: var(--accent3); }
        .flash-error   { background: rgba(247,129,102,0.12); border: 1px solid rgba(247,129,102,0.3); color: var(--accent); }

        .content-wrap { max-width: 680px; }

        .current-price-card { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 24px; margin-bottom: 24px; display: flex; align-items: center; gap: 20px; }
        .price-icon { width: 56px; height: 56px; background: rgba(227,179,65,0.15); border: 1px solid rgba(227,179,65,0.3); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
        .price-info h3 { font-size: 32px; font-weight: 700; font-family: var(--mono); color: var(--accent4); }
        .price-info p  { font-size: 13px; color: var(--muted); margin-top: 2px; }

        .form-card { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 28px; margin-bottom: 24px; }
        .form-card h5 { font-size: 15px; font-weight: 700; margin-bottom: 6px; display: flex; align-items: center; gap: 8px; }
        .form-card .subtitle { font-size: 13px; color: var(--muted); margin-bottom: 24px; line-height: 1.6; }

        .form-label-custom { font-size: 12px; font-weight: 600; letter-spacing: 0.06em; text-transform: uppercase; color: var(--muted); margin-bottom: 8px; display: block; }
        .input-wrapper { display: flex; align-items: stretch; }
        .input-prefix { background: rgba(255,255,255,0.05); border: 1px solid var(--border); border-right: none; border-radius: 8px 0 0 8px; padding: 0 14px; font-size: 14px; font-weight: 700; font-family: var(--mono); color: var(--muted); display: flex; align-items: center; }
        .input-suffix { background: rgba(255,255,255,0.05); border: 1px solid var(--border); border-left: none; border-radius: 0 8px 8px 0; padding: 0 14px; font-size: 13px; color: var(--muted); display: flex; align-items: center; }
        .price-input { flex: 1; background: rgba(255,255,255,0.04); border: 1px solid var(--border); border-left: none; border-right: none; color: var(--text); font-family: var(--mono); font-size: 18px; font-weight: 600; padding: 12px 10px; outline: none; -moz-appearance: textfield; }
        .price-input::-webkit-outer-spin-button, .price-input::-webkit-inner-spin-button { -webkit-appearance: none; }
        .price-input:focus { background: rgba(121,192,255,0.04); border-color: var(--accent2); }

        .preset-btns { margin-top: 14px; display: flex; gap: 8px; flex-wrap: wrap; }
        .preset-btn { background: rgba(255,255,255,0.04); border: 1px solid var(--border); color: var(--muted); font-family: var(--mono); font-size: 13px; padding: 6px 14px; border-radius: 6px; cursor: pointer; transition: all 0.15s; }
        .preset-btn:hover { background: rgba(121,192,255,0.1); border-color: var(--accent2); color: var(--accent2); }

        .btn-save { background: var(--accent4); color: #000; border: none; padding: 11px 28px; border-radius: 8px; font-family: var(--font); font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; margin-top: 20px; }
        .btn-save:hover { opacity: 0.85; }

        .info-note { background: rgba(121,192,255,0.06); border: 1px solid rgba(121,192,255,0.2); border-radius: 8px; padding: 14px 16px; font-size: 13px; color: var(--muted); line-height: 1.6; }
        .info-note strong { color: var(--accent2); }
    </style>
</head>
<body>

<nav class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon">P</div>
        <h1>Smart Parking</h1>
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
    <div class="sidebar-footer">System Online | Admin</div>
</nav>

<main class="main">
    <div class="page-header">
        <h2>Parking Price Settings</h2>
        <p>Update the global hourly parking rate.</p>
    </div>

    <% if (successMsg != null) { %>
        <div class="flash flash-success"><i class="fas fa-check-circle"></i> <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="flash flash-error"><i class="fas fa-exclamation-circle"></i> <%= errorMsg %></div>
    <% } %>

    <div class="content-wrap">
        <div class="current-price-card">
            <div class="price-icon">💰</div>
            <div class="price-info">
                <h3>Rs.<%= String.format("%.2f", currentPrice) %></h3>
                <p>Current rate per hour · Saved in config.txt</p>
            </div>
        </div>

        <div class="form-card">
            <h5><i class="fas fa-edit" style="color:var(--accent4);"></i> Update Price Per Hour</h5>
            <p class="subtitle">Enter the new hourly rate. This will be saved to config.txt and used by the Payment module.</p>

            <form method="post" action="<%= request.getContextPath() %>/admin/price" id="priceForm">
                <label class="form-label-custom">New Price (Rs. per hour)</label>
                <div class="input-wrapper">
                    <span class="input-prefix">Rs.</span>
                    <input type="number" name="price" id="priceInput" class="price-input"
                           min="1" step="0.01"
                           value="<%= String.format("%.2f", currentPrice) %>" required>
                    <span class="input-suffix">/hour</span>
                </div>
                <div class="preset-btns">
                    <span style="font-size:11px; color:var(--muted); align-self:center;">Quick set:</span>
                    <button type="button" class="preset-btn" onclick="setPrice(100)">Rs.100</button>
                    <button type="button" class="preset-btn" onclick="setPrice(150)">Rs.150</button>
                    <button type="button" class="preset-btn" onclick="setPrice(200)">Rs.200</button>
                    <button type="button" class="preset-btn" onclick="setPrice(250)">Rs.250</button>
                    <button type="button" class="preset-btn" onclick="setPrice(300)">Rs.300</button>
                </div>
                <div>
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i> Save New Price
                    </button>
                </div>
            </form>
        </div>

        <div class="info-note">
            <strong><i class="fas fa-info-circle"></i> How pricing works:</strong><br>
            When you save a new price, it is written to <strong>config.txt</strong> as
            <code style="background:rgba(255,255,255,0.06); padding:1px 5px; border-radius:3px;">price=200.0</code>.
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>