<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyParking | Payment</title>
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
        .amount-badge{text-align:center;padding:20px 0}
        .amount-badge .total-label{font-size:0.8rem;color:#b8c7e0;margin-bottom:6px}
        .amount-badge .total-amt{font-size:2.5rem;font-weight:800;color:#37ff8b}
        .pay-options{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-top:10px}
        .pay-btn{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:24px;text-align:center;cursor:pointer;transition:0.3s;text-decoration:none;display:block}
        .pay-btn:hover{border-color:#37ff8b;background:rgba(55,255,139,0.06);transform:translateY(-3px)}
        .pay-icon{font-size:2rem;margin-bottom:10px}
        .pay-label{font-size:1rem;font-weight:700;color:#f0f6fc}
        .pay-desc{font-size:0.75rem;color:#b8c7e0;margin-top:4px}
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
        <div class="logo"><span class="logo-icon">&#10018;</span> MyParking</div>
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
    <div class="page-title">Payment</div>
    <div class="page-sub">Choose your preferred payment method</div>

    <div class="card">
        <div class="amount-badge">
            <div class="total-label">Total Amount to Pay</div>
            <div class="total-amt">Rs. ${payment.amount}</div>
        </div>
    </div>

    <div class="card">
        <div class="card-title">Select Payment Method</div>
        <div class="pay-options">
            <a href="/payment/cash?id=${payment.id}" class="pay-btn">
                <div class="pay-icon">&#128181;</div>
                <div class="pay-label">Cash</div>
                <div class="pay-desc">Pay at counter</div>
            </a>
            <a href="/payment/card?id=${payment.id}" class="pay-btn">
                <div class="pay-icon">&#128179;</div>
                <div class="pay-label">Card</div>
                <div class="pay-desc">Debit / Credit</div>
            </a>
        </div>
    </div>

    <a href="/payment/create" class="btn-outline">&larr; Back</a>
</div>

<footer>
    <div class="footer-grid">
        <div class="f-col">
            <a href="#">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col">
            <a href="#">MyParking@gmail.com</a>
            <a href="#">0712345678</a>
        </div>
    </div>
</footer>

</body>
</html>