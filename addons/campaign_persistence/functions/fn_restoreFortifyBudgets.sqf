if (!isServer) exitWith {};

private _config = [] call CP_fnc_getFortifyConfig;
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {};
if !(_config param [CP_FOR_CFG_PERSIST_BUDGET, false]) exitWith {};

private _getBudgetFn = if (!isNil "ace_fortify_fnc_getBudget") then {
    ace_fortify_fnc_getBudget
} else {
    if (!isNil "acex_fortify_fnc_getBudget") then {acex_fortify_fnc_getBudget} else {objNull}
};
if (_getBudgetFn isEqualType objNull || {isNil "ace_fortify_fnc_updateBudget"}) exitWith {};

private _record = [] call CP_fnc_loadFortifyBudgetRecord;
if (_record isEqualTo []) exitWith {};

private _applied = 0;
private _skipped = 0;
{
    private _sideKey = _x param [0, "", [""]];
    private _storedBudget = _x param [1, 0, [0]];
    private _side = [_sideKey] call CP_fnc_getFortifySideFromKey;

    if (_side isEqualTo sideUnknown) then {
        _skipped = _skipped + 1;
    } else {
        private _currentBudget = [_side] call _getBudgetFn;
        if (_currentBudget isEqualType 0) then {
            private _delta = _storedBudget - _currentBudget;
            if (abs _delta > 0.001) then {
                [_side, _delta, false] call ace_fortify_fnc_updateBudget;
            };
            _applied = _applied + 1;
        } else {
            ["WARN", "Skipped fortify budget restore for side without an active ACE Fortify setup.", _sideKey] call CP_fnc_log;
            _skipped = _skipped + 1;
        };
    };
} forEach (_record param [CP_FOR_BUD_RECORD_BUDGETS, [], [[]]]);

["INFO", "Fortify budget restore complete.", [_applied, _skipped]] call CP_fnc_log;
