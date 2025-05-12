<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { display: inline-block; text-align: left; }
        label { display: block; margin: 10px 0 5px; }
    </style>
</head>
<body>
    <h1>Add New Product</h1>
    <form method="post" action="/products/add" enctype="multipart/form-data">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${product.name}" required/>

        <label for="price">Price:</label>
        <input type="number" id="price" name="price" step="0.01" value="${product.price}" required/>

        <label for="image">Image:</label>
        <input type="file" id="image" name="image" accept="image/*"/>

        <br/><br/>
        <button type="submit">Add Product</button>
    </form>
    <p><a href="/products">Back to Products</a></p>
</body>
</html>