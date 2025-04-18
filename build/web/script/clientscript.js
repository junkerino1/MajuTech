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