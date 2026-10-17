
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!"TEACHER".equals(session.getAttribute("role"))) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Course | LMS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            margin: 0;
            padding: 30px 16px;
        }
        .container {
            max-width: 600px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0000000a;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            margin: 8px 0 18px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 15px;
        }
        textarea { min-height: 130px; resize: vertical; }
        button, a {
            display: inline-block;
            padding: 12px 18px;
            border: 0;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            cursor: pointer;
        }
        .back { background: #64748b; }
    </style>
</head>
<body>
<div class="container">
    <h1>Create New Course</h1>
    <p>Enter the course details below.</p>

    <form action="create-course" method="post">
        <label for="title">Course Title</label>
        <input id="title" type="text" name="title"
               maxlength="150" required
               placeholder="e.g. Java Programming">

        <label for="description">Course Description</label>
        <textarea id="description" name="description"
                  required placeholder="Describe what students will learn"></textarea>

        <button type="submit">Create Course</button>
        <a class="back" href="teacher-dashboard.jsp">Back</a>
    </form>
</div>
</body>
</html>
