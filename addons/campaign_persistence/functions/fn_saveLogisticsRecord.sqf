if (!isServer) exitWith {false};

params [
    ["_record", [], [[]]]
];

private _validation = [_record] call CP_fnc_validateLogisticsRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Refused to save invalid logistics record.", _validation] call CP_fnc_log;
    false
};

private _id = _record param [CP_LOG_RECORD_ID, "", [""]];
private _missionKey = _record param [CP_LOG_RECORD_MISSION_KEY, "", [""]];
private _serialized = str _record;
private _result = ["save_logistics", [_id, _missionKey, _serialized]] call CP_fnc_callBackend;

private _success = _result param [0, false];
if (!_success) then {
    ["ERROR", "Failed to save logistics record through Pythia.", _result] call CP_fnc_log;
    false
} else {
    ["INFO", "Saved logistics record.", [_id, _missionKey, _record param [CP_LOG_RECORD_DELETED, false]]] call CP_fnc_log;
    true
}
