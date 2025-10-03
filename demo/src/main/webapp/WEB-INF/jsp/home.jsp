<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
    <title>TourMate - Discover Your Next Adventure</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#1e40af',
                        secondary: '#64748b'
                    }
                }
            }
        }
    </script>

    <style>
        /* Hero Slider Styles */
        .hero-slider {
            position: relative;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }

        .slider-wrapper {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .slide.active {
            opacity: 1;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(30, 64, 175, 0.7), rgba(59, 130, 246, 0.5));
            z-index: 1;
        }

        .hero-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            z-index: 2;
            color: white;
            width: 90%;
            max-width: 1000px;
        }

        .floating-animation {
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .slide-controls {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 3;
            display: flex;
            gap: 10px;
        }

        .slide-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .slide-dot.active {
            background: white;
            transform: scale(1.2);
        }

        .nav-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 50%;
            font-size: 18px;
            cursor: pointer;
            z-index: 3;
            transition: all 0.3s ease;
        }

        .nav-arrow:hover {
            background: rgba(0, 0, 0, 0.8);
        }

        .nav-arrow.prev {
            left: 20px;
        }

        .nav-arrow.next {
            right: 20px;
        }
    </style>
</head>
<body class="bg-gray-50">

    <!-- Hero Section with Image Slider -->
    <section class="hero-slider">
        <div class="slider-wrapper">
            <!-- Slide 1: Mountain Lake -->
            <div class="slide active" style="background-image: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>

            <!-- Slide 2: Tropical Beach -->
            <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>

            <!-- Slide 3: Ocean Sunset -->
            <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>

            <!-- Slide 4: Desert Landscape -->
            <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1483683804023-6ccdb62f86ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>

            <!-- Slide 5: Forest Path -->
            <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1494526585095-c41746248156?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>

            <!-- Slide 6: City Skyline -->
            <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1500534623283-312aade485b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');"></div>
        </div>

        <!-- Dark Overlay -->
        <div class="hero-overlay"></div>

        <!-- Hero Content (Text in Middle) -->
        <div class="hero-content">
            <div class="floating-animation">
                <h1 class="text-5xl md:text-7xl font-extrabold mb-6 leading-tight">
                    Discover Your Next
                    <span class="bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent block mt-2">
                        Adventure
                    </span>
                </h1>
                <p class="text-xl md:text-2xl mb-8 leading-relaxed max-w-3xl mx-auto">
                    Explore breathtaking destinations with our curated travel packages.
                    From serene beaches to majestic mountains, your perfect getaway awaits.
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="#packages" class="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-full text-lg transition-all duration-300 transform hover:scale-105 shadow-lg">
                        <i class="fas fa-compass mr-2"></i>Explore Packages
                    </a>
                    <a href="#about" class="bg-white bg-opacity-20 backdrop-blur-sm hover:bg-opacity-30 text-white font-semibold py-4 px-8 rounded-full text-lg transition-all duration-300 border border-white border-opacity-30">
                        <i class="fas fa-play mr-2"></i>Watch Video
                    </a>
                </div>
            </div>
        </div>

        <!-- Navigation Dots -->
        <div class="slide-controls">
            <div class="slide-dot active" data-slide="0"></div>
            <div class="slide-dot" data-slide="1"></div>
            <div class="slide-dot" data-slide="2"></div>
            <div class="slide-dot" data-slide="3"></div>
            <div class="slide-dot" data-slide="4"></div>
            <div class="slide-dot" data-slide="5"></div>
        </div>

        <!-- Navigation Arrows -->
        <button class="nav-arrow prev" id="prevBtn">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button class="nav-arrow next" id="nextBtn">
            <i class="fas fa-chevron-right"></i>
        </button>
    </section>

    <!-- Stats Section -->
    <section class="bg-white py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
                <div class="transform hover:scale-105 transition-transform duration-300">
                    <div class="text-4xl font-bold text-primary">${totalPackages != null ? totalPackages : '50'}+</div>
                    <div class="text-gray-600 mt-2">Travel Packages</div>
                </div>
                <div class="transform hover:scale-105 transition-transform duration-300">
                    <div class="text-4xl font-bold text-primary">${totalDestinations != null ? totalDestinations : '25'}+</div>
                    <div class="text-gray-600 mt-2">Destinations</div>
                </div>
                <div class="transform hover:scale-105 transition-transform duration-300">
                    <div class="text-4xl font-bold text-primary">${happyCustomers != null ? happyCustomers : '1000'}+</div>
                    <div class="text-gray-600 mt-2">Happy Travelers</div>
                </div>
                <div class="transform hover:scale-105 transition-transform duration-300">
                    <div class="text-4xl font-bold text-primary">4.8★</div>
                    <div class="text-gray-600 mt-2">Average Rating</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Packages Section -->
    <section id="packages" class="py-20 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
                    Featured Travel Packages
                </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Handpicked destinations and experiences crafted by our travel experts.
                    Each package promises unforgettable memories and authentic local experiences.
                </p>
            </div>

            <!-- Package Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                <c:forEach var="pkg" items="${packages}">
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden transform hover:scale-105 transition-all duration-300 hover:shadow-xl">
                    <div class="relative">
                        <img src="${pkg.imageUrl != null && !empty pkg.imageUrl ? pkg.imageUrl : 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'}"
                             alt="${pkg.title}"
                             class="w-full h-64 object-cover">

                        <!-- Featured Badge -->
                        <c:if test="${pkg.featured}">
                            <div class="absolute top-4 left-4">
                                <span class="bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-3 py-1 rounded-full text-sm font-semibold">
                                    <i class="fas fa-star mr-1"></i>Featured
                                </span>
                            </div>
                        </c:if>

                        <!-- Price Badge -->
                        <div class="absolute top-4 right-4">
                            <span class="bg-primary text-white px-4 py-2 rounded-full font-bold text-lg">
                                ₹<fmt:formatNumber value="${pkg.price}" pattern="#,##0"/>
                            </span>
                        </div>

                        <!-- Duration Badge -->
                        <div class="absolute bottom-4 left-4">
                            <span class="bg-black bg-opacity-70 text-white px-3 py-1 rounded-full text-sm">
                                <i class="fas fa-clock mr-1"></i>${pkg.duration != null ? pkg.duration : '5'} Days
                            </span>
                        </div>
                    </div>

                    <div class="p-6">
                        <div class="flex items-start justify-between mb-3">
                            <h3 class="text-xl font-bold text-gray-900 leading-tight">${pkg.title}</h3>
                            <div class="flex items-center text-yellow-500 ml-2">
                                <i class="fas fa-star"></i>
                                <span class="text-gray-600 text-sm ml-1">4.8</span>
                            </div>
                        </div>

                        <div class="flex items-center text-gray-600 mb-3">
                            <i class="fas fa-map-marker-alt text-primary mr-2"></i>
                            <span class="text-sm">${pkg.destination}</span>
                        </div>

                        <p class="text-gray-700 text-sm leading-relaxed mb-4 line-clamp-2">
                            ${pkg.description}
                        </p>

                        <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                            <div class="flex items-center text-sm text-gray-500">
                                <i class="fas fa-users mr-1"></i>
                                <span>Max ${pkg.maxPeople != null ? pkg.maxPeople : '10'} people</span>
                            </div>
                            <a href="/packages/${pkg.id}"
                               class="bg-primary hover:bg-blue-700 text-white px-6 py-2 rounded-full text-sm font-semibold transition-all duration-300 transform hover:scale-105">
                                <i class="fas fa-arrow-right mr-1"></i>Book Now
                            </a>
                        </div>
                    </div>
                </div>
                </c:forEach>

                <!-- Empty State -->
                <c:if test="${empty packages}">
                <div class="col-span-full text-center py-16">
                    <i class="fas fa-suitcase-rolling text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-2xl font-bold text-gray-500 mb-2">No Packages Available</h3>
                    <p class="text-gray-400">Check back soon for exciting travel packages!</p>
                </div>
                </c:if>
            </div>

            <!-- View All Packages Button -->
            <div class="text-center mt-12">
                <a href="/packages"
                   class="inline-block bg-gradient-to-r from-primary to-blue-600 hover:from-blue-700 hover:to-purple-600 text-white font-bold py-4 px-8 rounded-full text-lg transition-all duration-300 transform hover:scale-105 shadow-lg">
                    <i class="fas fa-compass mr-2"></i>View All Packages
                </a>
            </div>
        </div>
    </section>

    <!-- Why Choose Us Section -->
    <section class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 mb-4">Why Choose TourMate?</h2>
                <p class="text-xl text-gray-600">Your trusted partner for unforgettable travel experiences</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="text-center group">
                    <div class="bg-blue-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary transition-colors duration-300">
                        <i class="fas fa-shield-alt text-3xl text-primary group-hover:text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-3">Trusted & Secure</h3>
                    <p class="text-gray-600">Your safety and security are our top priorities. Travel with confidence.</p>
                </div>

                <div class="text-center group">
                    <div class="bg-green-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary transition-colors duration-300">
                        <i class="fas fa-headset text-3xl text-green-600 group-hover:text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-3">24/7 Support</h3>
                    <p class="text-gray-600">Round-the-clock customer support to assist you wherever you are.</p>
                </div>

                <div class="text-center group">
                    <div class="bg-purple-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary transition-colors duration-300">
                        <i class="fas fa-tags text-3xl text-purple-600 group-hover:text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-3">Best Prices</h3>
                    <p class="text-gray-600">Competitive pricing with no hidden fees. Get the best value for your money.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="bg-gradient-to-r from-primary to-blue-600 py-16">
        <div class="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
            <h2 class="text-3xl font-bold text-white mb-4">Stay Updated</h2>
            <p class="text-blue-100 mb-8 text-lg">Get the latest travel deals and destination guides delivered to your inbox</p>

            <form class="flex flex-col sm:flex-row gap-4 max-w-lg mx-auto" onsubmit="subscribeNewsletter(event)">
                <input type="email"
                       id="newsletterEmail"
                       placeholder="Enter your email address"
                       required
                       class="flex-1 px-6 py-3 rounded-full border-0 text-gray-900 placeholder-gray-500 focus:ring-4 focus:ring-white focus:ring-opacity-25">
                <button type="submit"
                        class="bg-white hover:bg-gray-100 text-primary font-semibold px-8 py-3 rounded-full transition-colors duration-300">
                    Subscribe
                </button>
            </form>
        </div>
    </section>


    <!-- All JavaScript Code Inline -->
    <script>
        // Image Slider Functionality
        document.addEventListener('DOMContentLoaded', function() {
            const slides = document.querySelectorAll('.slide');
            const dots = document.querySelectorAll('.slide-dot');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            let currentSlide = 0;
            let slideInterval;

            // Show specific slide
            function showSlide(index) {
                // Remove active class from all slides and dots
                slides.forEach(slide => slide.classList.remove('active'));
                dots.forEach(dot => dot.classList.remove('active'));

                // Add active class to current slide and dot
                slides[index].classList.add('active');
                dots[index].classList.add('active');

                currentSlide = index;
            }

            // Next slide
            function nextSlide() {
                const next = (currentSlide + 1) % slides.length;
                showSlide(next);
            }

            // Previous slide
            function prevSlide() {
                const prev = (currentSlide - 1 + slides.length) % slides.length;
                showSlide(prev);
            }

            // Start auto-slide
            function startAutoSlide() {
                slideInterval = setInterval(nextSlide, 5000);
            }

            // Stop auto-slide
            function stopAutoSlide() {
                clearInterval(slideInterval);
            }

            // Reset auto-slide
            function resetAutoSlide() {
                stopAutoSlide();
                startAutoSlide();
            }

            // Event listeners for dots
            dots.forEach((dot, index) => {
                dot.addEventListener('click', () => {
                    showSlide(index);
                    resetAutoSlide();
                });
            });

            // Event listeners for navigation arrows
            prevBtn.addEventListener('click', () => {
                prevSlide();
                resetAutoSlide();
            });

            nextBtn.addEventListener('click', () => {
                nextSlide();
                resetAutoSlide();
            });

            // Pause on hover
            document.querySelector('.hero-slider').addEventListener('mouseenter', stopAutoSlide);
            document.querySelector('.hero-slider').addEventListener('mouseleave', startAutoSlide);

            // Initialize slider
            showSlide(0);
            startAutoSlide();
        });

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Newsletter subscription
        function subscribeNewsletter(event) {
            event.preventDefault();
            const email = document.getElementById('newsletterEmail').value;

            if (email) {
                Swal.fire({
                    title: 'Thank You!',
                    text: 'You have successfully subscribed to our newsletter.',
                    icon: 'success',
                    confirmButtonColor: '#1e40af'
                });
                document.getElementById('newsletterEmail').value = '';
            }
        }
    </script>

</body>
</html>
