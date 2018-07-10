<template>
    <div id="metamask-warning">
        <form>
            <input name="name" type="string" v-model="name">
            <input type="file" name="photo" id="photo" @change="processFile($event)">
            <a href="/#/manufaturers" v-on:click="registerManufacturer">SUBMIT</a>
        </form>
        <ul id="example-1">
            <li v-for="manufacturer in manufacturers">
                {{ manufacturer.name }}
            </li>
        </ul>
    </div>

</template>

<script>
/* eslint-disable */
    const ipfsAPI = require('ipfs-api');
    const buffer = require('buffer');
    export default {
        data() {
            return {
                name: null,
                logo: null,
                contract: null,
                tokenContract: null,
                manufacturers: []
            }
        },
        methods: {
            processFile(event) {
                let file = event.target.files[0];
                const reader = new FileReader();
                reader.readAsText(file);
                reader.onload = function () {
                    const ipfs = ipfsAPI('localhost', '5001', {protocol: 'http'});
                    const buf = buffer.Buffer(reader.result);
                    ipfs.files.add(buf, (err, result) => {
                        console.log(this.name);
                        if (err) {
                            console.log("Something went wrong when trying to upload the photo.", err);
                            return;
                        }
                        this.logo = result[0].hash;
                    })
                }
            },
            registerManufacturer: function (event) {
                console.log(this.logo);
                console.log(this.name);

                this.contract.createManufacturer(this.web3js.eth.accounts[0], this.name, (err, balance) => {
                    this.tokenBalance = this.web3js.fromWei(balance) + " CUR"
                });
            }
        },
        created() {
            if (typeof web3 !== 'undefined') {
                // Use Mist/MetaMask's provider
                this.web3js = new Web3(web3.currentProvider);
                let abi = [
                    {
                        "inputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "constructor"
                    },
                    {
                        "payable": true,
                        "stateMutability": "payable",
                        "type": "fallback"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": true,
                                "name": "from",
                                "type": "address"
                            },
                            {
                                "indexed": true,
                                "name": "to",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "Transfer",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": true,
                                "name": "tokenOwner",
                                "type": "address"
                            },
                            {
                                "indexed": true,
                                "name": "spender",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "Approval",
                        "type": "event"
                    },
                    {
                        "constant": true,
                        "inputs": [],
                        "name": "totalSupply",
                        "outputs": [
                            {
                                "name": "",
                                "type": "uint256"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "view",
                        "type": "function"
                    },
                    {
                        "constant": true,
                        "inputs": [
                            {
                                "name": "tokenOwner",
                                "type": "address"
                            }
                        ],
                        "name": "balanceOf",
                        "outputs": [
                            {
                                "name": "balance",
                                "type": "uint256"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "view",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "to",
                                "type": "address"
                            },
                            {
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "transfer",
                        "outputs": [
                            {
                                "name": "success",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "spender",
                                "type": "address"
                            },
                            {
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "approve",
                        "outputs": [
                            {
                                "name": "success",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "from",
                                "type": "address"
                            },
                            {
                                "name": "to",
                                "type": "address"
                            },
                            {
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "transferFrom",
                        "outputs": [
                            {
                                "name": "success",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": true,
                        "inputs": [
                            {
                                "name": "tokenOwner",
                                "type": "address"
                            },
                            {
                                "name": "spender",
                                "type": "address"
                            }
                        ],
                        "name": "allowance",
                        "outputs": [
                            {
                                "name": "remaining",
                                "type": "uint256"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "view",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "spender",
                                "type": "address"
                            },
                            {
                                "name": "tokens",
                                "type": "uint256"
                            }
                        ],
                        "name": "approveAndCall",
                        "outputs": [
                            {
                                "name": "success",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    }
                ];
                let MyContract = web3.eth.contract(abi);

                this.tokenContract = MyContract.at('0x131cdde690467ecd9c9a6325b82e340bcc68929e');
                let abi2 = [
                    {
                        "inputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "constructor"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "VIN",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "repairService",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "authorised",
                                "type": "bool"
                            }
                        ],
                        "name": "carRepaired",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "name",
                                "type": "string"
                            }
                        ],
                        "name": "manufacturerCreated",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "name",
                                "type": "string"
                            }
                        ],
                        "name": "serviceCreated",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "model",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "VIN",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "manufaturerAddress",
                                "type": "address"
                            }
                        ],
                        "name": "carCreated",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "serviceAddress",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "manufaturerAddress",
                                "type": "address"
                            }
                        ],
                        "name": "serviceAuthorized",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": false,
                                "name": "carVIN",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "newOwnerName",
                                "type": "string"
                            }
                        ],
                        "name": "carSold",
                        "type": "event"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_address",
                                "type": "address"
                            },
                            {
                                "name": "_name",
                                "type": "string"
                            }
                        ],
                        "name": "createManufacturer",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_model",
                                "type": "string"
                            },
                            {
                                "name": "_VIN",
                                "type": "string"
                            }
                        ],
                        "name": "newCar",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_name",
                                "type": "string"
                            }
                        ],
                        "name": "newService",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_serviceAddress",
                                "type": "address"
                            }
                        ],
                        "name": "verifyService",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_carVIN",
                                "type": "string"
                            },
                            {
                                "name": "_carOwnerName",
                                "type": "string"
                            }
                        ],
                        "name": "sellCar",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    },
                    {
                        "constant": false,
                        "inputs": [
                            {
                                "name": "_carVIN",
                                "type": "string"
                            },
                            {
                                "name": "_serviceAddress",
                                "type": "address"
                            }
                        ],
                        "name": "repairCar",
                        "outputs": [],
                        "payable": false,
                        "stateMutability": "nonpayable",
                        "type": "function"
                    }
                ];

                let contract = web3.eth.contract(abi2);
                this.contract = contract.at('0x4cfdff84612ad29db92012cef9b3d7ba706d5f47');
                let self = this;
                this.contract.manufacturerCreated({}, { fromBlock: 0, toBlock: 'latest' }).get((error, eventResult) => {
                    if (error)
                        console.log('Error in myEvent event handler: ' + error);
                    else {
                        eventResult.map(function(value, key) {
                            self.manufacturers.push(value.args);
                        });
                    }
                        console.log('myEvent: ' + this.manufacturers);
                });
            } else {
                console.log('No web3? You should consider trying MetaMask!');
            }
        }
    }
</script>

<style>
</style>