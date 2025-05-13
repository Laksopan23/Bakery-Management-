<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<style>
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

<div class="content">
    <h1>Welcome to Bakery Management System</h1>
    <p>This is the admin dashboard for managing your bakery. Use the navigation bar above to access Products, Users, and Orders sections.</p>
    <p>Start by adding products, managing users, or viewing orders!</p>
</div>

<jsp:include page="footer.jsp" />