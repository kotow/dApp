pragma solidity ^0.4.24;

contract CUR {
    struct Manufacturer {
        string name;
        bool exists;
        string logo;
    }

    struct Car {
        string model;
        string VIN;
        address manufacturerAddress;
        bool exists;
    }

    struct Service {
        string name;
        string serviceAddress;
        bool exists;
        mapping(address => bool) authorizedManufacturers;
    }

    address private owner;
    mapping (address => Manufacturer) manufacturers;
    mapping (address => Service) services;
    mapping (string => Car) cars;

    constructor() public {
        owner = msg.sender;
    }

    event carRepaired(string VIN, address repairService, bool authorised, string documentLink);
    event manufacturerCreated(address _address, string name, string logo);
    event serviceCreated(string name, string serviceAddress);
    event carCreated(string model, string VIN, address manufaturerAddress);
    event serviceAuthorized(address serviceAddress, address manufaturerAddress);

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isManufacturer() {
        require(manufacturers[msg.sender].exists);
        _;
    }

    modifier isService() {
        require(services[msg.sender].exists);
        _;
    }

    function isContractOwner() view public returns(bool) {
        return msg.sender == owner;
    }

    function isManufacturerAddress() view public returns(bool) {
        return manufacturers[msg.sender].exists;
    }

    function isServiceAddress() view public returns(bool) {
        return services[msg.sender].exists;
    }

    function createManufacturer(address _address, string _name, string _logo) isOwner public {
        require(manufacturers[_address].exists == false);
        manufacturers[_address] = Manufacturer({name: _name, exists: true, logo: _logo});
        emit manufacturerCreated(_address, _name, _logo);
    }

    function newCar(string _model, string _VIN) public isManufacturer {
        require(cars[_VIN].exists == false);
        cars[_VIN] = Car({model: _model, VIN: _VIN, manufacturerAddress: msg.sender, exists: true});
        emit carCreated(_model, _VIN, msg.sender);
    }

    function newService(string _name, string _serviceAddress) public {
        require(services[msg.sender].exists == false);
        services[msg.sender] = Service({name: _name, exists: true, serviceAddress: _serviceAddress});
        emit serviceCreated(_name, _serviceAddress);
    }

    function verifyService(address _serviceAddress) public isManufacturer {
        services[_serviceAddress].authorizedManufacturers[msg.sender] = true;
        emit serviceAuthorized(_serviceAddress, msg.sender);
    }

    function repairCar(string _carVIN, address _serviceAddress, string documentLink) isService public {
        address carManufacturer = cars[_carVIN].manufacturerAddress;
        bool isAuthorizedService = services[msg.sender].authorizedManufacturers[carManufacturer];
        emit carRepaired(_carVIN, _serviceAddress, isAuthorizedService, documentLink);
    }
}