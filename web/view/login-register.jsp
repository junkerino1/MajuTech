<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login.css" />
    <title>Login & Registration</title>
</head>
<body>
    <div class="container" id="container">
        <div class="form-container sign-up-container">
            <form action="${pageContext.request.contextPath}/register" method="post">
                <h1>Create Account</h1>
                <p>Please fill in your information to register</p>

                <div class="section-title">Personal Information</div>
                <div class="form-row">
                    <input type="text" placeholder="First Name" required />
                    <input type="text" placeholder="Last Name" required />
                </div>
                <input type="text" placeholder="Username" required />
                <input type="email" placeholder="Email" required />
                <input type="tel" placeholder="Phone Number" required />

                <div class="section-title security-section">Security</div>
                <input type="password" placeholder="Password" required />
                <input type="password" placeholder="Confirm Password" required />

                <div class="section-title">Additional Information</div>
                <div class="form-row">
                    <input type="date" placeholder="Date of Birth" />
                    <select>
                        <option value="" disabled selected>Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="other">Other</option>
                        <option value="prefer">Prefer not to say</option>
                    </select>
                </div>

                <div class="checkbox-container">
                    <input type="checkbox" id="terms" required />
                    <label for="terms">I agree to all statements in Terms of Service</label>
                </div>

                <button type="submit">Sign Up</button>
                <button type="button" class="mobile-toggle mobile-signin" id="mobileSignIn">Sign In Instead</button>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="${pageContext.request.contextPath}/login" method="post">
                <h1>Sign in</h1>
                <p>Enter your email and password to login</p>
                <input type="text" placeholder="Username" name="username" required />
                <input type="password" placeholder="Password" name="password" required />
                <button type="submit">Sign In</button>
                <button type="button" class="mobile-toggle mobile-signup" id="mobileSignUp">Create Account</button>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <div class="logo-wrapper">
                        <img src="img/logo.png" alt="Logo">
                      </div>
                    <h1>Hello, Friend!</h1>
                    <p>Enter your personal details and start journey with us</p>
                    <button class="ghost desktop-toggle" id="signIn">Sign In</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <div class="logo-wrapper">
                        <img src="${pageContext.request.contextPath}/image/icon.png" alt="Logo">
                      </div>
                    <h1>Welcome Back!</h1>
                    <p>To keep connected with us please login with your personal info</p>
                    <button class="ghost desktop-toggle" id="signUp">Sign Up</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const signUpButton = document.getElementById('signUp');
        const signInButton = document.getElementById('signIn');
        const mobileSignUpButton = document.getElementById('mobileSignUp');
        const mobileSignInButton = document.getElementById('mobileSignIn');
        const container = document.getElementById('container');

        signUpButton.addEventListener('click', () => {
            container.classList.add('right-panel-active');
        });

        signInButton.addEventListener('click', () => {
            container.classList.remove('right-panel-active');
        });

        if (mobileSignUpButton) {
            mobileSignUpButton.addEventListener('click', () => {
                container.classList.add('right-panel-active');
            });
        }

        if (mobileSignInButton) {
            mobileSignInButton.addEventListener('click', () => {
                container.classList.remove('right-panel-active');
            });
        }
    </script>
</body>
</html>