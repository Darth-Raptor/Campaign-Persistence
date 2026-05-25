params [
    ["_config", [], [[]]]
];

if (_config isEqualTo []) then {
    _config = [] call CP_fnc_getVehicleConfig;
};

(_config param [CP_VEH_CFG_MODULE_PRESENT, false]) && (_config param [CP_VEH_CFG_ENABLED, false])
