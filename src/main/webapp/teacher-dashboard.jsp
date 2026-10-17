
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    Object userId = session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"TEACHER".equals(role)) {
        response.sendRedirect("welcome.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard | LMS</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #1f2937;
        }
        header {
            background: #172554;
            color: white;
            padding: 22px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        header h2 { margin: 0; }
        main { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        .welcome {
            background: white;
            padding: 28px;
            border-radius: 14px;
            margin-bottom: 24px;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0000000a;
        }
        .card h3 { margin-top: 0; }
        a.button {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 11px 16px;
            border-radius: 8px;
            text-decoration: none;
            margin-top: 8px;
        }
        .logout { color: white; }
    </style>
</head>
<body>
<header>
    <h2>LMS | Teacher Panel</h2>
    <a class="logout" href="logout">Logout</a>
</header>

<main>
    <section class="welcome">
        <h1>Welcome, <%= userName == null ? "Teacher" : userName %>!</h1>
        <p>Manage your courses and learning materials from one place.</p>
    </section>

    <section class="cards">
        <div class="card">
            <h3>📚 My Courses</h3>
            <p>View and manage your courses.</p>
            <a class="button" href="teacher-courses.jsp">Manage Courses</a>
        </div>

        <div class="card">
            <h3>➕ Create Course</h3>
            <p>Add a new course for students.</p>
            <a class="button" href="teacher-create-course.jsp">Create Course</a>
        </div>

        <div class="card">
            <h3>📖 Lessons</h3>
            <p>Organize lessons for your courses.</p>
     <a class="button" href="teacher-courses.jsp">Manage Lessons</a>
        </div>
    </section>
</main>
</body>
</html>
