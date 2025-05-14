<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
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
        .order-timeline {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .timeline-item {
            position: relative;
            padding-left: 30px;
            margin-bottom: 15px;
        }
        .timeline-item:before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item:last-child:before {
            bottom: 50%;
        }
        .timeline-dot {
            position: absolute;
            left: -4px;
            top: 0;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #007bff;
        }
        .timeline-date {
            font-size: 0.8em;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2 class="mb-4">My Orders</h2>
        
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

                        <div class="order-timeline">
                            <h5>Order Status Timeline</h5>
                            <div class="timeline-item">
                                <div class="timeline-dot"></div>
                                <div class="timeline-date">Order Placed</div>
                                <div>Your order has been placed successfully</div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-dot"></div>
                                <div class="timeline-date">Payment Confirmed</div>
                                <div>Payment has been processed successfully</div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-dot"></div>
                                <div class="timeline-date">Order Processing</div>
                                <div>Your order is being prepared</div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-dot"></div>
                                <div class="timeline-date">Out for Delivery</div>
                                <div>Your order is on its way</div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-dot"></div>
                                <div class="timeline-date">Delivered</div>
                                <div>Order has been delivered</div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 