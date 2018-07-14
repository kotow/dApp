<template>
    <div>
        <div class="form">
            <form v-if="this.isManufacturer" @submit="createCar">
                <label for="model">Model</label>
                <input id="model" name="model" type="text" v-model="model">
                <label for="VIN">VIN Number</label>
                <input id="VIN" name="VIN" type="text" v-model="VIN">
                <button :disabled="!model || !VIN" >Create Car</button>
            </form>
        </div>
        <table class="list">
            <thead>
                <td>VIN Number</td>
                <td>Model</td>
                <td>Details</td>
            </thead>
            <tr v-for="car in cars" :key="car.VIN">
                <td>{{ web3js.toAscii(car.VIN) }}</td>
                <td>{{ car.model }}</td>
                <td>
                    <router-link :to="{ name: 'Car', params: { VIN: car.VIN } }">View Details</router-link>
                </td>
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
            this.contract.carCreated({manufaturerAddress: this.$route.params.address}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                        self.cars.push(eventResult.args);
                        console.log(eventResult.args);
                        console.log(web3.toAscii(eventResult.args.VIN));
                }
            });
            console.log(this.cars)
        }
    }
</script>

<style>
input[type=text], select {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

button {
    width: 100%;
    background-color: #4CAF50;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:disabled {
    background-color: #b2b2b2;
}

div.form {
    border-radius: 5px;
    background-color: #f2f2f2;
    padding: 20px;
    color: black;
}

img {
    display: block;
    width: 100%;
    height: auto;
}

table.list {
    padding-top: 100px;
    border-collapse: collapse;
    width: 100%;
    border: 2px solid black;
}
table.list thead {
    background-color: #4CAF50;
    color: white;
    height: 25px;
}
table.list td {
    text-align: left;
    padding: 8px;
    height: 100px;
    border: 2px solid black;
}
table.list tr:nth-child(even){background-color: #c2c2c2}
table.list tr:nth-child(odd){background-color: #929292}
table.list img {
    display:block; width:100px; height:auto;
}
</style>