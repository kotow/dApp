<script>
/* eslint-disable */
    export default {
        data() {
            return {
                contract: null,
                tokenContract: null,
                web3js: null,
                isOwner: false,
                isManufacturer: false,
                isService: false
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

                this.tokenContract = MyContract.at('0xb143cE0fC6bb7BaF6C688E0962d11febc45DB4FF');
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
                                "name": "model",
                                "type": "string"
                            },
                            {
                                "indexed": true,
                                "name": "VIN",
                                "type": "bytes17"
                            },
                            {
                                "indexed": true,
                                "name": "manufaturerAddress",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "dateCreated",
                                "type": "uint256"
                            },
                            {
                                "indexed": false,
                                "name": "warrantyUntil",
                                "type": "uint256"
                            }
                        ],
                        "name": "carCreated",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": true,
                                "name": "VIN",
                                "type": "bytes17"
                            },
                            {
                                "indexed": true,
                                "name": "repairService",
                                "type": "address"
                            },
                            {
                                "indexed": false,
                                "name": "authorised",
                                "type": "bool"
                            },
                            {
                                "indexed": false,
                                "name": "documentLink",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "date",
                                "type": "uint256"
                            },
                            {
                                "indexed": false,
                                "name": "details",
                                "type": "string"
                            },
                            {
                                "indexed": false,
                                "name": "mileage",
                                "type": "uint256"
                            }
                        ],
                        "name": "carRepaired",
                        "type": "event"
                    },
                    {
                        "anonymous": false,
                        "inputs": [
                            {
                                "indexed": true,
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
                                "name": "serviceLocation",
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
                                "indexed": true,
                                "name": "serviceAddress",
                                "type": "address"
                            },
                            {
                                "indexed": true,
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
                                "indexed": true,
                                "name": "VIN",
                                "type": "bytes17"
                            }
                        ],
                        "name": "warrantyCanceled",
                        "type": "event"
                    },
                    {
                        "constant": true,
                        "inputs": [],
                        "name": "isContractOwner",
                        "outputs": [
                            {
                                "name": "",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "view",
                        "type": "function"
                    },
                    {
                        "constant": true,
                        "inputs": [],
                        "name": "isManufacturerAddress",
                        "outputs": [
                            {
                                "name": "",
                                "type": "bool"
                            }
                        ],
                        "payable": false,
                        "stateMutability": "view",
                        "type": "function"
                    },
                    {
                        "constant": true,
                        "inputs": [],
                        "name": "isServiceAddress",
                        "outputs": [
                            {
                                "name": "",
                                "type": "bool"
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
                                "type": "bytes17"
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
                            },
                            {
                                "name": "_serviceAddress",
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
                                "type": "bytes17"
                            },
                            {
                                "name": "documentLink",
                                "type": "string"
                            },
                            {
                                "name": "_details",
                                "type": "string"
                            },
                            {
                                "name": "mileage",
                                "type": "uint256"
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
                this.contract = contract.at('0x1c569be0b3acce2ebcc610d6cb0e3035604f8e44');
                this.contract.isContractOwner((err, resp) => {
                    console.log(err, resp);
                    this.isOwner = resp;
                });
                this.contract.isManufacturerAddress((err, resp) => {
                    console.log(err, resp);
                    this.isManufacturer = resp;
                });
                this.contract.isServiceAddress((err, resp) => {
                    console.log(err, resp);
                    this.isService = resp;
                });
                let account = web3.eth.accounts[0];
                let accountInterval = setInterval(function () {
                    if (web3.eth.accounts[0] !== account && account !== 'undefined') {

                        account = web3.eth.accounts[0];
                        location.reload();
                    }
                }, 500);
            } else {
                let warningDiv = document.getElementById('app');
                warningDiv.innerText = "You don't have MetaMask installed. You can only browse but you won't be able to adopt pets.";
            }
        }
    }
</script>