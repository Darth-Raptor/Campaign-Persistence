if (!isServer) exitWith {[]};

private _config = [] call CP_fnc_getFortifyConfig;
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {[]};
if !(_config param [CP_FOR_CFG_PERSIST_BUDGET, false]) exitWith {[]};

private _getBudgetFn = if (!isNil "ace_fortify_fnc_getBudget") then {
    ace_fortify_fnc_getBudget
} else {
    if (!isNil "acex_fortify_fnc_getBudget") then {acex_fortify_fnc_getBudget} else {objNull}
};
if (_getBudgetFn isEqualType objNull) exitWith {[]};

private _trackedKeys = + (missionNamespace getVariable ["CP_fortifyTrackedSides", []]);
if (_trackedKeys isEqualTo []) then {
    _trackedKeys = ["west", "east", "resistance", "civilian"];
};

private _budgets = [];
{
    private _side = [_x] call CP_fnc_getFortifySideFromKey;
    if !(_side isEqualTo sideUnknown) then {
        private _budget = [_side] call _getBudgetFn;
        if (_budget isEqualType 0) then {
            _budgets pushBack [_x, _budget];
        };
    };
} forEach _trackedKeys;

[
    CP_FOR_BUD_RECORD_SCHEMA_VERSION,
    "fortifyBudget",
    [] call CP_fnc_buildMissionKey,
    _budgets,
    serverTime
]
