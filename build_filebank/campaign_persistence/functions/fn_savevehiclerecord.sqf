if (!isServer) exitWith {false};

params [
    ["_record", [], [[]]]
];

private _validation = [_record] call CP_fnc_validateVehicleRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Refused to save invalid vehicle record.", _validation] call CP_fnc_log;
    false
};

private _id = _record param [CP_VEH_RECORD_ID, "", [""]];
private _missionKey = _record param [CP_VEH_RECORD_MISSION_KEY, "", [""]];
private _serialized = str _record;
private _result = ["save_vehicle", [_id, _missionKey, _serialized]] call CP_fnc_callBackend;

private _success = _result param [0, false];
if (!_success) then {
    ["ERROR", "Failed to save vehicle record through Pythia.", _result] call CP_fnc_log;
    false
} else {
    ["INFO", "Saved vehicle record.", [_id, _missionKey, _record param [CP_VEH_RECORD_DELETED, false]]] call CP_fnc_log;
    true
}
