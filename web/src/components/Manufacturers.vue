<template>
    <div id="metamask-warning">
        <form v-if="this.isOwner">
            <input name="address" type="text" v-model="address">
            <input name="name" type="text" v-model="name">
            <input type="file" name="photo" id="photo" @change="processFile($event)">
            <a href="/#/manufaturers" disabled v-on:click="registerManufacturer">SUBMIT</a>
        </form>
        <table class="list">
            <tr v-for="manufacturer in manufacturers" :key="manufacturer._address">
                <td style="display: block;width: 100px;"><img :src="getUrl(manufacturer.logo)"/></td>
                <td>{{ manufacturer.name }}</td>
                <td>
                    <a :href="'#/cars/' + manufacturer._address">Cars</a>
                    <router-link :to="{ name: 'Cars', params: { address: manufacturer._address } }">Navigate to Page2</router-link>
                    <a href="#">Authorized services</a>
                </td>
            </tr>
        </table>
    </div>

</template>
<style>
    img {
        display: block;
        width:100%;
        height:auto;
    }
    table.list, table.list td {
        border: solid 1px;
    }
</style>
<script>
/* eslint-disable */
    import Base from './Base'
    const ipfsAPI = require('ipfs-api');
    const buffer = require('buffer');
    export default {
        extends: Base,
        data() {
            return {
                name: null,
                logo: null,
                address: null,
                manufacturers: [],
                logoUploaded: false,
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
                        self.logo = result[0].hash;
                        console.log(self.logo);
                    })
                }
            },
            registerManufacturer: function (event) {
                console.log(this.logo);
                console.log(this.name);
                console.log(this.address);
                this.contract.createManufacturer("0x6780eaB092d2BF8436e655e7CbA4772847Ca7D57", this.name, this.logo, (err, resp) => {
                    console.log(err);
                });

            }
        },
        created() {
            let self = this;
            this.contract.manufacturerCreated({}, {fromBlock: 0, toBlock: 'latest'}).get((error, eventResult) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    eventResult.map(function (value, key) {
                        self.manufacturers.push(value.args);
                    });
                }
            });
        }
    }
</script>

<style>
</style>