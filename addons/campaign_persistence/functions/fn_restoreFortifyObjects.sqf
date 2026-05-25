if (!isServer) exitWith {};

private _config = [] call CP_fnc_getFortifyConfig;
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {};

private _records = [] call CP_fnc_loadFortifyObjectRecords;
private _loaded = 0;
private _deleted = 0;
private _skipped = 0;
private _logisticsConfig = [] call CP_fnc_getLogisticsConfig;

{
    private _id = _x param [CP_FOR_RECORD_ID, "", [""]];
    private _class = _x param [CP_FOR_RECORD_CLASS, "", [""]];
    private _isDeleted = _x param [CP_FOR_RECORD_DELETED, false];
    private _sideKey = _x param [CP_FOR_RECORD_SIDE, "unknown", [""]];
    private _side = [_sideKey] call CP_fnc_getFortifySideFromKey;
    private _cost = _x param [CP_FOR_RECORD_COST, -1, [0]];
    private _object = [_id] call CP_fnc_findFortifyObjectById;

    if (_isDeleted) then {
        if (!isNull _object) then {
            deleteVehicle _object;
        };
        _deleted = _deleted + 1;
    } else {
        if (isNull _object) then {
            _object = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
        };

        if (isNull _object) then {
            _skipped = _skipped + 1;
        } else {
            [_object, _side, _cost, _id] call CP_fnc_registerFortifyObject;

            if (_x param [CP_FOR_RECORD_HAS_POSITION, false]) then {
                _object setDir (_x param [CP_FOR_RECORD_DIR, getDir _object, [0]]);
                private _vectorUp = _x param [CP_FOR_RECORD_VECTOR_UP, vectorUp _object, [[]]];
                if (_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) then {
                    _object setVectorUp _vectorUp;
                };
                _object setPosASL (_x param [CP_FOR_RECORD_POS_ASL, getPosASL _object, [[]]]);
            };

            if (_x param [CP_FOR_RECORD_HAS_DAMAGE, false]) then {
                _object setDamage ((_x param [CP_FOR_RECORD_DAMAGE, damage _object, [0]]) max 0);
            };

            if ([_logisticsConfig] call CP_fnc_isLogisticsPersistenceActive) then {
                if (([_object] call CP_fnc_getLogisticsCategory) isNotEqualTo "") then {
                    [_object, [_id] call CP_fnc_getDerivedLogisticsIdForFortify] call CP_fnc_registerLogisticsObject;
                };
            };

            if (!isNil "CBA_fnc_globalEventJIP") then {
                private _jipId = ["acex_fortify_addActionToObject", [_side, _object]] call CBA_fnc_globalEventJIP;
                if (_jipId isEqualType "" && {!isNil "CBA_fnc_removeGlobalEventJIP"}) then {
                    [_jipId, _object] call CBA_fnc_removeGlobalEventJIP;
                };
            };

            _loaded = _loaded + 1;
        };
    };
} forEach _records;

["INFO", "Fortify restore complete.", [_loaded, _deleted, _skipped, count _records]] call CP_fnc_log;
