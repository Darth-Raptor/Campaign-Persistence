params [
    ["_record", [], [[]]]
];

if !(_record isEqualType []) exitWith {[false, "record_not_array"]};
if ((count _record) < 18) exitWith {[false, "record_too_short"]};
if ((_record select 0) isNotEqualTo CP_LOG_RECORD_SCHEMA_VERSION) exitWith {[false, "unsupported_schema"]};
if ((_record param [CP_LOG_RECORD_TYPE, "", [""]]) isNotEqualTo "logistics") exitWith {[false, "wrong_record_type"]};

private _id = _record param [CP_LOG_RECORD_ID, "", [""]];
private _missionKey = _record param [CP_LOG_RECORD_MISSION_KEY, "", [""]];
private _class = _record param [CP_LOG_RECORD_CLASS, "", [""]];
if (_id isEqualTo "" || {_missionKey isEqualTo ""} || {_class isEqualTo ""}) exitWith {[false, "missing_identity"]};
if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {[false, "unknown_class"]};
if (_missionKey isNotEqualTo ([] call CP_fnc_buildMissionKey)) exitWith {[false, "mission_key_mismatch"]};

private _deleted = _record param [CP_LOG_RECORD_DELETED, false];
private _hasPosition = _record param [CP_LOG_RECORD_HAS_POSITION, false];
private _posASL = _record param [CP_LOG_RECORD_POS_ASL, [], [[]]];
private _dir = _record param [CP_LOG_RECORD_DIR, 0, [0]];
private _vectorUp = _record param [CP_LOG_RECORD_VECTOR_UP, [], [[]]];
if (!_deleted && {_hasPosition}) then {
    if !(_posASL isEqualType [] && {(count _posASL) isEqualTo 3}) exitWith {[false, "invalid_position"]};
    if !(_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) exitWith {[false, "invalid_vector_up"]};
    if !(_dir isEqualType 0) exitWith {[false, "invalid_direction"]};
};

private _hasInventory = _record param [CP_LOG_RECORD_HAS_INVENTORY, false];
private _cargoData = _record param [CP_LOG_RECORD_CARGO, [], [[]]];
if (_hasInventory && {!(_cargoData isEqualType [])}) exitWith {[false, "invalid_cargo"]};

private _hasDamage = _record param [CP_LOG_RECORD_HAS_DAMAGE, false];
private _damage = _record param [CP_LOG_RECORD_DAMAGE, 0, [0]];
if (_hasDamage && {!(_damage isEqualType 0)}) exitWith {[false, "invalid_damage"]};

private _hasSupply = _record param [CP_LOG_RECORD_HAS_SUPPLY, false];
private _supplyState = _record param [CP_LOG_RECORD_SUPPLY, [], [[]]];
if (_hasSupply && {!(_supplyState isEqualType [])}) exitWith {[false, "invalid_supply"]};

[true, ""]
