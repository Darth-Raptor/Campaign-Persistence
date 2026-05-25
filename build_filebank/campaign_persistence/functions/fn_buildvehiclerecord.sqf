if (!isServer) exitWith {[]};

params [
    ["_vehicle", objNull, [objNull]],
    ["_deleted", false, [true]]
];

private _config = [] call CP_fnc_getVehicleConfig;
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {[]};
if (isNull _vehicle) exitWith {[]};

private _category = [_vehicle] call CP_fnc_getVehicleCategory;
if (_category isEqualTo "") exitWith {[]};

private _id = [_vehicle] call CP_fnc_registerVehicle;
if (_id isEqualTo "") exitWith {[]};

private _class = typeOf _vehicle;
private _missionKey = [] call CP_fnc_buildMissionKey;

private _persistPosition = (_config param [CP_VEH_CFG_PERSIST_POSITION, false]) && {!_deleted};
private _persistDamage = (_config param [CP_VEH_CFG_PERSIST_DAMAGE, false]) && {!_deleted};
private _persistAmmo = (_config param [CP_VEH_CFG_PERSIST_AMMO, false]) && {!_deleted};
private _persistFuel = (_config param [CP_VEH_CFG_PERSIST_FUEL, false]) && {!_deleted};
private _persistInventory = (_config param [CP_VEH_CFG_PERSIST_INVENTORY, false]) && {!_deleted};
private _persistNested = (_config param [CP_VEH_CFG_PERSIST_NESTED, false]) && {!_deleted};
private _persistService = (_config param [CP_VEH_CFG_PERSIST_SERVICE, false]) && {!_deleted};

private _posASL = [];
private _dir = 0;
private _vectorUp = [];
if (_persistPosition) then {
    _posASL = getPosASL _vehicle;
    _dir = getDir _vehicle;
    _vectorUp = vectorUp _vehicle;
};

private _damage = 0;
if (_persistDamage) then {
    _damage = [_vehicle] call CP_fnc_collectVehicleDamageState;
};

private _ammoState = [];
if (_persistAmmo) then {
    _ammoState = [_vehicle] call CP_fnc_collectVehicleAmmoState;
};

private _fuelState = 0;
if (_persistFuel) then {
    _fuelState = fuel _vehicle;
};

private _cargoData = [];
if (_persistInventory) then {
    _cargoData = [_vehicle, 0, _persistNested] call CP_fnc_collectCargoData;
};

private _serviceState = [];
if (_persistService) then {
    _serviceState = [
        getFuelCargo _vehicle,
        getAmmoCargo _vehicle,
        getRepairCargo _vehicle,
        _vehicle getVariable ["ace_refuel_currentFuelCargo", -1],
        _vehicle getVariable ["ace_refuel_fuelCargo", -1]
    ];
};

[
    CP_VEH_RECORD_SCHEMA_VERSION,
    "vehicle",
    _id,
    _missionKey,
    _class,
    _deleted,
    _category,
    _persistPosition,
    _posASL,
    _dir,
    _vectorUp,
    _persistDamage,
    _damage,
    _persistAmmo,
    _ammoState,
    _persistFuel,
    _fuelState,
    _persistInventory,
    _cargoData,
    _persistService,
    _serviceState,
    serverTime
]
