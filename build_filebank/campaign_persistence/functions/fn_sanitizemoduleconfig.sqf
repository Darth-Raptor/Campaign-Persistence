params [
    ["_rawConfig", [], [[]]]
];

private _defaultInterval = missionNamespace getVariable ["CP_defaultSaveInterval", 120];
private _maxInterval = missionNamespace getVariable ["CP_maxSaveInterval", 300];

private _modulePresent = _rawConfig param [CP_CFG_MODULE_PRESENT, false];
private _enabled = _rawConfig param [CP_CFG_ENABLED, false];
private _persistPosition = _rawConfig param [CP_CFG_PERSIST_POSITION, false];
private _persistLoadout = _rawConfig param [CP_CFG_PERSIST_LOADOUT, false];
private _persistAmmo = _rawConfig param [CP_CFG_PERSIST_AMMO, false];
private _persistHealth = _rawConfig param [CP_CFG_PERSIST_HEALTH, false];
private _saveInterval = _rawConfig param [CP_CFG_SAVE_INTERVAL, _defaultInterval];
private _aceManualSave = _rawConfig param [CP_CFG_ACE_MANUAL_SAVE, false];
private _debug = _rawConfig param [CP_CFG_DEBUG, false];

if !(_saveInterval isEqualType 0) then {
    _saveInterval = _defaultInterval;
};
_saveInterval = (_saveInterval max 1) min _maxInterval;

if (!_modulePresent || !_enabled) then {
    _persistPosition = false;
    _persistLoadout = false;
    _persistAmmo = false;
    _persistHealth = false;
    _aceManualSave = false;
};

if (!_persistLoadout) then {
    _persistAmmo = false;
};

[
    _modulePresent,
    _enabled,
    _persistPosition,
    _persistLoadout,
    _persistAmmo,
    _persistHealth,
    _saveInterval,
    _aceManualSave,
    _debug
]
