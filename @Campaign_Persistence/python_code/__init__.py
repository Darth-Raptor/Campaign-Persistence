from __future__ import annotations

import hashlib
import json
from pathlib import Path
from tempfile import NamedTemporaryFile


def _safe_name(value: str) -> str:
    safe_value = "".join(ch for ch in value if ch.isalnum() or ch in ("-", "_"))
    if safe_value:
        return safe_value
    return hashlib.sha1(value.encode("utf-8")).hexdigest()


def _profile_root(category: str) -> Path:
    profile_root = Path.cwd() / "CampaignPersistenceData" / category
    profile_root.mkdir(parents=True, exist_ok=True)
    return profile_root


def _mission_directory(category: str, mission_key: str) -> Path:
    mission_hash = hashlib.sha1(mission_key.encode("utf-8")).hexdigest()
    path = _profile_root(category) / mission_hash
    path.mkdir(parents=True, exist_ok=True)
    return path


def _player_path(uid: str, mission_key: str) -> Path:
    return _mission_directory("players", mission_key) / f"{_safe_name(uid)}.json"


def _logistics_path(logistics_id: str, mission_key: str) -> Path:
    return _mission_directory("logistics", mission_key) / f"{_safe_name(logistics_id)}.json"


def _vehicle_path(vehicle_id: str, mission_key: str) -> Path:
    return _mission_directory("vehicles", mission_key) / f"{_safe_name(vehicle_id)}.json"


def _fortify_object_path(object_id: str, mission_key: str) -> Path:
    return _mission_directory("fortify", mission_key) / f"{_safe_name(object_id)}.json"


def _fortify_budget_path(mission_key: str) -> Path:
    return _mission_directory("fortify", mission_key) / "fortify_budget.json"


def _write_json(path: Path, payload: dict):
    with NamedTemporaryFile("w", encoding="utf-8", delete=False, dir=str(path.parent), suffix=".tmp") as handle:
        json.dump(payload, handle, ensure_ascii=True, indent=2)
        temp_path = Path(handle.name)

    temp_path.replace(path)


def save_player(uid: str, mission_key: str, record_payload: str):
    try:
        path = _player_path(uid, mission_key)
        payload = {
            "uid": uid,
            "mission_key": mission_key,
            "record_payload": record_payload,
        }

        _write_json(path, payload)
        return [True, ""]
    except Exception as exc:  # pragma: no cover
        return [False, str(exc)]


def load_player(uid: str, mission_key: str):
    try:
        path = _player_path(uid, mission_key)
        if not path.exists():
            return [True, False, "", ""]

        payload = json.loads(path.read_text(encoding="utf-8"))
        return [True, True, payload.get("record_payload", ""), ""]
    except Exception as exc:  # pragma: no cover
        return [False, False, "", str(exc)]


def delete_player(uid: str, mission_key: str):
    try:
        path = _player_path(uid, mission_key)
        existed = path.exists()
        if existed:
            path.unlink()
        return [True, existed, ""]
    except Exception as exc:  # pragma: no cover
        return [False, False, str(exc)]


def save_logistics(logistics_id: str, mission_key: str, record_payload: str):
    try:
        path = _logistics_path(logistics_id, mission_key)
        payload = {
            "id": logistics_id,
            "mission_key": mission_key,
            "record_payload": record_payload,
        }

        _write_json(path, payload)
        return [True, ""]
    except Exception as exc:  # pragma: no cover
        return [False, str(exc)]


def load_logistics(mission_key: str):
    try:
        path = _mission_directory("logistics", mission_key)
        payloads = []

        for file_path in sorted(path.glob("*.json")):
            payload = json.loads(file_path.read_text(encoding="utf-8"))
            payloads.append(payload.get("record_payload", ""))

        return [True, payloads, ""]
    except Exception as exc:  # pragma: no cover
        return [False, [], str(exc)]


def save_vehicle(vehicle_id: str, mission_key: str, record_payload: str):
    try:
        path = _vehicle_path(vehicle_id, mission_key)
        payload = {
            "id": vehicle_id,
            "mission_key": mission_key,
            "record_payload": record_payload,
        }

        _write_json(path, payload)
        return [True, ""]
    except Exception as exc:  # pragma: no cover
        return [False, str(exc)]


def load_vehicles(mission_key: str):
    try:
        path = _mission_directory("vehicles", mission_key)
        payloads = []

        for file_path in sorted(path.glob("*.json")):
            payload = json.loads(file_path.read_text(encoding="utf-8"))
            payloads.append(payload.get("record_payload", ""))

        return [True, payloads, ""]
    except Exception as exc:  # pragma: no cover
        return [False, [], str(exc)]


def save_fortify_object(object_id: str, mission_key: str, record_payload: str):
    try:
        path = _fortify_object_path(object_id, mission_key)
        payload = {
            "id": object_id,
            "mission_key": mission_key,
            "record_payload": record_payload,
        }

        _write_json(path, payload)
        return [True, ""]
    except Exception as exc:  # pragma: no cover
        return [False, str(exc)]


def load_fortify_objects(mission_key: str):
    try:
        path = _mission_directory("fortify", mission_key)
        payloads = []

        for file_path in sorted(path.glob("*.json")):
            if file_path.name == "fortify_budget.json":
                continue
            payload = json.loads(file_path.read_text(encoding="utf-8"))
            payloads.append(payload.get("record_payload", ""))

        return [True, payloads, ""]
    except Exception as exc:  # pragma: no cover
        return [False, [], str(exc)]


def save_fortify_budget(mission_key: str, record_payload: str):
    try:
        path = _fortify_budget_path(mission_key)
        payload = {
            "mission_key": mission_key,
            "record_payload": record_payload,
        }

        _write_json(path, payload)
        return [True, ""]
    except Exception as exc:  # pragma: no cover
        return [False, str(exc)]


def load_fortify_budget(mission_key: str):
    try:
        path = _fortify_budget_path(mission_key)
        if not path.exists():
            return [True, False, "", ""]

        payload = json.loads(path.read_text(encoding="utf-8"))
        return [True, True, payload.get("record_payload", ""), ""]
    except Exception as exc:  # pragma: no cover
        return [False, False, "", str(exc)]
