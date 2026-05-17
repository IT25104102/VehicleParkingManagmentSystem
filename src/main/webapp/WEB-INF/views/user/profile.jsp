<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MyParking | My Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

    <header class="main-header">
        <div class="top-bar">
            <div class="logo">
                <span class="logo-icon">&#10018;</span> MyParking
            </div>
            <div class="header-controls">
                <button class="btn-sm">${user.name}</button>
                <a href="${pageContext.request.contextPath}/logout">
                    <button class="btn-sm login">Log out</button>
                </a>
            </div>
        </div>
        <nav class="full-width-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="#">Parking Slots</a></li>
                <li><a href="#">My Vehicles</a></li>
                <li><a href="#">Tickets</a></li>
                <li><a href="#">Payments</a></li>
                <c:if test="${user.role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/admin/users">Manage Users</a></li>
                </c:if>
            </ul>
        </nav>
    </header>

    <!-- ── Main content (no sidebar) ── -->
    <main style="padding: 2rem 5%; max-width: 1400px; margin: 0 auto;">

        <div class="page-hdr">
            <h1>My Profile</h1>
            <p>View account info &middot; change password &middot; update contact number</p>
        </div>

        <%-- Flash messages --%>
        <c:if test="${not empty pwError}">
            <div class="alert alert-error">&#9888; ${pwError}</div>
        </c:if>
        <c:if test="${not empty pwSuccess}">
            <div class="alert alert-success">&#10004; ${pwSuccess}</div>
        </c:if>
        <c:if test="${not empty phoneError}">
            <div class="alert alert-error">&#9888; ${phoneError}</div>
        </c:if>
        <c:if test="${not empty phoneSuccess}">
            <div class="alert alert-success">&#10004; ${phoneSuccess}</div>
        </c:if>
        <c:if test="${not empty deleteError}">
            <div class="alert alert-error">&#9888; ${deleteError}</div>
        </c:if>

        <div class="profile-grid">

            <!-- ════ CARD 1 — Account Info ════ -->
            <div class="d-card full animate-blur staggered-1">
                <div class="d-card-head">
                    <div class="d-card-icon">&#128483;</div>
                    <h3>Account Information</h3>
                </div>
                <div class="info-grid">
                    <div>
                        <span class="info-lbl">User ID</span>
                        <span class="info-val">${user.id}</span>
                    </div>
                    <div>
                        <span class="info-lbl">Full Name</span>
                        <span class="info-val">${user.name}</span>
                    </div>
                    <div>
                        <span class="info-lbl">Email Address</span>
                        <span class="info-val">${user.email}</span>
                    </div>
                    <div>
                        <span class="info-lbl">Phone Number</span>
                        <span class="info-val">${user.phone}</span>
                    </div>
                    <div>
                        <span class="info-lbl">Role</span>
                        <span class="info-val">
                            <span class="role-badge role-${user.role}">${user.role}</span>
                        </span>
                    </div>
                    <div>
                        <span class="info-lbl">Member Since</span>
                        <span class="info-val">${user.createdAt}</span>
                    </div>
                </div>
            </div>

            <!-- ════ CARD 2 — Change Password ════ -->
            <div class="d-card animate-blur staggered-2">
                <div class="d-card-head">
                    <div class="d-card-icon">&#128274;</div>
                    <h3>Change Password</h3>
                </div>
                <form action="${pageContext.request.contextPath}/profile/update-password"
                      method="post" id="formPassword">
                    <div class="form-group">
                        <label for="oldPassword">Current Password</label>
                        <input type="password" id="oldPassword" name="oldPassword"
                               placeholder="Enter your current password"
                               required autocomplete="current-password"/>
                    </div>
                    <div class="divider"></div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword"
                               placeholder="Minimum 6 characters"
                               required minlength="6" autocomplete="new-password"/>
                        <p class="field-hint">Must be at least 6 characters</p>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat new password"
                               required autocomplete="new-password"/>
                    </div>
                    <button type="submit" class="btn-update">UPDATE PASSWORD</button>
                </form>
            </div>

            <!-- ════ CARD 3 — Update Contact Number ════ -->
            <div class="d-card animate-blur staggered-3">
                <div class="d-card-head">
                    <div class="d-card-icon">&#128241;</div>
                    <h3>Update Contact Number</h3>
                </div>
                <form action="${pageContext.request.contextPath}/profile/update-phone"
                      method="post" id="formPhone">
                    <div class="form-group">
                        <label>Current Number</label>
                        <input type="text" value="${user.phone}" disabled/>
                    </div>
                    <div class="divider"></div>
                    <div class="form-group">
                        <label for="newPhone">New Phone Number</label>
                        <input type="tel" id="newPhone" name="phone"
                               placeholder="07XXXXXXXX"
                               required pattern="[0-9]{10}" maxlength="10"/>
                        <p class="field-hint">Enter a valid 10-digit Sri Lankan mobile number</p>
                    </div>
                    <button type="submit" class="btn-update">UPDATE NUMBER</button>
                </form>
            </div>

            <!-- ════ CARD 4 — Danger Zone ════ -->
            <div class="d-card full danger-card">
                <div class="d-card-head">
                    <div class="d-card-icon dng">&#9888;</div>
                    <h3>Danger Zone</h3>
                </div>
                <p class="danger-text">
                    Permanently delete your account. All personal data will be removed
                    and you will be signed out immediately.
                    <strong style="color:#ff6b6b;">This action cannot be undone.</strong>
                </p>
                <button type="button" class="btn-danger" onclick="showDeleteModal()">
                    Delete My Account
                </button>
            </div>

        </div><%-- /profile-grid --%>
    </main>

    <!-- ── Delete confirm modal ── -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h3>Delete Account?</h3>
            <p>You are about to permanently delete your account.<br/>
               All your data will be erased and you will be signed out.</p>
            <div class="modal-actions">
                <button class="btn-cancel" onclick="hideDeleteModal()">Cancel</button>
                <form action="${pageContext.request.contextPath}/profile/delete"
                      method="post" style="margin:0;">
                    <button type="submit" class="btn-danger">Yes, Delete It</button>
                </form>
            </div>
        </div>
    </div>

    <footer class="layered-footer">
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
                <p>MyParking@gmail.com</p>
                <p>0712345678</p>
            </div>
        </div>
        <p class="footer-copy">&copy; 2026 MyParking Smart System. All rights reserved.</p>
    </footer>

    <script>
        function showDeleteModal() {
            document.getElementById('deleteModal').classList.add('show');
        }
        function hideDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) hideDeleteModal();
        });

        document.getElementById('formPassword').addEventListener('submit', function(e) {
            var np = document.getElementById('newPassword').value;
            var cp = document.getElementById('confirmPassword').value;
            if (np !== cp) {
                e.preventDefault();
                alert('New passwords do not match. Please try again.');
                document.getElementById('confirmPassword').focus();
            }
        });

        document.getElementById('newPhone').addEventListener('input', function() {
            this.value = this.value.replace(/\D/g,'').slice(0,10);
        });
    </script>

</body>
</html>
