<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Orders</title>
    <style>
        table { margin: 20px auto; border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
    </style>
</head>
<body>
    <h1>Orders</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>User ID</th>
            <th>Product ID</th>
            <th>Quantity</th>
        </tr>
        <c:forEach var="order" items="${orders}">
            <tr>
                <td>${order.id}</td>
                <td>${order.userId}</td>
                <td>${order.productId}</td>
                <td>${order.quantity}</td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="/">Back to Home</a></p>
</body>
</html>