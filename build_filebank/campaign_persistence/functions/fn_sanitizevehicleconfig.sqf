params [
    ["_rawConfig", [], [[]]]
];

private _defaultInterval = missionNamespace getVariable ["CP_defaultSaveInterval", 120];
private _maxInterval = missionNamespace getVariable ["CP_maxSaveInterval", 300];

private _modulePresent = _rawConfig param [CP_VEH_CFG_MODULE_PRESENT, false];
private _enabled = _rawConfig param [CP_VEH_CFG_ENABLED, false];
private _persistPosition = _rawConfig param [CP_VEH_CFG_PERSIST_POSITION, false];
private _persistDamage = _rawConfig param [CP_VEH_CFG_PERSIST_DAMAGE, false];
private _persistAmmo = _rawConfig param [CP_VEH_CFG_PERSIST_AMMO, false];
private _persistFuel = _rawConfig param [CP_VEH_CFG_PERSIST_FUEL, false];
private _persistInventory = _rawConfig param [CP_VEH_CFG_PERSIST_INVENTORY, false];
private _persistNested = _rawConfig param [CP_VEH_CFG_PERSIST_NESTED, false];
private _persistService = _rawConfig param [CP_VEH_CFG_PERSIST_SERVICE, false];
private _includeRuntime = _rawConfig param [CP_VEH_CFG_INCLUDE_RUNTIME, false];
private _saveInterval = _rawConfig param [CP_VEH_CFG_SAVE_INTERVAL, _defaultInterval];
private _debug = _rawConfig param [CP_VEH_CFG_DEBUG, false];

if !(_saveInterval isEqualType 0) then {
    _saveInterval = _defaultInterval;
};
_saveInterval = (_saveInterval max 1) min _maxInterval;

if (!_modulePresent || !_enabled) then {
    _persistPosition = false;
    _persistDamage = false;
    _persistAmmo = false;
    _persistFuel = false;
    _persistInventory = false;
    _persistNested = false;
    _persistService = false;
    _includeRuntime = false;
};

if (!_persistInventory) then {
    _persistNested = false;
};

[
    _modulePresent,
    _enabled,
    _persistPosition,
    _persistDamage,
    _persistAmmo,
    _persistFuel,
    _persistInventory,
    _persistNested,
    _persistService,
    _includeRuntime,
    _saveInterval,
    _debug
]
