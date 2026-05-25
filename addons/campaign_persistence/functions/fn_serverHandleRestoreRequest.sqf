if (!isServer) exitWith {};

params [
    ["_unit", objNull, [objNull]],
    ["_uid", "", [""]]
];

private _config = [] call CP_fnc_getServerConfig;
if !([_config] call CP_fnc_isPlayerPersistenceActive) exitWith {};

private _requestOwner = if (isNil "remoteExecutedOwner") then {-1} else {remoteExecutedOwner};
if (isNull _unit || {!isPlayer _unit} || {!alive _unit}) exitWith {};
if !([_requestOwner, owner _unit, _unit] call CP_fnc_isAuthorizedRemoteOwner) exitWith {
    ["WARN", "Rejected restore request because the owner did not match the target player.", [_uid, _requestOwner, owner _unit]] call CP_fnc_log;
};
if (_uid isNotEqualTo getPlayerUID _unit) exitWith {
    ["WARN", "Rejected restore request because the UID did not match the target player.", [_uid, getPlayerUID _unit]] call CP_fnc_log;
};

private _record = [_unit] call CP_fnc_loadPlayerRecord;
if (_record isEqualTo []) exitWith {
    ["DEBUG", "No stored player record found for restore request.", _uid] call CP_fnc_log;
};

["INFO", "Server approved a restore request.", _uid] call CP_fnc_log;
[_record] remoteExecCall ["CP_fnc_applyPlayerState", owner _unit];
