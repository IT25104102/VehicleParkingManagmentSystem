<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkCity | Digital Ticket</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <style>
        .container{max-width:700px;margin:40px auto;padding:0 20px}
        .ticket-header{text-align:center;padding:20px 0 10px}
        .tick-icon{font-size:3.5rem;margin-bottom:10px}
        .tick-title{font-size:1.8rem;font-weight:800;color:#37ff8b;margin-bottom:6px}
        .tick-sub{font-size:0.85rem;color:var(--text-dim)}
        .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px;transition:0.3s}
        .card:hover{border-color:rgba(26,217,240,0.25)}
        .card-title{font-size:0.75rem;font-weight:600;color:var(--text-dim);text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
        .qr-section{display:flex;flex-direction:column;align-items:center;padding:20px 0}
        .qr-wrap{background:#fff;padding:16px;border-radius:12px;margin-bottom:12px}
        .qr-label{font-size:0.75rem;color:var(--text-dim);text-align:center;max-width:250px;line-height:1.6}
        .divider{border:none;border-top:1px dashed rgba(255,255,255,0.1);margin:16px 0}
        .confirm-item{display:flex;justify-content:space-between;padding:12px 0;border-bottom:1px solid rgba(255,255,255,0.05);font-size:0.88rem}
        .confirm-item:last-child{border-bottom:none}
        .c-label{color:var(--text-dim)}
        .c-val{font-weight:600}
        .badge-pending{display:inline-block;padding:4px 12px;border-radius:12px;font-size:0.75rem;font-weight:700;background:rgba(239,159,39,0.15);color:#EF9F27;border:1px solid rgba(239,159,39,0.3)}
        .badge-paid{display:inline-block;padding:4px 12px;border-radius:12px;font-size:0.75rem;font-weight:700;background:rgba(55,255,139,0.12);color:#37ff8b;border:1px solid rgba(55,255,139,0.3)}
        .info-note{background:rgba(26,217,240,0.06);border:1px solid rgba(26,217,240,0.15);border-radius:10px;padding:14px;font-size:0.8rem;color:var(--text-dim);margin-top:16px;text-align:center;line-height:1.6}
        .info-note strong{color:#1ad9f0}
        .btn-primary{width:100%;background:#37ff8b;border:none;border-radius:20px;padding:14px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;margin-top:16px;display:block;text-align:center}
        .btn-primary:hover{transform:translateY(-2px)}
        .btn-outline{width:100%;background:transparent;border:1px solid #37ff8b;border-radius:20px;padding:13px;font-family:'Montserrat',sans-serif;font-size:0.9rem;font-weight:700;color:#37ff8b;cursor:pointer;transition:0.3s;margin-top:8px;display:block;text-align:center}
        .btn-outline:hover{background:rgba(55,255,139,0.08)}
        @media print{
            .main-header,.full-width-nav,.btn-primary,.btn-outline,.info-note,footer{display:none}
            body{background:#fff;color:#000}
            .card{border:1px solid #ccc}
            .c-label,.tick-sub,.qr-label{color:#555}
            .tick-title{color:#000}
        }
    </style>
</head>
<body>

<header class="main-header">
    <div class="top-bar">
        <div class="logo">
            <%-- WHITE logo icon — no color override --%>
            <span class="logo-icon">&#10018;</span> ParkCity
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
            <li><a href="${pageContext.request.contextPath}/slots">Parking Slots</a></li>
            <li><a href="${pageContext.request.contextPath}/vehicle/list">My Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/payment/history" class="active">Payments</a></li>
        </ul>
    </nav>
</header>

<div class="container">

    <div class="ticket-header">
        <div class="tick-icon">&#9989;</div>
        <div class="tick-title">Booking Confirmed!</div>
        <div class="tick-sub">Your digital parking ticket is ready</div>
    </div>

    <div class="card">
        <div class="qr-section">
            <div class="qr-wrap" id="qr-code"></div>
            <div class="qr-label">
                &#128247; Scan this QR at the entrance.
                Officer verifies slot and payment status.
            </div>
        </div>

        <hr class="divider">

        <div class="card-title">Ticket Details</div>

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
            <span class="c-val">${payment.method}</span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Payment Status</span>
            <span class="c-val">
                <c:choose>
                    <c:when test="${payment.status == 'COMPLETED'}">
                        <span class="badge-paid">&#10003; Paid</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge-pending">
                            Pending — Pay at Counter
                        </span>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
        <div class="confirm-item">
            <span class="c-label">Date &amp; Time</span>
            <span class="c-val">${payment.createdAt}</span>
        </div>
    </div>

    <div class="info-note">
        &#128203; Show this QR code to the parking officer
        at the entrance. The officer will scan it to verify your
        <strong>slot number</strong> and
        <strong>payment status</strong>.
    </div>

    <button class="btn-primary" onclick="downloadTicket()">
        &#128438; Download Ticket
    </button>
    <a href="${pageContext.request.contextPath}/payment/history"
       class="btn-outline">
        View Payment History
    </a>

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
    <p class="footer-copy">&copy; 2026 ParkCity Smart System. All rights reserved.</p>
</footer>

<script>
function downloadTicket() {
    var elements = [
        document.querySelector('.btn-primary'),
        document.querySelector('.btn-outline'),
        document.querySelector('.info-note'),
        document.querySelector('footer'),
        document.querySelector('.main-header'),
        document.querySelector('.full-width-nav')
    ];
    elements.forEach(function(el) {
        if(el) el.style.display = 'none';
    });
    var ticket = document.querySelector('.container');
    html2canvas(ticket, {
        backgroundColor: '#0a1128',
        scale: 2,
        useCORS: true,
        allowTaint: true
    }).then(function(canvas) {
        var imgData = canvas.toDataURL('image/png');
        var pdf = new window.jspdf.jsPDF({
            orientation: 'portrait',
            unit: 'px',
            format: [canvas.width / 2, canvas.height / 2]
        });
        pdf.addImage(imgData, 'PNG', 0, 0,
            canvas.width / 2, canvas.height / 2);
        pdf.save('ParkCity-Ticket-${payment.id}.pdf');
        elements.forEach(function(el) {
            if(el) el.style.display = '';
        });
    });
}

var qrData = 'ParkCity'
    + '|ID:${payment.id}'
    + '|TICKET:${payment.ticketId}'
    + '|AMOUNT:Rs.${payment.amount}'
    + '|METHOD:${payment.method}'
    + '|STATUS:${payment.status}'
    + '|DATE:${payment.createdAt}';

new QRCode(document.getElementById('qr-code'), {
    text: qrData,
    width: 200,
    height: 200,
    colorDark: '#000000',
    colorLight: '#ffffff',
    correctLevel: QRCode.CorrectLevel.H
});
</script>

</body>
</html>
