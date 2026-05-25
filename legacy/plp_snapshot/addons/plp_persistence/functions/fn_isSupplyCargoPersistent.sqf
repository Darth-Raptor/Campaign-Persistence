/*
    Returns true for object classes whose supply cargo levels should be persisted.
*/
params ["_objectOrClass"];

private _class = "";
if (_objectOrClass isEqualType objNull) then {
    if (isNull _objectOrClass) exitWith {false};
    _class = typeOf _objectOrClass;
} else {
    if (_objectOrClass isEqualType "") then {
        _class = _objectOrClass;
    };
};

if (_class isEqualTo "") exitWith {false};

private _classes = [
    "storagebladder_01_fuel_sand_f",
    "storagebladder_01_fuel_forest_f",
    "storagebladder_02_water_forest_f",
    "storagebladder_02_water_sand_f",
    "flexibletank_01_forest_f",
    "flexibletank_01_sand_f",
    "rhsusf_props_sceptermfc_d",
    "rhsusf_props_sceptermfc_od"
];

(toLower _class) in _classes
