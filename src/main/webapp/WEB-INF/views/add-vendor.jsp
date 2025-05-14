<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Add New Vendor</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-danger">
                            <c:out value="${message}" />
                        </div>
                    </c:if>
                    <form autocomplete="off" method="post" action="${pageContext.request.contextPath}/vendors/add">
                        <input type="text" style="display:none;" name="hidden" autocomplete="off"/>
                        <div class="mb-3">
                            <label for="name" class="form-label">Name *</label>
                            <input type="text" class="form-control" id="name" name="name" value="" autocomplete="off" required/>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" class="form-control" id="email" name="email" value="" autocomplete="off" required/>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone *</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="" autocomplete="off" required/>
                        </div>
                        <div class="mb-3">
                            <label for="company" class="form-label">Company *</label>
                            <input type="text" class="form-control" id="company" name="company" value="" autocomplete="off" required/>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Add Vendor</button>
                            <a href="${pageContext.request.contextPath}/vendors" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" /> 