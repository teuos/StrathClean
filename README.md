# Information

This is a mirror of a private repository for our StrathHack26 challenge, this mirror has had some of the original files redacted due to the contents being internal to the university of strathclyde.

# Strath Clean: Supporting Cleaning

Challenge set by Computer & Information Sciences, University of Strathclyde.

Build a mobile app that helps the university's cleaning supervisors audit rooms and lets cleaning staff report building issues. It replaces the iPad audit app the team uses today, which needs a lot of manual data entry.

Start with the specification, then the slides.

## Key requirements

- Written in **Flutter**, with a **relational database** backend.
- Runs on a mobile phone or an iPad.
- Finds a room quickly using GPS with a floor number, a QR code on the door, or both.
- Cleaner schedules can be uploaded, so supervisors know when each room was last cleaned.
- Supervisors get a random selection of recently cleaned rooms to audit, which can be filtered by cleaner, building, floor or previous issues.
- Rooms pass by default. A failure asks for more detail: the object or area, common tags or text, and how significant it is.
- Cleaners and supervisors can record infrastructure issues such as PAT testing, cupboard locks, cupboard stock and damaged furniture.
- Photos of issues are optional.
