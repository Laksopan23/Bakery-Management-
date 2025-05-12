<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { display: inline-block; text-align: left; }
        label { display: block; margin: 10px 0 5px; }
        .message { color: green; margin: 10px; }
        .error { color: red; margin: 10px; }
    </style>
</head>
<body>
    <h1>Add New Product</h1>
    <c:if test="${not empty message}">
        <p class="${message.contains('Error') || message.contains('Price') || message.contains('Invalid') ? 'error' : 'message'}">${message}</p>
    </c:if>
    <form method="post" action="/products/add" enctype="multipart/form-data">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${product.name}" required/>

        <label for="price">Price:</label>
        <input type="number" id="price" name="price" step="0.01" min="0" placeholder="Enter price (e.g., 0.01)" required/>

        <label for="image">Image (PNG only):</label>
        <input type="file" id="image" name="image" accept="image/png"/>

        <br/><br/>
        <button type="submit">Add Product</button>
    </form>
    <p><a href="/products">Back to Products</a></p>
</body>
</html>