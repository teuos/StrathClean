"""Seed labeled Livingstone Tower rooms from Google Maps' indoor floor plans."""

import argparse
import re
import sqlite3
from pathlib import Path


BUILDING = "Livingstone Tower"

ROOMS_BY_FLOOR = {
    1: (
        "LT101a", "LT101b", "LT101c", "LT101d", "LT101e", "LT102",
        "LT103a", "LT103b", "LT105", "LT106a", "LT106b", "LT107",
    ),
    2: (
        "LT201", "LT202", "LT203", "LT205", "LT206", "LT212", "LT215",
        "LT217", "LT218", "LT219", "LT220", "LT221a", "LT221b",
    ),
    3: ("LT301a", "LT301b", "LT301c", "LT303", "LT304", "LT313", "LT315"),
    4: (
        "LT401", "LT402", "LT403", "LT404", "LT405", "LT415", "LT416",
        "LT417", "LT418", "LT419", "LT420",
    ),
    5: ("LT501", "LT502", "LT502a", "LT503", "LT504", "LT514", "LT515"),
    6: (
        "LT601", "LT601b", "LT601c", "LT601d", "LT601e", "LT602", "LT602a",
        "LT622", "LT623", "LT624", "LT625", "LT626",
    ),
    7: (
        "LT701", "LT702", "LT703", "LT704", "LT705", "LT706", "LT707",
        "LT708", "LT709", "LT710", "LT722", "LT723", "LT724", "LT725",
        "LT726", "LT727", "LT728", "LT729", "LT730", "LT731", "LT732",
        "LT733",
    ),
    8: (
        "LT801", "LT802", "LT803", "LT804", "LT805", "LT806", "LT807",
        "LT808", "LT809", "LT810", "LT811", "LT812", "LT813", "LT830",
        "LT831", "LT832", "LT833", "LT834", "LT835", "LT836", "LT837",
        "LT838", "LT839",
    ),
    9: (
        "LT901", "LT901c", "LT902", "LT903", "LT904", "LT911", "LT912",
        "LT913", "LT914", "LT915", "LT916", "LT916b",
    ),
    10: (
        "LT1003", "LT1004", "LT1005", "LT1006", "LT1007", "LT1008",
        "LT1009", "LT1010", "LT1011", "LT1012", "LT1013a", "LT1029",
        "LT1030", "LT1031", "LT1032", "LT1033", "LT1034", "LT1035",
        "LT1036", "LT1037", "LT1038", "LT1039", "LT1040", "LT1041",
        "LT1042", "LT1043",
    ),
    11: ("LT1101", "LT1101a", "LT1101b", "LT1101c", "LT1102", "LT1106"),
    12: (
        "LT1201", "LT1202", "LT1203", "LT1204", "LT1205", "LT1206",
        "LT1206a", "LT1207", "LT1215", "LT1216", "LT1217", "LT1218",
        "LT1219", "LT1220", "LT1221",
    ),
    13: (
        "LT1301b", "LT1302", "LT1303", "LT1304", "LT1305", "LT1306",
        "LT1312", "LT1314", "LT1315", "LT1315a", "LT1316", "LT1317",
        "LT1318", "LT1319", "LT1320",
    ),
    14: (
        "LT1401", "LT1402", "LT1402a", "LT1402b", "LT1403", "LT1404",
        "LT1405", "LT1406", "LT1407", "LT1408", "LT1409", "LT1410",
        "LT1411", "LT1418", "LT1420", "LT1421", "LT1422", "LT1423",
        "LT1424", "LT1425", "LT1426", "LT1427", "LT1428", "LT1428a",
        "LT1428b", "LT1428c", "LT1429",
    ),
    15: (
        "LT1502", "LT1503", "LT1504", "LT1506", "LT1508", "LT1509",
        "LT1510", "LT1511", "LT1512", "LT1513", "LT1514", "LT1518",
        "LT1520",
    ),
}


def room_rows() -> list[tuple[str, int, str]]:
    rows = []
    for floor, room_ids in ROOMS_BY_FLOOR.items():
        for room_id in room_ids:
            match = re.fullmatch(r"LT(\d+)[a-z]?", room_id)
            if match is None or int(match.group(1)[:-2]) != floor:
                raise ValueError(f"Room ID does not match floor {floor}: {room_id}")
            rows.append((room_id, floor, BUILDING))
    return rows


def main() -> None:
    parser = argparse.ArgumentParser(description="Seed Livingstone Tower rooms into SQLite.")
    parser.add_argument(
        "--database",
        type=Path,
        default=Path(__file__).resolve().with_name("database.db"),
        help="SQLite database path (default: database.db beside this script)",
    )
    args = parser.parse_args()
    rows = room_rows()

    connection = sqlite3.connect(args.database)
    try:
        with connection:
            connection.execute(
                "CREATE TABLE IF NOT EXISTS room ("
                "roomId TEXT PRIMARY KEY,"
                "floor INTEGER,"
                "building TEXT,"
                "cleanerId INTEGER,"
                "supervisorId INTEGER,"
                "lastCleaned TEXT,"
                "lastAudited TEXT,"
                "FOREIGN KEY (cleanerId) REFERENCES users(id),"
                "FOREIGN KEY (supervisorId) REFERENCES users(id)"
                ")"
            )
            changes_before = connection.total_changes
            connection.executemany(
                "INSERT OR IGNORE INTO room (roomId, floor, building) VALUES (?, ?, ?)",
                rows,
            )
            inserted = connection.total_changes - changes_before
    finally:
        connection.close()

    print(f"Inserted {inserted} of {len(rows)} Livingstone Tower rooms.")


if __name__ == "__main__":
    main()