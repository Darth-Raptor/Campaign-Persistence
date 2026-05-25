params [
    ["_rawConfig", [], [[]]]
];

private _defaultInterval = missionNamespace getVariable ["CP_defaultSaveInterval", 120];
private _maxInterval = missionNamespace getVariable ["CP_maxSaveInterval", 300];

private _modulePresent = _rawConfig param [CP_LOG_CFG_MODULE_PRESENT, false];
private _enabled = _rawConfig param [CP_LOG_CFG_ENABLED, false];
private _persistPosition = _rawConfig param [CP_LOG_CFG_PERSIST_POSITION, false];
private _persistInventory = _rawConfig param [CP_LOG_CFG_PERSIST_INVENTORY, false];
private _persistNested = _rawConfig param [CP_LOG_CFG_PERSIST_NESTED, false];
private _persistDamage = _rawConfig param [CP_LOG_CFG_PERSIST_DAMAGE, false];
private _persistSupply = _rawConfig param [CP_LOG_CFG_PERSIST_SUPPLY, false];
private _includeRuntime = _rawConfig param [CP_LOG_CFG_INCLUDE_RUNTIME, false];
private _saveInterval = _rawConfig param [CP_LOG_CFG_SAVE_INTERVAL, _defaultInterval];
private _debug = _rawConfig param [CP_LOG_CFG_DEBUG, false];

if !(_saveInterval isEqualType 0) then {
    _saveInterval = _defaultInterval;
};
_saveInterval = (_saveInterval max 1) min _maxInterval;

if (!_modulePresent || !_enabled) then {
    _persistPosition = false;
    _persistInventory = false;
    _persistNested = false;
    _persistDamage = false;
    _persistSupply = false;
    _includeRuntime = false;
};

if (!_persistInventory) then {
    _persistNested = false;
};

[
    _modulePresent,
    _enabled,
    _persistPosition,
    _persistInventory,
    _persistNested,
    _persistDamage,
    _persistSupply,
    _includeRuntime,
    _saveInterval,
    _debug
]
