<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">Our Products (Sorted by Price)</h3>
                </div>
                <div class="card-body p-4">
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
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Category</th>
                                    <th>Price (LKR)</th>
                                    <th>Initial Stock</th>
                                    <th>Current Stock</th>
                                    <th>Image</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td class="text-center">${product.id}</td>
                                        <td>${product.name}</td>
                                        <td>${product.description}</td>
                                        <td>${product.category}</td>
                                        <td class="text-end"><fmt:formatNumber value="${product.price}" type="currency" currencyCode="LKR"/></td>
                                        <td class="text-center">${product.initialStock}</td>
                                        <td class="text-center">${product.currentStock}</td>
                                        <td>
                                            <c:if test="${not empty product.image}">
                                                <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                                     alt="${product.name}" class="img-fluid rounded" style="max-width: 100px;">
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/products/edit/${product.id}" 
                                               class="btn btn-sm btn-primary me-2">Edit</a>
                                            <a href="${pageContext.request.contextPath}/products/delete/${product.id}" 
                                               class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/products/add" class="btn btn-primary btn-lg">Add New Product</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary btn-lg">Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />