if (!isServer) exitWith {false};

params [
    ["_unit", objNull, [objNull]],
    ["_reason", "autosave", [""]]
];

private _config = [] call CP_fnc_getServerConfig;
if !([_config] call CP_fnc_isPlayerPersistenceActive) exitWith {false};
if (isNull _unit || {!isPlayer _unit} || {!alive _unit}) exitWith {false};

private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {false};

private _ownerId = owner _unit;
if (_ownerId <= 0) exitWith {
    ["WARN", "Cannot request client state for a player without a valid network owner.", [_uid, _reason]] call CP_fnc_log;
    false
};

private _requestId = format ["%1:%2:%3", _uid, diag_frameNo, floor (random 1000000)];
CP_pendingRequests set [_requestId, [_uid, _ownerId, _reason, serverTime]];

["DEBUG", "Requesting client player state for server-approved save.", [_uid, _reason, _requestId]] call CP_fnc_log;
[_requestId] remoteExecCall ["CP_fnc_clientCollectState", _ownerId];

[_requestId] spawn {
    params ["_pendingRequestId"];
    sleep (missionNamespace getVariable ["CP_requestTimeout", 15]);
    private _pendingRequests = missionNamespace getVariable ["CP_pendingRequests", createHashMap];
    if (!isNil "_pendingRequests" && {!isNil {_pendingRequests get _pendingRequestId}}) then {
        _pendingRequests deleteAt _pendingRequestId;
        ["WARN", "Timed out waiting for client state collection.", _pendingRequestId] call CP_fnc_log;
    };
};

true
