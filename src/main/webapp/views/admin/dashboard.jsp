<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.parking.service.AdminService.SystemReport" %>
<%@ page import="com.parking.model.Log" %>
<%@ page import="java.util.*" %>
<%
    SystemReport report = (SystemReport) request.getAttribute("report");
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
    <title>Admin Dashboard — Smart Parking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bg: #0d1117; --surface: #161b22; --border: #30363d;
            --accent: #f78166; --accent2: #79c0ff;
            --accent3: #56d364; --accent4: #e3b341;
            --text: #e6edf3; --muted: #8b949e;
            --font: 'Space Grotesk', sans-serif;
            --mono: 'DM Mono', monospace;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--bg); color: var(--text); font-family: var(--font); min-height: 100vh; }

        .sidebar {
            position: fixed; top: 0; left: 0; width: 240px; height: 100vh;
            background: var(--surface); border-right: 1px solid var(--border);
            display: flex; flex-direction: column; z-index: 100;
        }
        .sidebar-brand { padding: 24px 20px 20px; border-bottom: 1px solid var(--border); }
        .sidebar-brand .logo-icon {
            width: 36px; height: 36px; background: var(--accent); border-radius: 8px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-bottom: 10px; font-size: 18px;
        }
        .sidebar-brand h1 { font-size: 15px; font-weight: 700; color: var(--text); line-height: 1.2; }
        .sidebar-brand p  { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .nav-section { padding: 16px 12px 8px; font-size: 10px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--muted); }
        .nav-link {
            display: flex; align-items: center; gap: 10px; padding: 9px 12px;
            border-radius: 6px; margin: 1px 8px; color: var(--muted);
            font-size: 13.5px; font-weight: 500; text-decoration: none; transition: all 0.15s;
        }
        .nav-link:hover { background: rgba(255,255,255,0.05); color: var(--text); }
        .nav-link.active { background: rgba(247,129,102,0.15); color: var(--accent); }
        .nav-link i { width: 16px; text-align: center; font-size: 13px; }
        .sidebar-footer { margin-top: auto; padding: 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--muted); }

        .main { margin-left: 240px; min-height: 100vh; padding: 32px 36px; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 22px; font-weight: 700; }
        .page-header p  { font-size: 13px; color: var(--muted); margin-top: 4px; }

        .flash { padding: 12px 16px; border-radius: 8px; font-size: 13.5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .flash-success { background: rgba(86,211,100,0.12); border: 1px solid rgba(86,211,100,0.3); color: var(--accent3); }
        .flash-error   { background: rgba(247,129,102,0.12); border: 1px solid rgba(247,129,102,0.3); color: var(--accent); }

        .stats-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 28px; }
        .stat-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; padding: 20px; position: relative; overflow: hidden;
        }
        .stat-card .label { font-size: 11px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); margin-bottom: 10px; }
        .stat-card .value { font-size: 30px; font-weight: 700; font-family: var(--mono); line-height: 1; }
        .stat-card .sub   { font-size: 11px; color: var(--muted); margin-top: 6px; }
        .stat-card .icon  { position: absolute; right: 16px; top: 16px; font-size: 20px; opacity: 0.2; }

        .c-red   { color: var(--accent); }
        .c-blue  { color: var(--accent2); }
        .c-green { color: var(--accent3); }
        .c-yellow{ color: var(--accent4); }

        .actions-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
        .action-card { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 22px; }
        .action-card h5 { font-size: 13.5px; font-weight: 600; margin-bottom: 6px; display: flex; align-items: center; gap: 8px; }
        .action-card p  { font-size: 12px; color: var(--muted); line-height: 1.6; margin-bottom: 16px; }

        .btn-primary-custom {
            background: var(--accent); color: #fff; border: none;
            padding: 9px 18px; border-radius: 6px; font-family: var(--font);
            font-size: 13px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: inline-block; transition: opacity 0.2s;
        }
        .btn-primary-custom:hover { opacity: 0.85; color: #fff; }
        .btn-secondary-custom {
            background: transparent; color: var(--accent2); border: 1px solid var(--accent2);
            padding: 9px 18px; border-radius: 6px; font-family: var(--font);
            font-size: 13px; font-weight: 600; cursor: pointer;
            text-decoration: none; display: inline-block; transition: all 0.2s;
        }
        .btn-secondary-custom:hover { background: rgba(121,192,255,0.1); color: var(--accent2); }
        .btn-danger-custom {
            background: transparent; color: var(--accent); border: 1px solid var(--accent);
            padding: 9px 18px; border-radius: 6px; font-family: var(--font);
            font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s;
        }
        .btn-danger-custom:hover { background: rgba(247,129,102,0.1); }

        .card { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; }
        .card-header { padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .card-header h5 { font-size: 14px; font-weight: 600; }

        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 10px 20px; font-size: 11px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); border-bottom: 1px solid var(--border); text-align: left; }
        tbody td { padding: 11px 20px; font-size: 13px; font-family: var(--mono); border-bottom: 1px solid rgba(48,54,61,0.5); }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.025); }

        .badge-pill { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-green { background: rgba(86,211,100,0.15); color: var(--accent3); }

        .empty-state { padding: 32px; text-align: center; color: var(--muted); font-size: 13px; }
        .empty-state i { font-size: 28px; display: block; margin-bottom: 8px; opacity: 0.4; }

        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 200; align-items: center; justify-content: center; }
        .modal-overlay.show { display: flex; }
        .modal-box { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 28px 32px; max-width: 400px; width: 100%; }
        .modal-box h5 { font-size: 16px; font-weight: 700; margin-bottom: 10px; }
        .modal-box p  { font-size: 13px; color: var(--muted); margin-bottom: 20px; line-height: 1.6; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
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
    <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-link active">
        <i class="fas fa-gauge-high"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/admin/reports" class="nav-link">
        <i class="fas fa-chart-bar"></i> System Reports
    </a>
    <a href="<%= request.getContextPath() %>/admin/price" class="nav-link">
        <i class="fas fa-tag"></i> Pricing
    </a>
    <div class="sidebar-footer">
        System Online | Admin
    </div>
</nav>

<main class="main">
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
                <button type="submit" class="btn-primary-custom">
                    <i class="fas fa-bolt"></i> Generate Now
                </button>
            </form>
        </div>
        <div class="action-card">
            <h5 class="c-blue"><i class="fas fa-chart-bar"></i> View Reports</h5>
            <p>See full system-wide reports from all modules — users, vehicles, slots, tickets, and payments.</p>
            <a href="<%= request.getContextPath() %>/admin/reports" class="btn-secondary-custom">
                <i class="fas fa-arrow-right"></i> Open Reports
            </a>
        </div>
        <div class="action-card">
            <h5 class="c-red"><i class="fas fa-trash-alt"></i> Clean Old Logs</h5>
            <p>Bulk delete log entries older than 30 days to keep logs.txt clean and the system fast.</p>
            <button class="btn-danger-custom"
                onclick="document.getElementById('confirmModal').classList.add('show')">
                <i class="fas fa-broom"></i> Run Cleanup
            </button>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5>Recent Log Entries</h5>
            <span style="font-size:12px;color:var(--muted);">
                <%= report != null ? report.getTotalLogs() : 0 %> total in logs.txt
            </span>
        </div>
        <%
            List<String> logLines = (report != null) ? report.getLogLines() : new ArrayList<>();
            int start = Math.max(0, logLines.size() - 10);
            List<String> recentLogs = new ArrayList<>(logLines.subList(start, logLines.size()));
            Collections.reverse(recentLogs);
        %>
        <% if (recentLogs.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-file-alt"></i>
                No log entries yet. Generate your first daily summary!
            </div>
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
                        <td><span class="badge-pill badge-green">Saved</span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</main>

<div class="modal-overlay" id="confirmModal">
    <div class="modal-box">
        <h5>Confirm Log Cleanup</h5>
        <p>This will permanently delete all log entries older than <strong>30 days</strong>. This cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn-secondary-custom"
                onclick="document.getElementById('confirmModal').classList.remove('show')">
                Cancel
            </button>
            <form method="post" action="<%= request.getContextPath() %>/admin/clean" style="display:inline;">
                <button type="submit" class="btn-danger-custom">Yes, Delete</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>