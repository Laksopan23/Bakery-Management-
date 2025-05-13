<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Our Users</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert ${message.contains('Failed') || message.contains('not found') ? 'alert-danger' : 'alert-success'}">
                            <c:out value="${message}" />
                        </div>
                    </c:if>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Password</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>${user.role}</td>
                                        <td>
                                            <c:if test="${user.role == 'Admin'}">
                                                <span class="password-hidden" id="password-${user.id}">********</span>
                                                <button type="button" class="btn btn-sm btn-link toggle-password" data-target="password-${user.id}">
                                                    Show
                                                </button>
                                                <span class="password-shown d-none" id="password-shown-${user.id}">${user.password}</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-sm btn-primary">Edit</a>
                                            <a href="${pageContext.request.contextPath}/users/delete/${user.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="${pageContext.request.contextPath}/users/add" class="btn btn-primary">Add New User</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.querySelectorAll('.toggle-password').forEach(button => {
    button.addEventListener('click', function() {
        const targetId = this.getAttribute('data-target');
        const hiddenSpan = document.getElementById(targetId);
        const shownSpan = document.getElementById('password-shown-' + targetId.split('-')[1]);
        
        if (hiddenSpan.classList.contains('d-none')) {
            hiddenSpan.classList.remove('d-none');
            shownSpan.classList.add('d-none');
            this.textContent = 'Show';
        } else {
            hiddenSpan.classList.add('d-none');
            shownSpan.classList.remove('d-none');
            this.textContent = 'Hide';
        }
    });
});
</script>

<jsp:include page="footer.jsp" />