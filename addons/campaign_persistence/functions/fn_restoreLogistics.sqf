if (!isServer) exitWith {};

private _config = [] call CP_fnc_getLogisticsConfig;
if !([_config] call CP_fnc_isLogisticsPersistenceActive) exitWith {};

private _records = [] call CP_fnc_loadLogisticsRecords;
private _loaded = 0;
private _deleted = 0;
private _skipped = 0;

{
    private _id = _x param [CP_LOG_RECORD_ID, "", [""]];
    private _class = _x param [CP_LOG_RECORD_CLASS, "", [""]];
    private _isDeleted = _x param [CP_LOG_RECORD_DELETED, false];
    private _object = [_id] call CP_fnc_findLogisticsObjectById;

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
            [_object, _id] call CP_fnc_registerLogisticsObject;

            if (_x param [CP_LOG_RECORD_HAS_POSITION, false]) then {
                _object setDir (_x param [CP_LOG_RECORD_DIR, getDir _object, [0]]);
                private _vectorUp = _x param [CP_LOG_RECORD_VECTOR_UP, vectorUp _object, [[]]];
                if (_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) then {
                    _object setVectorUp _vectorUp;
                };
                _object setPosASL (_x param [CP_LOG_RECORD_POS_ASL, getPosASL _object, [[]]]);
            };

            if (_x param [CP_LOG_RECORD_HAS_DAMAGE, false]) then {
                private _damage = _x param [CP_LOG_RECORD_DAMAGE, damage _object, [0]];
                _object setDamage ((_damage max 0) min 1);
            };

            if (_x param [CP_LOG_RECORD_HAS_INVENTORY, false]) then {
                [_object, _x param [CP_LOG_RECORD_CARGO, [], [[]]]] call CP_fnc_applyCargoData;
            };

            if (_x param [CP_LOG_RECORD_HAS_SUPPLY, false]) then {
                private _supplyState = _x param [CP_LOG_RECORD_SUPPLY, [], [[]]];
                private _fuelCargo = _supplyState param [0, -1, [0]];
                private _ammoCargo = _supplyState param [1, -1, [0]];
                private _repairCargo = _supplyState param [2, -1, [0]];
                private _fuel = _supplyState param [3, fuel _object, [0]];
                private _aceCurrentFuelCargo = _supplyState param [4, -1, [0]];
                private _aceFuelCargo = _supplyState param [5, -1, [0]];

                if (_fuelCargo >= 0) then {
                    _object setFuelCargo _fuelCargo;
                };
                if (_ammoCargo >= 0) then {
                    _object setAmmoCargo _ammoCargo;
                };
                if (_repairCargo >= 0) then {
                    _object setRepairCargo _repairCargo;
                };
                if (_fuel isEqualType 0) then {
                    _object setFuel _fuel;
                };
                if (_aceCurrentFuelCargo >= 0) then {
                    _object setVariable ["ace_refuel_currentFuelCargo", _aceCurrentFuelCargo, true];
                };
                if (_aceFuelCargo >= 0) then {
                    _object setVariable ["ace_refuel_fuelCargo", _aceFuelCargo, true];
                };
            };

            _loaded = _loaded + 1;
        };
    };
} forEach _records;

["INFO", "Logistics restore complete.", [_loaded, _deleted, _skipped, count _records]] call CP_fnc_log;
