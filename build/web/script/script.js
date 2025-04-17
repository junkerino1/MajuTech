document.addEventListener("DOMContentLoaded", function () {
      const dropdownLinks = document.querySelectorAll(".sidebar-link.has-arrow");
  
      dropdownLinks.forEach(link => {
        link.addEventListener("click", function (e) {
          e.preventDefault();
  
          const parentItem = link.closest(".sidebar-item");
          const submenu = parentItem.querySelector(".first-level");
  
          const isOpen = submenu.classList.contains("show");
  
          // Close all open submenus (optional accordion behavior)
          document.querySelectorAll(".first-level.show").forEach(openMenu => {
            if (openMenu !== submenu) {
              openMenu.classList.remove("show");
            }
          });
  
          // Toggle the clicked submenu
          submenu.classList.toggle("show");
        });
      });
    });