<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error Occurred</title>
    <link rel="shortcut icon" type="image/png" href="img/logos/favicon.png" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        .error-container {
            text-align: center;
            padding: 60px 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
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
        
        .contact-info {
            margin-top: 30px;
            font-size: 14px;
            color: #777;
        }
        
        .btn-outline {
            border: 1px solid #088178;
            color: #088178;
            background: none;
            padding: 10px 20px;
            font-size: 16px;
            margin-left: 10px;
        }
        
        .btn-outline:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>

<body>
    <div class="page-wrapper">
        <div class="body-wrapper d-flex align-items-center justify-content-center">
            <div class="error-container">
                <img src="img/error-general.png" alt="Error Occurred" class="error-image">
                <i class="bi bi-exclamation-triangle-fill error-icon"></i>
                <h1 class="error-message">Oops! Something went wrong</h1>
                <p class="error-description">We encountered an unexpected error while processing your request. Our technical team has been notified.</p>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                        <i class="bi bi-house-door me-2"></i>Return to Homepage
                    </a>
                    <a href="javascript:history.back();" class="btn btn-outline">
                        <i class="bi bi-arrow-left me-2"></i>Go Back
                    </a>
                </div>
                <div class="contact-info">
                    <p>If you need immediate assistance, please contact our support team at:</p>
                    <p><strong>Email:</strong> support@majutech.com</p>
                    <p><strong>Phone:</strong> +60 12-345-6789</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>