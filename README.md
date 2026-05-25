# Campaign Persistence

Campaign Persistence is an Arma 3 persistence addon built around server authority and multiplayer safety.

V1 includes player persistence, V2 adds server-authoritative logistics persistence, V3 adds server-authoritative vehicle persistence, and V4 adds server-authoritative ACE Fortify persistence. Each layer only activates when its matching Eden module is placed in the mission. The server is the sole authority for approving saves and restores. Pythia is required for backend storage, and ACE self interaction can expose an optional manual save request flow for players.

## V1 Status

V1 player persistence has been validated in hosted multiplayer testing for:

- position/location restore
- loadout and ammo-state restore
- health, treatment-state, and pain-state restore
- ACE manual save
- timed autosave
- death fallback to the mission's default Eden spawn/state
- server-authoritative save and restore approval

## V1 Features

- Eden-module-gated player persistence
- Per-feature toggles for position, loadout, ammo state, and health
- Server-approved autosave and reconnect restore
- Delete-on-death behavior
- Optional ACE self action:
  - `Campaign Persistence`
  - `Confirm Save`
- Pythia-backed JSON storage in `profiles\CampaignPersistenceData\players`

## V2 Features

- Eden-module-gated `Logistics Persistence`
- Per-feature toggles for position, cargo, nested container cargo, damage, and supply state
- Runtime-spawned logistics object support when enabled
- Editor prop opt-in through object attributes:
  - `Enable Logistics Persistence`
  - `Persistence ID`
- Tombstone handling so deleted or destroyed logistics objects stay gone
- Pythia-backed JSON storage in `profiles\CampaignPersistenceData\logistics`

## V3 Features

- Eden-module-gated `Vehicle Persistence`
- Per-feature toggles for position, damage, fuel, inventory, nested inventory, service cargo, runtime vehicles, and vehicle ammo counts
- Runtime-spawned vehicle persistence when enabled
- AI-crewed runtime vehicles excluded from persistence
- Player-to-vehicle restore linkage when both player and vehicle persistence are active
- Tombstone handling so deleted or destroyed vehicles stay gone
- Pythia-backed JSON storage in `profiles\CampaignPersistenceData\vehicles`

## V4 Features

- Eden-module-gated `Fortify Persistence`
- Persists only objects placed through ACE Fortify
- Per-feature toggles for position, damage, and remaining side budget
- Tombstone handling so deleted or destroyed fortifications stay gone
- Remaining ACE Fortify budget restore for active sides
- Fortify-built objects that qualify for logistics can also participate in `Logistics Persistence`
- Pythia-backed JSON storage in `profiles\CampaignPersistenceData\fortify`

## Mission Setup

1. Load the server and clients with:
   - `@Campaign_Persistence`
   - `Pythia`
   - `ACE3`
2. Pack `addons/campaign_persistence` into `campaign_persistence.pbo`.
3. Place the built PBO in `@Campaign_Persistence\addons`.
4. In Eden, place the `Player Persistence` module.
5. If you want V2 logistics persistence, also place the `Logistics Persistence` module.
6. If you want V3 vehicle persistence, also place the `Vehicle Persistence` module.
7. If you want V4 ACE Fortify persistence, also place the `Fortify Persistence` module.
8. Configure the module attributes for the persistence features you want enabled.
9. For props or normally excluded objects, use the object attributes under `Campaign Persistence` to opt them into logistics persistence when needed.

If no `Player Persistence` module is placed, Campaign Persistence remains inactive.

## Module Attributes

- `Enable player persistence`
- `Persist position/location`
- `Persist loadout`
- `Persist ammo / magazine state`
- `Persist health / damage`
- `Time between saves (seconds)`
- `Enable ACE manual save action`
- `Enable debug logging`

`Persist ammo / magazine state` is ignored when `Persist loadout` is disabled.

## Logistics Module Attributes

- `Enable logistics persistence`
- `Persist position/location`
- `Persist inventory`
- `Persist nested container inventory`
- `Persist damage`
- `Persist fuel/water/supply state`
- `Include runtime-spawned logistics objects`
- `Time between saves (seconds)`
- `Enable debug logging`

`Persist nested container inventory` is ignored when `Persist inventory` is disabled.

## Fortify Module Attributes

- `Enable fortify persistence`
- `Persist position/location`
- `Persist damage`
- `Persist remaining side budget`
- `Time between saves (seconds)`
- `Enable debug logging`

## Server Authority Model

- Clients can only request save/restore actions.
- The server validates the requesting player, owner, module config, and alive state.
- The server is the only side allowed to read or write persistent records.
- The server can request client-local player state when it needs current data for an approved save.
- Restore data is only applied after the server loads and validates the stored record.

## Pythia Layout

Pythia is expected to load the Python entry module at:

```text
@Campaign_Persistence\python_code\__init__.py
@Campaign_Persistence\python_code\$PYTHIA$
```

This matches the official Pythia layout where `python_code` contains the `$PYTHIA$`
marker file plus a root `__init__.py` that exposes the callable functions.

The backend writes durable player records into the server profile directory:

```text
profiles\CampaignPersistenceData\players
profiles\CampaignPersistenceData\logistics
profiles\CampaignPersistenceData\vehicles
profiles\CampaignPersistenceData\fortify
```

## Known Notes

- The `a3_characters_f` mission warning is a known Arma/Bohemia issue and is intentionally ignored here.
- The current Stratis test mission still reports `Missing 'description.ext::Header'`.
- Client and server should use matching CBA versions to avoid version-mismatch warnings in testing.
- Vehicle ammo save-side capture is working, but vehicle ammo restore is not yet reliable enough for release validation. The `Persist vehicle ammo counts` option remains exposed and is currently treated as a known deferred post-release fix.

## Remote Exec

If your mission uses a restrictive `CfgRemoteExec`, allow these functions:

```cpp
class CP_fnc_applyPlayerState { allowedTargets = 1; };
class CP_fnc_clientCollectState { allowedTargets = 1; };
class CP_fnc_notifyClient { allowedTargets = 1; };
class CP_fnc_serverHandleManualSaveRequest { allowedTargets = 2; };
class CP_fnc_serverHandleRestoreRequest { allowedTargets = 2; };
class CP_fnc_serverReceiveCollectedState { allowedTargets = 2; };
```
