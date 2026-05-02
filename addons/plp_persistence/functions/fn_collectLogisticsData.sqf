/*
    Returns serializable state for a logistics object.
*/
params ["_object"];

private _id = [_object] call PLP_fnc_registerLogisticsObject;
private _category = [_object] call PLP_fnc_getObjectCategory;
private _cargoData = [_object] call PLP_fnc_collectCargoData;
private _supplyCargo = createHashMap;

if ([_object] call PLP_fnc_isSupplyCargoPersistent) then {
    private _fuelCargo = getFuelCargo _object;
    private _ammoCargo = getAmmoCargo _object;
    private _repairCargo = getRepairCargo _object;

    if (_fuelCargo >= 0) then {
        _supplyCargo set ["fuelCargo", _fuelCargo];
    };
    if (_ammoCargo >= 0) then {
        _supplyCargo set ["ammoCargo", _ammoCargo];
    };
    if (_repairCargo >= 0) then {
        _supplyCargo set ["repairCargo", _repairCargo];
    };

    {
        if (!isNil {_object getVariable _x}) then {
            _supplyCargo set [_x, _object getVariable _x];
        };
    } forEach [
        "ace_refuel_currentFuelCargo",
        "ace_refuel_fuelCargo"
    ];
};

createHashMapFromArray [
    ["recordType", "logistics"],
    ["schemaVersion", 1],
    ["id", _id],
    ["class", typeOf _object],
    ["category", _category],
    ["posASL", getPosASL _object],
    ["dir", getDir _object],
    ["vectorUp", vectorUp _object],
    ["damage", damage _object],
    ["fuel", fuel _object],
    ["locked", locked _object],
    ["weaponsCargo", _cargoData getOrDefault ["weaponsCargo", []]],
    ["weaponsItemsCargo", _cargoData getOrDefault ["weaponsItemsCargo", []]],
    ["magazinesCargo", _cargoData getOrDefault ["magazinesCargo", []]],
    ["itemsCargo", _cargoData getOrDefault ["itemsCargo", []]],
    ["backpacksCargo", _cargoData getOrDefault ["backpacksCargo", []]],
    ["nestedContainers", _cargoData getOrDefault ["nestedContainers", []]],
    ["supplyCargo", _supplyCargo],
    ["vars", _object getVariable ["PLP_persistentVars", createHashMap]],
    ["timestamp", serverTime],
    ["lastWrite", serverTime]
]
