# Build Notes

Pack `addons/campaign_persistence` into `campaign_persistence.pbo`, then place the output in:

```text
C:\Users\JustF\Documents\New project 2\@Campaign_Persistence\addons\campaign_persistence.pbo
```

Keep the Python package directory in the mod root as:

```text
@Campaign_Persistence\python_code\$PYTHIA$
@Campaign_Persistence\python_code\__init__.py
```

The runtime persistence data directory is created automatically:

```text
profiles\CampaignPersistenceData\players
profiles\CampaignPersistenceData\logistics
profiles\CampaignPersistenceData\vehicles
profiles\CampaignPersistenceData\fortify
```

## Current Cleanup Notes

- Ignore the known `a3_characters_f` warning from Arma itself.
- The current Stratis test mission still needs a mission-source-side `description.ext::Header` cleanup if you want a warning-free mission package.
- Keep client and server CBA versions matched during testing to avoid version-mismatch warnings in the RPT.
- `Logistics Persistence` is fully server-side. No client remote execution path was added for logistics saves or restores.
- Keep `persistent = 0;` in the server config for the current local test workflow.
- `Vehicle Persistence` is release-ready except for vehicle ammo restore, which remains a known deferred post-release fix.
- `Fortify Persistence` assumes ACE Fortify presets, tools, and build-area rules are already configured by the mission or server; Campaign Persistence only persists the runtime Fortify state.
