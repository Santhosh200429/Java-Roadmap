# Spring Boot Security: Protecting Your APIs

## What is Security?

**Security** protects your application from unauthorized access and malicious attacks.

**Real-world analogy**: Security is like a locked door with a keycard system - only authorized people get access.

## Core Security Concepts

### Authentication vs Authorization

```
Authentication (Who are you?)
- Username/Password login
- OAuth tokens
- API keys

Authorization (What can you do?)
- User can view own profile
- Admin can delete users
- Guest can only read public data
```

## Spring Security Dependencies

Add to `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- For JWT tokens -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.11.5</version>
</dependency>
```

## Basic Authentication

### Simple HTTP Basic Auth

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/public/**").permitAll()  // No auth required
                .requestMatchers("/admin/**").hasRole("ADMIN")  // Admin only
                .anyRequest().authenticated()  // Everything else needs login
            )
            .httpBasic();  // Username/password in request header
        
        return http.build();
    }
}
```

### Controller with Security

```java
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

@RestController
@RequestMapping("/api")
public class UserController {
    
    // Public endpoint
    @GetMapping("/public/info")
    public String publicInfo() {
        return "Everyone can see this";
    }
    
    // Protected endpoint - any authenticated user
    @GetMapping("/profile")
    public String getProfile(Authentication auth) {
        return "Hello, " + auth.getName();
    }
    
    // Admin only
    @DeleteMapping("/users/{id}")
    public String deleteUser(@PathVariable Long id) {
        return "User deleted";
    }
}
```

## User Authentication

### In-Memory Users (Testing)

```java
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

@Configuration
public class SecurityConfig {
    
    @Bean
    public InMemoryUserDetailsManager userDetailsService() {
        // Create users with roles
        UserDetails user1 = User.builder()
            .username("alice")
            .password(passwordEncoder().encode("password123"))
            .roles("USER")
            .build();
        
        UserDetails admin = User.builder()
            .username("admin")
            .password(passwordEncoder().encode("admin123"))
            .roles("ADMIN", "USER")
            .build();
        
        return new InMemoryUserDetailsManager(user1, admin);
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### Database Users

```java
import org.springframework.data.jpa.repository.JpaRepository;

// User entity
@Entity
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String username;
    
    private String password;  // Encrypted
    
    private String roles;  // "ADMIN,USER"
}

// User repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}

// Custom UserDetailsService
@Service
public class CustomUserDetailsService implements UserDetailsService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public UserDetails loadUserByUsername(String username) 
            throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        
        return org.springframework.security.core.userdetails.User.builder()
            .username(user.getUsername())
            .password(user.getPassword())
            .roles(user.getRoles().split(","))
            .build();
    }
}
```

## JWT Token Authentication

### Generate JWT Token

```java
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;

@Component
public class JwtTokenProvider {
    
    @Value("${app.jwtSecret}")
    private String jwtSecret;
    
    @Value("${app.jwtExpirationMs:86400000}")  // 24 hours
    private int jwtExpirationMs;
    
    // Create token
    public String generateToken(String username) {
        return Jwts.builder()
            .setSubject(username)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
            .signWith(SignatureAlgorithm.HS512, jwtSecret)
            .compact();
    }
    
    // Get username from token
    public String getUsernameFromToken(String token) {
        return Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
    
    // Validate token
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
```

### Login Endpoint

```java
@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        Authentication auth = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                loginRequest.getUsername(),
                loginRequest.getPassword()
            )
        );
        
        String token = tokenProvider.generateToken(auth.getName());
        return ResponseEntity.ok(new LoginResponse(token));
    }
}

// Request/Response DTOs
@Data
class LoginRequest {
    private String username;
    private String password;
}

@Data
class LoginResponse {
    private String token;
    
    public LoginResponse(String token) {
        this.token = token;
    }
}
```

### JWT Filter

```java
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtTokenFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @Autowired
    private CustomUserDetailsService userDetailsService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {
        
        // Extract token from "Authorization: Bearer token"
        String token = extractToken(request);
        
        if (token != null && tokenProvider.validateToken(token)) {
            String username = tokenProvider.getUsernameFromToken(token);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            
            // Create authentication
            UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities()
                );
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        
        filterChain.doFilter(request, response);
    }
    
    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}

// Register filter
@Configuration
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                          JwtTokenFilter jwtFilter) 
            throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

## Complete Secure API Example

```java
@Entity
@Data
public class Product {
    @Id
    @GeneratedValue
    private Long id;
    private String name;
    private Double price;
}

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {}

@Service
public class ProductService {
    @Autowired
    private ProductRepository repo;
    
    public List<Product> getAllProducts() {
        return repo.findAll();
    }
    
    public Product createProduct(Product product) {
        return repo.save(product);
    }
}

@RestController
@RequestMapping("/api/products")
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    // Everyone can view products
    @GetMapping
    public List<Product> getAll() {
        return productService.getAllProducts();
    }
    
    // Only authenticated users
    @PostMapping
    public Product create(@RequestBody Product product) {
        return productService.createProduct(product);
    }
    
    // Only admins
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public void delete(@PathVariable Long id) {
        // Delete product
    }
}
```

## Configuration

Add to `application.properties`:

```properties
# JWT Secret (use long random string in production!)
app.jwtSecret=mySecretKeyThatShouldBeVeryLongAndRandom1234567890

# JWT Expiration (milliseconds)
app.jwtExpirationMs=86400000

# Password encoding strength (BCrypt rounds)
server.servlet.session.timeout=30m
```

## Common Mistakes

### 1. Storing Plain Text Passwords

```java
// âŒ WRONG
user.setPassword("password123");  // Plain text!

// âœ… RIGHT
PasswordEncoder encoder = new BCryptPasswordEncoder();
user.setPassword(encoder.encode("password123"));
```

### 2. Exposing Secrets in Code

```java
// âŒ WRONG
private String SECRET = "my-secret-key";

// âœ… RIGHT
@Value("${app.jwtSecret}")
private String jwtSecret;  // From properties file
```

### 3. Not Validating Tokens

```java
// âŒ WRONG
String username = Jwts.parser()
    .setSigningKey(secret)
    .parseClaimsJws(token)  // Crashes if invalid!
    .getBody()
    .getSubject();

// âœ… RIGHT
if (tokenProvider.validateToken(token)) {
    String username = tokenProvider.getUsernameFromToken(token);
}
```

## Testing Security

```java
@SpringBootTest
@AutoConfigureMockMvc
public class SecurityTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    public void publicEndpointRequiresNoAuth() throws Exception {
        mockMvc.perform(get("/api/public/info"))
            .andExpect(status().isOk());
    }
    
    @Test
    public void protectedEndpointRequiresAuth() throws Exception {
        mockMvc.perform(get("/api/products"))
            .andExpect(status().isUnauthorized());
    }
    
    @Test
    @WithMockUser(username="user", roles="USER")
    public void authenticatedUserCanAccess() throws Exception {
        mockMvc.perform(get("/api/products"))
            .andExpect(status().isOk());
    }
}
```

## Key Takeaways

- âœ… Authentication verifies identity (login)
- âœ… Authorization controls what authenticated users can do
- âœ… Always encrypt passwords with BCrypt
- âœ… JWT tokens enable stateless authentication
- âœ… Use @PreAuthorize for role-based access control
- âœ… Never expose secrets in code
- âœ… Validate tokens before using them

---

