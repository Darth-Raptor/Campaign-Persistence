params [
    ["_rawConfig", [], [[]]]
];

private _defaultInterval = missionNamespace getVariable ["CP_defaultSaveInterval", 120];
private _maxInterval = missionNamespace getVariable ["CP_maxSaveInterval", 300];

private _modulePresent = _rawConfig param [CP_FOR_CFG_MODULE_PRESENT, false];
private _enabled = _rawConfig param [CP_FOR_CFG_ENABLED, false];
private _persistPosition = _rawConfig param [CP_FOR_CFG_PERSIST_POSITION, false];
private _persistDamage = _rawConfig param [CP_FOR_CFG_PERSIST_DAMAGE, false];
private _persistBudget = _rawConfig param [CP_FOR_CFG_PERSIST_BUDGET, false];
private _saveInterval = _rawConfig param [CP_FOR_CFG_SAVE_INTERVAL, _defaultInterval];
private _debug = _rawConfig param [CP_FOR_CFG_DEBUG, false];

if !(_saveInterval isEqualType 0) then {
    _saveInterval = _defaultInterval;
};
_saveInterval = (_saveInterval max 1) min _maxInterval;

if (!_modulePresent || !_enabled) then {
    _persistPosition = false;
    _persistDamage = false;
    _persistBudget = false;
};

[
    _modulePresent,
    _enabled,
    _persistPosition,
    _persistDamage,
    _persistBudget,
    _saveInterval,
    _debug
]
