package com.team17.strathclean;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import kong.unirest.json.JSONObject;


@RestController
public class ApiController {

    private Database db = new Database(); //connects to database

    @GetMapping("/getName")
    public String getName(@RequestHeader int id) {
        JSONObject response = new JSONObject();
        String name = db.getName(id);

        response.put("name", name);

        return response.toString();
    }

    @GetMapping("/login")
    public ResponseEntity<String> login( @RequestParam String email, @RequestParam String password) {
        int id = db.checkEmail(email, password);

        if (id < 1) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        JSONObject response = new JSONObject();
        response.put("id", id);
        return ResponseEntity.ok(response.toString());
    }

    @PostMapping("/createIssue")
    public ResponseEntity<String> createIssue(
            @RequestHeader int userId,
            @RequestParam String roomCode,
            @RequestParam String image,
            @RequestParam int floor,
            @RequestParam String building,
            @RequestParam String description) {
            
        boolean success = db.createIssue(userId, roomCode, image, floor, building, description);
        if (success) {
            return ResponseEntity.ok("Issue created successfully");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to create issue");
        }
    }
}
