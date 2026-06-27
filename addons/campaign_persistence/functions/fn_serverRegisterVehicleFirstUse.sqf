if (!isServer) exitWith {};

params [
    ["_unit", objNull, [objNull]],
    ["_vehicle", objNull, [objNull]]
];

private _config = [] call CP_fnc_getVehicleConfig;
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {};

private _requestOwner = if (isNil "remoteExecutedOwner") then {-1} else {remoteExecutedOwner};
if (isNull _unit || {!isPlayer _unit} || {isNull _vehicle}) exitWith {};
if !([_requestOwner, owner _unit, _unit] call CP_fnc_isAuthorizedRemoteOwner) exitWith {
    ["WARN", "Rejected vehicle first-use registration because the owner did not match the target player.", [_requestOwner, owner _unit, typeOf _vehicle]] call CP_fnc_log;
};

private _category = [_vehicle] call CP_fnc_getVehicleCategory;
if (_category isEqualTo "") exitWith {};
if (_vehicle isKindOf "Steerable_Parachute_F") exitWith {};
if ((crew _vehicle) findIf {!isPlayer _x} >= 0) exitWith {};

private _existingId = _vehicle getVariable ["CP_runtimeVehiclePersistenceId", ""];
if (!(_existingId isEqualType "")) then {
    _existingId = "";
} else {
    _existingId = trim _existingId;
};
if (_existingId isNotEqualTo "") exitWith {};

private _isStartupObject = _vehicle getVariable ["CP_isStartupVehiclePersistenceCandidate", false];
if (!_isStartupObject && {!(_config param [CP_VEH_CFG_INCLUDE_RUNTIME, false])}) exitWith {
    ["DEBUG", "Skipped vehicle first-use registration because runtime vehicle persistence is disabled.", typeOf _vehicle] call CP_fnc_log;
};

private _id = [_vehicle] call CP_fnc_registerVehicle;
if (_id isNotEqualTo "") then {
    ["INFO", "Registered vehicle persistence on first player entry.", [_id, typeOf _vehicle, name _unit]] call CP_fnc_log;
};
