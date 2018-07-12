let kur = artifacts.require("CUR");

contract('CUR', function (accounts) {
    let instance;
    let ownerAddress = accounts[0];
    let manufacturerAddress = accounts[1];
    let serviceAddress = accounts[3];

    it("fails when incorrect owner", async function () {
        instance = await kur.deployed();
        try {
            await instance.createManufacturer(manufacturerAddress, 'BMW', {from: manufacturerAddress});
        } catch (e) {
            return;
        }
        assert(false, "didn't fail");
    });

    it("check is owner", async function () {
        await instance.isContractOwner({from: ownerAddress}).then((resp) => {
            assert.isOk(resp);
        });
    });

    it("check is manufacturer", async function () {
        try {
            await instance.repairCar('VINNUMBER123', serviceAddress, {from: manufacturerAddress});
        } catch (e) {
            return;
        }
        assert(false, "didn't fail");
    });

    it("create manufacturer", async function () {
        await instance.createManufacturer(manufacturerAddress, 'BMW', 'imageLink', {from: ownerAddress})
            .then(() => assertEvent(instance, {
                event: "manufacturerCreated",
                logIndex: 1,
                args: {name: "BMW", logo: "imageLink",}
            }));
    });

    it("check is manufacturer", async function () {
        await instance.isManufacturerAddress({from: manufacturerAddress}).then((resp) => {
            assert.isOk(resp);
        });
    });

    it("create car", async function () {
        await instance.newCar('316i', 'VINNUMBER123', {from: manufacturerAddress})
            .then(() => assertEvent(instance, {
                event: "carCreated",
                logIndex: 1,
                args: {model: "316i", VIN: 'VINNUMBER123', manufaturerAddress: manufacturerAddress}
            }));
    });

    it("create service", async function () {
        await instance.newService('Pesho\'s service', 'Sofia Bulgaria', {from: serviceAddress})
            .then(() => assertEvent(instance, {
                event: "serviceCreated",
                logIndex: 1,
                args: {name: "Pesho's service", serviceAddress: "Sofia Bulgaria"}
            }));
    });

    it("check is service", async function () {
        await instance.isServiceAddress({from: serviceAddress}).then((resp) => {
            assert.isOk(resp);
        });
    });

    it("authorize service", async function () {
        await instance.verifyService(serviceAddress, {from: manufacturerAddress})
            .then(() => assertEvent(instance, {
                event: "serviceAuthorized",
                logIndex: 1,
                args: {serviceAddress: serviceAddress, manufaturerAddress: manufacturerAddress}
            }));
    });

    it("repair car", async function () {
        await instance.repairCar('VINNUMBER123', serviceAddress, 'documentLink', {from: serviceAddress})
            .then(() => assertEvent(instance, {
                event: "carRepaired",
                logIndex: 1,
                args: {VIN: "kur", repairService: manufacturerAddress, authorised: true, documentLink: "documentLink"}
            }));
    });
});


let assertEvent = function (contract, filter) {
    return new Promise((resolve, reject) => {
        let event = contract[filter.event]();
        event.watch();
        event.get((error, logs) => {
            let log = _.filter(logs, filter);
            if (log) {
                resolve(log);
            } else {
                throw Error("Failed to find filtered event for " + filter.event);
            }
        });
        event.stopWatching();
    });
};