<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { display: inline-block; text-align: left; }
        label { display: block; margin: 10px 0 5px; }
    </style>
</head>
<body>
    <h1>Add New User</h1>
    <form method="post" action="/users/add">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${user.name}" required/>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="${user.email}" required/>

        <br/><br/>
        <button type="submit">Add User</button>
    </form>
    <p><a href="/users">Back to Users</a></p>
</body>
</html>