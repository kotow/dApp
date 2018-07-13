<template>
    <div>
        <ul>
            <li><a href="/#/">Home</a></li>
            <li v-if="this.web3js"><a href="/#/manufaturers">Manufacturers</a></li>
            <li v-if="this.web3js"><a href="/#/services">Services</a></li>
            <li style="float:right">
                <div v-if="!this.isOwner && this.web3js">
                    <div>
                        <div>address: {{account }}</div>
                        <div>
                            <div>ETH: {{balance}}</div>
                            <div>tokens: {{tokenBalance}}</div>
                        </div>
                    </div>
                    <div>
                        <form ref="form">
                            <input name="amountToBuy" type="number" v-model="amountToBuy">
                            <a href="#" v-on:click="buyTokens">Buy Tokens</a>
                        </form>
                    </div>
                </div>
            </li>
        </ul>
        <div class="warning">
            <p>To use this app please install metamask</p>
        </div>
    </div>
</template>
<style>
    div {
        color: white;
    }

    ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
        overflow: hidden;
        background-color: #333333;
    }

    li {
        float: left;
        border-right: 1px solid #bbb;
    }

    li a {
        display: block;
        color: white;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
    }

    /* Change the link color to #111 (black) on hover */
    li a:hover {
        background-color: #111111;
    }

    .active {
        background-color: #4CAF50;
    }
</style>
<script>
    /* eslint-disable */
    import Base from './Base'

    export default {
        name: 'RwvHeader',
        extends: Base,
        data() {
            return {
                account: null,
                balance: null,
                tokenBalance: null,
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
            },
            getTokenBalance: async function () {
                let self = this;
                this.tokenContract.balanceOf(this.web3js.eth.accounts[0], (err, balance) => {
                    self.tokenBalance = self.web3js.fromWei(balance, "ether") + " CUR";
                    console.log(self.web3js.fromWei(balance));
                });
            }
        },
        created() {
            this.getBalance();
            this.getTokenBalance();
        }
    }
</script>