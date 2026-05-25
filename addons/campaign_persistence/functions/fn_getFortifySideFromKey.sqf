params [
    ["_key", "", [""]]
];

switch (toLowerANSI _key) do {
    case "west": {west};
    case "east": {east};
    case "resistance": {resistance};
    case "civilian": {civilian};
    default {sideUnknown};
}
