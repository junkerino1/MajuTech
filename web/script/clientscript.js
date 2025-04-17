const bar = document.getElementById("bar");
const close = document.getElementById("close");
const nav = document.getElementById("navbar");

if (bar) {
  bar.addEventListener("click", () => {
    nav.classList.add("active");
  });
}
if (close) {
  close.addEventListener("click", () => {
    nav.classList.remove("active");
  });
}

// Set the countdown date (3 days from now)
const countdownDate = new Date();
countdownDate.setDate(countdownDate.getDate() + 3);

// Update the countdown every second
const countdown = setInterval(function() {
    const now = new Date().getTime();
    const distance = countdownDate - now;
    
    // Calculate days, hours, minutes and seconds
    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);
    
    // Display the result
    document.getElementById("days").innerHTML = days.toString().padStart(2, '0');
    document.getElementById("hours").innerHTML = hours.toString().padStart(2, '0');
    document.getElementById("minutes").innerHTML = minutes.toString().padStart(2, '0');
    document.getElementById("seconds").innerHTML = seconds.toString().padStart(2, '0');
    
    // If the countdown is finished, display expired message
    if (distance < 0) {
        clearInterval(countdown);
        document.getElementById("days").innerHTML = "00";
        document.getElementById("hours").innerHTML = "00";
        document.getElementById("minutes").innerHTML = "00";
        document.getElementById("seconds").innerHTML = "00";
        
        document.querySelector(".promotion-subtitle").innerHTML = "Promotion Has Ended!";
    }
}, 1000);

function toggleFilter(element) {
  const content = element.nextElementSibling;
  const arrow = element.querySelector('.filter-arrow');
  
  content.classList.toggle('show');
  arrow.classList.toggle('rotated');
}

// Auto-expand the first filter on page load
document.addEventListener('DOMContentLoaded', function() {
  const firstFilter = document.querySelector('.filter-title');
  if (firstFilter) {
      toggleFilter(firstFilter);
  }
});