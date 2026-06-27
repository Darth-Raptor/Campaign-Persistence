CP_CFG_MODULE_PRESENT = 0;
CP_CFG_ENABLED = 1;
CP_CFG_PERSIST_POSITION = 2;
CP_CFG_PERSIST_LOADOUT = 3;
CP_CFG_PERSIST_AMMO = 4;
CP_CFG_PERSIST_HEALTH = 5;
CP_CFG_SAVE_INTERVAL = 6;
CP_CFG_ACE_MANUAL_SAVE = 7;
CP_CFG_DEBUG = 8;

CP_LOG_CFG_MODULE_PRESENT = 0;
CP_LOG_CFG_ENABLED = 1;
CP_LOG_CFG_PERSIST_POSITION = 2;
CP_LOG_CFG_PERSIST_INVENTORY = 3;
CP_LOG_CFG_PERSIST_NESTED = 4;
CP_LOG_CFG_PERSIST_DAMAGE = 5;
CP_LOG_CFG_PERSIST_SUPPLY = 6;
CP_LOG_CFG_INCLUDE_RUNTIME = 7;
CP_LOG_CFG_SAVE_INTERVAL = 8;
CP_LOG_CFG_DEBUG = 9;

CP_VEH_CFG_MODULE_PRESENT = 0;
CP_VEH_CFG_ENABLED = 1;
CP_VEH_CFG_PERSIST_POSITION = 2;
CP_VEH_CFG_PERSIST_DAMAGE = 3;
CP_VEH_CFG_PERSIST_AMMO = 4;
CP_VEH_CFG_PERSIST_FUEL = 5;
CP_VEH_CFG_PERSIST_INVENTORY = 6;
CP_VEH_CFG_PERSIST_NESTED = 7;
CP_VEH_CFG_PERSIST_SERVICE = 8;
CP_VEH_CFG_INCLUDE_RUNTIME = 9;
CP_VEH_CFG_SAVE_INTERVAL = 10;
CP_VEH_CFG_DEBUG = 11;

CP_FOR_CFG_MODULE_PRESENT = 0;
CP_FOR_CFG_ENABLED = 1;
CP_FOR_CFG_PERSIST_POSITION = 2;
CP_FOR_CFG_PERSIST_DAMAGE = 3;
CP_FOR_CFG_PERSIST_BUDGET = 4;
CP_FOR_CFG_SAVE_INTERVAL = 5;
CP_FOR_CFG_DEBUG = 6;

CP_RECORD_SCHEMA_VERSION = 1;
CP_RECORD_UID = 1;
CP_RECORD_MISSION_KEY = 2;
CP_RECORD_HAS_POSITION = 3;
CP_RECORD_POS_ASL = 4;
CP_RECORD_DIR = 5;
CP_RECORD_HAS_LOADOUT = 6;
CP_RECORD_HAS_AMMO = 7;
CP_RECORD_LOADOUT = 8;
CP_RECORD_HAS_HEALTH = 9;
CP_RECORD_DAMAGE = 10;
CP_RECORD_LAST_WRITE = 11;
CP_RECORD_VEHICLE_ID = 12;
CP_RECORD_VEHICLE_ROLE = 13;

CP_LOG_RECORD_SCHEMA_VERSION = 1;
CP_LOG_RECORD_TYPE = 1;
CP_LOG_RECORD_ID = 2;
CP_LOG_RECORD_MISSION_KEY = 3;
CP_LOG_RECORD_CLASS = 4;
CP_LOG_RECORD_DELETED = 5;
CP_LOG_RECORD_CATEGORY = 6;
CP_LOG_RECORD_HAS_POSITION = 7;
CP_LOG_RECORD_POS_ASL = 8;
CP_LOG_RECORD_DIR = 9;
CP_LOG_RECORD_VECTOR_UP = 10;
CP_LOG_RECORD_HAS_INVENTORY = 11;
CP_LOG_RECORD_CARGO = 12;
CP_LOG_RECORD_HAS_DAMAGE = 13;
CP_LOG_RECORD_DAMAGE = 14;
CP_LOG_RECORD_HAS_SUPPLY = 15;
CP_LOG_RECORD_SUPPLY = 16;
CP_LOG_RECORD_LAST_WRITE = 17;

