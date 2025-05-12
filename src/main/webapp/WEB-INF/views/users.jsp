<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Users</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        table { margin: 20px auto; border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        .message { color: green; margin: 10px; }
        .error { color: red; margin: 10px; }
    </style>
</head>
<body>
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
                    <a href="/users/edit/${user.id}">Edit</a> |
                    <a href="/users/delete/${user.id}" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
    <p><a href="/users/add">Add New User</a></p>
    <p><a href="/">Back to Home</a></p>
</body>
</html>