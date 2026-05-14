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
    <title>ParkCity | System Reports</title>
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
        .summary-grid{display:grid;grid-template-columns:repeat(6,1fr);gap:12px;margin-bottom:28px}
        .tile{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:16px 14px;text-align:center;transition:0.3s}
        .tile:hover{border-color:rgba(26,217,240,0.25);transform:translateY(-2px)}
        .tile .t-val{font-size:1.6rem;font-weight:800;line-height:1}
        .tile .t-lbl{font-size:0.65rem;color:#b8c7e0;margin-top:5px;text-transform:uppercase;letter-spacing:0.06em;font-weight:700}
        .price-row{margin-bottom:24px;display:flex;align-items:center;gap:12px}
        .price-row span{font-size:0.85rem;color:#b8c7e0}
        .price-highlight{display:inline-block;background:rgba(55,255,139,0.08);border:1px solid rgba(55,255,139,0.2);color:#37ff8b;padding:6px 14px;border-radius:20px;font-size:0.9rem;font-weight:800}
        .price-row a{font-size:0.8rem;color:#1ad9f0}
        .section-card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;overflow:hidden;margin-bottom:20px}
        .section-header{padding:14px 20px;border-bottom:1px solid rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:space-between}
        .section-header h5{font-size:0.9rem;font-weight:700;display:flex;align-items:center;gap:8px}
        .section-header .count{font-size:0.75rem;color:#b8c7e0}
        .tab-nav{display:flex;gap:4px;padding:12px 20px;border-bottom:1px solid rgba(255,255,255,0.08);flex-wrap:wrap}
        .tab-btn{padding:6px 14px;border-radius:20px;border:1px solid rgba(255,255,255,0.08);background:transparent;color:#b8c7e0;font-family:'Montserrat',sans-serif;font-size:0.75rem;font-weight:700;cursor:pointer;transition:0.3s}
        .tab-btn:hover{background:rgba(255,255,255,0.05);color:#f0f6fc}
        .tab-btn.active{background:rgba(55,255,139,0.08);border-color:rgba(55,255,139,0.2);color:#37ff8b}
        .tab-content{display:none}
        .tab-content.show{display:block}
        table{width:100%;border-collapse:collapse}
        thead th{padding:10px 18px;font-size:0.7rem;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#b8c7e0;border-bottom:1px solid rgba(255,255,255,0.08);text-align:left}
        tbody td{padding:10px 18px;font-size:0.85rem;border-bottom:1px solid rgba(255,255,255,0.05)}
        tbody tr:last-child td{border-bottom:none}
        tbody tr:hover{background:rgba(255,255,255,0.03)}
        .empty-state{padding:28px;text-align:center;color:#b8c7e0;font-size:0.85rem}
        .empty-state i{font-size:2rem;display:block;margin-bottom:8px;opacity:0.35}
        .c-blue{color:#1ad9f0}
        .c-green{color:#37ff8b}
        .c-red{color:#ff6b6b}
        .c-yellow{color:#f0c040}
        .c-purple{color:#d2a8ff}
        .c-teal{color:#39d353}
        .badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:0.7rem;font-weight:700}
        .badge-available{background:rgba(55,255,139,0.1);color:#37ff8b;border:1px solid rgba(55,255,139,0.2)}
        .badge-occupied{background:rgba(255,107,107,0.1);color:#ff6b6b;border:1px solid rgba(255,107,107,0.2)}
        .total-row{padding:12px 18px;border-top:1px solid rgba(255,255,255,0.08);text-align:right;font-size:0.85rem}
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
    <a href="<%= request.getContextPath() %>/admin/reports" class="nav-link active">
        <i class="fas fa-chart-bar"></i> System Reports
    </a>
    <a href="<%= request.getContextPath() %>/admin/price" class="nav-link">
        <i class="fas fa-tag"></i> Pricing
    </a>
    <div class="sidebar-footer">&#128994; System Online | Admin</div>
</nav>

<main class="main">
    <div class="page-header">
        <h2>System-Wide Reports</h2>
        <p>Live data from all modules.</p>
    </div>

    <div class="price-row">
        <span>Current Parking Rate:</span>
        <span class="price-highlight">
            Rs.<%= String.format("%.2f", report.getCurrentPrice()) %>/hour
        </span>
        <a href="<%= request.getContextPath() %>/admin/price">
            Change &rarr;
        </a>
    </div>

    <div class="summary-grid">
        <div class="tile">
            <div class="t-val c-blue"><%= report.getTotalUsers() %></div>
            <div class="t-lbl">Users</div>
        </div>
        <div class="tile">
            <div class="t-val c-yellow"><%= report.getTotalVehicles() %></div>
            <div class="t-lbl">Vehicles</div>
        </div>
        <div class="tile">
            <div class="t-val c-green"><%= report.getAvailableSlots() %></div>
            <div class="t-lbl">Free Slots</div>
        </div>
        <div class="tile">
            <div class="t-val c-red"><%= report.getOccupiedSlots() %></div>
            <div class="t-lbl">Occupied</div>
        </div>
        <div class="tile">
            <div class="t-val c-purple"><%= report.getActiveTickets() %></div>
            <div class="t-lbl">Tickets</div>
        </div>
        <div class="tile">
            <div class="t-val c-teal">
                Rs.<%= String.format("%.0f", report.getTotalIncome()) %>
            </div>
            <div class="t-lbl">Income</div>
        </div>
    </div>

    <div class="section-card">
        <div class="section-header">
            <h5>Module Data</h5>
            <span class="count">All .txt files</span>
        </div>
        <div class="tab-nav">
            <button class="tab-btn active" onclick="showTab('users',this)">
                Users (<%= report.getTotalUsers() %>)
            </button>
            <button class="tab-btn" onclick="showTab('vehicles',this)">
                Vehicles (<%= report.getTotalVehicles() %>)
            </button>
            <button class="tab-btn" onclick="showTab('slots',this)">
                Slots (<%= report.getTotalSlots() %>)
            </button>
            <button class="tab-btn" onclick="showTab('tickets',this)">
                Tickets (<%= report.getActiveTickets() %>)
            </button>
            <button class="tab-btn" onclick="showTab('payments',this)">
                Payments (<%= report.getTotalPayments() %>)
            </button>
            <button class="tab-btn" onclick="showTab('logs',this)">
                Logs (<%= report.getTotalLogs() %>)
            </button>
        </div>

        <!-- Users Tab -->
        <div id="tab-users" class="tab-content show">
            <% if (report.getUserLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-user-slash"></i>No users data yet
                </div>
            <% } else { %>
                <table>
                    <thead><tr><th>#</th><th>Data from users.txt</th></tr></thead>
                    <tbody>
                    <% int i=1; for(String line: report.getUserLines()){ if(!line.trim().isEmpty()){ %>
                        <tr><td><%= i++ %></td><td><%= line %></td></tr>
                    <% } } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Vehicles Tab -->
        <div id="tab-vehicles" class="tab-content">
            <% if (report.getVehicleLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-car-side"></i>No vehicles data yet
                </div>
            <% } else { %>
                <table>
                    <thead><tr><th>#</th><th>Data from vehicles.txt</th></tr></thead>
                    <tbody>
                    <% int j=1; for(String line: report.getVehicleLines()){ if(!line.trim().isEmpty()){ %>
                        <tr><td><%= j++ %></td><td><%= line %></td></tr>
                    <% } } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Slots Tab -->
        <div id="tab-slots" class="tab-content">
            <% if (report.getSlotLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-parking"></i>No slots data yet
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr><th>#</th><th>Slot Data</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                    <% int k=1; for(String line: report.getSlotLines()){ if(!line.trim().isEmpty()){ boolean av=line.toLowerCase().contains("available"); %>
                        <tr>
                            <td><%= k++ %></td>
                            <td><%= line %></td>
                            <td>
                                <% if(av){ %>
                                    <span class="badge badge-available">Available</span>
                                <% }else{ %>
                                    <span class="badge badge-occupied">Occupied</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Tickets Tab -->
        <div id="tab-tickets" class="tab-content">
            <% if (report.getTicketLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-ticket-alt"></i>No tickets data yet
                </div>
            <% } else { %>
                <table>
                    <thead><tr><th>#</th><th>Data from tickets.txt</th></tr></thead>
                    <tbody>
                    <% int l=1; for(String line: report.getTicketLines()){ if(!line.trim().isEmpty()){ %>
                        <tr><td><%= l++ %></td><td><%= line %></td></tr>
                    <% } } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Payments Tab -->
        <div id="tab-payments" class="tab-content">
            <% if (report.getPaymentLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-money-check-alt"></i>No payments data yet
                </div>
            <% } else { %>
                <table>
                    <thead><tr><th>#</th><th>Payment Data</th></tr></thead>
                    <tbody>
                    <% int m=1; for(String line: report.getPaymentLines()){ if(!line.trim().isEmpty()){ %>
                        <tr><td><%= m++ %></td><td><%= line %></td></tr>
                    <% } } %>
                    </tbody>
                </table>
                <div class="total-row">
                    <strong class="c-green">
                        Total: Rs.<%= String.format("%.2f", report.getTotalIncome()) %>
                    </strong>
                </div>
            <% } %>
        </div>

        <!-- Logs Tab -->
        <div id="tab-logs" class="tab-content">
            <% if (report.getLogLines().isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-file-alt"></i>No logs yet
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Vehicles</th>
                            <th>Income</th>
                            <th>Available Slots</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for(String line: report.getLogLines()){ if(!line.trim().isEmpty()){ Log log=Log.fromLine(line); if(log!=null){ %>
                        <tr>
                            <td><%= log.getDate() %></td>
                            <td><%= log.getTotalVehicles() %></td>
                            <td>Rs.<%= String.format("%.2f",log.getIncome()) %></td>
                            <td><%= log.getAvailableSlots() %></td>
                        </tr>
                    <% } } } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
</main>

<script>
function showTab(name, btn) {
    document.querySelectorAll('.tab-content')
        .forEach(t => t.classList.remove('show'));
    document.querySelectorAll('.tab-btn')
        .forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + name).classList.add('show');
    btn.classList.add('active');
}
</script>

</body>
</html>