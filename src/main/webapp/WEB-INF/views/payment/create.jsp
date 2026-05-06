<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyParking | Amount Summary</title>
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
        .summary-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.05);font-size:0.9rem}
        .summary-row:last-child{border-bottom:none}
        .summary-row .label{color:#b8c7e0}
        .summary-row .value{font-weight:600;color:#f0f6fc}
        .total-row{display:flex;justify-content:space-between;align-items:center;padding:16px 0 0}
        .total-row .label{color:#b8c7e0;font-weight:600;font-size:1rem}
        .total-row .value{font-size:1.5rem;font-weight:800;color:#37ff8b}
        .rate-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:10px}
        .rate-card{background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:10px;padding:14px;text-align:center;cursor:pointer;transition:0.3s}
        .rate-card.active{border-color:#37ff8b;background:rgba(55,255,139,0.06)}
        .rate-card .vtype{font-size:0.75rem;color:#b8c7e0;margin-bottom:4px}
        .rate-card .vrate{font-size:1rem;font-weight:700;color:#37ff8b}
        .form-group{margin-bottom:16px}
        .form-group label{display:block;font-size:0.75rem;color:#b8c7e0;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.5px}
        .form-group input,.form-group select{width:100%;background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:8px;padding:12px 14px;color:#f0f6fc;font-family:'Montserrat',sans-serif;font-size:0.9rem;outline:none;transition:0.3s}
        .form-group input:focus,.form-group select:focus{border-color:#1ad9f0}
        .form-group select option{background:#0a1128}
        .form-group input::placeholder{color:rgba(255,255,255,0.2)}
        .total-display{background:rgba(55,255,139,0.06);border:1px solid rgba(55,255,139,0.2);border-radius:10px;padding:16px;text-align:center;margin-bottom:16px}
        .total-display .t-label{font-size:0.75rem;color:#b8c7e0;margin-bottom:4px}
        .total-display .t-amount{font-size:2rem;font-weight:800;color:#37ff8b}
        .btn-primary{width:100%;background:#37ff8b;border:none;border-radius:20px;padding:14px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;margin-top:10px}
        .btn-primary:hover{transform:translateY(-2px)}
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
    <div class="page-title">Booking Summary</div>
    <div class="page-sub">Fill in your booking details to calculate payment</div>

    <div class="card">
        <div class="card-title">Rate Chart</div>
        <div class="rate-grid">
            <div class="rate-card" onclick="selectRate('BIKE',200)">
                <div class="vtype">Bike</div>
                <div class="vrate">Rs.200/hr</div>
            </div>
            <div class="rate-card" onclick="selectRate('THREE WHEELER',250)">
                <div class="vtype">Three Wheeler</div>
                <div class="vrate">Rs.250/hr</div>
            </div>
            <div class="rate-card" onclick="selectRate('CAR',350)">
                <div class="vtype">Car</div>
                <div class="vrate">Rs.350/hr</div>
            </div>
            <div class="rate-card" onclick="selectRate('VAN',550)">
                <div class="vtype">Van</div>
                <div class="vrate">Rs.550/hr</div>
            </div>
            <div class="rate-card" onclick="selectRate('VIP',800)">
                <div class="vtype">VIP Vehicle</div>
                <div class="vrate">Rs.800/hr</div>
            </div>
        </div>
    </div>

    <form method="post" action="/payment/create" onsubmit="return validateForm()">

        <div class="card">
            <div class="card-title">Booking Details</div>

            <div class="form-group">
                <label>Ticket ID</label>
                <input type="text" name="ticketId"
                       placeholder="e.g. TKT001" required>
            </div>

            <div class="form-group">
                <label>Vehicle Number</label>
                <input type="text" name="vehicleNumber"
                       placeholder="e.g. CAB-2341">
            </div>

            <div class="form-group">
                <label>Vehicle Type</label>
                <select name="vehicleType" id="vehicleType"
                        onchange="updateRateFromSelect(this)">
                    <option value="BIKE">Bike — Rs.200/hr</option>
                    <option value="THREE WHEELER">Three Wheeler — Rs.250/hr</option>
                    <option value="CAR" selected>Car — Rs.350/hr</option>
                    <option value="VAN">Van — Rs.550/hr</option>
                    <option value="VIP">VIP Vehicle — Rs.800/hr</option>
                </select>
            </div>

            <div class="form-group">
                <label>Slot Number</label>
                <input type="text" name="slot"
                       placeholder="e.g. A-04">
            </div>

            <div class="form-group">
                <label>Booking Date</label>
                <input type="date" name="date" required>
            </div>

            <div class="form-group">
                <label>Duration (hours)</label>
                <input type="number" name="hours" id="hours"
                       min="1" max="24" step="0.5"
                       placeholder="e.g. 3"
                       oninput="calculateTotal()" required>
            </div>
        </div>

        <div class="total-display">
            <div class="t-label">Total Amount</div>
            <div class="t-amount" id="totalDisplay">Rs. 0.00</div>
        </div>

        <button type="submit" class="btn-primary">
            Proceed to Payment &rarr;
        </button>

    </form>
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

<script>
var rates = {
    'BIKE': 200,
    'THREE WHEELER': 250,
    'CAR': 350,
    'VAN': 550,
    'VIP': 800
};
var currentRate = 350;

function selectRate(type, rate) {
    currentRate = rate;
    document.getElementById('vehicleType').value = type;
    document.querySelectorAll('.rate-card').forEach(function(c){
        c.classList.remove('active');
    });
    event.currentTarget.classList.add('active');
    calculateTotal();
}

function updateRateFromSelect(select) {
    currentRate = rates[select.value];
    calculateTotal();
}

function calculateTotal() {
    var hours = parseFloat(
        document.getElementById('hours').value) || 0;
    var total = hours * currentRate;
    document.getElementById('totalDisplay').textContent =
        'Rs. ' + total.toFixed(2);
}

function validateForm() {
    var hours = document.getElementById('hours').value;
    if (!hours || parseFloat(hours) <= 0) {
        alert('Please enter valid duration in hours!');
        return false;
    }
    return true;
}
</script>

</body>
</html>
