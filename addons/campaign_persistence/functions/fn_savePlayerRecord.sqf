if (!isServer) exitWith {false};

params [
    ["_record", [], [[]]]
];

private _validation = [_record] call CP_fnc_validateStoredRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Refused to save invalid player record.", _validation] call CP_fnc_log;
    false
};

private _uid = _record param [CP_RECORD_UID, "", [""]];
private _missionKey = _record param [CP_RECORD_MISSION_KEY, "", [""]];
private _serialized = str _record;
private _result = ["save_player", [_uid, _missionKey, _serialized]] call CP_fnc_callBackend;

private _success = _result param [0, false];
if (!_success) then {
    ["ERROR", "Failed to save player record through Pythia.", _result] call CP_fnc_log;
    false
} else {
    ["INFO", "Saved player record.", [_uid, _missionKey]] call CP_fnc_log;
    true
}
