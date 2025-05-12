<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { display: inline-block; text-align: left; }
        label { display: block; margin: 10px 0 5px; }
        img { max-width: 100px; }
    </style>
</head>
<body>
    <h1>Edit Product</h1>
    <form method="post" action="/products/edit/${product.id}" enctype="multipart/form-data">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${product.name}" required/>

        <label for="price">Price:</label>
        <input type="number" id="price" name="price" step="0.01" value="${product.price}" required/>

        <label for="image">Current Image:</label>
        <c:if test="${not empty product.image}">
            <img src="/resources/images/products/${product.image}" alt="${product.name}"/>
        </c:if>
        <input type="hidden" name="existingImage" value="${product.image}"/>

        <label for="image">New Image (optional):</label>
        <input type="file" id="image" name="image" accept="image/*"/>

        <br/><br/>
        <button type="submit">Update Product</button>
    </form>
    <p><a href="/products">Back to Products</a></p>
</body>
</html>