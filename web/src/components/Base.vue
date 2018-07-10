<script>
    /* eslint-disable */
    export default {
        data() {
            return {
                contract: null,
                tokenContract: null,
                web3js: null,
                isOwner: false
            }
        },
        methods: {},
        created() {
            if (typeof web3 !== 'undefined') {
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
                                "name": "_address",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "name",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "logo",
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
                            },
                            {
                                "name": "_logo",
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
                this.contract = contract.at('0x7b751c0bfd12509eb3a1742a93f8d736b5c235a5');
                this.isOwner = this.web3js.eth.accounts[0] == '0x0b47c7a0b2e18aaa683759b5e04ed2c991d54409';
                let account = web3.eth.accounts[0];
                let accountInterval = setInterval(function () {
                    if (web3.eth.accounts[0] !== account && account !== 'undefined') {
                        account = web3.eth.accounts[0];
                        location.reload();
                    }
                }, 100);
            } else {
                let warningDiv = document.getElementById('app');
                warningDiv.innerText = "You don't have MetaMask installed. You can only browse but you won't be able to adopt pets.";
            }
        }
    }
</script>