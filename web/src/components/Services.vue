<template>
    <div>
        <div class="form">
            <form v-if="!this.isService" @submit="createService">
                <label for="name">Service Name</label>
                <input id="name" name="name" type="text" v-model="name">
                <label for="address">Service Location</label>
                <input id="address" name="address" type="text" v-model="address">
                <button :disabled="!name || !address" >Create Service</button>
            </form>
        </div>
        <table class="list">
            <thead>
                <td>Name</td>
                <td>Location</td>
                <td>Authozired From</td>
                <td>Actions</td>
            </thead>
            <tr v-for="service in services" :key="service.name">
                <td>{{ service.name }}</td>
                <td>{{ service.serviceLocation }}</td>
                <td>
                    <div v-for="logo in service.authorized">
                        <img :src="logo"/>
                    </div>
                </td>
                <td>
                    <button v-on:click="authorizeService(service._address)" >Authorize</button>
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
                services: [],
                name: null,
                address: null,
                logos: [],
                service: null
            }
        },
        methods: {
            createService() {
                this.contract.newService(this.name, this.address, (err, resp) => {
                    console.log(err);
                });
            },
            authorizeService(serviceAddress) {
                this.contract.verifyService(serviceAddress, (err, resp) => {
                    console.log(err);
                });
            }
        },
        created() {
            let self = this;
            this.contract.manufacturerCreated({}, {
                fromBlock: 0,
                toBlock: 'latest'
            }).get((error, manufaturers) => {
                if (error)
                    console.log('Error in myEvent event handler: ' + error);
                else {
                    manufaturers.map(function (value, key) {
                        self.logos[value.args._address] = 'http://localhost:8080/ipfs/' + value.args.logo;
                    });
                }
                self.contract.serviceCreated({}, {fromBlock: 0, toBlock: 'latest'}).watch((error, services) => {
                    if (error)
                        console.log('Error in myEvent event handler: ' + error);
                    else {
                        self.service = services.args;
                        self.contract.serviceAuthorized({}, {fromBlock: 0, toBlock: 'latest'}).get((error, authorized) => {
                            if (error)
                                console.log('Error in myEvent event handler: ' + error);
                            else {
                                self.service.authorized = [];
                                authorized.map(function (value, key) {
                                    self.service.authorized.push(self.logos[value.args.manufaturerAddress]);
                                });
                                self.services.push(self.service);
                            }
                        });

                    }
                });
            });
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