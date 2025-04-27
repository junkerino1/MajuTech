<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>503 - Service Unavailable</title>
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
                color: #f1c40f;
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

            .maintenance-info {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 25px;
            }

            .maintenance-info p {
                margin: 0;
                color: #555;
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
                    <div class="error-code">503</div>
                    <h1 class="error-message">Service Unavailable</h1>
                    <p class="error-description">Our system is temporarily down for maintenance. We apologize for the inconvenience.</p>
                    <div class="action-buttons">
                        <a href="javascript:location.reload();" class="btn btn-primary">
                            <i class="bi bi-arrow-repeat me-2"></i>Try Again
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>