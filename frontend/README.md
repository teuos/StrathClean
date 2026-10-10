# Strath Clean: Supporting Cleaning

Challenge set by Computer & Information Sciences, University of Strathclyde.

Build a mobile app that helps the university's cleaning supervisors audit rooms and lets cleaning staff report building issues. It replaces the iPad audit app the team uses today, which needs a lot of manual data entry.

Start with the specification, then the slides.

## What is in the `brief` folder

| File | What it is |
|---|---|
| `StrathClean-Specification.pdf` | The challenge on one page: who uses the app and what it must do |
| `StrathClean-Slides.pdf` | The challenge slides: problems with the current app, what the new app should do, photos of the current app and an example building floor plan |
| `Example-Cleaner-Schedules.pdf` | Four real weekly cleaner schedules (scanned), showing the rooms and tasks each day |

## Key requirements

- Written in **Flutter**, with a **relational database** backend.
- Runs on a mobile phone or an iPad.
- Finds a room quickly using GPS with a floor number, a QR code on the door, or both.
- Cleaner schedules can be uploaded, so supervisors know when each room was last cleaned.
- Supervisors get a random selection of recently cleaned rooms to audit, which can be filtered by cleaner, building, floor or previous issues.
- Rooms pass by default. A failure asks for more detail: the object or area, common tags or text, and how significant it is.
- Cleaners and supervisors can record infrastructure issues such as PAT testing, cupboard locks, cupboard stock and damaged furniture.
- Photos of issues are optional.

## Things to know

- The schedules and the floor plan are scans and pictures, not data. You will need to create your own sample data for buildings, rooms and schedules. The supplied files show what real data looks like.
- These documents are internal to the university. Keep your repository private.
