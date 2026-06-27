if (!isServer) exitWith {};

params [
    ["_unit", objNull, [objNull]],
    ["_object", objNull, [objNull]]
];

private _config = [] call CP_fnc_getLogisticsConfig;
if !([_config] call CP_fnc_isLogisticsPersistenceActive) exitWith {};

private _requestOwner = if (isNil "remoteExecutedOwner") then {-1} else {remoteExecutedOwner};
if (isNull _unit || {!isPlayer _unit} || {isNull _object}) exitWith {};
if !([_requestOwner, owner _unit, _unit] call CP_fnc_isAuthorizedRemoteOwner) exitWith {
    ["WARN", "Rejected logistics first-use registration because the owner did not match the target player.", [_requestOwner, owner _unit, typeOf _object]] call CP_fnc_log;
};

private _category = [_object] call CP_fnc_getLogisticsCategory;
if !(_category in ["crate", "container"]) exitWith {};

private _existingId = _object getVariable ["CP_runtimeLogisticsPersistenceId", ""];
if (!(_existingId isEqualType "")) then {
    _existingId = "";
} else {
    _existingId = trim _existingId;
};
if (_existingId isNotEqualTo "") exitWith {};

private _isStartupObject = _object getVariable ["CP_isStartupLogisticsPersistenceCandidate", false];
if (!_isStartupObject && {!(_config param [CP_LOG_CFG_INCLUDE_RUNTIME, false])}) exitWith {
    ["DEBUG", "Skipped logistics first-use registration because runtime logistics persistence is disabled.", typeOf _object] call CP_fnc_log;
};

private _id = [_object] call CP_fnc_registerLogisticsObject;
if (_id isNotEqualTo "") then {
    ["INFO", "Registered logistics persistence on first inventory open.", [_id, typeOf _object, name _unit]] call CP_fnc_log;
};
