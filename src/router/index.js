// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/CalendarView.vue';
import LoginView from '../components/LoginComponent.vue';
import OwnerPets from '../views/OwnerPets.List.vue';
import OwnersList from '../views/OwnersList.vue';
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
        path: '/invoices',
        name: 'Invoice List',
        component: () =>
            import('../views/InvoiceList.vue'),
        meta: { allowSessionTimeout: true }
    },
    ]
});

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore();
    if (to.meta.requiresAuth && !authStore.isLoggedIn) {
        // // console.log("Not logged in, redirecting...");
        next({ name: 'Login' });
    } else {
        // // console.log("Logged in or not required, proceeding...");
        next();
    }
});

export default router;