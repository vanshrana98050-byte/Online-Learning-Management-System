
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("userName");

    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Student Dashboard</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
        }

        .navbar {
            background: #1d4ed8;
            color: white;
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .navbar h2 {
            margin: 0;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .welcome {
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0000000d;
            margin-bottom: 30px;
        }

        .welcome h1 {
            color: #1d4ed8;
            margin-top: 0;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 22px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0000000d;
        }

        .card h3 {
            margin-top: 0;
            color: #1d4ed8;
        }

        .card p {
            color: #64748b;
            line-height: 1.6;
        }

        .btn {
            display: inline-block;
            margin-top: 12px;
            padding: 11px 18px;
            background: #1d4ed8;
            color: white;
            text-decoration: none;
            border-radius: 7px;
        }

        .btn:hover {
            background: #1e40af;
        }

        .footer {
            text-align: center;
            padding: 25px;
            color: #64748b;
        }

        @media (max-width: 500px) {
            .navbar {
                padding: 18px 20px;
            }

            .container {
                margin-top: 25px;
            }

            .welcome {
                padding: 22px;
            }
        }
    </style>
</head>

<body>

    <div class="navbar">
        <h2>🎓 LMS Portal</h2>
        <a href="logout">Logout ↗</a>
    </div>

    <div class="container">

        <div class="welcome">
            <h1>Welcome, <%= userName %>!</h1>
            <p>You have successfully logged in to your Learning Management System.</p>
            <p>Learn new skills, explore courses and manage your learning journey.</p>
        </div>

        <div class="cards">

            <div class="card">
                <h3>📚 Available Courses</h3>
                <p>Explore courses and discover learning opportunities.</p>
                <a class="btn" href="courses.jsp">Explore Courses</a>
            </div>

            <div class="card">
                <h3>📝 My Enrollments</h3>
                <p>View the courses you have enrolled in.</p>
                <a class="btn" href="my-courses.jsp">My Courses</a>
            </div>

            <div class="card">
                <h3>👤 My Profile</h3>
                <p>View your student account information.</p>
                <a class="btn" href="profile.jsp">View Profile</a>
            </div>

        </div>
    </div>

    <div class="footer">
        © 2026 LMS Portal | B.Tech Project
    </div>

</body>
</html>
