params [
    ["_record", [], [[]]]
];

if !(_record isEqualType []) exitWith {[false, "record_not_array"]};
if ((count _record) < 5) exitWith {[false, "record_too_short"]};
if ((_record select 0) isNotEqualTo CP_FOR_BUD_RECORD_SCHEMA_VERSION) exitWith {[false, "unsupported_schema"]};
if ((_record param [CP_FOR_BUD_RECORD_TYPE, "", [""]]) isNotEqualTo "fortifyBudget") exitWith {[false, "wrong_record_type"]};

private _missionKey = _record param [CP_FOR_BUD_RECORD_MISSION_KEY, "", [""]];
if (_missionKey isEqualTo "") exitWith {[false, "missing_mission_key"]};
if (_missionKey isNotEqualTo ([] call CP_fnc_buildMissionKey)) exitWith {[false, "mission_key_mismatch"]};

private _budgets = _record param [CP_FOR_BUD_RECORD_BUDGETS, [], [[]]];
if !(_budgets isEqualType []) exitWith {[false, "invalid_budgets"]};

private _entriesValid = true;
{
    if !(_x isEqualType [] && {(count _x) >= 2}) exitWith {
        _entriesValid = false;
    };

    private _sideKey = _x param [0, "", [""]];
    private _budgetValue = _x param [1, 0, [0]];
    if !(_sideKey isEqualType "" && {_budgetValue isEqualType 0}) exitWith {
        _entriesValid = false;
    };
} forEach _budgets;

if (!_entriesValid) exitWith {[false, "invalid_budget_entries"]};

[true, ""]
