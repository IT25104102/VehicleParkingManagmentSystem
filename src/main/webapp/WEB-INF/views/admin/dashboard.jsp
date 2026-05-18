<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smartparking.smartparkingsystem.service.AdminService" %>
<%@ page import="com.smartparking.smartparkingsystem.model.Log" %>
<%@ page import="java.util.*" %>
<%
    AdminService.SystemReport report = (AdminService.SystemReport) request.getAttribute("report");
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
    <title>ParkCity | Admin Dashboard</title>
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
        .flash-error { background: rgba(247,129,102,0.08); border: 1px solid rgba(247,129,102,0.2); color: #ff6b6b; }
        .stats-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px; position: relative; overflow: hidden; transition: 0.3s; }
        .stat-card:hover { border-color: rgba(26,217,240,0.25); transform: translateY(-2px); }
        .stat-card .label { font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--text-dim); margin-bottom: 10px; }
        .stat-card .value { font-size: 1.8rem; font-weight: 800; line-height: 1; }
        .stat-card .sub { font-size: 0.75rem; color: var(--text-dim); margin-top: 6px; }
        .stat-card .icon { position: absolute; right: 16px; top: 16px; font-size: 1.5rem; opacity: 0.15; }
        .c-blue { color: #1ad9f0; }
        .c-green { color: #37ff8b; }
        .c-yellow { color: #f0c040; }
        .c-red { color: #ff6b6b; }
        .actions-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
        .action-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 22px; transition: 0.3s; }
        .action-card:hover { border-color: rgba(26,217,240,0.25); }
        .action-card h5 { font-size: 0.9rem; font-weight: 700; margin-bottom: 8px; display: flex; align-items: center; gap: 8px; }
        .action-card p { font-size: 0.8rem; color: var(--text-dim); line-height: 1.6; margin-bottom: 16px; }
        .btn-primary { background: #37ff8b; border: none; border-radius: 20px; padding: 10px 20px; font-family: 'Montserrat',sans-serif; font-size: 0.8rem; font-weight: 800; color: #0c1a12; cursor: pointer; transition: 0.3s; display: inline-block; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 0 15px rgba(55,255,139,0.3); }
        .btn-secondary { background: transparent; border: 1px solid #1ad9f0; border-radius: 20px; padding: 9px 20px; font-family: 'Montserrat',sans-serif; font-size: 0.8rem; font-weight: 700; color: #1ad9f0; cursor: pointer; transition: 0.3s; display: inline-block; }
        .btn-secondary:hover { background: rgba(26,217,240,0.1); }
        .btn-danger { background: transparent; border: 1px solid #ff6b6b; border-radius: 20px; padding: 9px 20px; font-family: 'Montserrat',sans-serif; font-size: 0.8rem; font-weight: 700; color: #ff6b6b; cursor: pointer; transition: 0.3s; }
        .btn-danger:hover { background: rgba(255,107,107,0.1); }
        .card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; overflow: hidden; margin-bottom: 20px; }
        .card-header { padding: 16px 20px; border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; justify-content: space-between; }
        .card-header h5 { font-size: 0.9rem; font-weight: 700; }
        .card-header span { font-size: 0.75rem; color: var(--text-dim); }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 10px 20px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--text-dim); border-bottom: 1px solid rgba(255,255,255,0.08); text-align: left; }
        tbody td { padding: 12px 20px; font-size: 0.85rem; border-bottom: 1px solid rgba(255,255,255,0.05); }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.03); }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; background: rgba(55,255,139,0.1); color: #37ff8b; border: 1px solid rgba(55,255,139,0.2); }
        .empty-state { padding: 32px; text-align: center; color: var(--text-dim); font-size: 0.85rem; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 200; align-items: center; justify-content: center; }
        .modal-overlay.show { display: flex; }
        .modal-box { background: #0a1128; border: 1px solid rgba(26,217,240,0.2); border-radius: 14px; padding: 28px 32px; max-width: 400px; width: 100%; }
        .modal-box h5 { font-size: 1rem; font-weight: 800; margin-bottom: 10px; }
        .modal-box p { font-size: 0.85rem; color: var(--text-dim); margin-bottom: 20px; line-height: 1.6; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
    </style>
</head>
<body>

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
            <li><a href="<%= request.getContextPath() %>/admin/dashboard" class="active">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/reports">Reports</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/price">Pricing</a></li>
            <li><a href="<%= request.getContextPath() %>/slots/manage">Manage Slots</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/users">Manage Users</a></li>
            <li><a href="<%= request.getContextPath() %>/payment/history">Payments</a></li>
            <li><a href="<%= request.getContextPath() %>/tickets">Tickets</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">
    <div class="page-header">
        <h2>Dashboard Overview</h2>
        <p>Today: <%= new java.util.Date() %></p>
    </div>

    <% if (successMsg != null) { %>
        <div class="flash flash-success"><i class="fas fa-check-circle"></i> <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="flash flash-error"><i class="fas fa-exclamation-circle"></i> <%= errorMsg %></div>
    <% } %>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="label">Total Users</div>
            <div class="value c-blue"><%= report != null ? report.getTotalUsers() : 0 %></div>
            <div class="sub">Registered accounts</div>
            <div class="icon c-blue"><i class="fas fa-users"></i></div>
        </div>
        <div class="stat-card">
            <div class="label">Vehicles</div>
            <div class="value c-yellow"><%= report != null ? report.getTotalVehicles() : 0 %></div>
            <div class="sub">Registered vehicles</div>
            <div class="icon c-yellow"><i class="fas fa-car"></i></div>
        </div>
        <div class="stat-card">
            <div class="label">Available Slots</div>
            <div class="value c-green"><%= report != null ? report.getAvailableSlots() : 0 %></div>
            <div class="sub">of <%= report != null ? report.getTotalSlots() : 0 %> total</div>
            <div class="icon c-green"><i class="fas fa-parking"></i></div>
        </div>
        <div class="stat-card">
            <div class="label">Total Income</div>
            <div class="value c-red">Rs.<%= report != null ? String.format("%.0f", report.getTotalIncome()) : 0 %></div>
            <div class="sub"><%= report != null ? report.getTotalPayments() : 0 %> payments</div>
            <div class="icon c-red"><i class="fas fa-money-bill-wave"></i></div>
        </div>
    </div>

    <div class="actions-grid">
        <div class="action-card">
            <h5 class="c-green"><i class="fas fa-plus-circle"></i> Generate Summary</h5>
            <p>Create today's daily summary log entry with current vehicle counts, income, and slot availability.</p>
            <form method="post" action="<%= request.getContextPath() %>/admin/generate">
                <button type="submit" class="btn-primary"><i class="fas fa-bolt"></i> Generate Now</button>
            </form>
        </div>
        <div class="action-card">
            <h5 class="c-blue"><i class="fas fa-chart-bar"></i> View Reports</h5>
            <p>See full system-wide reports from all modules — users, vehicles, slots, tickets, and payments.</p>
            <a href="<%= request.getContextPath() %>/admin/reports" class="btn-secondary">
                <i class="fas fa-arrow-right"></i> Open Reports
            </a>
        </div>
        <div class="action-card">
            <h5 class="c-red"><i class="fas fa-trash-alt"></i> Clean Old Logs</h5>
            <p>Bulk delete log entries older than 30 days to keep logs.txt clean and the system fast.</p>
            <button class="btn-danger" onclick="document.getElementById('confirmModal').classList.add('show')">
                <i class="fas fa-broom"></i> Run Cleanup
            </button>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5>Recent Log Entries</h5>
            <span><%= report != null ? report.getTotalLogs() : 0 %> total in logs.txt</span>
        </div>
        <%
            List<String> logLines = (report != null) ? report.getLogLines() : new ArrayList<>();
            int start = Math.max(0, logLines.size() - 10);
            List<String> recentLogs = new ArrayList<>(logLines.subList(start, logLines.size()));
            Collections.reverse(recentLogs);
        %>
        <% if (recentLogs.isEmpty()) { %>
            <div class="empty-state"><i class="fas fa-file-alt"></i> No log entries yet. Generate your first daily summary!</div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Total Vehicles</th>
                        <th>Income</th>
                        <th>Available Slots</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% for (String line : recentLogs) {
                    Log log = Log.fromLine(line);
                    if (log == null) continue; %>
                    <tr>
                        <td><%= log.getDate() %></td>
                        <td><%= log.getTotalVehicles() %></td>
                        <td>Rs.<%= String.format("%.2f", log.getIncome()) %></td>
                        <td><%= log.getAvailableSlots() %></td>
                        <td><span class="badge">Saved</span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

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
            <p>MyParking@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
    <p class="footer-copy">&copy; 2026 ParkCity Smart System. All rights reserved.</p>
</footer>

<div class="modal-overlay" id="confirmModal">
    <div class="modal-box">
        <h5>Confirm Log Cleanup</h5>
        <p>This will permanently delete all log entries older than <strong>30 days</strong>. This cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="document.getElementById('confirmModal').classList.remove('show')">Cancel</button>
            <form method="post" action="<%= request.getContextPath() %>/admin/clean" style="display:inline;">
                <button type="submit" class="btn-danger">Yes, Delete</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
