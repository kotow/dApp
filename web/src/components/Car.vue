<template>
    <div>
        <div class="form">
            <form v-if="this.isService" @submit="repairCar">
                <label for="mileage">Milleage</label>
                <input id="mileage" name="mileage" type="text" v-model="mileage">
                <label for="details"> Repair details</label>
                <input id="details" name="details" type="text" v-model="details">
                <label for="photo">Repair document</label>
                <input type="file" name="photo" id="photo" @change="processFile($event)">
                <button :disabled="!mileage || !details || !documentUploaded" >Repair Car</button>
            </form>
        </div>

        <div v-if="this.car">
            <p>Model: {{ car.model }}</p>
            <p>VIN Number: {{ web3js.toAscii(car.VIN) }}</p>
            <p>Date of creation: {{ formatDate(car.dateCreated) }}</p>
            <p>Warranty: {{ formatDate(car.warrantyUntil) }}</p>
            <p>Warranty active: {{ warrantyActive }}</p>
        </div>

        <table class="list">
            <tr v-for="repair in repairs" :key="repair.VIN">
                <td>{{ repair.details }}</td>
                <td>{{ repair.mileage }}</td>
                <td>{{ formatDate(repair.date) }}</td>
                <td>{{ repair.authorised }}</td>
                <td>{{ getUrl(repair.documentLink) }}</td>
            </tr>
        </table>
    </div>

</template>

<script>
/* eslint-disable */
import Base from './Base'
import moment from 'moment'
const ipfsAPI = require('ipfs-api');
const buffer = require('buffer');

    export default {
        extends: Base,
        data() {
            return {
                repairs: [],
                car: null,
                model: null,
                VIN: null,
                warrantyActive: true,
                details: null,
                mileage: null,
                document: null,
                documentUploaded: false
            }
        },
        methods: {
            getUrl(path) {
                return 'http://localhost:8080/ipfs/' + path;
            },
            processFile(event) {
                let file = event.target.files[0];
                let self = this;
                const reader = new FileReader();
                reader.readAsArrayBuffer(file);
                reader.onload = function () {
                    const ipfs = ipfsAPI('localhost', '5001', {protocol: 'http'});
                    const buf = buffer.Buffer(reader.result);
                    ipfs.files.add(buf, (err, result) => {
                        if (err) {
                            console.log("Something went wrong when trying to upload the photo.", err);
                            return;
                        }
                        self.document = result[0].hash;
                        self.documentUploaded = true;
                    })
                }
            },
            formatDate(date) {
                if (date) {
                    return moment((date * 1000)).format('MM/DD/YYYY')
                }
            },
            repairCar: function (event) {
                this.contract.repairCar(this.car.VIN, this.document, this.details, this.mileage, (err, resp) => {
                    console.log(err);
                });

            }
        },
        created() {
            console.log(this.$route.params.VIN);
            let self = this;
            this.contract.carRepaired({VIN: this.$route.params.VIN}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {

                        self.repairs.push(eventResult.args);

                }
            });
            this.contract.carCreated({VIN: this.$route.params.VIN}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                console.log(eventResult)
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                        self.car = eventResult.args;
                    self.contract.warrantyCanceled({VIN: self.$route.params.VIN}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                        console.log('12344444', eventResult)
                        if (eventResult) self.warrantyActive = false;
                    });
                }
            });
            console.log(this.car)
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