<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ParkCity | Add Vehicle</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-content { padding: 2rem 5%; max-width: 900px; margin: 0 auto; }
        .slot-info-bar {
            background: rgba(26,217,240,0.08);
            border: 1px solid rgba(26,217,240,0.3);
            border-radius: 12px; padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;
        }
        .slot-badge {
            background: var(--btn-neon); color: #0a1128;
            padding: 4px 16px; border-radius: 20px;
            font-weight: 800; font-size: 1rem;
        }
        .date-badge {
            background: rgba(26,217,240,0.15); color: var(--cyan);
            padding: 4px 16px; border-radius: 20px;
            font-weight: 700; font-size: 0.85rem;
            border: 1px solid rgba(26,217,240,0.3);
        }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo"><span class="logo-icon">&#10018;</span> ParkCity</div>
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
            <li><a href="${pageContext.request.contextPath}/vehicle/list" class="active">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-content">

    <div class="page-hdr" style="margin-bottom:1.5rem;">
        <h1>Add Vehicle</h1>
        <p>Register a new vehicle in the ParkCity system</p>
    </div>

    <%-- Show slot + date info if came from slot selection --%>
    <c:if test="${not empty slotId}">
        <div class="slot-info-bar">
            <span class="slot-badge">${slotNumber}</span>
            <c:if test="${not empty date}">
                <span class="date-badge">📅 ${date}</span>
            </c:if>
            <p style="color:var(--text-dim);margin:0;">
                Adding vehicle for this slot &nbsp;·&nbsp;
                Type: <strong style="color:var(--text-main);">${slotType}</strong>
            </p>
        </div>
    </c:if>

    <div class="d-card" style="max-width:600px;">
        <form action="${pageContext.request.contextPath}/vehicle/add" method="post">

            <%-- Hidden fields — pass slot info and date through form --%>
            <input type="hidden" name="slotId"     value="${slotId}"/>
            <input type="hidden" name="slotNumber" value="${slotNumber}"/>
            <input type="hidden" name="slotType"   value="${slotType}"/>
            <input type="hidden" name="date"       value="${date}"/>
            <input type="hidden" name="userId"     value="${sessionScope.loggedInUser.id}"/>

            <div class="form-group">
                <label for="ownerName">Owner Name</label>
                <input type="text" id="ownerName" name="ownerName"
                       placeholder="e.g. John Silva" required/>
            </div>

            <div class="form-group">
                <label for="licensePlate">License Plate</label>
                <input type="text" id="licensePlate" name="licensePlate"
                       placeholder="e.g. CAB-1234"
                       oninput="this.value=this.value.toUpperCase()" required/>
            </div>

            <div class="form-group">
                <label for="vehicleType">Vehicle Type</label>
                <select id="vehicleType" name="vehicleType" required>
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
                       placeholder="e.g. 0771234567"
                       maxlength="15" required/>
            </div>

            <div style="margin-top:1.5rem; display:flex; gap:1rem;">
                <button type="submit" class="btn-update">Save Vehicle</button>
                <c:choose>
                    <c:when test="${not empty slotId}">
                        <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slotId}&slotNumber=${slotNumber}&slotType=${slotType}&date=${date}">
                            <button type="button" class="btn-danger">Cancel</button>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/vehicle/list">
                            <button type="button" class="btn-danger">Cancel</button>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

        </form>
    </div>

</div>

<footer class="layered-footer">
    <div class="footer-grid">
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="#">About</a>
            <a href="#">Help</a>
        </div>
        <div class="f-col">
            <a href="${pageContext.request.contextPath}/slots">Parking Slots</a>
            <a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
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
