<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>404 - Page Not Found</title>
    <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
    <style>
        .error-container {
            text-align: center;
            padding: 60px 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #e74c3c;
            line-height: 1;
            margin-bottom: 10px;
        }
        
        .error-message {
            font-size: 28px;
            font-weight: 500;
            margin-bottom: 20px;
            color: #333;
        }
        
        .error-description {
            font-size: 16px;
            margin-bottom: 30px;
            color: #777;
        }
        
        .error-image {
            max-width: 300px;
            margin-bottom: 30px;
        }
        
        .btn-primary {
            background-color: #088178;
            border-color: #088178;
            padding: 10px 20px;
            font-size: 16px;
        }
        
        .btn-primary:hover {
            background-color: #066e66;
            border-color: #066e66;
        }
    </style>
</head>

<body>
    <div class="page-wrapper">
        <div class="body-wrapper d-flex align-items-center justify-content-center">
            <div class="error-container">
                <div class="error-code">404</div>
                <h1 class="error-message">Page Not Found</h1>
                <p class="error-description">The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                        <i class="bi bi-house-door me-2"></i>Return to Homepage
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>

</html>