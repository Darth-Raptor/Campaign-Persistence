if (!isServer) exitWith {[]};

params [
    ["_object", objNull, [objNull]],
    ["_deleted", false, [true]]
];

private _config = [] call CP_fnc_getLogisticsConfig;
if !([_config] call CP_fnc_isLogisticsPersistenceActive) exitWith {[]};
if (isNull _object) exitWith {[]};

private _category = [_object] call CP_fnc_getLogisticsCategory;
if (_category isEqualTo "") exitWith {[]};

private _id = [_object] call CP_fnc_registerLogisticsObject;
if (_id isEqualTo "") exitWith {[]};

private _class = typeOf _object;
private _missionKey = [] call CP_fnc_buildMissionKey;

private _persistPosition = (_config param [CP_LOG_CFG_PERSIST_POSITION, false]) && {!_deleted};
private _persistInventory = (_config param [CP_LOG_CFG_PERSIST_INVENTORY, false]) && {!_deleted};
private _persistNested = (_config param [CP_LOG_CFG_PERSIST_NESTED, false]) && {!_deleted};
private _persistDamage = (_config param [CP_LOG_CFG_PERSIST_DAMAGE, false]) && {!_deleted};
private _persistSupply = (_config param [CP_LOG_CFG_PERSIST_SUPPLY, false]) && {!_deleted} && {[_object] call CP_fnc_isSupplyStatePersistent};

private _posASL = [];
private _dir = 0;
private _vectorUp = [];
if (_persistPosition) then {
    _posASL = getPosASL _object;
    _dir = getDir _object;
    _vectorUp = vectorUp _object;
};

private _cargoData = [];
if (_persistInventory) then {
    _cargoData = [_object, 0, _persistNested] call CP_fnc_collectCargoData;
};

private _damage = 0;
if (_persistDamage) then {
    _damage = damage _object;
};

private _supplyState = [];
if (_persistSupply) then {
    _supplyState = [
        getFuelCargo _object,
        getAmmoCargo _object,
        getRepairCargo _object,
        fuel _object,
        _object getVariable ["ace_refuel_currentFuelCargo", -1],
        _object getVariable ["ace_refuel_fuelCargo", -1]
    ];
};

[
    CP_LOG_RECORD_SCHEMA_VERSION,
    "logistics",
    _id,
    _missionKey,
    _class,
    _deleted,
    _category,
    _persistPosition,
    _posASL,
    _dir,
    _vectorUp,
    _persistInventory,
    _cargoData,
    _persistDamage,
    _damage,
    _persistSupply,
    _supplyState,
    serverTime
]
