if (!isServer) exitWith {false};

private _config = [] call CP_fnc_getLogisticsConfig;
if !([_config] call CP_fnc_isLogisticsPersistenceActive) exitWith {false};

private _records = [] call CP_fnc_loadLogisticsRecords;
private _seenIds = [];
private _saved = 0;

{
    if ([_x, _config] call CP_fnc_isLogisticsPersistent) then {
        private _record = [_x, false] call CP_fnc_buildLogisticsRecord;
        if !(_record isEqualTo []) then {
            private _id = _record param [CP_LOG_RECORD_ID, "", [""]];
            if (_id isNotEqualTo "") then {
                _seenIds pushBackUnique _id;
            };

            if ([_record] call CP_fnc_saveLogisticsRecord) then {
                _saved = _saved + 1;
            };
        };
    };
} forEach (allMissionObjects "All");

{
    private _storedId = _x param [CP_LOG_RECORD_ID, "", [""]];
    if (
        _storedId isNotEqualTo "" &&
        {(_seenIds find _storedId) < 0} &&
        {!(_x param [CP_LOG_RECORD_DELETED, false])}
    ) then {
        private _tombstone = +_x;
        _tombstone set [CP_LOG_RECORD_DELETED, true];
        _tombstone set [CP_LOG_RECORD_HAS_POSITION, false];
        _tombstone set [CP_LOG_RECORD_POS_ASL, []];
        _tombstone set [CP_LOG_RECORD_DIR, 0];
        _tombstone set [CP_LOG_RECORD_VECTOR_UP, []];
        _tombstone set [CP_LOG_RECORD_HAS_INVENTORY, false];
        _tombstone set [CP_LOG_RECORD_CARGO, []];
        _tombstone set [CP_LOG_RECORD_HAS_DAMAGE, false];
        _tombstone set [CP_LOG_RECORD_DAMAGE, 0];
        _tombstone set [CP_LOG_RECORD_HAS_SUPPLY, false];
        _tombstone set [CP_LOG_RECORD_SUPPLY, []];
        _tombstone set [CP_LOG_RECORD_LAST_WRITE, serverTime];
        [_tombstone] call CP_fnc_saveLogisticsRecord;
    };
} forEach _records;

["INFO", "Completed logistics save pass.", [_saved, count _seenIds, count _records]] call CP_fnc_log;
true
