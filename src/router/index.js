// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/CalendarView.vue';
import LoginView from '../components/LoginComponent.vue';
import OwnerPets from '../views/OwnerPets.List.vue';
import OwnersList from '../views/OwnersList.vue';
import Reports from '@/views/Reports.vue'
import { useAuthStore } from '@/stores/authStore';

const router = createRouter({
    history: createWebHistory(),
    routes: [{
        path: '/login',
        name: 'Login',
        component: LoginView,
        meta: { allowSessionTimeout: false }
    },
    {
        path: '/account',
        name: 'Account',
        component: () =>
            import('../views/AboutView.vue')
    },
    {
        path: '/',
        name: 'Home',
        component: HomeView,
        meta: { requiresAuth: true, allowSessionTimeout: true }
    },
    {
        path: '/owners',
        name: 'Owners',
        component: OwnersList,
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/:ownerid/pets',
        name: 'OwnerPets',
        component: OwnerPets,

        props: true, // This passes the route params as props to the component,
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/new-owner',
        name: 'NewOwner',
        component: () =>
            import('../views/AddNewOwner.vue'),

        props: true, // This passes the route params as props to the component,
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/pets',
        name: 'Pets',
        component: () =>
            import('../views/PetsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/pets/:petmicrochip',
        name: 'PetDetails',
        component: () =>
            import('../views/PetDetails.vue'),
        meta: { allowSessionTimeout: true }
    }, {
        path: '/new-pet',
        name: 'AddNewPet',
        component: () =>
            import('../views/AddNewPet.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/about',
        name: 'About',
        component: () =>
            import('../views/AboutView.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/profile',
        name: 'Profile',
        component: () =>
            import('../views/UserProfile.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-food',
        name: 'New Inventory',
        component: () =>
            import('../views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-toys',
        name: 'New Toys Inventory',
        component: () =>
            import('../views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-pharmaceutical',
        name: 'New Pharmaceutical Inventory',
        component: () =>
            import('../views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-grooming',
        name: 'New Grooming Inventory',
        component: () =>
            import('../views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/add-inventory-treatment',
        name: 'New Treatment Inventory',
        component: () =>
            import('../views/InventoryItemsList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/invoices',
        name: 'Invoice List',
        component: () =>
            import('../views/InvoiceList.vue'),
        meta: { allowSessionTimeout: true }
    },
    {
        path: '/settings',
        name: 'Settings',
        component: () =>
            import('../views/Settings.vue'),
        meta: { allowSessionTimeout: true }
    },
        // {
        //     path: '/shortcuts',
        //     name: 'Shortcuts',
        //     component: () =>
        //         import('../views/Shortcuts.vue'),
        //     meta: { allowSessionTimeout: true }
        // },
    {
        path: '/reports',
        component: Reports, // Your current component
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
        path: '/logout',
        name: 'Logout',
    },
    ]
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