params [
    ["_config", [], [[]]]
];

if (_config isEqualTo []) then {
    _config = [] call CP_fnc_getLogisticsConfig;
};

(_config param [CP_LOG_CFG_MODULE_PRESENT, false]) && (_config param [CP_LOG_CFG_ENABLED, false])
