<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #007bff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
            text-align: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 15px 25px;
            display: inline-block;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .navbar a:hover {
            background-color: #0056b3;
            border-radius: 5px;
        }
        .content {
            padding: 30px 20px;
            text-align: center;
        }
        h1 {
            color: #333;
            font-size: 2em;
            margin-bottom: 20px;
        }
        form {
            max-width: 500px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin: 10px 0 5px;
            color: #333;
            font-weight: 500;
        }
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            color: #28a745;
            font-weight: 500;
            margin: 10px 0;
        }
        .error {
            color: #dc3545;
            font-weight: 500;
            margin: 10px 0;
        }
        a.button {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        a.button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <a href="/">Home</a>
        <a href="/products">Products</a>
        <a href="/users">Users</a>
        <a href="/orders">Orders</a>
    </div>

    <!-- Content -->
    <div class="content">
        <h1>Edit User</h1>
        <c:if test="${not empty message}">
            <p class="${message.contains('Error') || message.contains('Price') || message.contains('Invalid') ? 'error' : 'message'}">${message}</p>
        </c:if>
        <form method="post" action="/users/edit/${user.id}">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="${user.name}" required/>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${user.email}" required/>

            <button type="submit">Update User</button>
        </form>
        <a href="/users" class="button">Back to Users</a>
    </div>
</body>
</html>