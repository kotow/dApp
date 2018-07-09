pragma solidity ^0.4.24;

contract CUR {
    struct Manufacturer {
        string name;
        bool exists;
        // mapping(string => Car) cars;
    }

    struct CarOwner {
        string name;
    }

    struct Car {
        string model;
        string VIN;
        mapping (string => CarOwner) owners;
        address manufacturerAddress;
    }

    struct Service {
        string name;
        bool exists;
        mapping(address => bool) authorizedManufaturers;
    }
    address private owner;
    mapping (address => Manufacturer) manufacturers;
    mapping (address => Service) services;
    mapping (string => CarOwner) owners;
    mapping (string => Car) cars;

    constructor() public {
        owner = msg.sender;
    }

    event carRepaired(string VIN, address repairService, bool authorised);
    event manufacturerCreated(string name);
    event serviceCreated(string name);
    event carCreated(string model, string VIN, address manufaturerAddress);
    event serviceAuthorized(address serviceAddress, address manufaturerAddress);
    event carSold(string carVIN, string newOwnerName);

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

    function createManufacturer(address _address, string _name) isOwner public {
        manufacturers[_address] = Manufacturer({name: _name, exists: true});
        emit manufacturerCreated(_name);
    }

    function newCar(string _model, string _VIN) public isManufacturer {
        cars[_VIN] = Car({model: _model, VIN: _VIN, manufacturerAddress: msg.sender});
        emit carCreated(_model, _VIN, msg.sender);
    }

    function newService(string _name) public {
        services[msg.sender] = Service({name: _name, exists: true});
        emit serviceCreated(_name);
    }

    function verifyService(address _serviceAddress) public isManufacturer {
        services[_serviceAddress].authorizedManufaturers[msg.sender] = true;
        emit serviceAuthorized(_serviceAddress, msg.sender);
    }

    function sellCar(string _carVIN, string _carOwnerName) public {
        owners[_carOwnerName] = CarOwner({name: _carOwnerName});
        cars[_carVIN].owners[_carOwnerName] = owners[_carOwnerName];
        emit carSold(_carVIN, _carOwnerName);
    }

    function repairCar(string _carVIN, address _serviceAddress) isService public {
        address carManufaturer = cars[_carVIN].manufacturerAddress;
        bool isAuthorizedService = services[msg.sender].authorizedManufaturers[carManufaturer];
        emit carRepaired(_carVIN, _serviceAddress, isAuthorizedService);
    }
}