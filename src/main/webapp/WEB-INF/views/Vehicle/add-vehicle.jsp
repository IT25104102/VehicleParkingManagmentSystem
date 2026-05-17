<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyParking | Add Vehicle</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> MyParking</div>
        <div class="header-controls">
            <a href="${pageContext.request.contextPath}/profile">
                <button class="btn-sm">${user.name}</button>
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
            <li><a href="${pageContext.request.contextPath}/vehicle/list" class="active">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<main style="padding: 2rem 5%; max-width: 1400px; margin: 0 auto;">

    <div style="font-size:0.8rem; color:var(--text-dim); margin-bottom:1.5rem;">
        <a href="${pageContext.request.contextPath}/vehicle/list" style="color:var(--btn-neon);">Vehicle Registry</a>
        &nbsp;›&nbsp; Add Vehicle
    </div>

    <div class="page-hdr">
        <h1>Add Vehicle</h1>
        <p>Register a new vehicle in the MyParking system</p>
    </div>

    <div class="d-card" style="max-width:600px;">
        <form action="${pageContext.request.contextPath}/vehicle/add" method="post">

            <div class="form-group">
                <label for="ownerName">Owner Name</label>
                <input type="text" id="ownerName" name="ownerName"
                       class="form-control" placeholder="e.g. John Silva" required>
            </div>

            <div class="form-group">
                <label for="licensePlate">License Plate</label>
                <input type="text" id="licensePlate" name="licensePlate"
                       class="form-control" placeholder="e.g. CAB-1234"
                       oninput="this.value=this.value.toUpperCase()" required>
            </div>

            <div class="form-group">
                <label for="vehicleType">Vehicle Type</label>
                <select id="vehicleType" name="vehicleType" class="form-control" required>
                    <option value="">-- Select Type --</option>
                    <option value="Car">Car</option>
                    <option value="Bike">Bike</option>
                    <option value="Van">Van</option>
                    <option value="Three-Wheeler">Three-Wheeler</option>
                </select>
            </div>

            <div class="form-group">
                <label for="contactNumber">Contact Number</label>
                <input type="text" id="contactNumber" name="contactNumber"
                       class="form-control" placeholder="e.g. 0771234567"
                       maxlength="15" required>
            </div>

            <!-- userId from session -->
            <input type="hidden" name="userId" value="${sessionScope.loggedInUser.id}"/>

            <div style="margin-top:1.5rem; display:flex; gap:1rem;">
                <button type="submit" class="btn-update">Save Vehicle</button>
                <a href="${pageContext.request.contextPath}/vehicle/list">
                    <button type="button" class="btn-danger">Cancel</button>
                </a>
            </div>

        </form>
    </div>

</main>

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

</body>
</html>
