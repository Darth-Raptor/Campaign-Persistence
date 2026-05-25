/*
    Campaign Persistence server debug helper

    Usage:
    1. Paste into the server debug console, or
    2. `[] execVM "cp_server_debug_check.sqf";` from a test mission on the server.

    This script only reads state and writes to the RPT. It does not modify
    persistence data.
*/

if (!isServer) exitWith {
    diag_log "[CP DEBUG] This script must run on the server.";
};

private _log = {
    params ["_message", ["_context", objNull]];

    private _suffix = "";
    if !(_context isEqualTo objNull) then {
        _suffix = format [" | %1", _context];
    };

    diag_log format ["[CP DEBUG] %1%2", _message, _suffix];
};

["Starting Campaign Persistence debug check."] call _log;
["Mission identity.", [
    missionName,
    missionNameSource,
    worldName,
    missionNamespace getVariable ["CP_runtimeMissionId", ""]
]] call _log;

private _checks = [
    ["CfgPatches campaign_persistence present", isClass (configFile >> "CfgPatches" >> "campaign_persistence")],
    ["Function CP_fnc_init registered", !isNil "CP_fnc_init"],
    ["Function CP_fnc_log registered", !isNil "CP_fnc_log"],
    ["Function CP_fnc_callBackend registered", !isNil "CP_fnc_callBackend"],
    ["Pythia bridge py3_fnc_callExtension present", !isNil "py3_fnc_callExtension"],
    ["Player config initialized", missionNamespace getVariable ["CP_serverConfigInitialized", false]],
    ["Vehicle startup registration complete", missionNamespace getVariable ["CP_vehicleStartupRegistrationComplete", false]],
    ["Logistics startup registration complete", missionNamespace getVariable ["CP_logisticsStartupRegistrationComplete", false]]
];

{
    _x params ["_label", "_value"];
    [format ["%1", _label], _value] call _log;
} forEach _checks;

private _playerConfig = missionNamespace getVariable ["CP_serverConfig", []];
private _logisticsConfig = missionNamespace getVariable ["CP_logisticsConfig", []];
private _vehicleConfig = missionNamespace getVariable ["CP_vehicleConfig", []];
private _fortifyConfig = missionNamespace getVariable ["CP_fortifyConfig", []];

["Player config payload.", _playerConfig] call _log;
["Logistics config payload.", _logisticsConfig] call _log;
["Vehicle config payload.", _vehicleConfig] call _log;
["Fortify config payload.", _fortifyConfig] call _log;

if (!isNil "CP_fnc_isPlayerPersistenceActive") then {
    ["Player persistence active.", [_playerConfig] call CP_fnc_isPlayerPersistenceActive] call _log;
};

if (!isNil "CP_fnc_isLogisticsPersistenceActive") then {
    ["Logistics persistence active.", [] call CP_fnc_isLogisticsPersistenceActive] call _log;
};

if (!isNil "CP_fnc_isVehiclePersistenceActive") then {
    ["Vehicle persistence active.", [] call CP_fnc_isVehiclePersistenceActive] call _log;
};

if (!isNil "CP_fnc_isFortifyPersistenceActive") then {
    ["Fortify persistence active.", [] call CP_fnc_isFortifyPersistenceActive] call _log;
};

if (!isNil "CP_fnc_buildMissionKey") then {
    private _missionKey = call CP_fnc_buildMissionKey;
    ["Derived mission key.", _missionKey] call _log;

    if (!isNil "CP_fnc_callBackend") then {
        private _backendProbe = ["load_player", ["__cp_debug__", _missionKey]] call CP_fnc_callBackend;
        ["Backend probe result from load_player.", _backendProbe] call _log;
    };
};

["Campaign Persistence debug check complete."] call _log;
