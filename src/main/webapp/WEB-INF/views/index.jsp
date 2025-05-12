<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Bakery Management</title>
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
            text-align: center;
            padding: 60px 20px;
        }
        h1 {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2em;
            color: #666;
            line-height: 1.6;
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

    <!-- Welcome Content -->
    <div class="content">
        <h1>Welcome to Bakery Management System</h1>
        <p>This is the admin dashboard for managing your bakery. Use the navigation bar above to access Products, Users, and Orders sections.</p>
        <p>Start by adding products, managing users, or viewing orders!</p>
    </div>
</body>
</html>