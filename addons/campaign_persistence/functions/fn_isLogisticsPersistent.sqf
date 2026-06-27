params [
    ["_object", objNull, [objNull]],
    ["_config", [], [[]]]
];

if (isNull _object) exitWith {false};
if !([_config] call CP_fnc_isLogisticsPersistenceActive) exitWith {false};

private _category = [_object] call CP_fnc_getLogisticsCategory;
if (_category isEqualTo "") exitWith {false};

private _existingId = _object getVariable ["CP_runtimeLogisticsPersistenceId", ""];
if (!(_existingId isEqualType "")) then {
    _existingId = "";
} else {
    _existingId = trim _existingId;
    if ((toLowerANSI _existingId) in ["true", "false"]) then {
        _existingId = "";
    };
};
if (_existingId isNotEqualTo "") exitWith {true};

private _includeRuntime = _config param [CP_LOG_CFG_INCLUDE_RUNTIME, false];
private _isStartupObject = _object getVariable ["CP_isStartupLogisticsPersistenceCandidate", false];

switch (_category) do {
    case "supply": {
        _isStartupObject || _includeRuntime
    };
    case "prop": {
        true
    };
    default {
        false
    };
}
