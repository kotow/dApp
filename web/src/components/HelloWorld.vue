<template>
    <div id="metamask-warning">
        <div>address: {{account }}</div>
        <div>ETH: {{balance}}</div>
        <div>tokens: {{tokenBalance}}</div>
        <form ref="form">
            <input name="amountToBuy" type="number" v-model="amountToBuy">
            <a href="#" v-on:click="buyTokens">SUBMIT</a>
        </form>

    </div>

</template>

<script>
/* eslint-disable */
    import Web3 from 'web3'

    export default {
        data() {
            return {
                account: null,
                balance: null,
                tokenBalance: null,
                web3js: null,
                amountToBuy: 0
            }
        },
        methods: {
            buyTokens: function () {
                console.log(this.amountToBuy);
                let ethToSpend = this.amountToBuy / 100;
                let rawTx = {
                    to: 'b143ce0fc6bb7baf6c688e0962d11febc45db4ff',
                    from: this.web3js.eth.accounts[0],
                    value: this.web3js.toWei(ethToSpend)
                };

                this.web3js.eth.sendTransaction(rawTx, (err, hash) => {
                    console.log(err);
                    console.log('adasdasdasdda');
                    if (!err)
                        console.log(hash);
                });
            },
            getBalance: async function () {
                this.account = this.web3js.eth.accounts[0];
                this.web3js.eth.getBalance(this.account, (err, balance) => {
                    this.balance = this.web3js.fromWei(balance, "ether") + " ETH"
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

                let myContractInstance = MyContract.at('0xb143ce0fc6bb7baf6c688e0962d11febc45db4ff');

                myContractInstance.balanceOf(this.web3js.eth.accounts[0], (err, balance) => {
                    this.tokenBalance = this.web3js.fromWei(balance, "ether") + " CUR"
                });
            } else {
                console.log('No web3? You should consider trying MetaMask!');
            }
            this.getBalance();
        }
    }
</script>

<style>
</style>