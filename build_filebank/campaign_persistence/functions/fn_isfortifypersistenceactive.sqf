params [
    ["_config", [], [[]]]
];

if (_config isEqualTo []) then {
    _config = [] call CP_fnc_getFortifyConfig;
};

(_config param [CP_FOR_CFG_MODULE_PRESENT, false]) &&
(_config param [CP_FOR_CFG_ENABLED, false])
