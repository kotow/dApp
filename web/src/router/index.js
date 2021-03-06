import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Manufacturers from '@/components/Manufacturers'
import Cars from '@/components/Cars'
import Car from '@/components/Car'
import Services from '@/components/Services'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    {
      path: '/manufaturers',
      name: 'Manufacturers',
      component: Manufacturers
    },
    {
      path: '/services',
      name: 'Services',
      component: Services
    },
    {
      path: '/cars/:address',
      name: 'Cars',
      component: Cars
    },
    {
      path: '/car/:VIN',
      name: 'Car',
      component: Car
    }
  ]
})
