<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<style>
    .visible {
        display: block;
    }
    .hidden {
        display: none;
    }
</style>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Edit User</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-danger">
                            <c:out value="${message}" />
                        </div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/users/edit/${user.id}">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username *</label>
                            <input type="text" class="form-control" id="username" name="username" value="${user.username}" required/>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" required/>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role *</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="User" ${user.role == 'User' ? 'selected' : ''}>User</option>
                                <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                        <div class="mb-3 password-field ${user.role == 'Admin' ? 'visible' : 'hidden'}">
                            <label for="password" class="form-label">Password ${user.role == 'Admin' ? '*' : ''}</label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" value="" ${user.role == 'Admin' ? 'required' : ''}/>
                                <button type="button" class="btn btn-outline-secondary toggle-password-btn">Show</button>
                            </div>
                            <small class="form-text text-muted">Leave blank to keep the existing password.</small>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Update User</button>
                            <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('role').addEventListener('change', function() {
    const passwordField = document.querySelector('.password-field');
    const passwordInput = document.getElementById('password');
    if (this.value === 'Admin') {
        passwordField.classList.remove('hidden');
        passwordField.classList.add('visible');
        passwordInput.setAttribute('required', 'required');
    } else {
        passwordField.classList.remove('visible');
        passwordField.classList.add('hidden');
        passwordInput.removeAttribute('required');
    }
});

// Toggle password visibility
document.querySelectorAll('.toggle-password-btn').forEach(button => {
    button.addEventListener('click', function() {
        const input = this.previousElementSibling;
        if (input.type === 'password') {
            input.type = 'text';
            this.textContent = 'Hide';
        } else {
            input.type = 'password';
            this.textContent = 'Show';
        }
    });
});
</script>

<jsp:include page="footer.jsp" />