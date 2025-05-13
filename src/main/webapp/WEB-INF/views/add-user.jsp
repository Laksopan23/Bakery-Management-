<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0">Add New User</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-danger">
                            <c:out value="${message}" />
                        </div>
                    </c:if>
                    <form autocomplete="off" method="post" action="${pageContext.request.contextPath}/users/add">
                        <input type="text" style="display:none;" name="hidden" autocomplete="off"/>
                        <input type="password" style="display:none;" name="hiddenPassword" autocomplete="off"/>
                        <div class="mb-3">
                            <label for="username" class="form-label">Username *</label>
                            <input type="text" class="form-control" id="username" name="username" value="" autocomplete="off" required/>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" class="form-control" id="email" name="email" value="" autocomplete="off" required/>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role *</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="User" ${user.role == 'User' ? 'selected' : ''}>User</option>
                                <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                        <div class="mb-3 password-field">
                            <label for="password" class="form-label">Password <span id="password-required" class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" value="" autocomplete="new-password" required/>
                                <button type="button" class="btn btn-outline-secondary toggle-password-btn">Show</button>
                            </div>
                            <small class="form-text text-muted">Password is required for Admin, optional for User.</small>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Add User</button>
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
    const passwordInput = document.getElementById('password');
    const passwordRequired = document.getElementById('password-required');
    if (this.value === 'Admin') {
        passwordInput.setAttribute('required', 'required');
        passwordRequired.style.display = 'inline';
    } else {
        passwordInput.removeAttribute('required');
        passwordRequired.style.display = 'none';
        passwordInput.value = '';
    }
});

document.addEventListener('DOMContentLoaded', function() {
    const roleSelect = document.getElementById('role');
    const passwordInput = document.getElementById('password');
    const passwordRequired = document.getElementById('password-required');
    if (roleSelect.value === 'Admin') {
        passwordInput.setAttribute('required', 'required');
        passwordRequired.style.display = 'inline';
    } else {
        passwordInput.removeAttribute('required');
        passwordRequired.style.display = 'none';
        passwordInput.value = '';
    }
});

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