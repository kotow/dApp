<template>
    <div>
        <form v-if="this.isManufacturer">
            <input name="model" type="text" v-model="model">
            <input name="VIN" type="text" v-model="VIN">
            <a href="/#/manufaturers" disabled v-on:click="createCar()">SUBMIT</a>
        </form>
        <table class="list">
            <tr v-for="car in cars" :key="car.VIN">
                <td>{{ car.VIN }}</td>
                <td>{{ car.model }}</td>
                <td v-if="isService">
                    <a href="#">Repair</a>
                </td>
            </tr>
        </table>
    </div>

</template>

<script>
/* eslint-disable */
import Base from './Base'
    export default {
        extends: Base,
        data() {
            return {
                cars: [],
                model: null,
                VIN: null
            }
        },
        methods: {
            createCar() {
                this.contract.newCar(this.model, this.VIN, (err, resp) => {
                    console.log(err);
                    location.reload();
                });
            }
        },
        created() {
            console.log(this.$route.params.address);
            let self = this;
            this.contract.carCreated({manufaturerAddress: this.$route.params.address}, {fromBlock: 0, toBlock: 'latest'}).get((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    eventResult.map(function (value, key) {
                        self.cars.push(value.args);
                    });
                }
            });
            console.log(this.cars)
        }
    }
</script>

<style>
</style>