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

private _explicitOptIn = _object getVariable ["CP_enableLogisticsPersistence", false];
if (_explicitOptIn) exitWith {true};

if !(missionNamespace getVariable ["CP_logisticsStartupRegistrationComplete", false]) exitWith {true};

_config param [CP_LOG_CFG_INCLUDE_RUNTIME, false]
