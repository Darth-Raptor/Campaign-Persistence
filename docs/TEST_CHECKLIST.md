# Campaign Persistence V1 Test Checklist

## Mission Disabled

1. Launch Arma 3 with `@Campaign_Persistence`, `Pythia`, and `ACE3`.
2. Open a mission in Eden without placing the `Player Persistence` module.
3. Start the mission.
4. Confirm no restore occurs and no ACE save action appears.

## Mission Enabled

1. Place the `Player Persistence` module.
2. Enable the persistence features you want to test.
3. Set `Time between saves (seconds)` to a short value such as `30`.
4. Start the mission and move the player.
5. If loadout persistence is enabled, modify gear and partially expend ammunition.
6. If health persistence is enabled, take damage.
7. Wait for an autosave or trigger `Campaign Persistence -> Confirm Save` through ACE self interaction.
8. Disconnect and reconnect.
9. Confirm only the enabled fields restore.

## Death Handling

1. Create a valid save.
2. Die before disconnecting.
3. Reconnect or restart the server.
4. Confirm the saved player record was deleted and the player starts fresh.

## Restart Validation

1. Create a valid save.
2. Fully restart the dedicated server.
3. Rejoin with the same UID.
4. Confirm restore still works from the Pythia-backed store.

## Verified V1 Results

- Position/location restore has been validated.
- Loadout and ammo-state restore has been validated.
- Health/damage, treatment, and pain-state restore have been validated.
- Manual ACE save has been validated.
- Autosave has been validated.
- Disconnecting while dead correctly falls back to the default Eden state instead of the previous saved record.

## Security Checks

1. Confirm the server logs owner/UID mismatch warnings for malformed remote requests.
2. Confirm a client cannot trigger a save for another player.
3. Confirm manual save does nothing when the module disables ACE manual save.

## V2 Logistics Checks

1. Place the `Logistics Persistence` module and enable the fields you want to test.
2. Move an editor-placed ammo crate, save, restart, and confirm its position restores.
3. Change crate cargo, including a nested backpack, save, restart, and confirm the nested contents restore.
4. Damage a persisted logistics object, save, restart, and confirm the damage state restores.
5. Test a supported fuel or water logistics object and confirm its supply state restores.
6. Spawn a qualifying runtime logistics object when runtime persistence is enabled, save, restart, and confirm it is recreated.
7. Delete or destroy a persisted logistics object, save or wait for autosave, restart, and confirm the object stays gone.
8. Opt a normally excluded prop into persistence with `Enable Logistics Persistence`, optionally set `Persistence ID`, and confirm it restores through the logistics layer.

## V3 Vehicle Checks

1. Place the `Vehicle Persistence` module and enable the fields you want to test.
2. Move and save an editor-placed vehicle, restart, and confirm its position restores.
3. Damage a persisted vehicle, save, restart, and confirm the damage state restores.
4. Change vehicle fuel, save, restart, and confirm the fuel state restores.
5. Change vehicle transport cargo, including nested container cargo when enabled, save, restart, and confirm the cargo restores.
6. Spawn a qualifying runtime vehicle when runtime persistence is enabled, save, restart, and confirm it is recreated.
7. Spawn a runtime vehicle with AI already inside it and confirm it is excluded from persistence.
8. Delete or destroy a persisted vehicle, save or wait for autosave, restart, and confirm the vehicle stays gone.
9. Save a player while seated in a persisted vehicle, restart, and confirm the player restores back into the vehicle when both records are valid.

## Known V3 Release Limitation

- Vehicle damage persistence has been validated.
- Vehicle ammo save-side capture has been validated.
- Vehicle ammo restore is still a known deferred issue and should be treated as post-release follow-up work.

## V4 Fortify Checks

1. Place the `Fortify Persistence` module and configure the fields you want to test.
2. Use ACE Fortify to place a fortification, save, restart, and confirm it restores in the correct location and orientation.
3. Damage a Fortify-built object, save, restart, and confirm the damage restores when enabled.
4. Spend Fortify budget, save, restart, and confirm the remaining budget restores.
5. Delete or destroy a Fortify-built object, save or wait for autosave, restart, and confirm it stays gone.
6. Build a Fortify object that also qualifies for logistics cargo, add cargo, save, restart, and confirm the object restores through Fortify while cargo restores through Logistics without duplication.
