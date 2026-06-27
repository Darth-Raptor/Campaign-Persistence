if (isServer) then {
    if (missionNamespace getVariable ["CP_serverInitStarted", false]) exitWith {};
    missionNamespace setVariable ["CP_serverInitStarted", true];
    missionNamespace setVariable ["CP_serverInitCompleted", false, true];

    private _runtimeMissionId = missionName;
    if (_runtimeMissionId isEqualTo "") then {
        _runtimeMissionId = missionNameSource;
    };
    missionNamespace setVariable ["CP_runtimeMissionId", _runtimeMissionId, true];

    [] spawn {
        waitUntil {sleep 0.25; time > 0};
        [] call CP_fnc_refreshModuleConfig;
        [] call CP_fnc_refreshFortifyModuleConfig;
        [] call CP_fnc_refreshLogisticsModuleConfig;
        [] call CP_fnc_refreshVehicleModuleConfig;
        [] call CP_fnc_registerFortifyEventHandlers;

        if ([] call CP_fnc_isVehiclePersistenceActive) then {
            {
                if (!isNull _x && {([_x] call CP_fnc_getVehicleCategory) isNotEqualTo ""}) then {
                    _x setVariable ["CP_isStartupVehiclePersistenceCandidate", true, true];
                };
            } forEach (allMissionObjects "All");

            private _simulationDelay = missionNamespace getVariable ["CP_vehicleStartupSimulationDelay", 10];
            {
                if (!isNull _x) then {
                    _x enableSimulationGlobal false;
                };
            } forEach vehicles;
            ["INFO", "Disabled simulation on startup vehicles before vehicle restore.", [count vehicles, _simulationDelay]] call CP_fnc_log;

            [] call CP_fnc_restoreVehicles;

            [] spawn {
                private _delay = missionNamespace getVariable ["CP_vehicleStartupSimulationDelay", 10];
                sleep _delay;

                {
                    if (!isNull _x) then {
                        _x enableSimulationGlobal true;
                    };
                } forEach vehicles;

                ["INFO", "Re-enabled simulation on startup vehicles after vehicle restore delay.", [count vehicles, _delay]] call CP_fnc_log;
            };
        };

        if ([] call CP_fnc_isFortifyPersistenceActive) then {
            [] call CP_fnc_restoreFortifyObjects;
            [] call CP_fnc_restoreFortifyBudgets;
        };

        if ([] call CP_fnc_isLogisticsPersistenceActive) then {
            {
                if (!isNull _x && {([_x] call CP_fnc_getLogisticsCategory) isNotEqualTo ""}) then {
                    _x setVariable ["CP_isStartupLogisticsPersistenceCandidate", true, true];
                };
            } forEach (allMissionObjects "All");

            [] call CP_fnc_restoreLogistics;
            [] call CP_fnc_saveAllLogistics;
        };

        addMissionEventHandler ["EntityKilled", {
            params ["_entity"];
            if (!isNull _entity && {isPlayer _entity}) then {
                ["INFO", "Deleting persisted player state because the player died.", getPlayerUID _entity] call CP_fnc_log;
                [_entity] call CP_fnc_deletePlayerRecord;
            };

            if (!isNull _entity && {!isPlayer _entity}) then {
                private _fortifyRecord = [_entity, true] call CP_fnc_buildFortifyRecord;
                if !(_fortifyRecord isEqualTo []) then {
                    [_fortifyRecord] call CP_fnc_saveFortifyObjectRecord;
                    ["INFO", "Saved fortify tombstone because the object was destroyed.", _fortifyRecord param [CP_FOR_RECORD_ID, "", [""]]] call CP_fnc_log;
                };

                private _vehicleConfig = [] call CP_fnc_getVehicleConfig;
                if ([_entity, _vehicleConfig] call CP_fnc_isVehiclePersistent) then {
                    private _vehicleRecord = [_entity, true] call CP_fnc_buildVehicleRecord;
                    if !(_vehicleRecord isEqualTo []) then {
                        [_vehicleRecord] call CP_fnc_saveVehicleRecord;
                        ["INFO", "Saved vehicle tombstone because the object was destroyed.", _vehicleRecord param [CP_VEH_RECORD_ID, "", [""]]] call CP_fnc_log;
                    };
                };

                private _logisticsConfig = [] call CP_fnc_getLogisticsConfig;
                if ([_entity, _logisticsConfig] call CP_fnc_isLogisticsPersistent) then {
                    private _record = [_entity, true] call CP_fnc_buildLogisticsRecord;
                    if !(_record isEqualTo []) then {
                        [_record] call CP_fnc_saveLogisticsRecord;
                        ["INFO", "Saved logistics tombstone because the object was destroyed.", _record param [CP_LOG_RECORD_ID, "", [""]]] call CP_fnc_log;
                    };
                };
            };
        }];

        addMissionEventHandler ["EntityDeleted", {
            params ["_entity"];
            if (!isNull _entity && {!isPlayer _entity}) then {
                private _fortifyRecord = [_entity, true] call CP_fnc_buildFortifyRecord;
                if !(_fortifyRecord isEqualTo []) then {
                    [_fortifyRecord] call CP_fnc_saveFortifyObjectRecord;
                    ["INFO", "Saved fortify tombstone because the object was deleted.", _fortifyRecord param [CP_FOR_RECORD_ID, "", [""]]] call CP_fnc_log;
                };

                private _vehicleConfig = [] call CP_fnc_getVehicleConfig;
                if ([_entity, _vehicleConfig] call CP_fnc_isVehiclePersistent) then {
                    private _vehicleRecord = [_entity, true] call CP_fnc_buildVehicleRecord;
                    if !(_vehicleRecord isEqualTo []) then {
                        [_vehicleRecord] call CP_fnc_saveVehicleRecord;
                        ["INFO", "Saved vehicle tombstone because the object was deleted.", _vehicleRecord param [CP_VEH_RECORD_ID, "", [""]]] call CP_fnc_log;
                    };
                };

                private _logisticsConfig = [] call CP_fnc_getLogisticsConfig;
                if ([_entity, _logisticsConfig] call CP_fnc_isLogisticsPersistent) then {
                    private _record = [_entity, true] call CP_fnc_buildLogisticsRecord;
                    if !(_record isEqualTo []) then {
                        [_record] call CP_fnc_saveLogisticsRecord;
                        ["INFO", "Saved logistics tombstone because the object was deleted.", _record param [CP_LOG_RECORD_ID, "", [""]]] call CP_fnc_log;
                    };
                };
            };
        }];

        addMissionEventHandler ["HandleDisconnect", {
            params ["_unit", "_id", "_uid", "_name"];
            if (!isNull _unit && {_uid isNotEqualTo ""} && {alive _unit}) then {
                private _config = [] call CP_fnc_getServerConfig;
                if ([_config] call CP_fnc_isPlayerPersistenceActive) then {
                    private _record = [_unit, [_unit] call CP_fnc_collectServerFallbackState] call CP_fnc_buildPlayerRecord;
                    if !(_record isEqualTo []) then {
                        [_record] call CP_fnc_savePlayerRecord;
                        ["INFO", "Saved disconnecting player using server fallback capture.", [_uid, _name]] call CP_fnc_log;
                    };
                };
            };
            false
        }];

        [] spawn CP_fnc_serverAutosaveLoop;
        [] spawn CP_fnc_serverFortifyAutosaveLoop;
        [] spawn CP_fnc_serverLogisticsAutosaveLoop;
        [] spawn CP_fnc_serverVehicleAutosaveLoop;

        missionNamespace setVariable ["CP_serverInitCompleted", true, true];
    };
};

