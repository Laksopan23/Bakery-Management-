<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-4">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-11">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">All Orders</h3>
                    <span class="badge bg-light text-dark">Total Orders: ${orders.size()}</span>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <c:out value="${successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered align-middle">
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center" style="width: 5%">Order ID</th>
                                    <th class="text-center" style="width: 10%">Date</th>
                                    <th class="text-center" style="width: 7%">Status</th>
                                    <th style="width: 10%">Product</th>
                                    <th class="text-center" style="width: 5%">Quantity</th>
                                    <th class="text-end" style="width: 8%">Total Amount (LKR)</th>
                                    <th style="width: 8%">Payment Method</th>
                                    <th style="width: 8%">Name</th>
                                    <th style="width: 8%">Phone</th>
                                    <th style="width: 8%">Email</th>
                                    <th style="width: 10%">Address</th>
                                    <th style="width: 5%">City</th>
                                    <th class="text-center" style="width: 5%">Postal Code</th>
                                    <th style="width: 8%">Delivery Notes</th>
                                    <th class="text-center" style="width: 5%">User ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr class="order-row">
                                        <td class="text-center fw-bold">#${order.id}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty order.orderDate}">
                                                    <fmt:formatDate value="${order.orderDateAsDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${order.status == 'PAID' ? 'bg-success' : order.status == 'PENDING' ? 'bg-warning' : 'bg-danger'} status-badge">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="product-name">${order.productName}</div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary">${order.quantity}</span>
                                        </td>
                                        <td class="text-end">
                                            <span class="price-badge">
                                                <fmt:formatNumber value="${order.quantity * order.price}" type="currency" currencyCode="LKR"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-info payment-badge">${order.paymentMethod != null ? order.paymentMethod : "N/A"}</span>
                                        </td>
                                        <td>
                                            <div class="customer-name">${order.fullName}</div>
                                        </td>
                                        <td>${order.phone}</td>
                                        <td>${order.email}</td>
                                        <td>
                                            <div class="address-text">${order.address}</div>
                                        </td>
                                        <td>${order.city}</td>
                                        <td class="text-center">${order.postalCode}</td>
                                        <td>
                                            <div class="delivery-notes">${order.deliveryNotes != null ? order.deliveryNotes : "N/A"}</div>
                                        </td>
                                        <td class="text-center fw-bold">${order.userId}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<style>
    .table {
        font-size: 0.95rem;
        border-color: #dee2e6;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        width: 100%;
    }
    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background-color: #007bff;
        color: white;
        border-bottom-width: 2px;
        padding: 1rem;
        white-space: nowrap;
    }
    .table tbody td {
        vertical-align: middle;
        padding: 1rem;
    }
    .order-row {
        transition: all 0.3s ease;
    }
    .order-row:hover {
        background-color: #f8f9fa;
        transform: scale(1.01);
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .product-name, .customer-name {
        font-weight: 600;
        color: #2c3e50;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .address-text, .delivery-notes {
        color: #6c757d;
        font-size: 0.9rem;
        max-width: 150px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
    }
    .badge {
        font-size: 0.85rem;
        padding: 0.5em 0.75em;
        border-radius: 20px;
        white-space: nowrap;
    }
    .status-badge {
        font-weight: 600;
        padding: 0.6em 1em;
    }
    .payment-badge {
        background-color: #17a2b8 !important;
        color: white;
    }
    .price-badge {
        font-weight: 600;
        color: #28a745;
        font-size: 1.1rem;
        white-space: nowrap;
    }
    @media (max-width: 1400px) {
        .address-text, .delivery-notes {
            max-width: 100px;
        }
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
        .badge {
            font-size: 0.75rem;
            padding: 0.4em 0.6em;
        }
        .address-text, .delivery-notes {
            max-width: 80px;
        }
    }
</style>