CP_VEH_RECORD_SCHEMA_VERSION = 1;
CP_VEH_RECORD_TYPE = 1;
CP_VEH_RECORD_ID = 2;
CP_VEH_RECORD_MISSION_KEY = 3;
CP_VEH_RECORD_CLASS = 4;
CP_VEH_RECORD_DELETED = 5;
CP_VEH_RECORD_CATEGORY = 6;
CP_VEH_RECORD_HAS_POSITION = 7;
CP_VEH_RECORD_POS_ASL = 8;
CP_VEH_RECORD_DIR = 9;
CP_VEH_RECORD_VECTOR_UP = 10;
CP_VEH_RECORD_HAS_DAMAGE = 11;
CP_VEH_RECORD_DAMAGE = 12;
CP_VEH_RECORD_HAS_AMMO = 13;
CP_VEH_RECORD_AMMO = 14;
CP_VEH_RECORD_HAS_FUEL = 15;
CP_VEH_RECORD_FUEL = 16;
CP_VEH_RECORD_HAS_INVENTORY = 17;
CP_VEH_RECORD_CARGO = 18;
CP_VEH_RECORD_HAS_SERVICE = 19;
CP_VEH_RECORD_SERVICE = 20;
CP_VEH_RECORD_LAST_WRITE = 21;

CP_FOR_RECORD_SCHEMA_VERSION = 1;
CP_FOR_RECORD_TYPE = 1;
CP_FOR_RECORD_ID = 2;
CP_FOR_RECORD_MISSION_KEY = 3;
CP_FOR_RECORD_CLASS = 4;
CP_FOR_RECORD_DELETED = 5;
CP_FOR_RECORD_SIDE = 6;
CP_FOR_RECORD_COST = 7;
CP_FOR_RECORD_HAS_POSITION = 8;
CP_FOR_RECORD_POS_ASL = 9;
CP_FOR_RECORD_DIR = 10;
CP_FOR_RECORD_VECTOR_UP = 11;
CP_FOR_RECORD_HAS_DAMAGE = 12;
CP_FOR_RECORD_DAMAGE = 13;
CP_FOR_RECORD_LAST_WRITE = 14;

CP_FOR_BUD_RECORD_SCHEMA_VERSION = 1;
CP_FOR_BUD_RECORD_TYPE = 1;
CP_FOR_BUD_RECORD_MISSION_KEY = 2;
CP_FOR_BUD_RECORD_BUDGETS = 3;
CP_FOR_BUD_RECORD_LAST_WRITE = 4;

missionNamespace setVariable ["CP_defaultSaveInterval", 120];
missionNamespace setVariable ["CP_maxSaveInterval", 300];
missionNamespace setVariable ["CP_requestTimeout", 15];
missionNamespace setVariable ["CP_vehicleStartupSimulationDelay", 10];

if (isNil "CP_serverConfig") then {
    CP_serverConfig = [false, false, false, false, false, false, 120, false, false];
};

if (isNil "CP_serverConfigInitialized") then {
    CP_serverConfigInitialized = false;
};

if (isNil "CP_logisticsConfig") then {
    CP_logisticsConfig = [false, false, false, false, false, false, false, false, 120, false];
};

if (isNil "CP_logisticsConfigInitialized") then {
    CP_logisticsConfigInitialized = false;
};

if (isNil "CP_vehicleConfig") then {
    CP_vehicleConfig = [false, false, false, false, false, false, false, false, false, false, 120, false];
};

if (isNil "CP_vehicleConfigInitialized") then {
    CP_vehicleConfigInitialized = false;
};

if (isNil "CP_fortifyConfig") then {
    CP_fortifyConfig = [false, false, false, false, false, 120, false];
};

if (isNil "CP_fortifyConfigInitialized") then {
    CP_fortifyConfigInitialized = false;
};

if (isNil "CP_pendingRequests") then {
    CP_pendingRequests = createHashMap;
};

if (isNil "CP_aceActionsRegistered") then {
    CP_aceActionsRegistered = false;
};

if (isNil "CP_serverInitStarted") then {
    CP_serverInitStarted = false;
};

if (isNil "CP_serverInitCompleted") then {
    CP_serverInitCompleted = false;
};

if (isNil "CP_fortifyEventHandlersRegistered") then {
    CP_fortifyEventHandlersRegistered = false;
};

if (isNil "CP_fortifyTrackedSides") then {
    CP_fortifyTrackedSides = [];
};

if (isNil "CP_runtimeMissionId") then {
    CP_runtimeMissionId = "";
};
