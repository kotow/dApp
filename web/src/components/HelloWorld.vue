<template>
    <div>
        <div v-if="this.web3js">
            <p>search</p>
            <select v-model="selected" @change="viewDetails()">
                <option disabled value="">kur</option>
                <option v-for="car in cars" v-bind:value="web3js.toAscii(car.VIN)">{{ web3js.toAscii(car.VIN) }}</option>
            </select>
        </div>
        <table class="cars">
            <thead>
                <td>
                    <p>Manucaturer</p>
                </td>
                <td>
                    <p>VIN</p>
                </td>
                <td>
                    <p>Model</p>
                </td>
                <td>
                    <p>Details</p>
                </td>
            </thead>
            <tr v-for="car in cars" :key="car.VIN">
                <td>
                    <div style="height: 100px; overflow:hidden;">
                        <img :src="logos[car.manufaturerAddress]"/>
                    </div>
                </td>
                <td>{{ web3js.toAscii(car.VIN) }}</td>
                <td>{{ car.model }}</td>
                <td>
                    <router-link :to="{ name: 'Car', params: { VIN: car.VIN } }">View Details</router-link>
                </td>
            </tr>
        </table>
    </div>

</template>

<script>
/* eslint-disable */
    import Base from './Base'
    import Vue from 'vue'
    import vSelect from 'vue-select'
    Vue.component('v-select', vSelect)

    export default {
        extends: Base,
        data() {
            return {
                cars: [],
                model: null,
                VIN: null,
                logos: [],
                selected: ''
            }
        },
        methods: {
            viewDetails: function () {
                window.location.href = 'http://localhost:1312/#/car/' + this.selected;
            },
        },
        created() {
            let self = this;
            this.contract.manufacturerCreated({}, {
                fromBlock: 0,
                toBlock: 'latest'
            }).get((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    eventResult.map(function (value, key) {
                        self.logos[value.args._address] = 'http://localhost:8080/ipfs/' + value.args.logo;
                    });
                }
                self.contract.carCreated({}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                    console.log('Error in myEvent event handler: ' + eventResult);
                    if (error)
                        console.log('Error in myEvent event handler: ' + eventResult);
                    else {
                        self.cars.push(eventResult.args);
                    }
                });
            });
        }
    }
</script>

<style>
    table.cars {
        padding-top: 100px;
        border-collapse: collapse;
        width: 100%;
        border: 2px solid black;
    }
    table.cars th {
        background-color: #4CAF50;
        color: white;
    }
    table.cars td {
        text-align: left;
        padding: 8px;
        height: 100px;
        border: 2px solid black;
    }
    table.cars tr:nth-child(1){width: 100px;}
    table.cars tr:nth-child(even){background-color: #c2c2c2}
    table.cars tr:nth-child(odd){background-color: #929292}
    table.cars img {
        display:block; width:100px; height:auto;
    }
</style>