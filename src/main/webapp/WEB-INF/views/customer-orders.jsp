<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <h2 class="mb-4">My Orders</h2>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${successMessage}" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${empty orders}">
        <div class="alert alert-info">
            You haven't placed any orders yet.
            <a href="${pageContext.request.contextPath}/products/customer" class="alert-link">Start shopping</a>
        </div>
    </c:if>

    <c:forEach items="${orders}" var="order">
        <div class="card mb-4 shadow-sm">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Order #${order.id}</h5>
                <span class="badge ${order.status == 'PAID' ? 'bg-success' : 'bg-warning'}">${order.status}</span>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <h6>Order Details</h6>
                        <p><strong>Product:</strong> ${order.productName}</p>
                        <p><strong>Quantity:</strong> ${order.quantity}</p>
                        <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                        <p><strong>Order Date:</strong> ${order.orderDate}</p>
                    </div>
                    <div class="col-md-4">
                        <h6>Delivery Details</h6>
                        <p><strong>Name:</strong> ${order.fullName}</p>
                        <p><strong>Phone:</strong> ${order.phone}</p>
                        <p><strong>Address:</strong> ${order.address}, ${order.city}</p>
                    </div>
                </div>

                <!-- Delivery Status Timeline -->
                <div class="delivery-status mt-4">
                    <h6>Delivery Status</h6>
                    <div class="timeline">
                        <div class="timeline-item ${order.status == 'PAID' ? 'active' : ''}">
                            <div class="timeline-point"></div>
                            <div class="timeline-content">
                                <h6>Order Confirmed</h6>
                                <small>Payment received</small>
                            </div>
                        </div>
                        <div class="timeline-item ${order.status == 'PREPARING' ? 'active' : ''}">
                            <div class="timeline-point"></div>
                            <div class="timeline-content">
                                <h6>Preparing Order</h6>
                                <small>Your items are being prepared</small>
                            </div>
                        </div>
                        <div class="timeline-item ${order.status == 'OUT_FOR_DELIVERY' ? 'active' : ''}">
                            <div class="timeline-point"></div>
                            <div class="timeline-content">
                                <h6>Out for Delivery</h6>
                                <small>Your order is on the way</small>
                            </div>
                        </div>
                        <div class="timeline-item ${order.status == 'DELIVERED' ? 'active' : ''}">
                            <div class="timeline-point"></div>
                            <div class="timeline-content">
                                <h6>Delivered</h6>
                                <small>Order completed</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<style>
.timeline {
    position: relative;
    padding: 20px 0;
}

.timeline::before {
    content: '';
    position: absolute;
    top: 0;
    left: 20px;
    height: 100%;
    width: 2px;
    background: #e9ecef;
}

.timeline-item {
    position: relative;
    padding-left: 50px;
    margin-bottom: 20px;
}

.timeline-item:last-child {
    margin-bottom: 0;
}

.timeline-point {
    position: absolute;
    left: 12px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    background: #e9ecef;
    border: 2px solid #fff;
    z-index: 1;
}

.timeline-item.active .timeline-point {
    background: #28a745;
}

.timeline-content {
    padding: 10px;
    background: #f8f9fa;
    border-radius: 4px;
}

.timeline-item.active .timeline-content {
    background: #e8f5e9;
}

.timeline-content h6 {
    margin: 0;
    color: #495057;
}

.timeline-content small {
    color: #6c757d;
}
</style>

<jsp:include page="footer.jsp" />