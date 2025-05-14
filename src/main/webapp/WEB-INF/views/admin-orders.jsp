<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - All Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .order-header {
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .order-details {
            margin-bottom: 15px;
        }
        .delivery-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 15px;
        }
        .status-pending { background-color: #ffeeba; }
        .status-paid { background-color: #c3e6cb; }
        .status-delivered { background-color: #b8daff; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2 class="mb-4">All Orders</h2>
        
        <div class="row">
            <c:forEach items="${orders}" var="orderText">
                <div class="col-md-6">
                    <div class="order-card">
                        <c:forTokens items="${orderText}" delims="\n" var="line">
                            <c:if test="${line.startsWith('Order ID:')}">
                                <div class="order-header">
                                    <h4>${line}</h4>
                                </div>
                            </c:if>
                            
                            <c:if test="${line.startsWith('Status:')}">
                                <c:set var="status" value="${line.substring(8)}"/>
                                <span class="status-badge status-${status.toLowerCase()}">${status}</span>
                            </c:if>
                            
                            <c:if test="${!line.startsWith('Delivery Details:') && !line.startsWith('User ID:')}">
                                <div class="order-details">${line}</div>
                            </c:if>
                            
                            <c:if test="${line.startsWith('Delivery Details:')}">
                                <div class="delivery-details">
                                    <h5>Delivery Details</h5>
                            </c:if>
                            
                            <c:if test="${line.startsWith('Name:') || line.startsWith('Phone:') || 
                                        line.startsWith('Email:') || line.startsWith('Address:') || 
                                        line.startsWith('City:') || line.startsWith('Postal Code:') || 
                                        line.startsWith('Delivery Notes:')}">
                                <div class="delivery-details">${line}</div>
                            </c:if>
                        </c:forTokens>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 