if (!isServer) exitWith {false};

private _config = [] call CP_fnc_getFortifyConfig;
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {false};

private _records = [] call CP_fnc_loadFortifyObjectRecords;
private _seenIds = [];
private _saved = 0;

{
    if ([_x, _config] call CP_fnc_isFortifyObjectPersistent) then {
        private _record = [_x, false] call CP_fnc_buildFortifyRecord;
        if !(_record isEqualTo []) then {
            private _id = _record param [CP_FOR_RECORD_ID, "", [""]];
            if (_id isNotEqualTo "") then {
                _seenIds pushBackUnique _id;
            };

            if ([_record] call CP_fnc_saveFortifyObjectRecord) then {
                _saved = _saved + 1;
            };
        };
    };
} forEach (allMissionObjects "All");

{
    private _storedId = _x param [CP_FOR_RECORD_ID, "", [""]];
    if (
        _storedId isNotEqualTo "" &&
        {(_seenIds find _storedId) < 0} &&
        {!(_x param [CP_FOR_RECORD_DELETED, false])}
    ) then {
        private _tombstone = +_x;
        _tombstone set [CP_FOR_RECORD_DELETED, true];
        _tombstone set [CP_FOR_RECORD_HAS_POSITION, false];
        _tombstone set [CP_FOR_RECORD_POS_ASL, []];
        _tombstone set [CP_FOR_RECORD_DIR, 0];
        _tombstone set [CP_FOR_RECORD_VECTOR_UP, []];
        _tombstone set [CP_FOR_RECORD_HAS_DAMAGE, false];
        _tombstone set [CP_FOR_RECORD_DAMAGE, 0];
        _tombstone set [CP_FOR_RECORD_LAST_WRITE, serverTime];
        [_tombstone] call CP_fnc_saveFortifyObjectRecord;
    };
} forEach _records;

private _budgetSaved = false;
private _budgetRecord = [] call CP_fnc_buildFortifyBudgetRecord;
if !(_budgetRecord isEqualTo []) then {
    _budgetSaved = [_budgetRecord] call CP_fnc_saveFortifyBudgetRecord;
};

["INFO", "Completed fortify save pass.", [_saved, count _seenIds, count _records, _budgetSaved]] call CP_fnc_log;
true
