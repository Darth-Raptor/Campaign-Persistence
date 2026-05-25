if (!isServer) exitWith {false};

params [
    ["_record", [], [[]]]
];

private _validation = [_record] call CP_fnc_validateFortifyBudgetRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Refused to save invalid fortify budget record.", _validation] call CP_fnc_log;
    false
};

private _missionKey = _record param [CP_FOR_BUD_RECORD_MISSION_KEY, "", [""]];
private _serialized = str _record;
private _result = ["save_fortify_budget", [_missionKey, _serialized]] call CP_fnc_callBackend;

private _success = _result param [0, false];
if (!_success) then {
    ["ERROR", "Failed to save fortify budget record through Pythia.", _result] call CP_fnc_log;
    false
} else {
    ["INFO", "Saved fortify budget record.", _missionKey] call CP_fnc_log;
    true
}
