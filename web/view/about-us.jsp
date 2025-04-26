<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="en">

    <jsp:include page="client-navbar.jsp" />

    <head>
        <script src="https://kit.fontawesome.com/bcb2c05d90.js" crossorigin="anonymous"></script>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MajuTech</title>
        <!-- Font Awesome Library -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        
        <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            overflow-x: hidden;
        }

        /* Hero Section */
        .hero {
            height: 100vh;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        p{
            color:white;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('/api/placeholder/1400/800') no-repeat center center/cover;
            opacity: 0.1;
        }

        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
            z-index: 2;
            text-align: center;
            animation: fadeInUp 1s ease;
        }

        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(90deg, #4fd1c5, #63b3ed);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hero p {
            font-size: 1.2rem;
            max-width: 800px;
            margin: 0 auto 2rem;
            line-height: 1.6;
        }

        /* About Section */
        .about-section {
            padding: 6rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            font-size: 2.5rem;
            color: #1a1a2e;
            margin-bottom: 1rem;
            position: relative;
            padding-bottom: 1rem;
            text-align: center;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #4fd1c5, #63b3ed);
        }

        .about-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            margin-top: 3rem;
        }

        .about-image {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            opacity: 0;
            transform: translateX(-50px);
            transition: all 0.8s ease;
        }

        .about-image.visible {
            opacity: 1;
            transform: translateX(0);
        }

        .about-image img {
            width: 100%;
            height: 100%;
            transition: transform 0.5s ease;
        }

        .about-image:hover img {
            transform: scale(1.05);
        }

        .about-content {
            opacity: 0;
            transform: translateX(50px);
            transition: all 0.8s ease;
        }

        .about-content.visible {
            opacity: 1;
            transform: translateX(0);
        }

        .about-content h3 {
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
            color: #1a1a2e;
        }

        .about-content p {
            margin-bottom: 1rem;
            line-height: 1.7;
            color: #4a5568;
        }

        /* Mission and Vision */
        .mission-vision {
            background-color: #1a1a2e;
            padding: 6rem 2rem;
            color: white;
        }

        .mission-vision-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
        }

        .mission, .vision {
            padding: 2rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(50px);
        }

        .mission {
            background: linear-gradient(135deg, rgba(79, 209, 197, 0.1) 0%, rgba(79, 209, 197, 0.2) 100%);
            transition-delay: 0.2s;
        }

        .vision {
            background: linear-gradient(135deg, rgba(99, 179, 237, 0.1) 0%, rgba(99, 179, 237, 0.2) 100%);
            transition-delay: 0.4s;
        }

        .mission.visible, .vision.visible {
            opacity: 1;
            transform: translateY(0);
        }

        .mission h3, .vision h3 {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            position: relative;
            padding-bottom: 0.8rem;
        }

        .mission h3::after, .vision h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
        }

        .mission h3::after {
            background-color: #4fd1c5;
        }

        .vision h3::after {
            background-color: #63b3ed;
        }

        .mission p, .vision p {
            line-height: 1.7;
        }

        /* Team Section */
        .team-section {
            padding: 6rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .team-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .team-member {
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(30px);
        }

        .team-member.visible {
            opacity: 1;
            transform: translateY(0);
        }

        .team-member:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .member-img {
            height: 300px;
            overflow: hidden;
        }

        .member-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .team-member:hover .member-img img {
            transform: scale(1.05);
        }

        .member-info {
            padding: 1.5rem;
            text-align: center;
        }

        .member-info h4 {
            font-size: 1.3rem;
            color: #1a1a2e;
            margin-bottom: 0.5rem;
        }

        .member-info p {
            color: #4a5568;
            margin-bottom: 1rem;
        }

        .social-links {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }

        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            color: white;
            background-color: #1a1a2e;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background-color: #4fd1c5;
            transform: translateY(-3px);
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .about-container, .mission-vision-container {
                grid-template-columns: 1fr;
            }
            
            .hero h1 {
                font-size: 2.5rem;
            }
            
            .hero p {
                font-size: 1rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
        }
        </style>
    </head>

<body>
    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-content">
            <h1>Innovating Tomorrow's Technology</h1>
            <p>At MajuTech, we're passionate about creating cutting-edge gadgets that seamlessly integrate into your lifestyle, enhancing productivity and bringing joy to everyday experiences.</p>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section" id="about">
        <h2 class="section-title">Our Story</h2>
        <div class="about-container">
            <div class="about-image" id="about-image">
                <img src="../image/office.jpg" alt="MajuTech Office">
            </div>
            <div class="about-content" id="about-content">
                <h3>Leading the Tech Revolution Since 2018</h3>
                <p>MajuTech was founded in 2018 by a group of tech enthusiasts who shared a common vision: to create innovative gadgets that would make life simpler, more efficient, and more enjoyable.</p>
                <p>What began as a small startup in a garage has now grown into a leading tech company with a global presence. Our journey has been marked by groundbreaking innovations, unwavering commitment to quality, and a deep understanding of our users' needs.</p>
                <p>Today, MajuTech stands at the forefront of technological innovation, consistently pushing boundaries and redefining what's possible in the world of consumer electronics. Our products range from smart home devices to wearable technology, all designed with the user experience at the center.</p>
            </div>
        </div>
    </section>

    <!-- Mission and Vision -->
    <section class="mission-vision">
        <div class="mission-vision-container">
            <div class="mission" id="mission">
                <h3>Our Mission</h3>
                <p>To create intuitive, innovative tech solutions that simplify everyday tasks and enhance human potential, while maintaining the highest standards of quality, sustainability, and ethical design.</p>
                <p>We believe technology should work for people, not the other way around. Every product we create is designed to integrate seamlessly into your life, solving real problems while being accessible to everyone.</p>
            </div>
            <div class="vision" id="vision">
                <h3>Our Vision</h3>
                <p>To lead the technological revolution by developing products that not only meet the needs of today but anticipate the challenges of tomorrow.</p>
                <p>We envision a world where technology enhances human connection rather than replacing it, where innovation serves a purpose beyond novelty, and where our products contribute to creating a more efficient, sustainable, and connected global community.</p>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team-section" id="team">
        <h2 class="section-title">Meet Our Team</h2>
        <div class="team-container">
            <div class="team-member" id="team-member-1">
                <div class="member-img">
                    <img src="../image/people/ooijunkang.jpg" alt="Team Member">
                </div>
                <div class="member-info">
                    <h4>Ooi Jun Kang</h4>
                    <p>CEO & Founder</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="team-member" id="team-member-2">
                <div class="member-img">
                    <img src="../image/people/chawchunjia.jpg" alt="Team Member">
                </div>
                <div class="member-info">
                    <h4>Chaw Chun Jia</h4>
                    <p>Chief Technology Officer</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-github"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="team-member" id="team-member-3">
                <div class="member-img">
                    <img src="../image/people/gohchunwen.jpg" alt="Team Member">
                </div>
                <div class="member-info">
                    <h4>Goh Chun Wen</h4>
                    <p>Head of Product Design</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-dribbble"></i></a>
                        <a href="#"><i class="fab fa-behance"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="team-member" id="team-member-4">
                <div class="member-img">
                    <img src="../image/people/wongshunbin.jpg" alt="Team Member">
                </div>
                <div class="member-info">
                    <h4>Wong Shun Bin</h4>
                    <p>Head of Marketing</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Font Awesome for Icons -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
    
    <!-- JavaScript for animations and interactivity -->
    <script>
        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.2,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries, observer) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Elements to observe
        const elementsToObserve = [
            document.getElementById('about-image'),
            document.getElementById('about-content'),
            document.getElementById('mission'),
            document.getElementById('vision'),
            document.getElementById('team-member-1'),
            document.getElementById('team-member-2'),
            document.getElementById('team-member-3'),
            document.getElementById('team-member-4')
        ];

        // Start observing elements
        elementsToObserve.forEach(element => {
            if (element) {
                observer.observe(element);
            }
        });
    </script>
</body>

    <jsp:include page="client-footer.jsp" />
</html>