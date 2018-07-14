<template>
    <div id="app">
        <rwv-header></rwv-header>
        <router-view/>
    </div>
</template>

<script>
/* eslint-disable */
import RwvHeader from '@/components/Header'
export default {
  name: 'App',
    components: {
        RwvHeader
    }
}
</script>

<style>
html {
    background-color: #4dc71f;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #333333;
}

li {
    float: left;
    border-right: 1px solid #bbb;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

/* Change the link color to #111 (black) on hover */
li a:hover {
    background-color: #111111;
}
.active {
    background-color: #4CAF50;
}
</style>
