params [
    ["_record", [], [[]]]
];

if (!hasInterface) exitWith {};

private _vehicleId = _record param [CP_RECORD_VEHICLE_ID, "", [""]];
if (_vehicleId isEqualTo "") exitWith {};

private _vehicleRole = _record param [CP_RECORD_VEHICLE_ROLE, [], [[]]];
[_vehicleId, _vehicleRole] spawn {
    params ["_persistedVehicleId", "_persistedVehicleRole"];

    private _deadline = time + 10;
    private _vehicle = objNull;
    waitUntil {
        _vehicle = [_persistedVehicleId] call CP_fnc_findVehicleById;
        (!isNull _vehicle) || {time > _deadline}
    };

    if (isNull _vehicle || {isNull player} || {!alive player} || {!local player}) exitWith {
        ["DEBUG", "Skipped player vehicle restore because the vehicle was unavailable.", _persistedVehicleId] call CP_fnc_log;
    };

    private _roleType = "";
    if (_persistedVehicleRole isEqualType [] && {(count _persistedVehicleRole) > 0}) then {
        _roleType = _persistedVehicleRole param [0, "", [""]];
    };

    switch (_roleType) do {
        case "Driver": {
            player moveInDriver _vehicle;
        };
        case "Commander": {
            player moveInCommander _vehicle;
        };
        case "Gunner": {
            player moveInGunner _vehicle;
        };
        case "Cargo": {
            private _cargoIndex = _persistedVehicleRole param [1, -1, [0]];
            if (_cargoIndex >= 0) then {
                player moveInCargo [_vehicle, _cargoIndex];
            } else {
                player moveInCargo _vehicle;
            };
        };
        case "Turret": {
            private _turretPath = _persistedVehicleRole param [1, [], [[]]];
            if (_turretPath isEqualType []) then {
                player moveInTurret [_vehicle, _turretPath];
            } else {
                player moveInCargo _vehicle;
            };
        };
        default {
            player moveInCargo _vehicle;
        };
    };

    ["INFO", "Restored player into a persisted vehicle.", [_persistedVehicleId, _roleType]] call CP_fnc_log;
};
