if (!isServer) exitWith {[]};

private _missionKey = [] call CP_fnc_buildMissionKey;
private _result = ["load_fortify_budget", [_missionKey]] call CP_fnc_callBackend;
if !(_result param [0, false]) exitWith {
    ["ERROR", "Failed to load fortify budget record through Pythia.", _result] call CP_fnc_log;
    []
};

private _found = _result param [1, false];
if (!_found) exitWith {[]};

private _serialized = _result param [2, "", [""]];
if !(_serialized isEqualType "") exitWith {[]};

private _record = parseSimpleArray _serialized;
private _validation = [_record] call CP_fnc_validateFortifyBudgetRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Skipped invalid stored fortify budget record.", _validation] call CP_fnc_log;
    []
};

_record
