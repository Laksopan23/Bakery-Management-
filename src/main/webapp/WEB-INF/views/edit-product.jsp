<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Edit Product</h3>
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
                    
                    <form action="${pageContext.request.contextPath}/products/edit/${product.id}" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="name" class="form-label">Product Name *</label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   value="${product.name}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" 
                                      rows="3">${product.description}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="category" class="form-label">Category *</label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="">Select a category</option>
                                <option value="Bread" ${product.category == 'Bread' ? 'selected' : ''}>Bread</option>
                                <option value="Cake" ${product.category == 'Cake' ? 'selected' : ''}>Cake</option>
                                <option value="Pastry" ${product.category == 'Pastry' ? 'selected' : ''}>Pastry</option>
                                <option value="Cookie" ${product.category == 'Cookie' ? 'selected' : ''}>Cookie</option>
                                <option value="Other" ${product.category == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="price" class="form-label">Price (LKR) *</label>
                            <input type="number" class="form-control" id="price" name="price" 
                                   step="0.01" min="0" value="${product.price}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="quantityAvailable" class="form-label">Quantity Available *</label>
                            <input type="number" class="form-control" id="quantityAvailable" 
                                   name="quantityAvailable" min="0" value="${product.quantityAvailable}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="initialStock" class="form-label">Initial Stock *</label>
                            <input type="number" class="form-control" id="initialStock" 
                                   name="initialStock" min="0" value="${product.initialStock}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="currentStock" class="form-label">Current Stock *</label>
                            <input type="number" class="form-control" id="currentStock" 
                                   name="currentStock" min="0" value="${product.currentStock}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="image" class="form-label">Current Image:</label>
                            <c:if test="${not empty product.image}">
                                <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                     alt="${product.name}" class="img-fluid mb-2" style="max-width: 100px;">
                            </c:if>
                            <input type="hidden" name="existingImage" value="${product.image}"/>
                        </div>
                        
                        <div class="mb-3">
                            <label for="image" class="form-label">New Image (PNG only, optional):</label>
                            <input type="file" class="form-control" id="image" name="image" 
                                   accept="image/png">
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Update Product</button>
                            <a href="${pageContext.request.contextPath}/products" 
                               class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />