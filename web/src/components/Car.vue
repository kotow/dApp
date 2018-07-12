<template>
    <div>
        <form v-if="this.isService">
           <!-- Repair car-->
        </form>
        <!-- Car info -->
        <table class="list">
            <tr v-for="repair in repairs" :key="repair.VIN">
                <!-- List repairs-->
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
                repairs: [],
                model: null,
                VIN: null
            }
        },
        methods: {
        },
        created() {
            console.log(this.$route.params.VIN);
            let self = this;
            this.contract.carRepaired({VIN: this.$route.params.VIN}, {fromBlock: 0, toBlock: 'latest'}).get((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    eventResult.map(function (value, key) {
                        self.repairs.push(value.args);
                    });
                }
            });
            console.log(this.cars)
        }
    }
</script>

<style>
</style>