// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/authStore';
const router = createRouter({
    history: createWebHistory(),
    routes: [{
        path: '/login',
        name: 'Login',
        // component: LoginView,
        component: () =>
            import('@/components/LoginComponent.vue'),
        meta: { title: 'Login', allowSessionTimeout: false }
    },
    {
        path: '/account',
        name: 'Account',
        component: () =>
            import('@/views/AboutView.vue')
    },
    {
        path: '/',
        name: 'Home',
        component: () =>
            import('@/views/CalendarView.vue'),
        meta: { title: 'Calendar', requiresAuth: true, allowSessionTimeout: true }
    },
    {
        path: '/owners',
        name: 'Owners',
        component: () =>
            import('@/views/OwnersList.vue'),
        meta: { title: 'Owners List', allowSessionTimeout: true }
    },

    {
        path: '/:ownerid/pets',
        name: 'OwnerPets',
        meta: { title: 'Owner Pets', transition: 'slide-right', allowSessionTimeout: true },
        component: () =>
            import('@/views/OwnerPets.List.vue'),
        props: true, // This passes the route params as props to the component,
        // meta: { title: 'About Page' }
    },
    {
        path: '/new-owner',
        name: 'NewOwner',
        component: () =>
            import('@/views/AddNewOwner.vue'),

        props: true, // This passes the route params as props to the component,
        meta: { title: 'New Owner', allowSessionTimeout: true }
    },
        {
            path: '/clinics',
            name: 'Clinics',
            component: () =>
                import('@/views/ListUserClinics.vue'),
            meta: { title: 'Clinics', allowSessionTimeout: true }
        },
        {
            path: '/:clinic/manage',
            name: 'Manage Clinic',
            meta: { title: 'Manage Clinic', transition: 'slide-right', allowSessionTimeout: true },
            component: () =>
                import('@/views/ManageClinic.vue'),
            props: true, // This passes the route params as props to the component,
            // meta: { title: 'About Page', allowSessionTimeout: true }
        },
        {
            path: '/clinics/:clinic/branches',
            name: 'Manage Clinic Branches',
            meta: { title: 'Manage Clinic Branches', transition: 'slide-right', allowSessionTimeout: true },
            component: () =>
                import('@/views/ListClinicBranches.vue'),
            props: true, // This passes the route params as props to the component,
            // meta: { title: 'About Page', allowSessionTimeout: true }
        },
        {
            path: '/branches/:branch/users',
            name: 'Branch Users',
            meta: { title: 'Manage Branch Users', transition: 'slide-right', allowSessionTimeout: true },
            component: () =>
                import('@/views/ManageBranch.vue'),
            props: true, // This passes the route params as props to the component,
            // meta: { title: 'About Page', allowSessionTimeout: true }
        },

    {
        path: '/pets',
        name: 'Pets',
        component: () =>
            import('@/views/PetsList.vue'),
        meta: { title: 'Patient List', allowSessionTimeout: true }
    },
    {
        path: '/pets/:petmicrochip',
        name: 'PetDetails',
        component: () =>
            import('@/views/PetDetails.vue'),
        meta: { title: 'Pet Details', allowSessionTimeout: true }
    }, {
        path: '/new-pet',
        name: 'AddNewPet',
        component: () =>
            import('@/views/AddNewPet.vue'),
        meta: { title: 'Add New Pet', allowSessionTimeout: true }
    },
    {
        path: '/about',
        name: 'About',
        component: () =>
            import('@/views/AboutView.vue'),
        meta: { title: 'About Page', allowSessionTimeout: true }
    },
    {
        path: '/profile',
        name: 'Profile',
        component: () =>
            import('@/views/UserProfile.vue'),
        meta: { title: 'User Profile', allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-food',
        name: 'New Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { title: 'Add New Inventory | Food', allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-toys',
        name: 'New Toys Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { title: 'Add New Inventory | Toys', allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-pharmaceutical',
        name: 'New Pharmaceutical Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { title: 'Add New Inventory | Pharmaceutical', allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-grooming',
        name: 'New Grooming Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { title: 'Add New Inventory | Grooming', allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-treatment',
        name: 'New Treatment Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { title: 'Add New Inventory | Treatment ', allowSessionTimeout: true }
    },
    {
        path: '/invoices',
        name: 'Invoice List',
        component: () =>
            import('@/views/InvoiceList.vue'),
        meta: { title: 'Invoices', allowSessionTimeout: true }
    },
    {
        path: '/settings',
        name: 'Settings',
        component: () =>
            import('@/views/WhatsAppOnboardingLanding.vue'),
        // import('@/views/Settings.vue'),
        meta: { title: 'Settings', allowSessionTimeout: true, requiresAuth: true }
    },
        {
            path: '/reset-password',
            name: 'reset-password',
            component: () =>
                import('@/components/LoginComponent.vue'),
            props: (route) => ({
                action: 'reset',
                code: route.query.code
            })
        },
        // {
        //     path: '/shortcuts',
        //     name: 'Shortcuts',
        //     component: () =>
        //         import('@/views/Shortcuts.vue'),
        //     meta: { title: 'About Page',allowSessionTimeout: true }
        // },
        {
            path: '/accept-invite',
            name: 'AcceptInvite',
            component: () => import('@/views/AcceptInvite.vue'),
            meta: { title: 'Accept Invite', public: true } // If using auth guards
        },
        {
        path: '/reports',
        component: () =>
            import('@/views/Reports.vue'),
        // component: Reports, // Your current component
        children: [
            {
                path: 'stock-movement', component: () => import('@/views/partials/Reports/StockMovement.vue'),
                meta: { title: 'Stock Movement Reports', allowSessionTimeout: true }
            },
            {
                path: 'patients', component: () => import('@/views/partials/Reports/Patients.vue'),
                meta: { title: 'Patient Visits Reports', allowSessionTimeout: true }
            },
            // {
            //     path: 'sales', component: () => import('@/views/partials/Reports/Sales.vue'),
            //     meta: { title: 'About Page',allowSessionTimeout: true }
            // },
        ]
    },
    {
        path: '/whatsapp/onboarding',
        name: 'whatsapp-onboarding',
        component: () => import('@/views/WhatsAppOnboardingLanding.vue'),
        meta: {
            title: 'WhatsApp Integration', 
                requiresAuth: true,
                breadcrumb: 'WhatsApp Setup',
                feature: 'whatsapp_integration'
            }
        },
        {
            path: '/whatsapp/onboarding/number-verification',
            name: 'whatsapp-number-verification',
            // component: () => import('@/views/WhatsAppNumberVerification.vue'),
            component: () => import('@/views/WahaNumVerifiy.vue'),
            // component: WhatsAppNumberVerification,
            meta: {
                title: 'WhatsApp Number Verification', 
                requiresAuth: true,
                breadcrumb: 'Number Verification',
                feature: 'whatsapp_integration'
            }
        },
        {
            path: '/whatsapp/onboarding/qr-scan',
            name: 'whatsapp-qr-scanner',
            component: () => import('@/views/WhatsAppQRScanner.vue'),
            meta: {
                title: 'WhatsApp Login', 
                requiresAuth: true,
                breadcrumb: 'QR Connection',
                feature: 'whatsapp_integration'
            },
            props: route => ({
                phone: route.query.phone
            })
        },
        {
        path: '/logout',
        name: 'Logout',
    },
    ],
    scrollBehavior(to, from, savedPosition) {
        // always scroll to top
        return { top: 0 }
    },
});
const app_title = import.meta.env.VITE_APP_TITLE;

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore();
    if (to.meta.requiresAuth && !authStore.isLoggedIn) {
        next({ name: 'Login' });
    } else if (to.fullPath === "/logout") {
        authStore.logOut();
    }
    else {
        next();
    }
});
router.afterEach((to) => {
    document.title = to.meta.title + " | " + import.meta.env.VITE_APP_TITLE || 'Default Title';
});
export default router;