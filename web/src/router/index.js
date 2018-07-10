import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Manufacturers from '@/components/Manufacturers'
import Cars from '@/components/Cars'

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
      path: '/cars',
      name: 'Cars',
      component: Cars
    }
  ]
})
