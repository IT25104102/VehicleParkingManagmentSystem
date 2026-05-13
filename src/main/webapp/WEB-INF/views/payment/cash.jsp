<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Cash Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Montserrat',sans-serif;background:radial-gradient(at top left,#1e3a8a 0%,#0a1128 50%),radial-gradient(at bottom right,#0d1117 0%,#010409 60%);background-attachment:fixed;color:#f0f6fc;min-height:100vh}
        a{text-decoration:none;color:inherit}
        .main-header{width:100%;position:sticky;top:0;z-index:1000}
        .top-bar{display:flex;justify-content:space-between;align-items:center;padding:15px 5%;background:rgba(10,17,40,0.8);backdrop-filter:blur(10px)}
        .logo{font-weight:800;font-size:1.15rem}
        .logo-icon{color:#37ff8b}
        .full-width-nav{width:100%;background:#0d1117;border-bottom:2px solid #1ad9f0}
        .full-width-nav ul{display:flex;justify-content:center;list-style:none;padding:12px 0;margin:0;gap:10px}
        .full-width-nav li a{text-transform:uppercase;font-size:0.8rem;font-weight:600;padding:0 20px;color:#f0f6fc;transition:0.3s}
        .full-width-nav li a:hover,.full-width-nav li a.active{color:#37ff8b}
        .container{max-width:700px;margin:40px auto;padding:0 20px}
        .page-title{font-size:1.8rem;font-weight:800;margin-bottom:6px}
        .page-sub{color:#b8c7e0;font-size:0.85rem;margin-bottom:30px}
        .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px;transition:0.3s}
        .card:hover{border-color:rgba(26,217,240,0.25)}
        .card-title{font-size:0.75rem;font-weight:600;color:#b8c7e0;text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
        .confirm-item{display:flex;justify-content:space-between;padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.05);font-size:0.88rem}
        .confirm-item:last-child{border-bottom:none}
        .c-label{color:#b8c7e0}
        .c-val{font-weight:600}
        .badge-pending{display:inline-block;padding:4px 12px;border-radius:12px;font-size:0.75rem;font-weight:700;background:rgba(239,159,39,0.15);color:#EF9F27;border:1px solid rgba(239,159,39,0.3)}
        .info-note{background:rgba(26,217,240,0.06);border:1px solid rgba(26,217,240,0.15);border-radius:10px;padding:14px;font-size:0.8rem;color:#b8c7e0;margin-top:16px;text-align:center;line-height:1.6}
        .info-note strong{color:#1ad9f0}
        .btn-primary{width:100%;background:#37ff8b;border:none;border-radius:20px;padding:14px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;margin-top:16px;display:block;text-align:center}
        .btn-primary:hover{transform:translateY(-2px)}
        .btn-outline{width:100%;background:transparent;border:1px solid #37ff8b;border-radius:20px;padding:13px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:700;color:#37ff8b;cursor:pointer;transition:0.3s;margin-top:8px;display:block;text-align:center}
        .btn-outline:hover{background:rgba(55,255,139,0.08)}
        footer{background:rgba(13,17,23,0.8);padding:40px 5%;border-top:1px solid rgba(255,255,255,0.05);margin-top:60px}
        .footer-grid{display:flex;justify-content:center;gap:40px}
        .f-col{display:flex;flex-direction:column;font-size:0.8rem}
        .f-col a{color:#b8c7e0;padding-bottom:5px}
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Parking Slots</a></li>
            <li><a href="#">My Vehicles</a></li>
            <li><a href="#">Tickets</a></li>
            <li><a href="#" class="active">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="page-title">Confirm Booking</div>
    <div class="page-sub">Review and confirm your cash payment</div>

    <div class="card">
        <div class="card-title">Booking Confirmation</div>
        <div class="confirm-item">
            <span class="c-label">Booking ID</span>
            <span class="c-val">${payment.id}</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Ticket ID</span>
            <span class="c-val">${payment.ticketId}</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Amount</span>
            <span class="c-val" style="color:#37ff8b;font-size:1.1rem">
                Rs. ${payment.amount}
            </span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Payment Method</span>
            <span class="c-val">&#128181; Cash</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Status</span>
            <span class="c-val">
                <span class="badge-pending">Pending</span>
            </span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Date</span>
            <span class="c-val">${payment.createdAt}</span>
        </div>
    </div>

    <div class="info-note">
        &#128680; Please pay <strong>Rs. ${payment.amount}</strong>
        at the parking counter when you arrive.
        Show your QR ticket to the officer.
    </div>

    <form method="post" action="/payment/confirmCash">
        <input type="hidden" name="id" value="${payment.id}"/>
        <button type="submit" class="btn-primary">
            Confirm &amp; Generate Ticket &rarr;
        </button>
    </form>

    <a href="/payment/history" class="btn-outline">&larr; Back</a>
</div>

<footer>
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col">
            <a href="#">ParkCity@gmail.com</a>
            <a href="#">0712345678</a>
        </div>
    </div>
</footer>

</body>
</html>
