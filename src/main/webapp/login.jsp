```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS Login</title>
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
        .login-box {
            background: white;
            width: 320px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #1e293b;
        }
        input {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            margin: 8px 0 16px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background: #1d4ed8;
        }
        .register-link {
            text-align: center;
            margin-top: 18px;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>LMS Login</h2>

        <form action="login" method="post">
            <label>Email</label>
            <input type="email" name="email" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <div class="register-link">
            New student?
            <a href="register.jsp">Register here</a>
        </div>
    </div>
</body>
</html>
```