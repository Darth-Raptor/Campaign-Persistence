if (!isServer) exitWith {};

private _config = [] call CP_fnc_getVehicleConfig;
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {};

[] call CP_fnc_primeVehicleRegistration;

private _records = [] call CP_fnc_loadVehicleRecords;
private _loaded = 0;
private _deleted = 0;
private _skipped = 0;

{
    private _id = _x param [CP_VEH_RECORD_ID, "", [""]];
    private _class = _x param [CP_VEH_RECORD_CLASS, "", [""]];
    private _isDeleted = _x param [CP_VEH_RECORD_DELETED, false];
    private _vehicle = [_id] call CP_fnc_findVehicleById;

    if (_isDeleted) then {
        if (!isNull _vehicle) then {
            deleteVehicle _vehicle;
        };
        _deleted = _deleted + 1;
    } else {
        if (isNull _vehicle) then {
            _vehicle = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
        };

        if (isNull _vehicle) then {
            _skipped = _skipped + 1;
        } else {
            [_vehicle, _id] call CP_fnc_registerVehicle;

            if (_x param [CP_VEH_RECORD_HAS_POSITION, false]) then {
                _vehicle setDir (_x param [CP_VEH_RECORD_DIR, getDir _vehicle, [0]]);
                private _vectorUp = _x param [CP_VEH_RECORD_VECTOR_UP, vectorUp _vehicle, [[]]];
                if (_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) then {
                    _vehicle setVectorUp _vectorUp;
                };
                _vehicle setPosASL (_x param [CP_VEH_RECORD_POS_ASL, getPosASL _vehicle, [[]]]);
            };

            if (_x param [CP_VEH_RECORD_HAS_FUEL, false]) then {
                _vehicle setFuel ((_x param [CP_VEH_RECORD_FUEL, fuel _vehicle, [0]]) max 0);
            };

            if (_x param [CP_VEH_RECORD_HAS_DAMAGE, false]) then {
                [_vehicle, _x param [CP_VEH_RECORD_DAMAGE, damage _vehicle, [0, []]]] call CP_fnc_applyVehicleDamageState;
            };

            if (_x param [CP_VEH_RECORD_HAS_AMMO, false]) then {
                [_vehicle, _x param [CP_VEH_RECORD_AMMO, [], [[]]]] call CP_fnc_applyVehicleAmmoState;
            };

            if (_x param [CP_VEH_RECORD_HAS_INVENTORY, false]) then {
                [_vehicle, _x param [CP_VEH_RECORD_CARGO, [], [[]]]] call CP_fnc_applyCargoData;
            };

            if (_x param [CP_VEH_RECORD_HAS_SERVICE, false]) then {
                private _serviceState = _x param [CP_VEH_RECORD_SERVICE, [], [[]]];
                private _fuelCargo = _serviceState param [0, -1, [0]];
                private _ammoCargo = _serviceState param [1, -1, [0]];
                private _repairCargo = _serviceState param [2, -1, [0]];
                private _aceCurrentFuelCargo = _serviceState param [3, -1, [0]];
                private _aceFuelCargo = _serviceState param [4, -1, [0]];

                if (_fuelCargo >= 0) then {
                    _vehicle setFuelCargo _fuelCargo;
                };
                if (_ammoCargo >= 0) then {
                    _vehicle setAmmoCargo _ammoCargo;
                };
                if (_repairCargo >= 0) then {
                    _vehicle setRepairCargo _repairCargo;
                };
                if (_aceCurrentFuelCargo >= 0) then {
                    _vehicle setVariable ["ace_refuel_currentFuelCargo", _aceCurrentFuelCargo, true];
                };
                if (_aceFuelCargo >= 0) then {
                    _vehicle setVariable ["ace_refuel_fuelCargo", _aceFuelCargo, true];
                };
            };

            _loaded = _loaded + 1;
        };
    };
} forEach _records;

["INFO", "Vehicle restore complete.", [_loaded, _deleted, _skipped, count _records]] call CP_fnc_log;
