<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Our Products (Sorted by Price)</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <c:out value="${successMessage}" />
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <c:out value="${errorMessage}" />
                        </div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Category</th>
                                    <th>Price (LKR)</th>
                                    <th>Quantity Available</th>
                                    <th>Initial Stock</th>
                                    <th>Current Stock</th>
                                    <th>Image</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td>${product.id}</td>
                                        <td>${product.name}</td>
                                        <td>${product.description}</td>
                                        <td>${product.category}</td>
                                        <td>${product.price}</td>
                                        <td>${product.quantityAvailable}</td>
                                        <td>${product.initialStock}</td>
                                        <td>${product.currentStock}</td>
                                        <td>
                                            <c:if test="${not empty product.image}">
                                                <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                                     alt="${product.name}" class="img-fluid" style="max-width: 80px;">
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/products/edit/${product.id}" 
                                               class="btn btn-sm btn-primary">Edit</a>
                                            <a href="${pageContext.request.contextPath}/products/delete/${product.id}" 
                                               class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="${pageContext.request.contextPath}/products/add" 
                           class="btn btn-primary">Add New Product</a>
                        <a href="${pageContext.request.contextPath}/" 
                           class="btn btn-secondary">Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />