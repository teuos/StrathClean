package com.team17.strathclean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
                + "id INTEGER PRIMARY KEY,"
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
                + "issueId INTEGER PRIMARY KEY,"
                + "userID INTEGER,"
                + "roomID TEXT,"
                + "opened TEXT,"
                + "image BLOB,"
                + "descript TEXT,"
                + "FOREIGN KEY (userID) REFERENCES users(id),"
                + "FOREIGN KEY (roomID) REFERENCES room(roomId)"
                + ")",
                "CREATE TABLE IF NOT EXISTS audit ("
                + "auditID INTEGER PRIMARY KEY,"
                + "roomID TEXT,"
                + "supervisorId INTEGER,"
                + "FOREIGN KEY (roomID) REFERENCES room(roomId),"
                + "FOREIGN KEY (supervisorId) REFERENCES users(id)"
                + ")"
            };

        String debugCommand = "INSERT INTO users (id, fname, lname, email, password, supervisor) VALUES(1, 'andrew', 'fagan', 'andrewfagan@strath.ac.uk', 'IHeartFred', 0)";

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

    public int createIssue(int userId, String roomCode, int floor, String building) {
        String command = "INSERT INTO issues (";

        try (PreparedStatement stmt = conn.prepareStatement(command)) {
            stmt.setString(1, );
            stmt.setString(2, password);
            output = stmt.executeQuery().getInt("id");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }




}
