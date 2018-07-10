<template>
    <div id="metamask-warning">
        <form v-if="this.isOwner">
            <input name="address" type="text" v-model="address">
            <input name="name" type="text" v-model="name">
            <input type="file" name="photo" id="photo" @change="processFile($event)">
            <a href="/#/manufaturers" disabled v-on:click="registerManufacturer">SUBMIT</a>
        </form>
        <ul id="example-1">
            <li v-for="manufacturer in manufacturers" :key="manufacturer.address">
                <img :src="getUrl(manufacturer.logo)"/>
                {{ manufacturer.name }}
            </li>
        </ul>
    </div>

</template>

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
                let self = this;
                this.contract.createManufacturer(this.web3js.eth.accounts[0], this.name, this.logo, (err, balance) => {
                    console.log(err);
                });
//                this.tokenContract.transferFrom(this.web3js.eth.accounts[0], "0x0b47c7a0b2E18aaa683759B5E04ED2C991d54409", 100000000000000000000, (err) => {
//                    if(!err) {
//                        self.contract.createManufacturer(self.account, self.name, self.logo, (err, balance) => {
//                            console.log(err);
//                        });
//                    }
//                    console.log(err);
//                });

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