<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyParking | Generate Ticket</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-wrap { padding: 60px 5%; display: flex; justify-content: center; }
        .form-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(26,217,240,0.2);
            border-radius: 14px; padding: 40px; width: 600px;
            animation: blurClear .6s ease both;
        }
        .form-card h2 { color: white; font-size: 1.4rem; margin-bottom: 8px; }
        .form-card p  { color: var(--text-dim); font-size: .82rem; margin-bottom: 30px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.full { grid-column: 1 / -1; }

        label { color: var(--cyan); font-size: .7rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
        input, select {
            padding: 12px 16px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 8px; color: var(--text-main);
            font-family: Montserrat,sans-serif; font-size: .88rem;
            outline: none; transition: 0.3s; width: 100%;
        }
        input:focus, select:focus { border-color: var(--cyan); box-shadow: 0 0 12px rgba(26,217,240,0.2); }
        input::placeholder { color: #2a3a55; }
        input[readonly] { opacity: 0.7; cursor: not-allowed; border-color: rgba(26,217,240,0.15); }
        select option { background: #0a1128; color: white; }

        .form-divider { border: none; border-top: 1px solid rgba(255,255,255,0.07); margin: 26px 0; }

        /* Price chart */
        .price-chart {
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 1.2rem;
            margin-bottom: 1.5rem;
        }
        .price-chart-title {
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.1em;
            color: var(--text-dim); margin-bottom: 1rem;
        }
        .price-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 10px; }
        .price-item {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 8px; padding: 0.8rem;
            text-align: center;
        }
        .price-type { font-size: 0.75rem; color: var(--text-dim); margin-bottom: 4px; }
        .price-amount { font-size: 1rem; font-weight: 800; color: var(--btn-neon); }

        /* Total amount */
        .total-box {
            background: rgba(55,255,139,0.05);
            border: 1px solid rgba(55,255,139,0.2);
            border-radius: 12px; padding: 1.2rem;
            text-align: center; margin: 1.5rem 0;
        }
        .total-label { font-size: 0.75rem; color: var(--text-dim); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 6px; }
        .total-amount { font-size: 2rem; font-weight: 800; color: var(--btn-neon); }

        .btn-generate {
            width: 100%; padding: 14px;
            background: var(--btn-neon); color: #0c1a12;
            border: 2px solid var(--btn-neon); border-radius: 20px;
            font-family: Montserrat,sans-serif; font-weight: 800;
            font-size: .95rem; cursor: pointer; transition: 0.3s;
        }
        .btn-generate:hover { transform: translateY(-3px); box-shadow: 0 0 20px var(--btn-neon); }
        .back-link { display: block; text-align: center; margin-top: 18px; color: var(--text-dim); font-size: .8rem; }
        .back-link:hover { color: var(--cyan); }

        @keyframes blurClear { from { filter:blur(8px); opacity:0; transform:translateY(10px); } to { filter:blur(0); opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> MyParking</div>
        <div class="header-controls">
            <a href="${pageContext.request.contextPath}/profile">
                <button class="btn-sm">${sessionScope.loggedInUser.name}</button>
            </a>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="btn-sm login">Log out</button>
            </a>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/slots">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/tickets" class="active">Tickets</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-wrap">
    <div class="form-card">
        <h2>&#127915; Generate Parking Ticket</h2>
        <p>Vehicle and slot details are pre-filled — just select duration to generate your ticket</p>

        <!-- Price Chart -->
        <div class="price-chart">
            <div class="price-chart-title">Rate Chart</div>
            <div class="price-grid">
                <div class="price-item">
                    <div class="price-type">Bike</div>
                    <div class="price-amount">Rs.200/hr</div>
                </div>
                <div class="price-item">
                    <div class="price-type">Three Wheeler</div>
                    <div class="price-amount">Rs.250/hr</div>
                </div>
                <div class="price-item">
                    <div class="price-type">Car</div>
                    <div class="price-amount">Rs.350/hr</div>
                </div>
                <div class="price-item">
                    <div class="price-type">Van</div>
                    <div class="price-amount">Rs.550/hr</div>
                </div>
                <div class="price-item">
                    <div class="price-type">VIP Vehicle</div>
                    <div class="price-amount">Rs.800/hr</div>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/tickets/create" method="post">

            <div class="form-grid">

                <!-- Auto-filled fields -->
                <div class="form-group">
                    <label>Vehicle ID</label>
                    <input type="text" name="vehicleId"
                           value="${param.vehicleId}"
                           readonly/>
                </div>
                <div class="form-group">
                    <label>Vehicle Number</label>
                    <input type="text" name="vehicleNumber"
                           value="${param.vehicleNumber}"
                           readonly/>
                </div>
                <div class="form-group">
                    <label>Parking Slot</label>
                    <input type="text" name="slotNumber"
                           value="${param.slotNumber}"
                           readonly/>
                </div>
                <div class="form-group">
                    <label>Slot ID</label>
                    <input type="text" name="slotId"
                           value="${param.slotId}"
                           readonly/>
                </div>

                <!-- Vehicle type for price calculation -->
                <div class="form-group full">
                    <label>Vehicle Type</label>
                    <select name="vehicleType" id="vehicleType"
                            onchange="calculateTotal()" required>
                        <option value="">-- Select Vehicle Type --</option>
                        <option value="Bike">Bike — Rs.200/hr</option>
                        <option value="Three-Wheeler">Three Wheeler — Rs.250/hr</option>
                        <option value="Car">Car — Rs.350/hr</option>
                        <option value="Van">Van — Rs.550/hr</option>
                        <option value="VIP">VIP Vehicle — Rs.800/hr</option>
                    </select>
                </div>

                <!-- Duration -->
                <div class="form-group full">
                    <label>Duration (Hours)</label>
                    <input type="number" name="hours" id="hours"
                           placeholder="e.g. 3" min="1" max="24"
                           oninput="calculateTotal()" required/>
                </div>

            </div>

            <!-- Total Amount -->
            <div class="total-box">
                <div class="total-label">Total Amount</div>
                <div class="total-amount" id="totalDisplay">Rs. 0.00</div>
                <input type="hidden" name="totalAmount" id="totalAmount" value="0"/>
            </div>

            <hr class="form-divider">
            <button type="submit" class="btn-generate">&#127915; Generate Ticket</button>
        </form>

        <a href="${pageContext.request.contextPath}/tickets" class="back-link">&#8592; Back to Ticket List</a>
    </div>
</div>

<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a>
            <a href="${pageContext.request.contextPath}/slots">Parking Slots</a>
            <a href="${pageContext.request.contextPath}/tickets">Tickets</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col contact-info">
            <strong>Contact us:</strong>
            <p>MyParking@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
</footer>

<script>
    const rates = {
        'Bike': 200,
        'Three-Wheeler': 250,
        'Car': 350,
        'Van': 550,
        'VIP': 800
    };

    function calculateTotal() {
        const type = document.getElementById('vehicleType').value;
        const hours = parseFloat(document.getElementById('hours').value) || 0;
        const rate = rates[type] || 0;
        const total = rate * hours;
        document.getElementById('totalDisplay').textContent = 'Rs. ' + total.toFixed(2);
        document.getElementById('totalAmount').value = total.toFixed(2);
    }
</script>

</body>
</html>
