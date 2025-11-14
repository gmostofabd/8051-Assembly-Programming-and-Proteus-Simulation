const carouselSlide = document.getElementById('carouselSlide');
const carouselDots = document.getElementById('carouselDots');
let index = 0;
const totalImages = carouselSlide.children.length;

// Create dots dynamically
for (let i = 0; i < totalImages; i++) {
    const dot = document.createElement('span');
    dot.addEventListener('click', () => goToSlide(i));
    carouselDots.appendChild(dot);
}

// Show initial slide
updateDots();
showSlide(index);

function showSlide(i) {
    carouselSlide.style.transform = `translateX(-${i * 100}%)`;
    updateDots();
}

function nextSlide() {
    index = (index + 1) % totalImages;
    showSlide(index);
}

function prevSlide() {
    index = (index - 1 + totalImages) % totalImages;
    showSlide(index);
}

function goToSlide(i) {
    index = i;
    showSlide(index);
}

function updateDots() {
    const dots = carouselDots.children;
    for (let i = 0; i < dots.length; i++) {
        dots[i].classList.remove('active');
    }
    dots[index].classList.add('active');
}

// Infinite auto-slide every 4 seconds
setInterval(nextSlide, 4000);
