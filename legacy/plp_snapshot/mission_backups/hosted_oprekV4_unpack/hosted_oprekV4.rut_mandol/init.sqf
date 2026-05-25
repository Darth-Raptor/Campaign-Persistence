[] call TFO_fnc_acrePreset;
enableEnvironment [false, false];
if (isServer) then {
    {
        if (_x isKindOf "AllVehicles") then {
            _x enableSimulationGlobal false;
        };
    } forEach vehicles;
};
sleep 10;
if (isServer) then {
    {
        if (_x isKindOf "AllVehicles") then {
            _x enableSimulationGlobal true;
        };
    } forEach vehicles;
};
