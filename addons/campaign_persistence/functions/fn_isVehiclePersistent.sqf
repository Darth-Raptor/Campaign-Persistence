params [
    ["_object", objNull, [objNull]],
    ["_config", [], [[]]]
];

if (isNull _object) exitWith {false};
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {false};
if (_object isKindOf "Steerable_Parachute_F") exitWith {false};

private _category = [_object] call CP_fnc_getVehicleCategory;
if (_category isEqualTo "") exitWith {false};
if ((crew _object) findIf {!isPlayer _x} >= 0) exitWith {false};

private _existingId = _object getVariable ["CP_runtimeVehiclePersistenceId", ""];
if (!(_existingId isEqualType "")) then {
    _existingId = "";
} else {
    _existingId = trim _existingId;
    if ((toLowerANSI _existingId) in ["true", "false"]) then {
        _existingId = "";
    };
};
if (_existingId isNotEqualTo "") exitWith {true};
false
