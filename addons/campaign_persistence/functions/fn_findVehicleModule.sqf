private _modules = allMissionObjects "CAMPAIGN_PERSISTENCE_ModuleVehiclePersistence";
if ((count _modules) > 1) then {
    ["WARN", "Multiple Vehicle Persistence modules found; using the first module placed in the mission.", count _modules] call CP_fnc_log;
};

if (_modules isEqualTo []) exitWith {objNull};
_modules select 0
