params [
    ["_object", objNull, [objNull]],
    ["_forcedId", "", [""]]
];

if (isNull _object) exitWith {""};

private _assignedId = _forcedId;
if (_assignedId isEqualTo "") then {
    _assignedId = _object getVariable ["CP_runtimeLogisticsPersistenceId", ""];
};

if (_assignedId isEqualTo "") then {
    _assignedId = _object getVariable ["CP_logisticsPersistenceIdOverride", ""];
};

if !(_assignedId isEqualType "") then {
    _assignedId = "";
} else {
    _assignedId = trim _assignedId;
    if ((toLowerANSI _assignedId) in ["true", "false"]) then {
        _assignedId = "";
    };
};

if (_assignedId isEqualTo "") then {
    if (!(missionNamespace getVariable ["CP_logisticsStartupRegistrationComplete", false])) then {
        _assignedId = [_object] call CP_fnc_getDefaultLogisticsId;
    } else {
        private _config = [] call CP_fnc_getLogisticsConfig;
        if (_config param [CP_LOG_CFG_INCLUDE_RUNTIME, false]) then {
            _assignedId = format ["runtime:%1:%2:%3", typeOf _object, round (serverTime * 100), floor (random 1000000)];
        };
    };
};

if (_assignedId isEqualTo "") exitWith {""};

_object setVariable ["CP_runtimeLogisticsPersistenceId", _assignedId, true];
_object setVariable ["CP_logisticsPersistenceId", _assignedId, true];
_assignedId
