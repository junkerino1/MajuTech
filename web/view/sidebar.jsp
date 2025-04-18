 <aside class="left-sidebar">
            <!-- Sidebar scroll-->
            <div>
                <div class="brand-logo d-flex align-items-center justify-content-between">
                    <a href="./index.html" class="text-nowrap logo-img">
                        <img src="${pageContext.request.contextPath}/image/logo.png" width="100" height="84" alt="Company Logo" />
                    </a>
                </div>
                <!-- Sidebar navigation-->
                <nav class="sidebar-nav scroll-sidebar" data-simplebar="">
                    <ul id="sidebarnav">
                        <li class="sidebar-item">
                            <a class="sidebar-link" href="" aria-expanded="false">
                                <span>
                                    <i class="bi bi-house"></i>
                                </span>
                                <span class="hide-menu">Home</span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                                <span>
                                    <i class="bi bi-box"></i>
                                </span>
                                <span class="hide-menu">Products</span>
                            </a>
                            <ul class="collapse first-level" aria-expanded="false">
                                <li class="sidebar-item">
                                    <a href="${pageContext.request.contextPath}/products-list" class="sidebar-link">
                                        <span class="hide-menu">Product List</span>
                                    </a>
                                </li>
                                <li class="sidebar-item">
                                    <a href="${pageContext.request.contextPath}/add-product" class="sidebar-link">
                                        <span class="hide-menu">Add Product</span>
                                    </a>
                                </li>
                                <li class="sidebar-item">
                                    <a href="${pageContext.request.contextPath}/campaign" class="sidebar-link">
                                        <span class="hide-menu">Promotion Campaign</span>
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li class="sidebar-item">
                            <a class="sidebar-link has-arrow" href="javascript:void(0)" aria-expanded="false">
                              <span>
                                <i class="bi bi-person"></i>
                              </span>
                              <span class="hide-menu">Staff</span>
                            </a>
                            <ul class="collapse first-level" aria-expanded="false">
                              <li class="sidebar-item">
                                <a href="staff-list.html" class="sidebar-link">
                                  <span class="hide-menu">Staff List</span>
                                </a>
                              </li>
                              <li class="sidebar-item">
                                <a href="add-staff.html" class="sidebar-link">
                                  <span class="hide-menu">Add Staff</span>
                                </a>
                              </li>
                            </ul>
                          </li>
                        <li class="sidebar-item">
                            <a class="sidebar-link" href="#" aria-expanded="false">
                                <span>
                                    <i class="bi bi-people"></i>
                                </span>
                                <span class="hide-menu">Customer</span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a class="sidebar-link" href="admin-profile.html" aria-expanded="false">
                                <span>
                                    <i class="bi bi-person-square"></i>
                                </span>
                                <span class="hide-menu">Profile</span>
                            </a>
                        </li>
                    </ul>
                </nav>
                <!-- End Sidebar navigation -->
            </div>
            <!-- End Sidebar scroll-->
        </aside>