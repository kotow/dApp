<template>
    <div>
        <form v-if="!this.isService">
            <input name="name" type="text" v-model="name">
            <input name="address" type="text" v-model="address">
            <a href="/#/manufaturers" disabled v-on:click="createCar()">SUBMIT</a>
        </form>
        <table class="list">
            <tr v-for="service in services" :key="service.VIN">
                <td>{{ service.name }}</td>
                <td>{{ service.serviceAddress }}</td>
                <!--<td v-if="isManufaturer">-->
                    <!--<a href="#">Authorize</a>-->
                <!--</td>-->
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
                services: [],
                name: null,
                address: null
            }
        },
        methods: {
            createCar() {
                this.contract.newService(this.name, this.address, (err, resp) => {
                    console.log(err);
                    location.reload();
                });
            }
        },
        created() {
            let self = this;
            this.contract.serviceCreated({}, {fromBlock: 0, toBlock: 'latest'}).get((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    eventResult.map(function (value, key) {
                        self.services.push(value.args);
                    });
                }
            });
            console.log(this.cars)
        }
    }
</script>

<style>
</style>