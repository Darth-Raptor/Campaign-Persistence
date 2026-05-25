if (!isServer) exitWith {};

params [
    ["_unit", objNull, [objNull]],
    ["_uid", "", [""]]
];

private _config = [] call CP_fnc_getServerConfig;
if !([_config] call CP_fnc_isPlayerPersistenceActive) exitWith {};

private _manualSaveEnabled = _config param [CP_CFG_ACE_MANUAL_SAVE, false];
if (!_manualSaveEnabled) exitWith {
    if (!isNull _unit) then {
        ["Campaign Persistence: Manual save is disabled for this mission."] remoteExecCall ["CP_fnc_notifyClient", owner _unit];
    };
};

private _requestOwner = if (isNil "remoteExecutedOwner") then {-1} else {remoteExecutedOwner};
if (isNull _unit || {!isPlayer _unit} || {!alive _unit}) exitWith {};
if !([_requestOwner, owner _unit, _unit] call CP_fnc_isAuthorizedRemoteOwner) exitWith {
    ["WARN", "Rejected manual save request because the owner did not match the target player.", [_uid, _requestOwner, owner _unit]] call CP_fnc_log;
};
if (_uid isNotEqualTo getPlayerUID _unit) exitWith {
    ["WARN", "Rejected manual save request because the UID did not match the target player.", [_uid, getPlayerUID _unit]] call CP_fnc_log;
};

["Campaign Persistence: Save requested. Waiting for server approval."] remoteExecCall ["CP_fnc_notifyClient", owner _unit];
[_unit, "manual"] call CP_fnc_beginSaveForPlayer;
