if (!isServer) exitWith {["", []]};

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!isPlayer _unit} || {!alive _unit}) exitWith {["", []]};

private _vehicleConfig = [] call CP_fnc_getVehicleConfig;
if !([_vehicleConfig] call CP_fnc_isVehiclePersistenceActive) exitWith {["", []]};

private _vehicle = vehicle _unit;
if (isNull _vehicle || {_vehicle isEqualTo _unit}) exitWith {["", []]};
if !([_vehicle, _vehicleConfig] call CP_fnc_isVehiclePersistent) exitWith {["", []]};

private _vehicleId = [_vehicle] call CP_fnc_registerVehicle;
if (_vehicleId isEqualTo "") exitWith {["", []]};

private _vehicleRole = assignedVehicleRole _unit;
if !(_vehicleRole isEqualType []) then {
    _vehicleRole = [];
};

[_vehicleId, _vehicleRole]
