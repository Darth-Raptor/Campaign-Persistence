if (!isServer) exitWith {};

params [
    ["_requestId", "", [""]],
    ["_unit", objNull, [objNull]],
    ["_uid", "", [""]],
    ["_payload", [], [[]]]
];

if (_requestId isEqualTo "") exitWith {};

private _pendingRequests = missionNamespace getVariable ["CP_pendingRequests", createHashMap];
private _request = _pendingRequests getOrDefault [_requestId, []];
if (_request isEqualTo []) exitWith {
    ["WARN", "Rejected unexpected client state submission.", _requestId] call CP_fnc_log;
};

_pendingRequests deleteAt _requestId;

private _expectedUid = _request param [0, "", [""]];
private _expectedOwner = _request param [1, -1, [0]];
private _reason = _request param [2, "autosave", [""]];
private _requestOwner = if (isNil "remoteExecutedOwner") then {-1} else {remoteExecutedOwner};

if (isNull _unit || {!isPlayer _unit}) exitWith {
    ["WARN", "Rejected client state submission without a valid player unit.", _requestId] call CP_fnc_log;
};

if !([_requestOwner, _expectedOwner, _unit] call CP_fnc_isAuthorizedRemoteOwner) exitWith {
    ["WARN", "Rejected client state submission due to owner mismatch.", [_requestId, _requestOwner, _expectedOwner]] call CP_fnc_log;
};

if (_uid isNotEqualTo _expectedUid || {_uid isNotEqualTo getPlayerUID _unit}) exitWith {
    ["WARN", "Rejected client state submission due to UID mismatch.", [_requestId, _uid, _expectedUid]] call CP_fnc_log;
};

if (!alive _unit) exitWith {
    ["INFO", "Dropped pending save because the player died before server approval completed.", [_uid, _reason]] call CP_fnc_log;
};

private _record = [_unit, _payload] call CP_fnc_buildPlayerRecord;
if (_record isEqualTo []) exitWith {
    ["WARN", "Failed to build a player record from collected client state.", [_uid, _reason]] call CP_fnc_log;
};

if ([_record] call CP_fnc_savePlayerRecord) then {
    if (_reason isEqualTo "manual") then {
        ["Campaign Persistence: Save completed."] remoteExecCall ["CP_fnc_notifyClient", _expectedOwner];
    };
} else {
    if (_reason isEqualTo "manual") then {
        ["Campaign Persistence: Save failed. Check the server RPT for details."] remoteExecCall ["CP_fnc_notifyClient", _expectedOwner];
    };
};
