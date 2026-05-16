<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Add Vehicle</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-deep: #0a1128;
            --text-main: #f0f6fc;
            --text-dim: #b8c7e0;
            --btn-neon: #37ff8b;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Montserrat', sans-serif;
            color: var(--text-main);
            background: radial-gradient(at top left, #1e3a8a 0%, #0a1128 50%),
            radial-gradient(at bottom right, #0d1117 0%, #010409 60%);
            background-attachment: fixed;
            min-height: 100vh;
        }
        a { text-decoration: none; color: inherit; transition: 0.3s; }

        .main-header { width: 100%; position: sticky; top: 0; z-index: 1000; }
        .top-bar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 5%; background: rgba(10,17,40,0.85); backdrop-filter: blur(10px);
        }
        .logo { font-weight: 800; font-size: 1.15rem; }
        .logo span { color: var(--btn-neon); }
        .header-controls { display: flex; gap: 10px; }
        .btn-sm {
            padding: 5px 18px; font-size: 0.7rem; font-weight: 700;
            border-radius: 15px; background: transparent;
            border: 1px solid var(--btn-neon); color: var(--btn-neon);
            cursor: pointer; font-family: 'Montserrat', sans-serif;
        }
        .btn-sm:hover { background: var(--btn-neon); color: #0c1a12; }
        .full-width-nav {
            width: 100%; background: #0d1117;
            border-bottom: 2px solid #1ad9f0;
        }
        .full-width-nav ul {
            display: flex; justify-content: center; list-style: none;
            padding: 12px 0; margin: 0;
        }
        .full-width-nav li a {
            text-transform: uppercase; font-size: 0.8rem;
            font-weight: 600; padding: 0 20px; color: var(--text-dim);
        }
        .full-width-nav li a:hover,
        .full-width-nav li a.active { color: var(--btn-neon); text-shadow: 0 0 10px var(--btn-neon); }

        .page-content { padding: 50px 5%; max-width: 1400px; margin: 0 auto; }
        .breadcrumb { font-size: 0.8rem; color: var(--text-dim); margin-bottom: 1.5rem; }
        .breadcrumb a { color: var(--btn-neon); }
        .breadcrumb span { margin: 0 0.5rem; color: #444; }

        .page-title { font-size: 2.5rem; font-weight: 800; margin-bottom: 0.3rem; }
        .page-title span { color: var(--btn-neon); }
        .page-subtitle { color: var(--text-dim); font-size: 0.9rem; margin-bottom: 2rem; }

        .form-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px; padding: 2rem; max-width: 600px;
        }
        .form-group { margin-bottom: 1.2rem; }
        .form-label {
            display: block; color: var(--text-dim); font-size: 0.72rem;
            letter-spacing: 1.5px; text-transform: uppercase;
            font-weight: 600; margin-bottom: 0.5rem;
        }
        .form-control, .form-select {
            width: 100%; background: rgba(10,17,40,0.8);
            border: 1px solid rgba(26,217,240,0.2);
            color: white; border-radius: 8px; padding: 0.6rem 1rem;
            font-size: 0.85rem; font-family: 'Montserrat', sans-serif;
        }
        .form-control:focus, .form-select:focus {
            outline: none; border-color: var(--btn-neon);
            box-shadow: 0 0 0 2px rgba(55,255,139,0.15);
        }
        .form-control::placeholder { color: #555; }
        .form-select option { background: #0a1128; color: white; }

        .btn-save {
            background: var(--btn-neon); border: none; color: #000;
            padding: 0.6rem 2rem; border-radius: 20px;
            font-weight: 800; font-size: 0.85rem; cursor: pointer;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-save:hover { box-shadow: 0 0 15px var(--btn-neon); }
        .btn-cancel {
            background: transparent; border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-dim); padding: 0.6rem 2rem; border-radius: 20px;
            font-size: 0.85rem; margin-left: 0.8rem;
            font-family: 'Montserrat', sans-serif;
        }
        .btn-cancel:hover { border-color: #1ad9f0; color: white; }

        footer {
            background: rgba(13,17,23,0.8); padding: 40px 5%;
            border-top: 1px solid rgba(255,255,255,0.05); margin-top: 4rem;
        }
        .footer-grid { display: flex; justify-content: center; gap: 40px; }
        .f-col { display: flex; flex-direction: column; font-size: 0.8rem; }
        .f-col a { color: var(--text-dim); padding-bottom: 5px; }
        .f-col a:hover { color: var(--btn-neon); }
        .contact-info { color: var(--text-dim); }
        .contact-info p { margin: 3px 0; }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
        <div class="header-controls">
            <button class="btn-sm">Sign up</button>
            <button class="btn-sm">Log in</button>
        </div>
    </div>
    <nav class="full-width-nav">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/?action=list" class="active">My Vehicles</a></li>
            <li><a href="#">Tickets</a></li>
            <li><a href="#">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/vehicle/?action=list">Vehicle Registry</a>
        <span>›</span> Add Vehicle
    </div>

    <div class="page-title">Add <span>Vehicle</span></div>
    <div class="page-subtitle">Register a new vehicle in the ParkCity system</div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/vehicle/" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label class="form-label">Owner Name</label>
                <input type="text" name="ownerName" class="form-control"
                       placeholder="e.g. John Silva" required>
            </div>

            <div class="form-group">
                <label class="form-label">License Plate</label>
                <input type="text" name="licensePlate" class="form-control"
                       placeholder="e.g. CAB-1234"
                       oninput="this.value=this.value.toUpperCase()" required>
            </div>

            <div class="form-group">
                <label class="form-label">Vehicle Type</label>
                <select name="vehicleType" class="form-select" required>
                    <option value="">-- Select Type --</option>
                    <option value="Car">Car</option>
                    <option value="Bike">Bike</option>
                    <option value="Van">Van</option>
                    <option value="Bus">Bus</option>
                    <option value="Truck">Truck</option>
                    <option value="Three-Wheeler">Three-Wheeler</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Contact Number</label>
                <input type="text" name="contactNumber" class="form-control"
                       placeholder="e.g. 0771234567" maxlength="15" required>
            </div>

            <div class="form-group">
                <label class="form-label">Authorization Status</label>
                <select name="status" class="form-select" required>
                    <option value="Authorized">Authorized</option>
                    <option value="Unauthorized">Unauthorized</option>
                </select>
            </div>

            <div style="margin-top: 1.5rem;">
                <button type="submit" class="btn-save">Save Vehicle</button>
                <a href="${pageContext.request.contextPath}/vehicle/?action=list" class="btn-cancel">Cancel</a>
            </div>
        </form>
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
</footer>

</body>
</html>
