<footer class="bg-gradient-to-r from-primary to-blue-600 text-white py-16">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

    <!-- Top Section -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-12 mb-12">

      <!-- Brand & Description -->
      <div class="lg:col-span-2 space-y-6">
        <div>
          <h2 class="text-3xl font-bold text-white mb-4">
            <i class="fas fa-compass mr-3"></i>TourMate
          </h2>
          <p class="text-gray-200 text-lg leading-relaxed">
            Your trusted travel companion for unforgettable adventures. We specialize in creating personalized
            travel experiences that blend culture, adventure, and comfort. From exotic destinations to local
            hidden gems, TourMate connects you with passionate guides and authentic experiences that create
            memories to last a lifetime.
          </p>
        </div>

        <!-- Social Media Icons -->
        <div class="flex space-x-4">
          <a href="#" class="bg-white bg-opacity-20 hover:bg-opacity-30 p-3 rounded-full transition-all duration-300 transform hover:scale-110">
            <i class="fab fa-facebook-f text-white"></i>
          </a>
          <a href="#" class="bg-white bg-opacity-20 hover:bg-opacity-30 p-3 rounded-full transition-all duration-300 transform hover:scale-110">
            <i class="fab fa-twitter text-white"></i>
          </a>
          <a href="#" class="bg-white bg-opacity-20 hover:bg-opacity-30 p-3 rounded-full transition-all duration-300 transform hover:scale-110">
            <i class="fab fa-instagram text-white"></i>
          </a>
          <a href="#" class="bg-white bg-opacity-20 hover:bg-opacity-30 p-3 rounded-full transition-all duration-300 transform hover:scale-110">
            <i class="fab fa-youtube text-white"></i>
          </a>
          <a href="#" class="bg-white bg-opacity-20 hover:bg-opacity-30 p-3 rounded-full transition-all duration-300 transform hover:scale-110">
            <i class="fab fa-linkedin-in text-white"></i>
          </a>
        </div>
      </div>

      <!-- Newsletter Subscription -->
      <div class="space-y-6">
        <div>
          <h3 class="text-xl font-bold text-white mb-3">
            <i class="fas fa-envelope mr-2"></i>Stay Connected
          </h3>
          <p class="text-gray-200 text-sm leading-relaxed mb-4">
            Subscribe to our newsletter and get exclusive travel deals, destination guides, and insider tips delivered to your inbox.
          </p>
        </div>

        <form class="space-y-4" onsubmit="subscribeFooter(event)">
          <div class="relative">
            <input
              type="email"
              id="footerEmail"
              placeholder="Enter your email address"
              required
              class="w-full px-4 py-3 pr-12 bg-white bg-opacity-20 border border-white border-opacity-30 rounded-xl text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent transition-all duration-300"
            />
            <button type="submit" class="absolute right-2 top-1/2 transform -translate-y-1/2 bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 p-2 rounded-lg transition-all duration-300">
              <i class="fas fa-paper-plane text-black"></i>
            </button>
          </div>
          <div class="flex items-center space-x-2">
            <input type="checkbox" id="footerPrivacy" class="rounded border-white border-opacity-30 text-yellow-400 focus:ring-yellow-400 bg-transparent">
            <label for="footerPrivacy" class="text-xs text-gray-300">
              I agree to receive marketing communications
            </label>
          </div>
        </form>
      </div>
    </div>

    <!-- Links Section -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 py-8 border-t border-white border-opacity-20">

      <!-- Services -->
      <div>
        <h3 class="font-bold text-white mb-4 uppercase tracking-wide">
          <i class="fas fa-cogs mr-2"></i>Services
        </h3>
        <ul class="space-y-3">
          <li><a href="/services/booking" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Travel Booking</a></li>
          <li><a href="/services/packages" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Custom Packages</a></li>
          <li><a href="/services/guides" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Tour Guides</a></li>
          <li><a href="/services/insurance" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Travel Insurance</a></li>
          <li><a href="/faq" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">FAQs</a></li>
        </ul>
      </div>

      <!-- Destinations -->
      <div>
        <h3 class="font-bold text-white mb-4 uppercase tracking-wide">
          <i class="fas fa-globe-americas mr-2"></i>Destinations
        </h3>
        <ul class="space-y-3">
          <li><a href="/destinations/asia" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Asia</a></li>
          <li><a href="/destinations/europe" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Europe</a></li>
          <li><a href="/destinations/america" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Americas</a></li>
          <li><a href="/destinations/africa" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Africa</a></li>
          <li><a href="/destinations/oceania" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Oceania</a></li>
        </ul>
      </div>

      <!-- Community -->
      <div>
        <h3 class="font-bold text-white mb-4 uppercase tracking-wide">
          <i class="fas fa-users mr-2"></i>Community
        </h3>
        <ul class="space-y-3">
          <li><a href="/community/blog" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Travel Blog</a></li>
          <li><a href="/community/vlogs" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Travel Vlogs</a></li>
          <li><a href="/community/events" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Events</a></li>
          <li><a href="/community/reviews" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Reviews</a></li>
          <li><a href="/community/forum" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Travel Forum</a></li>
        </ul>
      </div>

      <!-- Company -->
      <div>
        <h3 class="font-bold text-white mb-4 uppercase tracking-wide">
          <i class="fas fa-info-circle mr-2"></i>Company
        </h3>
        <ul class="space-y-3">
          <li><a href="/about-us" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">About Us</a></li>
          <li><a href="/careers" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Careers</a></li>
          <li><a href="/contact" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Contact Us</a></li>
          <li><a href="/press" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Press</a></li>
          <li><a href="/partnerships" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300 text-sm">Partnerships</a></li>
        </ul>
      </div>
    </div>

    <!-- Contact Info Section -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 py-8 border-t border-white border-opacity-20">
      <div class="flex items-center space-x-3">
        <div class="bg-yellow-400 p-3 rounded-full">
          <i class="fas fa-map-marker-alt text-black"></i>
        </div>
        <div>
          <h4 class="font-semibold text-white">Address</h4>
          <p class="text-gray-300 text-sm">123 Travel Street, Adventure City, AC 12345</p>
        </div>
      </div>

      <div class="flex items-center space-x-3">
        <div class="bg-yellow-400 p-3 rounded-full">
          <i class="fas fa-phone text-black"></i>
        </div>
        <div>
          <h4 class="font-semibold text-white">Phone</h4>
          <p class="text-gray-300 text-sm">+1 (555) 123-4567</p>
        </div>
      </div>

      <div class="flex items-center space-x-3">
        <div class="bg-yellow-400 p-3 rounded-full">
          <i class="fas fa-envelope text-black"></i>
        </div>
        <div>
          <h4 class="font-semibold text-white">Email</h4>
          <p class="text-gray-300 text-sm">info@tourmate.com</p>
        </div>
      </div>
    </div>

    <!-- Bottom Section -->
    <div class="flex flex-col md:flex-row justify-between items-center pt-8 border-t border-white border-opacity-20">
      <div class="flex flex-col md:flex-row items-center space-y-2 md:space-y-0 md:space-x-6">
        <p class="text-gray-300 text-sm">
          &copy; 2025 TourMate. All rights reserved.
        </p>
        <div class="flex space-x-4 text-sm">
          <a href="/privacy" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300">Privacy Policy</a>
          <a href="/terms" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300">Terms of Service</a>
          <a href="/cookies" class="text-gray-300 hover:text-yellow-400 transition-colors duration-300">Cookie Policy</a>
        </div>
      </div>

      <div class="mt-4 md:mt-0">
        <p class="text-gray-300 text-sm">
          Made with <i class="fas fa-heart text-red-400"></i> for travelers worldwide
        </p>
      </div>
    </div>

  </div>
</footer>

<!-- Footer JavaScript -->
<script>
function subscribeFooter(event) {
    event.preventDefault();
    const email = document.getElementById('footerEmail').value;
    const privacy = document.getElementById('footerPrivacy').checked;

    if (!privacy) {
        Swal.fire({
            title: 'Privacy Agreement',
            text: 'Please agree to receive marketing communications.',
            icon: 'warning',
            confirmButtonColor: '#f59e0b'
        });
        return;
    }

    if (email) {
        Swal.fire({
            title: 'Thank You!',
            text: 'Successfully subscribed to our newsletter!',
            icon: 'success',
            confirmButtonColor: '#f59e0b'
        });
        document.getElementById('footerEmail').value = '';
        document.getElementById('footerPrivacy').checked = false;
    }
}
</script>
