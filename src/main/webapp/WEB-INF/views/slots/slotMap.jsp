<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Slot Map — MyParking</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .page-container { padding: 2rem 5%; max-width: 1400px; margin: 0 auto; }
        .page-title { font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin: 0 0 0.3rem; }
        .page-subtitle { color: var(--text-dim); font-size: 0.82rem; margin-bottom: 1.5rem; }

        .zone-label {
            font-size: 0.72rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 0.12em;
            color: var(--cyan); margin: 28px 0 10px 4px;
            display: flex; align-items: center; gap: 8px;
        }
        .zone-label::after {
            content: ''; flex: 1; height: 1px;
            background: rgba(26,217,240,0.2);
        }

        .parking-lot {
            background: rgba(13,21,48,0.6);
            border: 1px solid rgba(26,217,240,0.2);
            border-radius: 14px; padding: 24px;
        }

        .zone-row { display: grid; gap: 10px; margin-bottom: 8px; }
        .zone-row.cars,
        .zone-row.vans-vip,
        .zone-row.threewheelers,
        .zone-row.bikes { grid-template-columns: repeat(10, 1fr); }

        .slot-cell {
            border-radius: 8px; text-align: center; border: 2px solid;
            cursor: pointer; transition: transform 0.18s, box-shadow 0.18s;
            position: relative; display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            user-select: none; text-decoration: none;
        }
        .slot-cell:hover { transform: translateY(-3px) scale(1.05); }

        .slot-car   { padding: 10px 4px 8px; min-height: 80px; }
        .slot-van   { padding: 12px 4px 10px; min-height: 95px; border-radius: 10px; }
        .slot-vip   { padding: 12px 4px 10px; min-height: 95px; border-radius: 10px; }
        .slot-three { padding: 8px 4px 6px; min-height: 72px; }
        .slot-bike  { padding: 6px 4px 5px; min-height: 62px; }

        .slot-cell.available {
            background: rgba(55,255,139,0.07);
            border-color: #37ff8b;
            box-shadow: 0 0 8px rgba(55,255,139,0.15);
        }
        .slot-cell.occupied {
            background: rgba(255,76,76,0.07);
            border-color: #ff4c4c;
            box-shadow: 0 0 8px rgba(255,76,76,0.15);
            cursor: default;
        }
        .slot-cell.pending {
            background: rgba(255,215,0,0.07);
            border-color: #ffd700;
            box-shadow: 0 0 8px rgba(255,215,0,0.15);
            cursor: default;
        }
        .slot-cell.pre_reserved {
            background: rgba(205,133,63,0.07);
            border-color: #cd853f;
            box-shadow: 0 0 8px rgba(205,133,63,0.15);
            cursor: default;
        }
        .slot-vip.available {
            border-color: #ffd700;
            box-shadow: 0 0 12px rgba(255,215,0,0.25);
            background: rgba(255,215,0,0.07);
        }

        .slot-icon { line-height: 1; }
        .slot-car   .slot-icon { font-size: 1.4rem; }
        .slot-van   .slot-icon { font-size: 1.7rem; }
        .slot-vip   .slot-icon { font-size: 1.6rem; }
        .slot-three .slot-icon { font-size: 1.2rem; }
        .slot-bike  .slot-icon { font-size: 1.0rem; }

        .slot-number { font-weight: 800; letter-spacing: 0.04em; margin-top: 3px; color: #e8f4f8; }
        .slot-car   .slot-number { font-size: 0.68rem; }
        .slot-van   .slot-number { font-size: 0.72rem; }
        .slot-vip   .slot-number { font-size: 0.72rem; }
        .slot-three .slot-number { font-size: 0.62rem; }
        .slot-bike  .slot-number { font-size: 0.58rem; }

        .slot-status-dot {
            position: absolute; top: 5px; right: 5px;
            width: 7px; height: 7px; border-radius: 50%;
        }
        .available   .slot-status-dot { background: #37ff8b; box-shadow: 0 0 4px #37ff8b; }
        .occupied    .slot-status-dot { background: #ff4c4c; box-shadow: 0 0 4px #ff4c4c; }
        .pending     .slot-status-dot { background: #ffd700; box-shadow: 0 0 4px #ffd700; }
        .pre_reserved .slot-status-dot { background: #cd853f; box-shadow: 0 0 4px #cd853f; }

        .checkin-hint {
            font-size: 0.52rem; font-weight: 700;
            text-transform: uppercase; color: #37ff8b;
            margin-top: 3px; opacity: 0;
            transition: opacity 0.2s; letter-spacing: 0.05em;
        }
        .slot-cell.available:hover .checkin-hint { opacity: 1; }
        .slot-vip.available:hover .checkin-hint { color: #ffd700; }

        .zone-divider { grid-column: span 1; display: flex; align-items: center; justify-content: center; }
        .divider-line { width: 2px; height: 80%; background: rgba(26,217,240,0.25); border-radius: 2px; }

        .road-lane {
            height: 18px; margin: 4px 0;
            background: repeating-linear-gradient(90deg,
                rgba(255,255,255,0.04) 0px, rgba(255,255,255,0.04) 20px,
                transparent 20px, transparent 40px);
            border-radius: 4px; display: flex;
            align-items: center; justify-content: center;
        }
        .road-text {
            font-size: 0.58rem; font-weight: 700;
            letter-spacing: 0.15em; text-transform: uppercase;
            color: rgba(255,255,255,0.2);
        }

        .stats-grid {
            display: grid; grid-template-columns: repeat(4,1fr);
            gap: 1rem; margin-bottom: 1.5rem;
        }
        .stat-card {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 12px; padding: 1rem; text-align: center;
        }
        .stat-number { font-size: 1.6rem; font-weight: 800; }
        .stat-label  { font-size: 0.7rem; color: var(--text-dim); text-transform: uppercase; letter-spacing: 0.08em; }
        .stat-card.green  .stat-number { color: #37ff8b; }
        .stat-card.red    .stat-number { color: #ff4c4c; }
        .stat-card.yellow .stat-number { color: #ffd700; }
        .stat-card.brown  .stat-number { color: #cd853f; }

        .map-legend {
            display: flex; align-items: center; gap: 1.5rem;
            margin-bottom: 1.5rem; flex-wrap: wrap;
        }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 0.78rem; color: var(--text-dim); }
        .legend-dot  { width: 10px; height: 10px; border-radius: 50%; border: 2px solid; }

        @media(max-width: 900px) {
            .zone-row.cars,
            .zone-row.vans-vip,
            .zone-row.threewheelers,
            .zone-row.bikes { grid-template-columns: repeat(5, 1fr); }
            .stats-grid { grid-template-columns: repeat(2,1fr); }
        }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo">
            <span class="logo-icon">&#10018;</span> MyParking
        </div>
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
            <li><a href="${pageContext.request.contextPath}/slots" class="active">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/tickets">Tickets</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="page-container">
<c:if test="${not empty successMsg}">
    <div style="margin-bottom:1.5rem;">
        <h1 class="page-title">🗺 Parking Slot Map</h1>
        <p class="page-subtitle">
            50 slots across 5 vehicle types — click any
            <span style="color:#37ff8b;font-weight:700;">green</span> slot to select your vehicle
        </p>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✅ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">❌ ${errorMsg}</div>
    </c:if>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card green">
            <div class="stat-number">${available}</div>
            <div class="stat-label">Available</div>
        </div>
        <div class="stat-card red">
            <div class="stat-number">${occupied}</div>
            <div class="stat-label">Occupied</div>
        </div>
        <div class="stat-card yellow">
            <div class="stat-number">${pending}</div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card brown">
            <div class="stat-number">${preReserved}</div>
            <div class="stat-label">Pre-Reserved</div>
        </div>
    </div>

    <!-- Legend -->
    <div class="map-legend">
        <div class="legend-item">
            <div class="legend-dot" style="background:#37ff8b;border-color:#37ff8b;"></div>
            <span>Available — click to select vehicle</span>
        </div>
        <div class="legend-item">
            <div class="legend-dot" style="background:#ff4c4c;border-color:#ff4c4c;"></div>
            <span>Occupied</span>
        </div>
        <div class="legend-item">
            <div class="legend-dot" style="background:#ffd700;border-color:#ffd700;"></div>
            <span>Pending</span>
        </div>
        <div class="legend-item">
            <div class="legend-dot" style="background:#cd853f;border-color:#cd853f;"></div>
            <span>Pre-Reserved</span>
        </div>
        <div class="legend-item" style="margin-left:auto;">
            <span style="font-size:0.72rem;color:var(--text-dim);">
                🚗 Small = Bike &nbsp;|&nbsp; Medium = Car/3W &nbsp;|&nbsp; Large = Van/VIP
            </span>
        </div>
    </div>

    <!-- Parking Lot -->
    <div class="parking-lot">

        <!-- ROW 1 : Cars 1-10 -->
        <div class="zone-label">🚗 Cars — Row 1 (C01–C10)</div>
        <div class="zone-row cars">
            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'CAR' and slot.slotNumber ge 'C01' and slot.slotNumber le 'C10'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-car available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚗</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-car ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚗</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>

        <div class="road-lane"><span class="road-text">· · · · · drive lane · · · · ·</span></div>

        <!-- ROW 2 : Cars 11-20 -->
        <div class="zone-label">🚗 Cars — Row 2 (C11–C20)</div>
        <div class="zone-row cars">
            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'CAR' and slot.slotNumber ge 'C11' and slot.slotNumber le 'C20'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-car available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚗</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-car ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚗</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>

        <div class="road-lane"><span class="road-text">· · · · · drive lane · · · · ·</span></div>

        <!-- ROW 3 : Vans + VIP -->
        <div class="zone-label">🚐 Vans (V01–V06) &nbsp;·&nbsp; ⭐ VIP (VIP01–VIP04)</div>
        <div class="zone-row vans-vip">
            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'VAN'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-van available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚐</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-van ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🚐</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>

            <div class="zone-divider"><div class="divider-line"></div></div>

            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'VIP'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-vip available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">⭐</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-vip ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">⭐</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>

        <div class="road-lane"><span class="road-text">· · · · · drive lane · · · · ·</span></div>

        <!-- ROW 4 : Three Wheelers -->
        <div class="zone-label">🛺 Three Wheelers (T01–T10)</div>
        <div class="zone-row threewheelers">
            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'THREE_WHEELER'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-three available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🛺</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-three ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🛺</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>

        <div class="road-lane"><span class="road-text">· · · · · drive lane · · · · ·</span></div>

        <!-- ROW 5 : Bikes -->
        <div class="zone-label">🏍 Bikes (B01–B10)</div>
        <div class="zone-row bikes">
            <c:forEach var="slot" items="${slots}">
                <c:if test="${slot.slotType == 'BIKE'}">
                    <c:choose>
                        <c:when test="${slot.status == 'AVAILABLE'}">
                            <a href="${pageContext.request.contextPath}/vehicle/select?slotId=${slot.id}&slotNumber=${slot.slotNumber}&slotType=${slot.slotType}"
                               class="slot-cell slot-bike available">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🏍</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                                <div class="checkin-hint">Select</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="slot-cell slot-bike ${slot.status == 'OCCUPIED' ? 'occupied' : slot.status == 'PENDING' ? 'pending' : 'pre_reserved'}">
                                <div class="slot-status-dot"></div>
                                <div class="slot-icon">🏍</div>
                                <div class="slot-number">${slot.slotNumber}</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        </div>

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
            <a href="${pageContext.request.contextPath}/tickets">Tickets</a>
            <a href="${pageContext.request.contextPath}/payment/history">Payments</a>
        </div>
        <div class="f-col contact-info">
            <strong>Contact us:</strong>
            <p>MyParking@gmail.com</p>
            <p>0712345678</p>
        </div>
    </div>
</footer>

<script>
    setTimeout(() => location.reload(), 30000);
</script>
</body>
</html>
