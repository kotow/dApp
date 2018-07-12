<template>
    <div id="metamask-warning" v-if="!this.isOwner && this.web3js">
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
    import Base from './Base'

    export default {
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
                    self.tokenBalance = self.web3js.fromWei(balance, "ether") + " CUR"
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

<style>
</style>