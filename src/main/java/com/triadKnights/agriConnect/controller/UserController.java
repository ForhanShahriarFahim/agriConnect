package com.triadKnights.agriConnect.controller;

import com.triadKnights.agriConnect.model.Role;
import com.triadKnights.agriConnect.model.User;
import com.triadKnights.agriConnect.repository.UserRepository;
import com.triadKnights.agriConnect.service.JwtService;
import com.triadKnights.agriConnect.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class UserController {

    @Autowired
    private UserService service;

    @Autowired
    private JwtService jwtService;

    @Autowired
    AuthenticationManager authenticationManager;

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }
    @PostMapping("registerForm")
    public String register(@ModelAttribute User user) {
        try {
            Role userRole = Role.valueOf(user.getRole().name());  // Ensure valid enum conversion
            user.setRole(userRole);
        } catch (IllegalArgumentException e) {
            user.setRole(Role.FARMER);  // Assign a default role if invalid
        }
        System.out.println("Role received: " + user.getRole());
        service.saveUser(user);
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
//    @PostMapping("/loginForm")
//    public String login(@RequestParam String username, @RequestParam String password, Model model) {
//        Authentication authentication = authenticationManager
//                .authenticate(new UsernamePasswordAuthenticationToken(username, password));
//
//        if (authentication.isAuthenticated()) {
//            String token = jwtService.generateToken(username);
//            model.addAttribute("token", token);
//            return "redirect:/"; // Redirect to the dashboard or home page
//        } else {
//            model.addAttribute("error", "Invalid username or password");
//            return "login"; // Stay on the login page if authentication fails
//        }
//    }

    @PostMapping("/loginForm")
    public String login(@RequestParam String username, @RequestParam String password, Model model, HttpServletResponse response, HttpSession session) {
        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(username, password));

        if (authentication.isAuthenticated()) {
            String token = jwtService.generateToken(username);
            session.setAttribute("loggedInUser", username);
            // Create a secure HTTP-only cookie for JWT
            Cookie jwtCookie = new Cookie("jwt", token);
            jwtCookie.setHttpOnly(true);  // Prevent access from JavaScript
            jwtCookie.setSecure(true);    // Enable for HTTPS
            jwtCookie.setPath("/");       // Available across all pages
            jwtCookie.setMaxAge(60 * 60); // Expire in 1 hour (same as JWT expiration)
            response.addCookie(jwtCookie); // Add cookie to response

            return "redirect:/"; // Redirect to home page
        } else {
            model.addAttribute("error", "Invalid username or password");
            return "login"; // Stay on the login page if authentication fails
        }
    }

//    @GetMapping("/logout")
//    public String logout(HttpServletResponse response) {
//        Cookie jwtCookie = new Cookie("jwt", null);
//        jwtCookie.setHttpOnly(true);
//        jwtCookie.setSecure(true);
//        jwtCookie.setPath("/");
//        jwtCookie.setMaxAge(0); // Deletes the cookie
//        response.addCookie(jwtCookie);
//        return "redirect:/login";
//    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        // Invalidate the session
        session.removeAttribute("loggedInUser");

        // Clear the JWT cookie by setting its max age to 0
        Cookie jwtCookie = new Cookie("jwt", null);
        jwtCookie.setPath("/");
        jwtCookie.setHttpOnly(true);
        jwtCookie.setSecure(true);  // true if using HTTPS
        jwtCookie.setMaxAge(0);     // Delete the cookie immediately
        response.addCookie(jwtCookie);

        return "redirect:/login";   // Redirect to login page after logout
    }


}
