  <%@ page contentType="text/html;charset=UTF-8" %>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <!DOCTYPE html>
 <html lang="en">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>ParkCity | Payment History</title>
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
         .container{max-width:900px;margin:40px auto;padding:0 20px}
         .page-title{font-size:1.8rem;font-weight:800;margin-bottom:6px}
         .page-sub{color:#b8c7e0;font-size:0.85rem;margin-bottom:30px}
         .card{background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:14px;padding:24px;margin-bottom:20px}
         .card-title{font-size:0.75rem;font-weight:600;color:#b8c7e0;text-transform:uppercase;letter-spacing:1px;margin-bottom:16px}
         .btn-primary{background:#37ff8b;border:none;border-radius:20px;padding:10px 24px;font-family:'Montserrat',sans-serif;font-size:0.85rem;font-weight:800;color:#0c1a12;cursor:pointer;transition:0.3s;display:inline-block;margin-bottom:20px}
         .btn-primary:hover{transform:translateY(-2px)}
         table{width:100%;border-collapse:collapse;font-size:0.85rem}
         thead tr{border-bottom:1px solid rgba(26,217,240,0.3)}
         thead th{padding:12px 10px;color:#b8c7e0;font-weight:600;text-align:left;font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px}
         tbody tr{border-bottom:1px solid rgba(255,255,255,0.05);transition:0.2s}
         tbody tr:hover{background:rgba(255,255,255,0.03)}
         tbody td{padding:12px 10px;color:#f0f6fc}
         .badge{display:inline-block;padding:4px 12px;border-radius:12px;font-size:0.7rem;font-weight:700}
         .badge-pending{background:rgba(239,159,39,0.15);color:#EF9F27;border:1px solid rgba(239,159,39,0.3)}
         .badge-completed{background:rgba(55,255,139,0.12);color:#37ff8b;border:1px solid rgba(55,255,139,0.3)}
         .action-form{display:inline}
         .btn-update{background:rgba(26,217,240,0.1);border:1px solid rgba(26,217,240,0.3);border-radius:8px;padding:5px 10px;font-family:'Montserrat',sans-serif;font-size:0.75rem;color:#1ad9f0;cursor:pointer;transition:0.3s}
         .btn-update:hover{background:rgba(26,217,240,0.2)}
         .btn-delete{background:rgba(220,53,69,0.1);border:1px solid rgba(220,53,69,0.3);border-radius:8px;padding:5px 10px;font-family:'Montserrat',sans-serif;font-size:0.75rem;color:#ff6b6b;cursor:pointer;transition:0.3s}
         .btn-delete:hover{background:rgba(220,53,69,0.2)}
         select{background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);border-radius:6px;padding:4px 8px;color:#f0f6fc;font-family:'Montserrat',sans-serif;font-size:0.75rem}
         select option{background:#0a1128}
         .empty-state{text-align:center;padding:40px;color:#b8c7e0}
         .empty-state .empty-icon{font-size:3rem;margin-bottom:16px}
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
     <div class="page-title">Payment History</div>
     <div class="page-sub">View and manage all payment records</div>

     <a href="/payment/create" class="btn-primary">+ Create New Payment</a>

     <div class="card">
         <div class="card-title">All Payments</div>

         <c:choose>
             <c:when test="${empty payments}">
                 <div class="empty-state">
                     <div class="empty-icon">&#128184;</div>
                     <p>No payment records found</p>
                 </div>
             </c:when>
             <c:otherwise>
                 <table>
                     <thead>
                         <tr>
                             <th>Payment ID</th>
                             <th>Ticket ID</th>
                             <th>Amount</th>
                             <th>Method</th>
                             <th>Status</th>
                             <th>Date</th>
                             <th>Actions</th>
                         </tr>
                     </thead>
                     <tbody>
                         <c:forEach var="payment" items="${payments}">
                         <tr>
                             <td>${payment.id}</td>
                             <td>${payment.ticketId}</td>
                             <td style="color:#37ff8b;font-weight:700">Rs. ${payment.amount}</td>
                             <td>${payment.method}</td>
                             <td>
                                 <span class="badge ${payment.status == 'COMPLETED' ? 'badge-completed' : 'badge-pending'}">
                                     ${payment.status}
                                 </span>
                             </td>
                             <td>${payment.createdAt}</td>
                             <td>
                                 <form method="post" action="/payment/updateStatus" class="action-form">
                                     <input type="hidden" name="id" value="${payment.id}"/>
                                     <select name="status">
                                         <option value="PENDING" ${payment.status=='PENDING'?'selected':''}>Pending</option>
                                         <option value="COMPLETED" ${payment.status=='COMPLETED'?'selected':''}>Completed</option>
                                     </select>
                                     <button type="submit" class="btn-update">Update</button>
                                 </form>
                                 <form method="post" action="/payment/delete" class="action-form" style="margin-top:6px">
                                     <input type="hidden" name="id" value="${payment.id}"/>
                                     <button type="submit" class="btn-delete"
                                         onclick="return confirm('Delete this payment?')">
                                         Delete
                                     </button>
                                 </form>
                             </td>
                         </tr>
                         </c:forEach>
                     </tbody>
                 </table>
             </c:otherwise>
         </c:choose>
     </div>
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
