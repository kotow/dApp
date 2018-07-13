<template>
    <div>
        <div class="form">
            <p> Create Manufacturer </p>
            <form v-if="this.isOwner">
                <label for="address">Manufacturer Address</label>
                <input id="address" name="address" type="text" v-model="address">
                <label for="name">Manufacturer Name</label>
                <input id="name" name="name" type="text" v-model="name">
                <label for="photo">Manufacturer Logo</label>
                <input type="file" name="photo" id="photo" @change="processFile($event)">
                <button :disabled="!address || !name || !logoUploaded" v-on:click="registerManufacturer">SUBMIT</button>
            </form>
        </div>

        <table class="list">
            <tr v-for="manufacturer in manufacturers" :key="manufacturer._address">
                <td style="display: block;width: 100px;"><img :src="getUrl(manufacturer.logo)"/></td>
                <td>{{ manufacturer.name }}</td>
                <td>
                    <router-link :to="{ name: 'Cars', params: { address: manufacturer._address } }">Cars</router-link>
                    <a href="#">Authorized services</a>
                </td>
            </tr>
        </table>
    </div>

</template>
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
                        self.logoUploaded = true;
                    })
                }
            },
            registerManufacturer: function (event) {
                console.log(this.logo);
                console.log(this.name);
                console.log(this.address);
                this.contract.createManufacturer("0x4e10eff0eb046194a4b220053d8bd3644707574f", this.name, this.logo, (err, resp) => {
                    console.log(err);
                });

            }
        },
        created() {
            let self = this;
//            this.contract.manufacturerCreated({}, {fromBlock: 0, toBlock: 'latest'}).get((error, eventResult) => {
//                if (error)
//                    console.log('Error in myEvent event handler: ' + error);
//                else {
//                    eventResult.map(function (value, key) {
//                        self.manufacturers.push(value.args);
//                    });
//                }
//            });
            this.contract.manufacturerCreated({}, {fromBlock: 0, toBlock: 'latest'}).watch((error, eventResult) => {
                console.log('Error in myEvent event handler: ' + eventResult);
                if (error)
                    console.log('Error in myEvent event handler: ' + eventResult);
                else {
                    self.manufacturers.push(eventResult.args);
                }
            });
        }
    }
</script>

<style>
</style>