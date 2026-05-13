<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Card Payment</title>
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
        .amount-badge{text-align:center;padding:20px 0}
        .amount-badge .total-label{font-size:0.8rem;color:#b8c7e0;margin-bottom:6px}
        .amount-badge .total-amt{font-size:2.5rem;font-weight:800;color:#37ff8b}
        .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px;transition:0.3s}
        .card:hover{border-color:rgba(26,217,240,0.25)}
        .card-title{font-size:0.75rem;font-weight:600;color:#b8c7e0;text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
        .form-group{margin-bottom:16px}
        .form-group label{display:block;font-size:0.75rem;color:#b8c7e0;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.5px}
        .form-group input{width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:8px;padding:12px 14px;color:#f0f6fc;font-family:'Montserrat',sans-serif;font-size:0.9rem;outline:none;transition:0.3s}
        .form-group input:focus{border-color:#1ad9f0}
        .form-group input::placeholder{color:rgba(255,255,255,0.2)}
        .form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
        .card-preview{background:linear-gradient(135deg,#1e3a8a,#0a1128);border:1px solid rgba(26,217,240,0.3);border-radius:14px;padding:24px;margin-bottom:20px;position:relative;min-height:140px}
        .card-preview .card-chip{width:36px;height:28px;background:rgba(239,159,39,0.6);border-radius:5px;margin-bottom:20px}
        .card-preview .card-num{font-size:1rem;font-weight:600;letter-spacing:3px;color:#f0f6fc;margin-bottom:16px}
        .card-preview .card-info{display:flex;justify-content:space-between;font-size:0.75rem;color:#b8c7e0}
        .card-preview .card-logo{position:absolute;top:20px;right:20px;font-size:1.5rem}
        .btn-primary{width:100%;background:#37ff8b;border:none;border-radius:20px;padding:14px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;margin-top:10px}
        .btn-primary:hover{transform:translateY(-2px)}
        .btn-outline{width:100%;background:transparent;border:1px solid #37ff8b;border-radius:20px;padding:13px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:700;color:#37ff8b;cursor:pointer;transition:0.3s;margin-top:8px;display:block;text-align:center}
        .btn-outline:hover{background:rgba(55,255,139,0.08)}
        .secure-note{display:flex;align-items:center;justify-content:center;gap:8px;font-size:0.75rem;color:#b8c7e0;margin-top:12px}
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
    <div class="page-title">Card Payment</div>
    <div class="page-sub">Enter your card details to complete payment</div>

    <div class="card">
        <div class="amount-badge">
            <div class="total-label">Amount to Pay</div>
            <div class="total-amt">Rs. ${payment.amount}</div>
        </div>
    </div>

    <!-- Card Preview -->
    <div class="card-preview">
        <div class="card-logo">&#128179;</div>
        <div class="card-chip"></div>
        <div class="card-num" id="preview-num">**** **** **** ****</div>
        <div class="card-info">
            <div>
                <div style="font-size:0.65rem;margin-bottom:2px">Card Holder</div>
                <div id="preview-name">YOUR NAME</div>
            </div>
            <div>
                <div style="font-size:0.65rem;margin-bottom:2px">Expires</div>
                <div id="preview-expiry">MM/YY</div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-title">Card Details</div>
        <div class="form-group">
            <label>Card Number</label>
            <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456"
                   maxlength="19" oninput="formatCard(this)">
        </div>
        <div class="form-group">
            <label>Cardholder Name</label>
            <input type="text" id="cardName" placeholder="Name on card"
                   oninput="updatePreviewName(this)">
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Expiry Date</label>
                <input type="text" id="cardExpiry" placeholder="MM/YY"
                       maxlength="5" oninput="formatExpiry(this)">
            </div>
            <div class="form-group">
                <label>CVV</label>
                <input type="password" id="cardCvv" placeholder="***" maxlength="3">
            </div>
        </div>
    </div>

    <form method="post" action="/payment/confirmCard" id="cardForm">
        <input type="hidden" name="id" value="${payment.id}"/>
        <input type="hidden" name="cardNumber" id="hiddenCard"/>
        <input type="hidden" name="cardName" id="hiddenName"/>
        <button type="button" class="btn-primary" onclick="processPayment()">
            &#128274; Pay Rs. ${payment.amount} &rarr;
        </button>
    </form>

    <div class="secure-note">&#128274; Secured payment — card details are not stored</div>

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

<script>
function formatCard(input) {
    var v = input.value.replace(/\D/g,'').substring(0,16);
    input.value = v.replace(/(.{4})/g,'$1 ').trim();
    var preview = v.padEnd(16,'*');
    document.getElementById('preview-num').textContent =
        preview.replace(/(.{4})/g,'$1 ').trim();
}

function updatePreviewName(input) {
    var name = input.value.toUpperCase() || 'YOUR NAME';
    document.getElementById('preview-name').textContent = name;
}

function formatExpiry(input) {
    var v = input.value.replace(/\D/g,'');
    if(v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2,4);
    input.value = v;
    document.getElementById('preview-expiry').textContent = v || 'MM/YY';
}

function processPayment() {
    var num = document.getElementById('cardNumber').value;
    var name = document.getElementById('cardName').value;
    var expiry = document.getElementById('cardExpiry').value;
    var cvv = document.getElementById('cardCvv').value;

    if(!num || !name || !expiry || !cvv) {
        alert('Please fill in all card details!');
        return;
    }
    if(num.replace(/\s/g,'').length < 16) {
        alert('Please enter a valid 16-digit card number!');
        return;
    }
    if(cvv.length < 3) {
        alert('Please enter a valid CVV!');
        return;
    }

    document.getElementById('hiddenCard').value = num;
    document.getElementById('hiddenName').value = name;
    document.getElementById('cardForm').submit();
}
</script>

</body>
</html>
