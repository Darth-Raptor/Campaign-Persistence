params [
    ["_method", "", [""]],
    ["_arguments", [], [[]]]
];

if (_method isEqualTo "") exitWith {
    ["ERROR", "Attempted to call backend without a method name."] call CP_fnc_log;
    [false, "invalid_method"]
};

if (isNil "py3_fnc_callExtension") exitWith {
    ["ERROR", "Pythia is unavailable. Campaign Persistence requires the Pythia mod on the server."] call CP_fnc_log;
    [false, "pythia_unavailable"]
};

private _backendCall = format ["CampaignPersistence.%1", _method];
private _result = [_backendCall, _arguments] call py3_fnc_callExtension;
if !(_result isEqualType []) exitWith {
    ["ERROR", "Backend returned an unexpected result.", _result] call CP_fnc_log;
    [false, "invalid_backend_result"]
};

_result
