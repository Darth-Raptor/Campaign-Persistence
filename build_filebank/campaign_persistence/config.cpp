class CfgPatches
{
    class campaign_persistence
    {
        name = "Campaign Persistence";
        author = "Codex";
        version = 4.0;
        versionStr = "4.0.0";
        versionAr[] = {4, 0, 0};
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "ace_interact_menu", "ace_fortify"};
        units[] = {"CAMPAIGN_PERSISTENCE_ModulePlayerPersistence", "CAMPAIGN_PERSISTENCE_ModuleLogisticsPersistence", "CAMPAIGN_PERSISTENCE_ModuleVehiclePersistence", "CAMPAIGN_PERSISTENCE_ModuleFortifyPersistence"};
        weapons[] = {};
    };
};

class CfgFactionClasses
{
    class CAMPAIGN_PERSISTENCE_Modules
    {
        displayName = "Campaign Persistence";
        priority = 2;
        side = 7;
    };
};

class CfgFunctions
{
    class CP
    {
        class core
        {
            file = "\campaign_persistence\functions";
            class applyCargoData {};
            class applyPlayerState {};
            class applyVehicleDamageState {};
            class applyVehicleAmmoState {};
            class beginSaveForPlayer {};
            class buildLogisticsRecord {};
            class buildMissionKey {};
            class buildPlayerRecord {};
            class buildPlayerVehicleLink {};
            class buildVehicleRecord {};
            class callBackend {};
            class clientCollectState {};
            class collectCargoData {};
            class collectServerFallbackState {};
            class collectVehicleDamageState {};
            class collectVehicleAmmoState {};
            class deletePlayerRecord {};
            class findLogisticsModule {};
            class findLogisticsObjectById {};
            class findFortifyModule {};
            class findFortifyObjectById {};
            class findPlayerModule {};
            class findVehicleById {};
            class findVehicleModule {};
            class getDerivedLogisticsIdForFortify {};
            class getFortifyConfig {};
            class getFortifySideFromKey {};
            class getFortifySideKey {};
            class getDefaultLogisticsId {};
            class getDefaultFortifyId {};
            class getDefaultVehicleId {};
            class getLogisticsCategory {};
            class getLogisticsConfig {};
            class getServerConfig {};
            class getVehicleCategory {};
            class getVehicleConfig {};
            class init {postInit = 1;};
            class isAuthorizedRemoteOwner {};
            class isFortifyObjectPersistent {};
            class isFortifyPersistenceActive {};
            class isLogisticsPersistenceActive {};
            class isLogisticsPersistent {};
            class isPlayerPersistenceActive {};
            class isSupplyStatePersistent {};
            class isVehiclePersistenceActive {};
            class isVehiclePersistent {};
            class loadFortifyBudgetRecord {};
            class loadFortifyObjectRecords {};
            class loadLogisticsRecords {};
            class loadPlayerRecord {};
            class loadVehicleRecords {};
            class log {};
            class notifyClient {};
            class preInit {preInit = 1;};
            class primeVehicleRegistration {};
            class refreshFortifyModuleConfig {};
            class refreshLogisticsModuleConfig {};
            class refreshModuleConfig {};
            class refreshVehicleModuleConfig {};
            class registerAceActions {};
            class registerFortifyEventHandlers {};
            class registerFortifyObject {};
            class registerLogisticsObject {};
            class registerVehicle {};
            class requestManualSave {};
            class restoreFortifyBudgets {};
            class restoreFortifyObjects {};
            class restoreLogistics {};
            class restorePlayerVehicleLink {};
            class restoreVehicles {};
            class sanitizeFortifyConfig {};
            class sanitizeLogisticsConfig {};
            class sanitizeModuleConfig {};
            class sanitizeVehicleConfig {};
            class saveAllFortifyObjects {};
            class saveFortifyBudgetRecord {};
            class saveFortifyObjectRecord {};
            class saveAllLogistics {};
            class saveAllVehicles {};
            class saveLogisticsRecord {};
            class savePlayerRecord {};
            class saveVehicleRecord {};
            class serverAutosaveLoop {};
            class serverFortifyAutosaveLoop {};
            class serverHandleManualSaveRequest {};
            class serverHandleRestoreRequest {};
            class serverLogisticsAutosaveLoop {};
            class serverReceiveCollectedState {};
            class serverVehicleAutosaveLoop {};
            class validateFortifyBudgetRecord {};
            class validateFortifyObjectRecord {};
            class validateLogisticsRecord {};
            class validateStoredRecord {};
            class validateVehicleRecord {};
            class buildFortifyBudgetRecord {};
            class buildFortifyRecord {};
        };
    };
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class ArgumentsBaseUnits;
        class ModuleDescription;
    };

    class CAMPAIGN_PERSISTENCE_ModulePlayerPersistence: Module_F
    {
        scope = 2;
        displayName = "Player Persistence";
        category = "CAMPAIGN_PERSISTENCE_Modules";
        icon = "iconModule";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        curatorCanAttach = 0;

        class Arguments: ArgumentsBaseUnits
        {
            class cp_enabled
            {
                displayName = "Enable player persistence";
                description = "Master toggle for Campaign Persistence V1 player saves.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_persistPosition
            {
                displayName = "Persist position/location";
                description = "Save and restore player position and facing.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_persistLoadout
            {
                displayName = "Persist loadout";
                description = "Save and restore the player's Arma loadout.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_persistAmmo
            {
                displayName = "Persist ammo / magazine state";
                description = "Only applies when loadout persistence is enabled.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_persistHealth
            {
                displayName = "Persist health / damage";
                description = "Save and restore player damage.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_saveIntervalSeconds
            {
                displayName = "Time between saves (seconds)";
                description = "Autosave interval in seconds. Maximum 300.";
                typeName = "NUMBER";
                defaultValue = "120";
            };
            class cp_enableAceManualSave
            {
                displayName = "Enable ACE manual save action";
                description = "Adds a self-interaction action that requests a server-approved save.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_debugLogging
            {
                displayName = "Enable debug logging";
                description = "Write debug lines to the RPT.";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Required for Campaign Persistence V1 player persistence. Only one module is honored.";
        };
    };

    class CAMPAIGN_PERSISTENCE_ModuleLogisticsPersistence: Module_F
    {
        scope = 2;
        displayName = "Logistics Persistence";
        category = "CAMPAIGN_PERSISTENCE_Modules";
        icon = "iconModule";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        curatorCanAttach = 0;

        class Arguments: ArgumentsBaseUnits
        {
            class cp_logisticsEnabled
            {
                displayName = "Enable logistics persistence";
                description = "Master toggle for Campaign Persistence V2 logistics saves.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsPersistPosition
            {
                displayName = "Persist position/location";
                description = "Save and restore logistics object position and orientation.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsPersistInventory
            {
                displayName = "Persist inventory";
                description = "Save and restore logistics object cargo.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsPersistNestedInventory
            {
                displayName = "Persist nested container inventory";
                description = "Only applies when inventory persistence is enabled.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsPersistDamage
            {
                displayName = "Persist damage";
                description = "Save and restore logistics object damage.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsPersistSupplyState
            {
                displayName = "Persist fuel/water/supply state";
                description = "Save and restore supported logistics supply state.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsIncludeRuntime
            {
                displayName = "Include runtime-spawned logistics objects";
                description = "Allow new logistics objects created during play to be registered and restored.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_logisticsSaveIntervalSeconds
            {
                displayName = "Time between saves (seconds)";
                description = "Autosave interval in seconds. Maximum 300.";
                typeName = "NUMBER";
                defaultValue = "120";
            };
            class cp_logisticsDebugLogging
            {
                displayName = "Enable debug logging";
                description = "Write logistics persistence debug lines to the RPT.";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Required for Campaign Persistence V2 logistics persistence. Only one module is honored.";
        };
    };

    class CAMPAIGN_PERSISTENCE_ModuleVehiclePersistence: Module_F
    {
        scope = 2;
        displayName = "Vehicle Persistence";
        category = "CAMPAIGN_PERSISTENCE_Modules";
        icon = "iconModule";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        curatorCanAttach = 0;

        class Arguments: ArgumentsBaseUnits
        {
            class cp_vehicleEnabled
            {
                displayName = "Enable vehicle persistence";
                description = "Master toggle for Campaign Persistence V3 vehicle saves.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistPosition
            {
                displayName = "Persist position/location";
                description = "Save and restore vehicle position and orientation.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistDamage
            {
                displayName = "Persist damage";
                description = "Save and restore vehicle damage.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistAmmo
            {
                displayName = "Persist vehicle ammo counts";
                description = "Save and restore turret and pylon ammo counts.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistFuel
            {
                displayName = "Persist fuel";
                description = "Save and restore vehicle fuel.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistInventory
            {
                displayName = "Persist inventory";
                description = "Save and restore vehicle cargo.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistNestedInventory
            {
                displayName = "Persist nested container inventory";
                description = "Only applies when inventory persistence is enabled.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehiclePersistServiceCargo
            {
                displayName = "Persist service cargo state";
                description = "Save and restore fuel, ammo, and repair cargo where supported.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehicleIncludeRuntime
            {
                displayName = "Include runtime-spawned vehicles";
                description = "Allow qualifying vehicles created during play to be registered and restored.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_vehicleSaveIntervalSeconds
            {
                displayName = "Time between saves (seconds)";
                description = "Autosave interval in seconds. Maximum 300.";
                typeName = "NUMBER";
                defaultValue = "120";
            };
            class cp_vehicleDebugLogging
            {
                displayName = "Enable debug logging";
                description = "Write vehicle persistence debug lines to the RPT.";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Required for Campaign Persistence V3 vehicle persistence. Only one module is honored.";
        };
    };

    class CAMPAIGN_PERSISTENCE_ModuleFortifyPersistence: Module_F
    {
        scope = 2;
        displayName = "Fortify Persistence";
        category = "CAMPAIGN_PERSISTENCE_Modules";
        icon = "iconModule";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        curatorCanAttach = 0;

        class Arguments: ArgumentsBaseUnits
        {
            class cp_fortifyEnabled
            {
                displayName = "Enable fortify persistence";
                description = "Master toggle for Campaign Persistence V4 ACE Fortify persistence.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_fortifyPersistPosition
            {
                displayName = "Persist position/location";
                description = "Save and restore ACE Fortify object position and orientation.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_fortifyPersistDamage
            {
                displayName = "Persist damage";
                description = "Save and restore ACE Fortify object damage.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_fortifyPersistBudget
            {
                displayName = "Persist remaining side budget";
                description = "Save and restore remaining ACE Fortify budget for active sides.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class cp_fortifySaveIntervalSeconds
            {
                displayName = "Time between saves (seconds)";
                description = "Autosave interval in seconds. Maximum 300.";
                typeName = "NUMBER";
                defaultValue = "120";
            };
            class cp_fortifyDebugLogging
            {
                displayName = "Enable debug logging";
                description = "Write fortify persistence debug lines to the RPT.";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Required for Campaign Persistence V4 ACE Fortify persistence. Only one module is honored.";
        };
    };
};

class Cfg3DEN
{
    class Object
    {
        class AttributeCategories
        {
            class CP_LogisticsPersistenceAttributes
            {
                displayName = "Campaign Persistence";
                collapsed = 1;

                class Attributes
                {
                    class CP_EnableLogisticsPersistence
                    {
                        property = "CP_enableLogisticsPersistence";
                        control = "Checkbox";
                        displayName = "Enable Logistics Persistence";
                        tooltip = "Opt this object into Campaign Persistence V2 even if it would not normally qualify.";
                        expression = "_this setVariable ['CP_enableLogisticsPersistence', _value, true];";
                        defaultValue = "false";
                        typeName = "BOOL";
                        condition = "objectSimulated";
                    };

                    class CP_LogisticsPersistenceId
                    {
                        property = "CP_logisticsPersistenceIdAttribute";
                        control = "EditShort";
                        displayName = "Persistence ID";
                        tooltip = "Optional override for the logistics persistence ID. Leave blank to use the automatic ID.";
                        expression = "_this setVariable ['CP_logisticsPersistenceIdOverride', if (_value isEqualType """") then {trim _value} else {""""}, true];";
                        defaultValue = """""";
                        typeName = "STRING";
                        condition = "objectSimulated";
                    };
                };
            };
        };
    };
};
