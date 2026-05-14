<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyParking | Ticket Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root { --text-main:#f0f6fc; --text-dim:#b8c7e0; --btn-neon:#37ff8b; --cyan:#1ad9f0; --orange:#f0a500; --red:#ff4d6d; }
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:Montserrat,sans-serif; color:var(--text-main);
               background:radial-gradient(at top left,#1e3a8a 0%,#0a1128 50%),radial-gradient(at bottom right,#0d1117 0%,#010409 60%);
               background-attachment:fixed; min-height:100vh; }
        a { text-decoration:none; color:inherit; transition:0.3s; }

        /* Header */
        .main-header { width:100%; z-index:1000; position:sticky; top:0; }
        .top-bar { display:flex; justify-content:space-between; align-items:center; padding:15px 5%; background:rgba(10,17,40,0.8); backdrop-filter:blur(10px); }
        .logo { font-weight:800; font-size:1.15rem; }
        .logo-icon { color:var(--cyan); margin-right:6px; }
        .header-controls { display:flex; gap:10px; }
        .btn-sm { padding:5px 18px; font-size:0.7rem; font-weight:700; border-radius:15px; background:transparent; border:1px solid var(--btn-neon); color:var(--btn-neon); cursor:pointer; font-family:Montserrat,sans-serif; transition:0.3s; }
        .btn-sm.login:hover { background:var(--btn-neon); color:#0c1a12; }
        .full-width-nav { width:100%; background:#0d1117; border-bottom:2px solid var(--cyan); box-shadow:0 4px 15px rgba(0,0,0,0.3); }
        .full-width-nav ul { display:flex; justify-content:center; list-style:none; padding:12px 0; }
        .full-width-nav li a { text-transform:uppercase; font-size:0.8rem; font-weight:600; padding:0 20px; }
        .full-width-nav li a:hover, .full-width-nav li a.active { color:var(--btn-neon); text-shadow:0 0 10px var(--btn-neon); }

        /* Page */
        .page-wrap { padding:60px 5%; display:flex; justify-content:center; }

        /* Card */
        .detail-card { background:rgba(255,255,255,0.03); border:1px solid rgba(26,217,240,0.2); border-radius:14px; padding:40px; width:560px; animation:blurClear .6s ease both; }
        .detail-card:hover { background:rgba(255,255,255,0.05); border-color:rgba(26,217,240,0.4); box-shadow:0 10px 30px rgba(0,0,0,0.3); }

        .card-header { text-align:center; margin-bottom:28px; }
        .card-header h2 { color:white; font-size:1.4rem; margin-bottom:6px; }
        .card-header p  { color:var(--text-dim); font-size:.8rem; }

        /* Ticket ID Banner */
        .ticket-banner { text-align:center; background:rgba(26,217,240,0.05); border:1px dashed rgba(26,217,240,0.3); border-radius:10px; padding:16px; margin-bottom:28px; }
        .ticket-banner span { color:var(--cyan); font-size:1.1rem; font-weight:800; letter-spacing:2px; font-family:monospace; }

        /* Info Grid */
        .info-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:28px; }
        .info-box { background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:16px; transition:0.3s; }
        .info-box:hover { background:rgba(255,255,255,0.05); }
        .info-box .lbl { color:var(--cyan); font-size:.68rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; margin-bottom:8px; }
        .info-box .val { color:var(--text-main); font-size:.9rem; font-weight:600; }
        .val-slot   { color:var(--orange); }
        .val-active { color:var(--btn-neon); }
        .val-voided { color:var(--red); }
        .val-muted  { color:var(--text-dim); font-style:italic; }

        .divider { border:none; border-top:1px solid rgba(255,255,255,0.07); margin:22px 0; }

        /* Action Buttons */
        .action-row { display:flex; gap:12px; }
        .btn-act { flex:1; padding:12px; border:none; border-radius:20px; font-family:Montserrat,sans-serif; font-weight:800; font-size:.82rem; cursor:pointer; transition:0.3s; text-decoration:none; text-align:center; display:inline-block; }
        .btn-act:hover { transform:translateY(-2px); }
        .btn-edit-act { background:var(--orange); color:#0c1a12; }
        .btn-void-act { background:var(--red);    color:white; }
        .btn-edit-act:hover { box-shadow:0 0 15px var(--orange); }
        .btn-void-act:hover { box-shadow:0 0 15px var(--red); }

        .back-link { display:block; text-align:center; margin-top:18px; color:var(--text-dim); font-size:.8rem; }
        .back-link:hover { color:var(--cyan); }

        /* Footer */
        footer { background:rgba(13,17,23,0.8); padding:40px 5%; border-top:1px solid rgba(255,255,255,0.05); margin-top:60px; }
        .footer-grid { display:flex; justify-content:center; gap:40px; }
        .f-col { display:flex; flex-direction:column; font-size:0.8rem; }
        .f-col a { color:var(--text-dim); padding-bottom:5px; }
        .f-col a:hover { color:var(--btn-neon); }
        .contact-info { color:var(--text-dim); }

        @keyframes blurClear { from { filter:blur(8px); opacity:0; transform:translateY(10px); } to { filter:blur(0); opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> MyParking</div>
        <div class="header-controls">
            <button class="btn-sm">Sign up</button>
            <button class="btn-sm login">Log in</button>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Parking Slots</a></li>
            <li><a href="#">My Vehicles</a></li>
            <li><a href="/tickets" class="active">Tickets</a></li>
            <li><a href="#">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-wrap">
    <div class="detail-card">

        <div class="card-header">
            <h2>&#127915; Ticket Details</h2>
            <p>Full information for this parking ticket</p>
        </div>

        <div class="ticket-banner">
            <span>${ticket.id}</span>
        </div>

        <div class="info-grid">
            <div class="info-box">
                <div class="lbl">Vehicle Number</div>
                <div class="val">${ticket.vehicleNumber}</div>
            </div>
            <div class="info-box">
                <div class="lbl">Vehicle ID</div>
                <div class="val">${ticket.vehicleId}</div>
            </div>
            <div class="info-box">
                <div class="lbl">Parking Slot</div>
                <div class="val val-slot">&#128205; ${ticket.slotId}</div>
            </div>
            <div class="info-box">
                <div class="lbl">Status</div>
                <div class="val ${ticket.status == 'ACTIVE' ? 'val-active' : 'val-voided'}">
                    ${ticket.status}
                </div>
            </div>
            <div class="info-box">
                <div class="lbl">Check-In Time</div>
                <div class="val">${ticket.checkInTime}</div>
            </div>
            <div class="info-box">
                <div class="lbl">Check-Out Time</div>
                <div class="val ${empty ticket.checkOutTime ? 'val-muted' : ''}">
                    ${not empty ticket.checkOutTime ? ticket.checkOutTime : 'Still Parked'}
                </div>
            </div>
            <div class="info-box">
                <div class="lbl">Created At</div>
                <div class="val">${ticket.createdAt}</div>
            </div>
        </div>

        <hr class="divider">

        <div class="action-row">
            <a href="/tickets/${ticket.id}/edit" class="btn-act btn-edit-act">&#128260; Edit Slot</a>
            <form action="/tickets/${ticket.id}/void" method="post" style="flex:1"
                  onsubmit="return confirm('Are you sure you want to void this ticket?')">
                <button type="submit" class="btn-act btn-void-act" style="width:100%">
                    &#128465; Void Ticket
                </button>
            </form>
        </div>

        <a href="/tickets" class="back-link">&#8592; Back to Ticket List</a>
    </div>
</div>

<footer>
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">My Vehicles</a>
            <a href="#">Parking Slots</a>
            <a href="#">Tickets</a>
            <a href="#">Payments</a>
        </div>
        <div class="footer-grid">
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
    </div>
</footer>
</body>
</html>