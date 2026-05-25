params [
    ["_record", [], [[]]]
];

if !(_record isEqualType []) exitWith {[false, "record_not_array"]};
if ((count _record) < 22) exitWith {[false, "record_too_short"]};
if ((_record select 0) isNotEqualTo CP_VEH_RECORD_SCHEMA_VERSION) exitWith {[false, "unsupported_schema"]};
if ((_record param [CP_VEH_RECORD_TYPE, "", [""]]) isNotEqualTo "vehicle") exitWith {[false, "wrong_record_type"]};

private _id = _record param [CP_VEH_RECORD_ID, "", [""]];
private _missionKey = _record param [CP_VEH_RECORD_MISSION_KEY, "", [""]];
private _class = _record param [CP_VEH_RECORD_CLASS, "", [""]];
private _category = _record param [CP_VEH_RECORD_CATEGORY, "", [""]];
if (_id isEqualTo "" || {_missionKey isEqualTo ""} || {_class isEqualTo ""} || {_category isEqualTo ""}) exitWith {[false, "missing_identity"]};
if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {[false, "unknown_class"]};
if (_missionKey isNotEqualTo ([] call CP_fnc_buildMissionKey)) exitWith {[false, "mission_key_mismatch"]};

private _deleted = _record param [CP_VEH_RECORD_DELETED, false];
private _hasPosition = _record param [CP_VEH_RECORD_HAS_POSITION, false];
private _posASL = _record param [CP_VEH_RECORD_POS_ASL, [], [[]]];
private _dir = _record param [CP_VEH_RECORD_DIR, 0, [0]];
private _vectorUp = _record param [CP_VEH_RECORD_VECTOR_UP, [], [[]]];
if (!_deleted && {_hasPosition}) then {
    if !(_posASL isEqualType [] && {(count _posASL) isEqualTo 3}) exitWith {[false, "invalid_position"]};
    if !(_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) exitWith {[false, "invalid_vector_up"]};
    if !(_dir isEqualType 0) exitWith {[false, "invalid_direction"]};
};

private _hasDamage = _record param [CP_VEH_RECORD_HAS_DAMAGE, false];
private _damage = _record param [CP_VEH_RECORD_DAMAGE, 0, [0, []]];
if (_hasDamage) then {
    if !(_damage isEqualType 0 || {_damage isEqualType []}) exitWith {[false, "invalid_damage"]};
    if (_damage isEqualType []) then {
        if ((count _damage) < 3) exitWith {[false, "invalid_damage_state"]};
        private _hitPointNames = _damage param [1, [], [[]]];
        private _hitPointDamages = _damage param [2, [], [[]]];
        if !(_hitPointNames isEqualType [] && {_hitPointDamages isEqualType []}) exitWith {[false, "invalid_hitpoint_damage"]};
    };
};

private _hasAmmo = _record param [CP_VEH_RECORD_HAS_AMMO, false];
private _ammoState = _record param [CP_VEH_RECORD_AMMO, [], [[]]];
if (_hasAmmo && {!(_ammoState isEqualType [])}) exitWith {[false, "invalid_ammo"]};

private _hasFuel = _record param [CP_VEH_RECORD_HAS_FUEL, false];
private _fuelState = _record param [CP_VEH_RECORD_FUEL, 0, [0]];
if (_hasFuel && {!(_fuelState isEqualType 0)}) exitWith {[false, "invalid_fuel"]};

private _hasInventory = _record param [CP_VEH_RECORD_HAS_INVENTORY, false];
private _cargoData = _record param [CP_VEH_RECORD_CARGO, [], [[]]];
if (_hasInventory && {!(_cargoData isEqualType [])}) exitWith {[false, "invalid_cargo"]};

private _hasService = _record param [CP_VEH_RECORD_HAS_SERVICE, false];
private _serviceState = _record param [CP_VEH_RECORD_SERVICE, [], [[]]];
if (_hasService && {!(_serviceState isEqualType [])}) exitWith {[false, "invalid_service"]};

[true, ""]
