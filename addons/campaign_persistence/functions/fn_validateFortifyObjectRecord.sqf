params [
    ["_record", [], [[]]]
];

if !(_record isEqualType []) exitWith {[false, "record_not_array"]};
if ((count _record) < 15) exitWith {[false, "record_too_short"]};
if ((_record select 0) isNotEqualTo CP_FOR_RECORD_SCHEMA_VERSION) exitWith {[false, "unsupported_schema"]};
if ((_record param [CP_FOR_RECORD_TYPE, "", [""]]) isNotEqualTo "fortify") exitWith {[false, "wrong_record_type"]};

private _id = _record param [CP_FOR_RECORD_ID, "", [""]];
private _missionKey = _record param [CP_FOR_RECORD_MISSION_KEY, "", [""]];
private _class = _record param [CP_FOR_RECORD_CLASS, "", [""]];
private _sideKey = _record param [CP_FOR_RECORD_SIDE, "", [""]];
private _cost = _record param [CP_FOR_RECORD_COST, 0, [0]];
if (_id isEqualTo "" || {_missionKey isEqualTo ""} || {_class isEqualTo ""}) exitWith {[false, "missing_identity"]};
if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {[false, "unknown_class"]};
if (_missionKey isNotEqualTo ([] call CP_fnc_buildMissionKey)) exitWith {[false, "mission_key_mismatch"]};
if !(_sideKey isEqualType "") exitWith {[false, "invalid_side"]};
if !(_cost isEqualType 0) exitWith {[false, "invalid_cost"]};

private _deleted = _record param [CP_FOR_RECORD_DELETED, false];
private _hasPosition = _record param [CP_FOR_RECORD_HAS_POSITION, false];
private _posASL = _record param [CP_FOR_RECORD_POS_ASL, [], [[]]];
private _dir = _record param [CP_FOR_RECORD_DIR, 0, [0]];
private _vectorUp = _record param [CP_FOR_RECORD_VECTOR_UP, [], [[]]];
if (!_deleted && {_hasPosition}) then {
    if !(_posASL isEqualType [] && {(count _posASL) isEqualTo 3}) exitWith {[false, "invalid_position"]};
    if !(_vectorUp isEqualType [] && {(count _vectorUp) isEqualTo 3}) exitWith {[false, "invalid_vector_up"]};
    if !(_dir isEqualType 0) exitWith {[false, "invalid_direction"]};
};

private _hasDamage = _record param [CP_FOR_RECORD_HAS_DAMAGE, false];
private _damage = _record param [CP_FOR_RECORD_DAMAGE, 0, [0]];
if (_hasDamage && {!(_damage isEqualType 0)}) exitWith {[false, "invalid_damage"]};

[true, ""]
