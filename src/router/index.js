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
        meta: { allowSessionTimeout: false }
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
        meta: { requiresAuth: true, allowSessionTimeout: true }
    },
    {
        path: '/owners',
        name: 'Owners',
        component: () =>
            import('@/views/OwnersList.vue'),
        meta: { allowSessionTimeout: true }
    },

    {
        path: '/:ownerid/pets',
        name: 'OwnerPets',
        meta: { transition: 'slide-right' },
        component: () =>
            import('@/views/OwnerPets.List.vue'),
        props: true, // This passes the route params as props to the component,
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/new-owner',
        name: 'NewOwner',
        component: () =>
            import('@/views/AddNewOwner.vue'),

        props: true, // This passes the route params as props to the component,
        meta: { allowSessionTimeout: true }
    },
        {
            path: '/clinics',
            name: 'Clinics',
            component: () =>
                import('@/views/ListUserClinics.vue'),
            meta: { allowSessionTimeout: true }
        },
        {
            path: '/:clinic/manage',
            name: 'Manage Clinic',
            meta: { transition: 'slide-right' },
            component: () =>
                import('@/views/ManageClinic.vue'),
            props: true, // This passes the route params as props to the component,
            meta: { allowSessionTimeout: true }
        },
        {
            path: '/clinics/:clinic/branches',
            name: 'Manage Clinic Branches',
            meta: { transition: 'slide-right' },
            component: () =>
                import('@/views/ListClinicBranches.vue'),
            props: true, // This passes the route params as props to the component,
            meta: { allowSessionTimeout: true }
        },
        {
            path: '/branches/:branch/users',
            name: 'Branch Users',
            meta: { transition: 'slide-right' },
            component: () =>
                import('@/views/ManageBranch.vue'),
            props: true, // This passes the route params as props to the component,
            meta: { allowSessionTimeout: true }
        },

    {
        path: '/pets',
        name: 'Pets',
        component: () =>
            import('@/views/PetsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/pets/:petmicrochip',
        name: 'PetDetails',
        component: () =>
            import('@/views/PetDetails.vue'),
        meta: { allowSessionTimeout: true }
    }, {
        path: '/new-pet',
        name: 'AddNewPet',
        component: () =>
            import('@/views/AddNewPet.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/about',
        name: 'About',
        component: () =>
            import('@/views/AboutView.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/profile',
        name: 'Profile',
        component: () =>
            import('@/views/UserProfile.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-food',
        name: 'New Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-toys',
        name: 'New Toys Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-pharmaceutical',
        name: 'New Pharmaceutical Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-grooming',
        name: 'New Grooming Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-treatment',
        name: 'New Treatment Inventory',
        component: () =>
            import('@/views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/invoices',
        name: 'Invoice List',
        component: () =>
            import('@/views/InvoiceList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/settings',
        name: 'Settings',
        component: () =>
            import('@/views/WhatsAppOnboardingLanding.vue'),
        // import('@/views/Settings.vue'),
        meta: { allowSessionTimeout: true, requiresAuth: true }
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
        //     meta: { allowSessionTimeout: true }
        // },
        {
            path: '/accept-invite',
            name: 'AcceptInvite',
            component: () => import('@/views/AcceptInvite.vue'),
            meta: { public: true } // If using auth guards
        },
        {
        path: '/reports',
        component: () =>
            import('@/views/Reports.vue'),
        // component: Reports, // Your current component
        children: [
            {
                path: 'stock-movement', component: () => import('@/views/partials/Reports/StockMovement.vue'),
                meta: { allowSessionTimeout: true }
            },
            {
                path: 'patients', component: () => import('@/views/partials/Reports/Patients.vue'),
                meta: { allowSessionTimeout: true }
            },
            // {
            //     path: 'sales', component: () => import('@/views/partials/Reports/Sales.vue'),
            //     meta: { allowSessionTimeout: true }
            // },
        ]
    },
    {
        path: '/whatsapp/onboarding',
        name: 'whatsapp-onboarding',
        component: () => import('@/views/WhatsAppOnboardingLanding.vue'),
            meta: {
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

export default router;