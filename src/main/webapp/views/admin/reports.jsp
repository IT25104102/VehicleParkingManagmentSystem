<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.parking.service.AdminService.SystemReport" %>
<%@ page import="com.parking.model.Log" %>
<%@ page import="java.util.List" %>
<%
    SystemReport report = (SystemReport) request.getAttribute("report");
    if (report == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Reports — Smart Parking</title>
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
        .nav-link.active { background: rgba(121,192,255,0.15); color: var(--accent2); }
        .nav-link i { width: 16px; text-align: center; font-size: 13px; }
        .sidebar-footer { margin-top: auto; padding: 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--muted); }

        .main { margin-left: 240px; min-height: 100vh; padding: 32px 36px; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 22px; font-weight: 700; }
        .page-header p  { font-size: 13px; color: var(--muted); margin-top: 4px; }

        .summary-grid { display: grid; grid-template-columns: repeat(6,1fr); gap: 12px; margin-bottom: 28px; }
        .tile { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 16px 14px; text-align: center; }
        .tile .t-val { font-size: 26px; font-weight: 700; font-family: var(--mono); line-height: 1; }
        .tile .t-lbl { font-size: 10.5px; color: var(--muted); margin-top: 5px; text-transform: uppercase; letter-spacing: 0.06em; font-weight: 600; }

        .section-card { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; margin-bottom: 20px; }
        .section-header { padding: 14px 20px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .section-header h5 { font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .section-header .count { font-size: 12px; color: var(--muted); font-family: var(--mono); }

        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 10px 18px; font-size: 11px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); border-bottom: 1px solid var(--border); text-align: left; }
        tbody td { padding: 10px 18px; font-size: 13px; font-family: var(--mono); border-bottom: 1px solid rgba(48,54,61,0.5); }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.025); }

        .empty-state { padding: 28px; text-align: center; color: var(--muted); font-size: 13px; }
        .empty-state i { font-size: 24px; display: block; margin-bottom: 8px; opacity: 0.35; }

        .c-blue  { color: var(--accent2); }
        .c-green { color: var(--accent3); }
        .c-red   { color: var(--accent); }
        .c-yellow{ color: var(--accent4); }
        .c-purple{ color: #d2a8ff; }
        .c-teal  { color: #39d353; }

        .badge-pill { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-available { background: rgba(86,211,100,0.15); color: var(--accent3); }
        .badge-occupied  { background: rgba(247,129,102,0.15); color: var(--accent); }

        .price-highlight { display: inline-block; background: rgba(227,179,65,0.15); border: 1px solid rgba(227,179,65,0.3); color: var(--accent4); padding: 6px 14px; border-radius: 20px; font-size: 14px; font-weight: 700; font-family: var(--mono); }

        .tab-nav { display: flex; gap: 4px; padding: 12px 20px; border-bottom: 1px solid var(--border); flex-wrap: wrap; }
        .tab-btn { padding: 6px 14px; border-radius: 6px; border: none; background: transparent; color: var(--muted); font-family: var(--font); font-size: 12.5px; font-weight: 600; cursor: pointer; transition: all 0.15s; }
        .tab-btn:hover { background: rgba(255,255,255,0.05); color: var(--text); }
        .tab-btn.active { background: rgba(121,192,255,0.12); color: var(--accent2); }
        .tab-content { display: none; }
        .tab-content.show { display: block; }
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
    <a href="<%= request.getContextPath() %>/admin/reports" class="nav-link active">
        <i class="fas fa-chart-bar"></i> System Reports
    </a>
    <a href="<%= request.getContextPath() %>/admin/price" class="nav-link">
        <i class="fas fa-tag"></i> Pricing
    </a>
    <div class="sidebar-footer">System Online | Admin</div>
</nav>

<main class="main">
    <div class="page-header">
        <h2>System-Wide Reports</h2>
        <p>Live data from all modules.</p>
    </div>

    <div style="margin-bottom:24px; display:flex; align-items:center; gap:12px;">
        <span style="font-size:13px; color:var(--muted);">Current Parking Rate:</span>
        <span class="price-highlight">Rs.<%= String.format("%.2f", report.getCurrentPrice()) %>/hour</span>
        <a href="<%= request.getContextPath() %>/admin/price"
           style="font-size:12px; color:var(--accent2); text-decoration:none;">Change →</a>
    </div>

    <div class="summary-grid">
        <div class="tile"><div class="t-val c-blue"><%= report.getTotalUsers() %></div><div class="t-lbl">Users</div></div>
        <div class="tile"><div class="t-val c-yellow"><%= report.getTotalVehicles() %></div><div class="t-lbl">Vehicles</div></div>
        <div class="tile"><div class="t-val c-green"><%= report.getAvailableSlots() %></div><div class="t-lbl">Free Slots</div></div>
        <div class="tile"><div class="t-val c-red"><%= report.getOccupiedSlots() %></div><div class="t-lbl">Occupied</div></div>
        <div class="tile"><div class="t-val c-purple"><%= report.getActiveTickets() %></div><div class="t-lbl">Tickets</div></div>
        <div class="tile"><div class="t-val c-teal">Rs.<%= String.format("%.0f", report.getTotalIncome()) %></div><div class="t-lbl">Income</div></div>
    </div>

    <div class="section-card">
        <div class="section-header">
            <h5>Module Data</h5>
            <span class="count">All .txt files</span>
        </div>
        <div class="tab-nav">
            <button class="tab-btn active" onclick="showTab('users',this)">Users (<%= report.getTotalUsers() %>)</button>
            <button class="tab-btn" onclick="showTab('vehicles',this)">Vehicles (<%= report.getTotalVehicles() %>)</button>
            <button class="tab-btn" onclick="showTab('slots',this)">Slots (<%= report.getTotalSlots() %>)</button>
            <button class="tab-btn" onclick="showTab('tickets',this)">Tickets (<%= report.getActiveTickets() %>)</button>
            <button class="tab-btn" onclick="showTab('payments',this)">Payments (<%= report.getTotalPayments() %>)</button>
            <button class="tab-btn" onclick="showTab('logs',this)">Logs (<%= report.getTotalLogs() %>)</button>
        </div>

        <div id="tab-users" class="tab-content show">
            <% if (report.getUserLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-user-slash"></i>No users data yet</div>
            <% } else { %><table><thead><tr><th>#</th><th>Data from users.txt</th></tr></thead><tbody>
            <% int i=1; for(String line: report.getUserLines()){ if(!line.trim().isEmpty()){ %><tr><td><%= i++ %></td><td><%= line %></td></tr><% } } %>
            </tbody></table><% } %>
        </div>

        <div id="tab-vehicles" class="tab-content">
            <% if (report.getVehicleLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-car-side"></i>No vehicles data yet</div>
            <% } else { %><table><thead><tr><th>#</th><th>Data from vehicles.txt</th></tr></thead><tbody>
            <% int j=1; for(String line: report.getVehicleLines()){ if(!line.trim().isEmpty()){ %><tr><td><%= j++ %></td><td><%= line %></td></tr><% } } %>
            </tbody></table><% } %>
        </div>

        <div id="tab-slots" class="tab-content">
            <% if (report.getSlotLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-parking"></i>No slots data yet</div>
            <% } else { %><table><thead><tr><th>#</th><th>Slot Data</th><th>Status</th></tr></thead><tbody>
            <% int k=1; for(String line: report.getSlotLines()){ if(!line.trim().isEmpty()){ boolean av=line.toLowerCase().contains("available"); %>
            <tr><td><%= k++ %></td><td><%= line %></td><td><% if(av){ %><span class="badge-pill badge-available">Available</span><% }else{ %><span class="badge-pill badge-occupied">Occupied</span><% } %></td></tr>
            <% } } %></tbody></table><% } %>
        </div>

        <div id="tab-tickets" class="tab-content">
            <% if (report.getTicketLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-ticket-alt"></i>No tickets data yet</div>
            <% } else { %><table><thead><tr><th>#</th><th>Data from tickets.txt</th></tr></thead><tbody>
            <% int l=1; for(String line: report.getTicketLines()){ if(!line.trim().isEmpty()){ %><tr><td><%= l++ %></td><td><%= line %></td></tr><% } } %>
            </tbody></table><% } %>
        </div>

        <div id="tab-payments" class="tab-content">
            <% if (report.getPaymentLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-money-check-alt"></i>No payments data yet</div>
            <% } else { %><table><thead><tr><th>#</th><th>Payment Data</th></tr></thead><tbody>
            <% int m=1; for(String line: report.getPaymentLines()){ if(!line.trim().isEmpty()){ %><tr><td><%= m++ %></td><td><%= line %></td></tr><% } } %>
            </tbody></table>
            <div style="padding:12px 18px; border-top:1px solid var(--border); text-align:right; font-size:13px;">
                <strong style="color:var(--accent4);">Total: Rs.<%= String.format("%.2f", report.getTotalIncome()) %></strong>
            </div><% } %>
        </div>

        <div id="tab-logs" class="tab-content">
            <% if (report.getLogLines().isEmpty()) { %><div class="empty-state"><i class="fas fa-file-alt"></i>No logs yet</div>
            <% } else { %><table><thead><tr><th>Date</th><th>Vehicles</th><th>Income</th><th>Available Slots</th></tr></thead><tbody>
            <% for(String line: report.getLogLines()){ if(!line.trim().isEmpty()){ Log log=Log.fromLine(line); if(log!=null){ %>
            <tr><td><%= log.getDate() %></td><td><%= log.getTotalVehicles() %></td><td>Rs.<%= String.format("%.2f",log.getIncome()) %></td><td><%= log.getAvailableSlots() %></td></tr>
            <% } } } %></tbody></table><% } %>
        </div>
    </div>
</main>

<script>
function showTab(name, btn) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('show'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + name).classList.add('show');
    btn.classList.add('active');
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>