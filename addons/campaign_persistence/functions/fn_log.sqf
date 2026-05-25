params [
    ["_level", "INFO", [""]],
    ["_message", "", [""]],
    ["_context", objNull]
];

private _playerConfig = missionNamespace getVariable ["CP_serverConfig", [false, false, false, false, false, false, 120, false, false]];
private _logisticsConfig = missionNamespace getVariable ["CP_logisticsConfig", [false, false, false, false, false, false, false, false, 120, false]];
private _vehicleConfig = missionNamespace getVariable ["CP_vehicleConfig", [false, false, false, false, false, false, false, false, false, false, 120, false]];
private _fortifyConfig = missionNamespace getVariable ["CP_fortifyConfig", [false, false, false, false, false, 120, false]];
private _debugEnabled =
    (_playerConfig param [CP_CFG_DEBUG, false]) ||
    (_logisticsConfig param [CP_LOG_CFG_DEBUG, false]) ||
    (_vehicleConfig param [CP_VEH_CFG_DEBUG, false]) ||
    (_fortifyConfig param [CP_FOR_CFG_DEBUG, false]);
if ((_level isEqualTo "DEBUG") && {!_debugEnabled}) exitWith {};

private _contextText = "";
if !(isNil "_context") then {
    _contextText = str _context;
};

diag_log format ["[Campaign Persistence] [%1] %2%3", _level, _message, if (_contextText isEqualTo "") then {""} else {format [" | %1", _contextText]}];
