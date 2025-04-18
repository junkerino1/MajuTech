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
document.addEventListener('DOMContentLoaded', function () {
    const drop2Toggle = document.getElementById('drop2');
    const drop2Menu = document.querySelector('.dropdown-menu');

    // Toggle the dropdown visibility
    drop2Toggle.addEventListener('click', function (e) {
        e.preventDefault();
        drop2Menu.classList.toggle('show'); // Toggle visibility of the dropdown menu
    });

    // Close the dropdown if clicked outside
    document.addEventListener('click', function (e) {
        if (!drop2Toggle.contains(e.target) && !drop2Menu.contains(e.target)) {
            drop2Menu.classList.remove('show'); // Close the dropdown menu if clicked outside
        }
    });
});