if (hasInterface) then {
    [] spawn {
        waitUntil {sleep 0.25; !isNull player && {local player} && {getPlayerUID player isNotEqualTo ""}};

        waitUntil {sleep 0.25; missionNamespace getVariable ["CP_serverConfigInitialized", false]};

        private _playerConfig = [] call CP_fnc_getServerConfig;
        if ([_playerConfig] call CP_fnc_isPlayerPersistenceActive) then {
            missionNamespace setVariable ["CP_aceActionsRegistered", false];
            [] call CP_fnc_registerAceActions;
            [player, getPlayerUID player] remoteExecCall ["CP_fnc_serverHandleRestoreRequest", 2];
        };

        [] call CP_fnc_registerFirstUseEventHandlers;

        player addEventHandler ["Respawn", {
            [] spawn {
                waitUntil {sleep 0.25; !isNull player && {local player} && {getPlayerUID player isNotEqualTo ""}};
                waitUntil {sleep 0.25; missionNamespace getVariable ["CP_serverConfigInitialized", false]};

                private _playerConfig = [] call CP_fnc_getServerConfig;
                if ([_playerConfig] call CP_fnc_isPlayerPersistenceActive) then {
                    missionNamespace setVariable ["CP_aceActionsRegistered", false];
                    [] call CP_fnc_registerAceActions;
                    [player, getPlayerUID player] remoteExecCall ["CP_fnc_serverHandleRestoreRequest", 2];
                };

                [] call CP_fnc_registerFirstUseEventHandlers;
            };
        }];
    };
};
