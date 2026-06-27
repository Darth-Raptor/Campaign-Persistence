params [
    ["_object", objNull, [objNull]],
    ["_forcedId", "", [""]]
];

if (isNull _object) exitWith {""};

private _assignedId = _forcedId;
if (_assignedId isEqualTo "") then {
    _assignedId = _object getVariable ["CP_runtimeVehiclePersistenceId", ""];
};

if (_assignedId isEqualTo "") then {
    _assignedId = _object getVariable ["CP_vehiclePersistenceIdOverride", ""];
};

if !(_assignedId isEqualType "") then {
    _assignedId = "";
} else {
    _assignedId = trim _assignedId;
    if ((toLowerANSI _assignedId) in ["true", "false"]) then {
        _assignedId = "";
    };
};

if (_assignedId isEqualTo "") then {
    if (_object getVariable ["CP_isStartupVehiclePersistenceCandidate", false]) then {
        _assignedId = [_object] call CP_fnc_getDefaultVehicleId;
    } else {
        private _config = [] call CP_fnc_getVehicleConfig;
        if (_config param [CP_VEH_CFG_INCLUDE_RUNTIME, false]) then {
            _assignedId = format ["runtime:%1:%2:%3", typeOf _object, round (serverTime * 100), floor (random 1000000)];
        };
    };
};

if (_assignedId isEqualTo "") exitWith {""};

_object setVariable ["CP_runtimeVehiclePersistenceId", _assignedId, true];
_object setVariable ["CP_vehiclePersistenceId", _assignedId, true];
_assignedId
