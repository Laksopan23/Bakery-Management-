<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">Add New Product</h3>
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
                    <form action="${pageContext.request.contextPath}/products/add" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Product Name *</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="category" class="form-label fw-bold">Category *</label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="">Select a category</option>
                                <option value="Bread">Bread</option>
                                <option value="Cake">Cake</option>
                                <option value="Pastry">Pastry</option>
                                <option value="Cookie">Cookie</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label fw-bold">Price (LKR) *</label>
                            <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" placeholder="Enter price (e.g., 0.01)" required>
                        </div>
                        <div class="mb-3">
                            <label for="initialStock" class="form-label fw-bold">Initial Stock *</label>
                            <input type="number" class="form-control" id="initialStock" name="initialStock" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="currentStock" class="form-label fw-bold">Current Stock *</label>
                            <input type="number" class="form-control" id="currentStock" name="currentStock" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="image" class="form-label fw-bold">Product Image (PNG only)</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/png">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">Add Product</button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />