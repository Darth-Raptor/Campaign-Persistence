params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {""};
if (_object isKindOf "CAManBase") exitWith {""};
if (_object isKindOf "Logic") exitWith {""};
if (_object isKindOf "Module_F") exitWith {""};
if (_object isKindOf "EmptyDetector") exitWith {""};
if (_object isKindOf "StaticWeapon") exitWith {""};
if (_object isKindOf "Air") exitWith {""};
if (_object isKindOf "Ship") exitWith {""};
if (_object isKindOf "Tank") exitWith {""};
if (_object isKindOf "Car") exitWith {""};
if (_object isKindOf "Bag_Base") exitWith {""};

if (_object getVariable ["CP_enableLogisticsPersistence", false]) exitWith {"prop"};

private _supplyClasses = [
    "storagebladder_01_fuel_sand_f",
    "storagebladder_01_fuel_forest_f",
    "storagebladder_02_water_forest_f",
    "storagebladder_02_water_sand_f",
    "flexibletank_01_forest_f",
    "flexibletank_01_sand_f",
    "rhsusf_props_sceptermfc_d",
    "rhsusf_props_sceptermfc_od"
];

if ((toLowerANSI typeOf _object) in _supplyClasses) exitWith {"supply"};
if (_object isKindOf "ReammoBox_F") exitWith {"crate"};

private _vehicleConfig = configFile >> "CfgVehicles" >> typeOf _object;
private _hasCargoCapacity =
    (getNumber (_vehicleConfig >> "transportMaxWeaponsCargo") > 0) ||
    (getNumber (_vehicleConfig >> "transportMaxMagazinesCargo") > 0) ||
    (getNumber (_vehicleConfig >> "transportMaxItemsCargo") > 0) ||
    (getNumber (_vehicleConfig >> "transportMaxBackpacks") > 0);

if (_hasCargoCapacity) exitWith {"container"};
""
