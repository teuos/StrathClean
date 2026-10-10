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
                "CREATE TABLE issues ("
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
                + ")"
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


}
