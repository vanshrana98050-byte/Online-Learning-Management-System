
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS - Student Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 340px;
            box-shadow: 0 4px 18px #00000015;
        }
        h2 { text-align: center; color: #1e293b; }
        label { display: block; margin-top: 15px; }
        input {
            width: 100%;
            box-sizing: border-box;
            padding: 11px;
            margin-top: 6px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
        }
        button {
            width: 100%;
            margin-top: 22px;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: 0;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Create Student Account</h2>

        <form action="register" method="post">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name"
                   maxlength="100" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   maxlength="100" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   minlength="8" maxlength="72" required>

            <button type="submit">Register</button>
        </form>
    </div>
</body>
</html>
