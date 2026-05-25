params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {""};

private _override = _object getVariable ["CP_vehiclePersistenceIdOverride", ""];
if !(_override isEqualType "") then {
    _override = "";
} else {
    _override = trim _override;
    if ((toLowerANSI _override) in ["true", "false"]) then {
        _override = "";
    };
};
if (_override isNotEqualTo "") exitWith {_override};

private _pos = getPosWorld _object;
private _dir = round (getDir _object);
format [
    "%1:%2:%3:%4",
    typeOf _object,
    round ((_pos select 0) * 100),
    round ((_pos select 1) * 100),
    _dir
]
