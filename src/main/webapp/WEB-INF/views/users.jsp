<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Users</title>
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
        table {
            margin: 20px auto;
            border-collapse: separate;
            border-spacing: 0;
            width: 90%;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f1f1f1;
            color: #333;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f5f5f5;
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
        <h1>Our Users</h1>
        <c:if test="${not empty message}">
            <p class="${message.contains('Failed') || message.contains('not found') ? 'error' : 'message'}">${message}</p>
        </c:if>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.name}</td>
                    <td>${user.email}</td>
                    <td>
                        <a href="/users/edit/${user.id}" class="button">Edit</a>
                        <a href="/users/delete/${user.id}" class="button" style="background-color: #dc3545;" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
        <a href="/users/add" class="button">Add New User</a>
        <a href="/" class="button">Back to Home</a>
    </div>
</body>
</html>