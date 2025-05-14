<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h3 class="mb-0">My Orders</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <c:out value="${successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${empty orders}">
                        <p class="text-center">You have no orders yet.</p>
                    </c:if>
                    <c:if test="${not empty orders}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover table-bordered align-middle">
                                <thead class="table-info">
                                    <tr>
                                        <th class="text-center">Order ID</th>
                                        <th class="text-center">Product ID</th>
                                        <th class="text-center">Quantity</th>
                                        <th class="text-center">Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td class="text-center">${order.id}</td>
                                            <td class="text-center">${order.productId}</td>
                                            <td class="text-center">${order.quantity}</td>
                                            <td class="text-center"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/products/customer" class="btn btn-secondary">Back to Products</a>
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
    }
    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background-color: #17a2b8;
        color: white;
        border-bottom-width: 2px;
    }
    .text-center {
        text-align: center;
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
    }
</style>