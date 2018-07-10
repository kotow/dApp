import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Manufacturers from '@/components/Manufacturers'

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
    }
  ]
})
