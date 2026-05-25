if (!isServer) exitWith {[]};

private _missionKey = [] call CP_fnc_buildMissionKey;
private _result = ["load_vehicles", [_missionKey]] call CP_fnc_callBackend;
if !(_result param [0, false]) exitWith {
    ["ERROR", "Failed to load vehicle records through Pythia.", _result] call CP_fnc_log;
    []
};

private _serializedRecords = _result param [1, [], [[]]];
private _records = [];

{
    if (_x isEqualType "") then {
        private _record = parseSimpleArray _x;
        private _validation = [_record] call CP_fnc_validateVehicleRecord;
        if (_validation param [0, false]) then {
            _records pushBack _record;
        } else {
            ["WARN", "Skipped invalid stored vehicle record.", _validation] call CP_fnc_log;
        };
    };
} forEach _serializedRecords;

_records
