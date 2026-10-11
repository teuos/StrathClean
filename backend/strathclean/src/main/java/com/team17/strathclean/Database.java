package com.team17.strathclean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Database {

    private Connection conn;

    public Database() {
        try {
            conn = DriverManager.getConnection("jdbc:sqlite:database.db");
            System.out.println("Connection to SQLite has been established.");
        } catch (SQLException e) {
            throw new IllegalStateException("Could not connect to SQLite database", e);
        }

        String[] initCommands = {
            "CREATE TABLE IF NOT EXISTS users ("
                + "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "fname TEXT NOT NULL,"
                + "lname TEXT NOT NULL,"
                + "email TEXT NOT NULL,"
                + "password TEXT NOT NULL,"
                + "supervisor INTEGER NOT NULL DEFAULT 0"
            + ")",
            "CREATE TABLE IF NOT EXISTS room ("
                + "roomId TEXT PRIMARY KEY,"
                + "floor INTEGER,"
                + "building TEXT,"
                + "cleanerId INTEGER,"
                + "supervisorId INTEGER,"
                + "lastCleaned TEXT,"
                + "lastAudited TEXT,"
                + "FOREIGN KEY (cleanerId) REFERENCES users(id),"
                + "FOREIGN KEY (supervisorId) REFERENCES users(id)"
                + ")",
                "CREATE TABLE IF NOT EXISTS issues ("
                + "issueId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "userID INTEGER,"
                + "roomID TEXT,"
                + "opened TEXT,"
                + "image TEXT,"
                + "descript TEXT,"
                + "FOREIGN KEY (userID) REFERENCES users(id),"
                + "FOREIGN KEY (roomID) REFERENCES room(roomId)"
                + ")",
                "CREATE TABLE IF NOT EXISTS audit ("
                + "auditID INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "roomID TEXT,"
                + "supervisorId INTEGER,"
                + "FOREIGN KEY (roomID) REFERENCES room(roomId),"
                + "FOREIGN KEY (supervisorId) REFERENCES users(id)"
                + ")",
                "CREATE TABLE IF NOT EXISTS assigned ("
                + "assignmentID INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "userID INTEGER NOT NULL,"
                + "floor1 INTEGER,"
                + "floor2 INTEGER,"
                + "FOREIGN KEY (userID) REFERENCES users(id)"
                + ")",
                "CREATE TRIGGER IF NOT EXISTS assigned_floors_unique "
                + "BEFORE INSERT ON assigned "
                + "WHEN NEW.floor1 = NEW.floor2 OR EXISTS ("
                + "SELECT 1 FROM assigned "
                + "WHERE floor1 IN (NEW.floor1, NEW.floor2) "
                + "OR floor2 IN (NEW.floor1, NEW.floor2)) "
                + "BEGIN SELECT RAISE(ABORT, 'floor already assigned'); END"

            };

        String debugCommand = "INSERT INTO users (fname, lname, email, password, supervisor) VALUES('andrew', 'fagan', 'andrewfagan@strath.ac.uk', 'IHeartFred', 0)";

        try (Statement stmt = conn.createStatement()) {
            // create the required tables for the application schema
            for (String initCommand : initCommands) {
                stmt.executeUpdate(initCommand);
            }
            stmt.execute(debugCommand);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public String getName(int id){
        String getCommand = "SELECT fname, lname FROM users WHERE id =" + id;
        String output = "";

        try (Statement stmt = conn.createStatement()) {
            output = stmt.executeQuery(getCommand).getString("fname")+ " " + stmt.executeQuery(getCommand).getString("lname"); // i <3 one-liners

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return output;

    }

    public int checkEmail(String email, String password){

        int output = 0;
        String command = "SELECT id FROM users WHERE email = ? AND password = ?";

        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            output = stmt.executeQuery().getInt("id");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return output;
    }

    public boolean createIssue(int userId, String roomCode, String image, int floor, String building, String description) {
        String command = "INSERT INTO issues (userID, roomID, opened, image, descript) VALUES (?, ?, ?, ?, ?)";

        // Get the current date and time
        LocalDateTime now = LocalDateTime.now();

        // Define the format
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        // Format the current date and time
        String formattedNow = now.format(formatter);

        // Print the formatted date and time
        System.out.println("Current Timestamp:" + formattedNow);


        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setInt(1, userId);
            stmt.setString(2, roomCode);
            stmt.setString(3, formattedNow);
            stmt.setString(4, image);
            stmt.setString(5, description);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
        return true;
    }

    public Map<String, Object> getIssue(int issueId) {
        String command = "SELECT issueId, userID, roomID, opened, image, descript FROM issues WHERE issueId = ?";

        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setInt(1, issueId);
            try (ResultSet result = stmt.executeQuery()) {
                if (result.next()) {
                    return mapIssue(result);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return null;
    }

    public List<Map<String, Object>> getAllIssues() {
        String command = "SELECT issueId, userID, roomID, opened, image, descript FROM issues";
        List<Map<String, Object>> issues = new ArrayList<>();

        try (Statement stmt = conn.createStatement(); ResultSet result = stmt.executeQuery(command)) {
            while (result.next()) {
                issues.add(mapIssue(result));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return issues;
    }

    private Map<String, Object> mapIssue(ResultSet result) throws SQLException {
        Map<String, Object> issue = new LinkedHashMap<>();
        issue.put("issueId", result.getInt("issueId"));
        issue.put("userID", result.getInt("userID"));
        issue.put("roomID", result.getString("roomID"));
        issue.put("opened", result.getString("opened"));
        issue.put("image", result.getString("image"));
        issue.put("descript", result.getString("descript"));
        return issue;
    }

    public Map<String, Object> getRoom(String roomId) {
        String command = "SELECT roomId, floor, building, cleanerId, supervisorId, lastCleaned, lastAudited FROM room WHERE roomId = ?";

        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setString(1, roomId);
            try (ResultSet result = stmt.executeQuery()) {
                if (result.next()) {
                    return mapRoom(result);
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return null;
    }

    private Map<String, Object> mapRoom(ResultSet result) {
        Map<String, Object> room = new LinkedHashMap<>();
        try {
            room.put("roomId", result.getString("roomId"));
            room.put("floor", result.getInt("floor"));
            room.put("building", result.getString("building"));
            room.put("cleanerId", result.getInt("cleanerId"));
            room.put("supervisorId", result.getInt("supervisorId"));
            room.put("lastCleaned", result.getString("lastCleaned"));
            room.put("lastAudited", result.getString("lastAudited"));
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return room; 
    }

    public List<Map<String, Object>> getAllRooms() {
        String command = "SELECT roomId, floor, building, cleanerId, supervisorId, lastCleaned, lastAudited FROM room";
        List<Map<String, Object>> rooms = new ArrayList<>();

        try (Statement stmt = conn.createStatement(); ResultSet result = stmt.executeQuery(command)) {
            while (result.next()) {
                rooms.add(mapRoom(result));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return rooms;
    }

    public int[] assignRandomTwoFloors(int userId, int totalFloors) {
        if (totalFloors < 2) {
            return null;
        }

        String availabilityCommand = "SELECT COUNT(DISTINCT floor) FROM ("
            + "SELECT floor1 AS floor FROM assigned UNION ALL "
            + "SELECT floor2 AS floor FROM assigned) WHERE floor BETWEEN 1 AND ?";
        String conflictCommand = "SELECT 1 FROM assigned "
            + "WHERE floor1 IN (?, ?) OR floor2 IN (?, ?) LIMIT 1";
        String insertCommand = "INSERT INTO assigned (userID, floor1, floor2) VALUES (?, ?, ?)";

        try {
            conn.setAutoCommit(false);

            int assignedFloorCount;
            try (PreparedStatement stmt = conn.prepareStatement(availabilityCommand)) {
                stmt.setInt(1, totalFloors);
                try (ResultSet result = stmt.executeQuery()) {
                    result.next();
                    assignedFloorCount = result.getInt(1);
                }
            }
            if (totalFloors - assignedFloorCount < 2) {
                conn.rollback();
                return null;
            }

            try (PreparedStatement conflictStmt = conn.prepareStatement(conflictCommand);
                 PreparedStatement insertStmt = conn.prepareStatement(insertCommand)) {
                while (true) {
                    int floor1 = (int) (Math.random() * totalFloors) + 1;
                    int floor2;
                    do {
                        floor2 = (int) (Math.random() * totalFloors) + 1;
                    } while (floor2 == floor1);

                    conflictStmt.setInt(1, floor1);
                    conflictStmt.setInt(2, floor2);
                    conflictStmt.setInt(3, floor1);
                    conflictStmt.setInt(4, floor2);
                    try (ResultSet conflicts = conflictStmt.executeQuery()) {
                        if (conflicts.next()) {
                            continue;
                        }
                    }

                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, floor1);
                    insertStmt.setInt(3, floor2);
                    insertStmt.executeUpdate();
                    conn.commit();
                    return new int[] {floor1, floor2};
                }
            }
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackError) {
                e.addSuppressed(rollbackError);
            }
            System.out.println(e.getMessage());
            return null;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
    }

    public Map<String, Object> getAssignedFloors(int userId) {
        String command = "SELECT floor1, floor2 FROM assigned WHERE userID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setInt(1, userId);
            try (ResultSet result = stmt.executeQuery()) {
                if (result.next()) {
                    Map<String, Object> assignedFloors = new LinkedHashMap<>();
                    assignedFloors.put("floor1", result.getInt("floor1"));
                    assignedFloors.put("floor2", result.getInt("floor2"));
                    return assignedFloors;
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return null;
    }

    public Map<String, Object> getAssignedRooms(int userId) {
        String assignmentCommand = "SELECT floor1, floor2 FROM assigned WHERE userID = ?";
        String roomsCommand = "SELECT roomId, floor, building FROM room WHERE floor IN ("
            + "SELECT floor1 FROM assigned WHERE userID = ? UNION "
            + "SELECT floor2 FROM assigned WHERE userID = ?) ORDER BY floor, roomId";

        try (PreparedStatement assignmentStmt = conn.prepareStatement(assignmentCommand)) {
            assignmentStmt.setInt(1, userId);
            try (ResultSet assignment = assignmentStmt.executeQuery()) {
                if (!assignment.next()) {
                    return null;
                }

                List<Integer> assignedFloors = new ArrayList<>();
                assignedFloors.add(assignment.getInt("floor1"));
                assignedFloors.add(assignment.getInt("floor2"));

                List<Map<String, Object>> assignedRooms = new ArrayList<>();
                try (PreparedStatement roomsStmt = conn.prepareStatement(roomsCommand)) {
                    roomsStmt.setInt(1, userId);
                    roomsStmt.setInt(2, userId);
                    try (ResultSet result = roomsStmt.executeQuery()) {
                        while (result.next()) {
                            Map<String, Object> room = new LinkedHashMap<>();
                            room.put("roomId", result.getString("roomId"));
                            room.put("floor", result.getInt("floor"));
                            room.put("building", result.getString("building"));
                            assignedRooms.add(room);
                        }
                    }
                }

                Map<String, Object> response = new LinkedHashMap<>();
                response.put("assignedFloors", assignedFloors);
                response.put("assignedRooms", assignedRooms);
                return response;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return null;
    }



}
