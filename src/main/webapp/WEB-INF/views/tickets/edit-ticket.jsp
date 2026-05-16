<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Reassign Slot</title>
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
        .edit-card { background:rgba(255,255,255,0.03); border:1px solid rgba(26,217,240,0.2); border-radius:14px; padding:40px; width:540px; animation:blurClear .6s ease both; }
        .edit-card:hover { background:rgba(255,255,255,0.05); border-color:rgba(26,217,240,0.4); box-shadow:0 10px 30px rgba(0,0,0,0.3); }

        .card-header { text-align:center; margin-bottom:28px; }
        .card-header h2 { color:white; font-size:1.4rem; margin-bottom:6px; }
        .card-header p  { color:var(--text-dim); font-size:.8rem; }

        /* Current Info */
        .current-info { background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:20px; margin-bottom:24px; }
        .info-row { display:flex; justify-content:space-between; align-items:center; padding:8px 0; border-bottom:1px solid rgba(255,255,255,0.05); font-size:.82rem; }
        .info-row:last-child { border-bottom:none; }
        .info-row .key { color:var(--cyan); font-weight:700; font-size:.7rem; letter-spacing:.8px; text-transform:uppercase; }
        .info-row .val { color:var(--text-main); font-weight:600; }
        .info-row .val-slot { color:var(--orange); font-weight:800; }

        /* Arrow */
        .arrow-down { text-align:center; color:var(--btn-neon); font-size:1.6rem; margin:20px 0; }

        /* Form */
        .form-group { display:flex; flex-direction:column; gap:8px; margin-bottom:22px; }
        label { color:var(--cyan); font-size:.7rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; }
        input { padding:12px 16px; background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08); border-radius:8px; color:var(--text-main); font-family:Montserrat,sans-serif; font-size:.88rem; outline:none; transition:0.3s; }
        input:focus { border-color:var(--cyan); box-shadow:0 0 12px rgba(26,217,240,0.2); }
        input::placeholder { color:#2a3a55; }

        .divider { border:none; border-top:1px solid rgba(255,255,255,0.07); margin:22px 0; }

        /* Buttons */
        .btn-row { display:flex; gap:12px; }
        .btn-update { flex:1; padding:13px; background:var(--orange); color:#0c1a12; border:2px solid var(--orange); border-radius:20px; font-family:Montserrat,sans-serif; font-weight:800; font-size:.92rem; cursor:pointer; transition:0.3s; }
        .btn-update:hover { transform:translateY(-3px); box-shadow:0 0 20px var(--orange); }

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
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
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
    <div class="edit-card">

        <div class="card-header">
            <h2>&#128260; Reassign Parking Slot</h2>
            <p>Move vehicle to a different parking slot</p>
        </div>

        <!-- Current Ticket Info -->
        <div class="current-info">
            <div class="info-row">
                <span class="key">Ticket ID</span>
                <span class="val">${ticket.id}</span>
            </div>
            <div class="info-row">
                <span class="key">Vehicle Number</span>
                <span class="val">${ticket.vehicleNumber}</span>
            </div>
            <div class="info-row">
                <span class="key">Vehicle ID</span>
                <span class="val">${ticket.vehicleId}</span>
            </div>
            <div class="info-row">
                <span class="key">Current Slot</span>
                <span class="val val-slot">&#128205; ${ticket.slotId}</span>
            </div>
        </div>

        <!-- Arrow -->
        <div class="arrow-down">&#8659; Assign New Slot</div>

        <!-- Update Form -->
        <form action="/tickets/${ticket.id}/update" method="post">
            <div class="form-group">
                <label>New Slot ID</label>
                <input type="text" name="newSlotId"
                       placeholder="e.g. S-05B" required/>
            </div>

            <hr class="divider">

            <div class="btn-row">
                <button type="submit" class="btn-update">
                    &#128260; Update Slot
                </button>
            </div>
        </form>

        <a href="/tickets" class="back-link">&#8592; Cancel &amp; Go Back</a>
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
                <p>ParkCity@gmail.com</p>
                <p>0712345678</p>
            </div>
        </div>
    </div>
</footer>
</body>
</html>
