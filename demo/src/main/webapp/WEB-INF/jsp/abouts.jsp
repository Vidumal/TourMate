<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="navbar.jsp" %>

<html>
<head>
    <title>About TourMate - Your Travel Companion</title>
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
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .glass-effect {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        .fade-in {
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .floating-animation {
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .video-overlay {
            background: linear-gradient(45deg, rgba(30, 64, 175, 0.8), rgba(59, 130, 246, 0.6));
        }

        .stat-counter {
            animation: countUp 2s ease-out;
        }

        @keyframes countUp {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body class="bg-gray-50">

    <!-- Breadcrumb -->
    <div class="bg-white border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <nav class="text-sm text-gray-500">
                <a href="${pageContext.request.contextPath}/" class="hover:text-primary transition-colors duration-300">
                    <i class="fas fa-home mr-1"></i>Home
                </a>
                <span class="mx-2">/</span>
                <span class="text-gray-900 font-medium">About Us</span>
            </nav>
        </div>
    </div>

    <!-- Hero Section -->
    <section class="relative">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div class="text-center mb-12 fade-in">
                <div class="floating-animation mb-8">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full mb-6">
                        <i class="fas fa-compass text-3xl text-white"></i>
                    </div>
                </div>
                <h1 class="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
                    About <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">TourMate</span>
                </h1>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
                    Your trusted travel companion for unforgettable adventures around the world.
                    Let's explore what makes us your perfect travel partner!
                </p>
            </div>

            <!-- Video Section -->
            <div class="relative rounded-3xl overflow-hidden shadow-2xl mb-16">
                <div class="relative">
                    <video class="w-full h-auto" autoplay muted loop poster="https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80">
                        <source src="https://cdn.coverr.co/videos/coverr-exploring-mountains-3177/1080p.mp4" type="video/mp4">
                        <source src="https://videos.pexels.com/video-files/2169880/2169880-uhd_2560_1440_25fps.mp4" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <div class="video-overlay absolute inset-0 flex items-center justify-center">
                        <div class="text-center text-white">
                            <h2 class="text-4xl md:text-5xl font-bold mb-4">Discover Amazing Destinations</h2>
                            <p class="text-xl mb-8 max-w-2xl">Experience the world through our eyes and create memories that last a lifetime</p>
                            <button class="bg-white text-primary font-bold py-4 px-8 rounded-full hover:bg-gray-100 transition-colors duration-300 transform hover:scale-105">
                                <i class="fas fa-play mr-2"></i>Watch Our Story
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Mission Statement -->
    <section class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div class="max-w-4xl mx-auto">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-8">
                    We Provide The Best Travel Experience For You
                </h2>
                <p class="text-xl text-gray-600 leading-relaxed mb-12">
                    At TourMate, we understand that every journey has unique needs and dreams. Therefore, we offer
                    customized travel packages designed according to your preferences, budget, and travel style.
                    Our expert team crafts personalized experiences that transform ordinary trips into extraordinary adventures.
                </p>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div class="glass-effect rounded-2xl p-8 transform hover:scale-105 transition-all duration-300">
                        <div class="bg-gradient-to-r from-blue-500 to-purple-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-heart text-2xl text-white"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 mb-2">Passionate</h3>
                        <p class="text-gray-600">We love what we do and it shows in every detail of our service</p>
                    </div>
                    <div class="glass-effect rounded-2xl p-8 transform hover:scale-105 transition-all duration-300">
                        <div class="bg-gradient-to-r from-green-500 to-blue-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-users text-2xl text-white"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 mb-2">Personal</h3>
                        <p class="text-gray-600">Every journey is tailored to your unique preferences and desires</p>
                    </div>
                    <div class="glass-effect rounded-2xl p-8 transform hover:scale-105 transition-all duration-300">
                        <div class="bg-gradient-to-r from-orange-500 to-red-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-shield-alt text-2xl text-white"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 mb-2">Professional</h3>
                        <p class="text-gray-600">Trusted expertise with years of experience in travel industry</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="gradient-bg py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center text-white mb-16">
                <h2 class="text-4xl font-bold mb-4">Our Journey in Numbers</h2>
                <p class="text-xl opacity-90">These numbers represent our commitment to excellence</p>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center text-white">
                <div class="stat-counter">
                    <div class="text-5xl font-bold mb-2">500+</div>
                    <div class="text-lg opacity-90">Destinations</div>
                </div>
                <div class="stat-counter">
                    <div class="text-5xl font-bold mb-2">10K+</div>
                    <div class="text-lg opacity-90">Happy Travelers</div>
                </div>
                <div class="stat-counter">
                    <div class="text-5xl font-bold mb-2">15+</div>
                    <div class="text-lg opacity-90">Years Experience</div>
                </div>
                <div class="stat-counter">
                    <div class="text-5xl font-bold mb-2">4.9★</div>
                    <div class="text-lg opacity-90">Average Rating</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Story Section -->
    <section class="py-20 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                <div>
                    <h2 class="text-4xl font-bold text-gray-900 mb-6">Our Story</h2>
                    <p class="text-lg text-gray-600 mb-6 leading-relaxed">
                        Founded in 2009 by a group of passionate travelers, TourMate began as a small travel agency
                        with a big dream: to make extraordinary travel experiences accessible to everyone. What started
                        as a local business has grown into a trusted global platform.
                    </p>
                    <p class="text-lg text-gray-600 mb-8 leading-relaxed">
                        Today, we're proud to serve thousands of travelers worldwide, offering personalized journey
                        planning, exclusive destinations, and unforgettable experiences that create lasting memories.
                    </p>
                    <div class="flex flex-wrap gap-4">
                        <div class="bg-white rounded-lg p-4 shadow-md">
                            <div class="flex items-center">
                                <div class="bg-green-100 p-2 rounded-full mr-3">
                                    <i class="fas fa-check-circle text-green-600"></i>
                                </div>
                                <span class="font-semibold">Certified Travel Agency</span>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg p-4 shadow-md">
                            <div class="flex items-center">
                                <div class="bg-blue-100 p-2 rounded-full mr-3">
                                    <i class="fas fa-award text-blue-600"></i>
                                </div>
                                <span class="font-semibold">Award Winning Service</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="relative">
                    <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                         alt="Our Story"
                         class="rounded-2xl shadow-2xl w-full h-96 object-cover">
                    <div class="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent rounded-2xl"></div>
                    <div class="absolute bottom-6 left-6 text-white">
                        <h3 class="text-2xl font-bold mb-2">Adventure Awaits</h3>
                        <p class="text-lg opacity-90">Every destination tells a story</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="py-20 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 mb-4">Meet Our Team</h2>
                <p class="text-xl text-gray-600 max-w-2xl mx-auto">
                    Our passionate team of travel experts is dedicated to making your journey unforgettable
                </p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="text-center group">
                    <div class="relative mb-6">
                        <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80"
                             alt="Team Member"
                             class="w-32 h-32 rounded-full mx-auto object-cover group-hover:scale-110 transition-transform duration-300">
                        <div class="absolute inset-0 rounded-full bg-gradient-to-t from-blue-600 to-transparent opacity-0 group-hover:opacity-20 transition-opacity duration-300"></div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">John Smith</h3>
                    <p class="text-gray-600 mb-4">Founder & CEO</p>
                    <div class="flex justify-center space-x-4">
                        <a href="#" class="text-blue-600 hover:text-blue-800 transition-colors">
                            <i class="fab fa-linkedin"></i>
                        </a>
                        <a href="#" class="text-blue-400 hover:text-blue-600 transition-colors">
                            <i class="fab fa-twitter"></i>
                        </a>
                    </div>
                </div>
                <div class="text-center group">
                    <div class="relative mb-6">
                        <img src="https://images.unsplash.com/photo-1494790108755-2616c366e09b?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80"
                             alt="Team Member"
                             class="w-32 h-32 rounded-full mx-auto object-cover group-hover:scale-110 transition-transform duration-300">
                        <div class="absolute inset-0 rounded-full bg-gradient-to-t from-purple-600 to-transparent opacity-0 group-hover:opacity-20 transition-opacity duration-300"></div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Sarah Johnson</h3>
                    <p class="text-gray-600 mb-4">Travel Operations Manager</p>
                    <div class="flex justify-center space-x-4">
                        <a href="#" class="text-blue-600 hover:text-blue-800 transition-colors">
                            <i class="fab fa-linkedin"></i>
                        </a>
                        <a href="#" class="text-pink-500 hover:text-pink-700 transition-colors">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>
                <div class="text-center group">
                    <div class="relative mb-6">
                        <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80"
                             alt="Team Member"
                             class="w-32 h-32 rounded-full mx-auto object-cover group-hover:scale-110 transition-transform duration-300">
                        <div class="absolute inset-0 rounded-full bg-gradient-to-t from-green-600 to-transparent opacity-0 group-hover:opacity-20 transition-opacity duration-300"></div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Michael Chen</h3>
                    <p class="text-gray-600 mb-4">Customer Experience Lead</p>
                    <div class="flex justify-center space-x-4">
                        <a href="#" class="text-blue-600 hover:text-blue-800 transition-colors">
                            <i class="fab fa-linkedin"></i>
                        </a>
                        <a href="#" class="text-blue-400 hover:text-blue-600 transition-colors">
                            <i class="fab fa-twitter"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="py-20 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 mb-4">Our Values</h2>
                <p class="text-xl text-gray-600">The principles that guide everything we do</p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div class="text-center">
                    <div class="bg-gradient-to-r from-blue-500 to-purple-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-compass text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Adventure</h3>
                    <p class="text-gray-600">We believe in pushing boundaries and exploring the unknown</p>
                </div>
                <div class="text-center">
                    <div class="bg-gradient-to-r from-green-500 to-blue-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-handshake text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Trust</h3>
                    <p class="text-gray-600">Building lasting relationships through transparency and reliability</p>
                </div>
                <div class="text-center">
                    <div class="bg-gradient-to-r from-orange-500 to-red-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-lightbulb text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Innovation</h3>
                    <p class="text-gray-600">Constantly evolving to provide cutting-edge travel solutions</p>
                </div>
                <div class="text-center">
                    <div class="bg-gradient-to-r from-purple-500 to-pink-600 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-globe-americas text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">Sustainability</h3>
                    <p class="text-gray-600">Promoting responsible travel that preserves our planet</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="gradient-bg py-20">
        <div class="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
            <h2 class="text-4xl font-bold text-white mb-6">Ready to Start Your Adventure?</h2>
            <p class="text-xl text-gray-200 mb-8 leading-relaxed">
                Join thousands of happy travelers who have trusted TourMate with their dream vacations.
                Let us help you create memories that will last a lifetime.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="${pageContext.request.contextPath}/packages" class="bg-white text-primary font-bold py-4 px-8 rounded-full hover:bg-gray-100 transition-all duration-300 transform hover:scale-105 shadow-lg">
                    <i class="fas fa-suitcase mr-2"></i>View Our Packages
                </a>
                <a href="${pageContext.request.contextPath}/contact" class="bg-transparent border-2 border-white text-white font-bold py-4 px-8 rounded-full hover:bg-white hover:text-primary transition-all duration-300">
                    <i class="fas fa-envelope mr-2"></i>Contact Us
                </a>
            </div>
        </div>
    </section>

    <script>
        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // Observe all sections
        document.addEventListener('DOMContentLoaded', function() {
            const sections = document.querySelectorAll('section > div');
            sections.forEach(section => {
                observer.observe(section);
            });
        });
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
