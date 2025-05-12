<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
    <style>
        table { margin: 20px auto; border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        img { max-width: 100px; }
        .message { color: green; margin: 10px; }
        .error { color: red; margin: 10px; }
    </style>
</head>
<body>
    <h1>Our Products (Sorted by Price)</h1>
    <c:if test="${not empty message}">
        <p class="${message.contains('Error') || message.contains('not found') ? 'error' : 'message'}">${message}</p>
    </c:if>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Image</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="product" items="${products}">
            <tr>
                <td>${product.id}</td>
                <td>${product.name}</td>
                <td>${product.price}</td>
                <td>
                    <c:if test="${not empty product.image}">
                        <img src="/resources/images/products/${product.image}" alt="${product.name}"/>
                    </c:if>
                </td>
                <td>
                    <a href="/products/edit/${product.id}">Edit</a> |
                    <a href="/products/delete/${product.id}" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="/products/add">Add New Product</a></p>
    <p><a href="/">Back to Home</a></p>
</body>
</html>