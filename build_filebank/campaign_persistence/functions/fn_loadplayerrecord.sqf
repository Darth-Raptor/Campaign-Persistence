if (!isServer) exitWith {[]};

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!isPlayer _unit}) exitWith {[]};

private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {[]};

private _missionKey = [] call CP_fnc_buildMissionKey;
private _result = ["load_player", [_uid, _missionKey]] call CP_fnc_callBackend;
if !(_result param [0, false]) exitWith {
    ["ERROR", "Failed to load player record through Pythia.", _result] call CP_fnc_log;
    []
};

private _found = _result param [1, false];
if (!_found) exitWith {[]};

private _serialized = _result param [2, "", [""]];
if (_serialized isEqualTo "") exitWith {[]};

private _record = parseSimpleArray _serialized;
private _validation = [_record, _unit] call CP_fnc_validateStoredRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Skipped invalid stored player record.", _validation] call CP_fnc_log;
    []
};

_record
