# 🅿 Smart Parking Management System

A Spring Boot + JSP web application for managing smart parking operations.

---

## 👤 User Profile Management Module

**Developer:** Nadin P.G.K  
**Student ID:** IT25101876  
**Package:** `com.smartparking.smartparkingsystem`

---

## ✅ Features (CRUD)

| Operation | Description | Route |
|-----------|-------------|-------|
| **CREATE** | Register new drivers | `POST /register` |
| **READ**   | Login authentication | `POST /login` |
| **UPDATE** | Change password / phone | `POST /profile/update-password` / `POST /profile/update-phone` |
| **DELETE** | Delete unauthorised accounts | `POST /profile/delete` / `POST /admin/delete` |

---

## 🖥 Pages

| Page | File | Description |
|------|------|-------------|
| Login | `login.jsp` | First page — sign in |
| Register | `register.jsp` | Create driver account |
| Dashboard | `home.jsp` | Post-login home |
| Profile | `profile.jsp` | View & update profile |
| Admin Users | `admin-users.jsp` | Manage all users (ADMIN only) |

---

## 📁 Project Structure

```
smartparkingsystem/
├── data/
│   └── users.txt                          # Shared user data file
├── src/main/
│   ├── java/com/smartparking/smartparkingsystem/
│   │   ├── SmartParkingSystemApplication.java
│   │   ├── controller/UserController.java
│   │   ├── model/User.java
│   │   ├── service/UserService.java
│   │   └── util/FileHandler.java
│   ├── resources/
│   │   └── application.properties
│   └── webapp/
│       ├── WEB-INF/views/
│       │   ├── login.jsp
│       │   ├── register.jsp
│       │   ├── home.jsp
│       │   ├── profile.jsp
│       │   └── admin-users.jsp
│       └── css/style.css
└── pom.xml
```

---

## 📄 Data Format (`data/users.txt`)

Each line follows the pipe-delimited format shared across all modules:

```
USR001|John|john@email.com|pass123|0771234567|DRIVER|2026-05-04
```

Fields: `id | name | email | password | phone | role | createdAt`

---

## 🚀 Getting Started

### Prerequisites
- Java 17+
- Maven 3.8+
- IntelliJ IDEA (recommended)

### Run the Application

```bash
mvn spring-boot:run
```

Then open: [http://localhost:8080](http://localhost:8080)

### Default Admin Login
| Email | Password |
|-------|----------|
| admin@smartparking.com | admin123 |

---

## 🎨 Design Theme

- **Background:** Dark Navy `#0a0f1e`
- **Accent:** Neon Green `#37ff8b`
- **Border/Highlight:** Cyan `#1ad9f0`
- **Font:** Montserrat

---

## 📝 Notes

- No database — all data stored in `data/users.txt`
- The `users.txt` file is shared with other modules (parking slots, payments, etc.)
- Session-based authentication using `HttpSession`
- Login is the entry point for all users
