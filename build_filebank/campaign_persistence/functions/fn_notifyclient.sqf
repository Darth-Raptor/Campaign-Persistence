params [
    ["_message", "", [""]]
];

if (!hasInterface) exitWith {};
if (_message isEqualTo "") exitWith {};

systemChat _message;
