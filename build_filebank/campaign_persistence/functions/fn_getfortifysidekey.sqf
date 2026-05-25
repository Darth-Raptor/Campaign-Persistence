params [
    ["_side", sideUnknown, [sideUnknown]]
];

switch (_side) do {
    case west: {"west"};
    case east: {"east"};
    case resistance: {"resistance"};
    case civilian: {"civilian"};
    default {"unknown"};
}
