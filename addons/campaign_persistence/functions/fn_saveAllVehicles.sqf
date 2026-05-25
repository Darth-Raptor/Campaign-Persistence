if (!isServer) exitWith {false};

private _config = [] call CP_fnc_getVehicleConfig;
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {false};

private _records = [] call CP_fnc_loadVehicleRecords;
private _seenIds = [];
private _saved = 0;

{
    if ([_x, _config] call CP_fnc_isVehiclePersistent) then {
        private _record = [_x, false] call CP_fnc_buildVehicleRecord;
        if !(_record isEqualTo []) then {
            private _id = _record param [CP_VEH_RECORD_ID, "", [""]];
            if (_id isNotEqualTo "") then {
                _seenIds pushBackUnique _id;
            };

            if ([_record] call CP_fnc_saveVehicleRecord) then {
                _saved = _saved + 1;
            };
        };
    };
} forEach (allMissionObjects "All");

{
    private _storedId = _x param [CP_VEH_RECORD_ID, "", [""]];
    if (
        _storedId isNotEqualTo "" &&
        {(_seenIds find _storedId) < 0} &&
        {!(_x param [CP_VEH_RECORD_DELETED, false])}
    ) then {
        private _tombstone = +_x;
        _tombstone set [CP_VEH_RECORD_DELETED, true];
        _tombstone set [CP_VEH_RECORD_HAS_POSITION, false];
        _tombstone set [CP_VEH_RECORD_POS_ASL, []];
        _tombstone set [CP_VEH_RECORD_DIR, 0];
        _tombstone set [CP_VEH_RECORD_VECTOR_UP, []];
        _tombstone set [CP_VEH_RECORD_HAS_DAMAGE, false];
        _tombstone set [CP_VEH_RECORD_DAMAGE, 0];
        _tombstone set [CP_VEH_RECORD_HAS_AMMO, false];
        _tombstone set [CP_VEH_RECORD_AMMO, []];
        _tombstone set [CP_VEH_RECORD_HAS_FUEL, false];
        _tombstone set [CP_VEH_RECORD_FUEL, 0];
        _tombstone set [CP_VEH_RECORD_HAS_INVENTORY, false];
        _tombstone set [CP_VEH_RECORD_CARGO, []];
        _tombstone set [CP_VEH_RECORD_HAS_SERVICE, false];
        _tombstone set [CP_VEH_RECORD_SERVICE, []];
        _tombstone set [CP_VEH_RECORD_LAST_WRITE, serverTime];
        [_tombstone] call CP_fnc_saveVehicleRecord;
    };
} forEach _records;

["INFO", "Completed vehicle save pass.", [_saved, count _seenIds, count _records]] call CP_fnc_log;
true
