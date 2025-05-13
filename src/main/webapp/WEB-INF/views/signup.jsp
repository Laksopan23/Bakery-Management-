<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Bakery Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f5f5f5;
        }
        .signup-container {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2 class="text-center mb-4">Sign Up</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <c:out value="${error}" />
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <c:out value="${success}" />
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/signup" method="post" autocomplete="off" onsubmit="return validateForm()">
            <input type="text" style="display:none;" name="hidden" autocomplete="off"/>
            <input type="password" style="display:none;" name="hiddenPassword" autocomplete="off"/>
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" class="form-control" autocomplete="off" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" name="email" class="form-control" autocomplete="off" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <div class="input-group">
                    <input type="password" id="password" name="password" class="form-control" autocomplete="new-password" required/>
                    <button type="button" class="btn btn-outline-secondary toggle-password-btn">Show</button>
                </div>
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password:</label>
                <div class="input-group">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" autocomplete="new-password" required/>
                    <button type="button" class="btn btn-outline-secondary toggle-password-btn">Show</button>
                </div>
            </div>
            <button type="submit" class="btn btn-success w-100">Sign Up</button>
        </form>
        <div class="text-center mt-3">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/">Login</a></p>
        </div>
    </div>

    <script>
    // Toggle password visibility for both password fields
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

    // Validate password and confirm password match
    function validateForm() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (password !== confirmPassword) {
            alert('Passwords do not match!');
            return false;
        }
        return true;
    }
    </script>
</body>
</html>