# REST-Assured: Testing REST APIs

## What is REST-Assured?

**REST-Assured** is a Java library that simplifies testing REST APIs with a readable, fluent syntax.

**Real-world analogy**: REST-Assured is like a test client that pretends to be a user, making requests to your API and verifying responses.

## Dependencies

Add to `pom.xml`:

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.3.1</version>
    <scope>test</scope>
</dependency>
```

## Basic GET Request

### Simple Request

```java
import io.rest-assured.RestAssured;
import static io.rest-assured.RestAssured.*;
import static org.hamcrest.Matchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class StudentAPITest {
    
    @LocalServerPort
    private int port;
    
    @BeforeEach
    public void setUp() {
        RestAssured.port = port;
        RestAssured.basePath = "/api";
    }
    
    @Test
    public void testGetAllStudents() {
        get("/students")
            .then()
            .statusCode(200)
            .contentType("application/json");
    }
}
```

### Verify Response Body

```java
@Test
public void testGetStudentById() {
    get("/students/1")
        .then()
        .statusCode(200)
        .body("id", equalTo(1))
        .body("name", equalTo("Alice"))
        .body("gpa", equalTo(3.8f));
}
```

## POST Request

### Create Resource

```java
@Test
public void testCreateStudent() {
    String requestBody = """
        {
            "name": "Charlie",
            "email": "charlie@email.com",
            "gpa": 3.9
        }
        """;
    
    given()
        .contentType("application/json")
        .body(requestBody)
    .when()
        .post("/students")
    .then()
        .statusCode(201)
        .body("id", notNullValue())
        .body("name", equalTo("Charlie"));
}
```

### Using Objects

```java
// DTO
class StudentDTO {
    public String name;
    public String email;
    public double gpa;
}

@Test
public void testCreateWithObject() {
    StudentDTO student = new StudentDTO();
    student.name = "David";
    student.email = "david@email.com";
    student.gpa = 3.7;
    
    given()
        .contentType("application/json")
        .body(student)
    .when()
        .post("/students")
    .then()
        .statusCode(201)
        .body("name", equalTo("David"));
}
```

## PUT Request (Update)

```java
@Test
public void testUpdateStudent() {
    String updateBody = """
        {
            "name": "Alice Updated",
            "gpa": 3.9
        }
        """;
    
    given()
        .contentType("application/json")
        .body(updateBody)
    .when()
        .put("/students/1")
    .then()
        .statusCode(200)
        .body("name", equalTo("Alice Updated"));
}
```

## DELETE Request

```java
@Test
public void testDeleteStudent() {
    given()
    .when()
        .delete("/students/1")
    .then()
        .statusCode(204);
    
    // Verify deleted
    get("/students/1")
        .then()
        .statusCode(404);
}
```

## Advanced Testing

### Path Parameters

```java
@Test
public void testWithPathParam() {
    given()
        .pathParam("id", 1)
    .when()
        .get("/students/{id}")
    .then()
        .statusCode(200);
}
```

### Query Parameters

```java
@Test
public void testWithQueryParam() {
    given()
        .queryParam("name", "Alice")
        .queryParam("minGpa", 3.5)
    .when()
        .get("/students/search")
    .then()
        .statusCode(200)
        .body("$", hasSize(greaterThan(0)));
}
```

### Headers

```java
@Test
public void testWithHeaders() {
    given()
        .header("Authorization", "Bearer token123")
        .header("X-Custom-Header", "value")
    .when()
        .get("/students")
    .then()
        .statusCode(200);
}
```

### Cookies

```java
@Test
public void testWithCookies() {
    given()
        .cookie("sessionId", "abc123")
    .when()
        .get("/students")
    .then()
        .statusCode(200);
}
```

## Complete Examples

### 1. Student API Test Suite

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class StudentControllerTest {
    
    @LocalServerPort
    private int port;
    
    @BeforeEach
    public void setUp() {
        RestAssured.port = port;
        RestAssured.basePath = "/api";
    }
    
    @Test
    public void testGetAllStudents() {
        get("/students")
            .then()
            .statusCode(200)
            .contentType("application/json")
            .body("$", hasSize(greaterThanOrEqualTo(0)));
    }
    
    @Test
    public void testGetStudentById() {
        // First create a student
        String created = given()
            .contentType("application/json")
            .body("{\"name\":\"Alice\",\"email\":\"alice@email.com\",\"gpa\":3.8}")
            .when()
            .post("/students")
            .then()
            .statusCode(201)
            .extract()
            .path("id");
        
        // Then fetch it
        get("/students/{id}")
            .then()
            .statusCode(200)
            .body("name", equalTo("Alice"));
    }
    
    @Test
    public void testCreateStudent() {
        given()
            .contentType("application/json")
            .body("{\"name\":\"Bob\",\"email\":\"bob@email.com\",\"gpa\":3.9}")
        .when()
            .post("/students")
        .then()
            .statusCode(201)
            .body("name", equalTo("Bob"))
            .body("email", equalTo("bob@email.com"));
    }
    
    @Test
    public void testUpdateStudent() {
        // Create student first
        int id = given()
            .contentType("application/json")
            .body("{\"name\":\"Charlie\",\"email\":\"charlie@email.com\",\"gpa\":3.7}")
            .when()
            .post("/students")
            .then()
            .statusCode(201)
            .extract()
            .path("id");
        
        // Update it
        given()
            .contentType("application/json")
            .body("{\"name\":\"Charlie Updated\",\"gpa\":3.95}")
        .when()
            .put("/students/" + id)
        .then()
            .statusCode(200)
            .body("name", equalTo("Charlie Updated"));
    }
    
    @Test
    public void testDeleteStudent() {
        // Create first
        int id = given()
            .contentType("application/json")
            .body("{\"name\":\"David\",\"email\":\"david@email.com\",\"gpa\":3.6}")
            .when()
            .post("/students")
            .then()
            .statusCode(201)
            .extract()
            .path("id");
        
        // Delete it
        delete("/students/" + id)
            .then()
            .statusCode(204);
        
        // Verify deleted
        get("/students/" + id)
            .then()
            .statusCode(404);
    }
}
```

### 2. Error Handling Tests

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ErrorHandlingTest {
    
    @LocalServerPort
    private int port;
    
    @BeforeEach
    public void setUp() {
        RestAssured.port = port;
        RestAssured.basePath = "/api";
    }
    
    @Test
    public void testNotFound() {
        get("/students/99999")
            .then()
            .statusCode(404);
    }
    
    @Test
    public void testBadRequest() {
        given()
            .contentType("application/json")
            .body("{\"name\":\"\",\"email\":\"invalid\"}")
        .when()
            .post("/students")
        .then()
            .statusCode(400);
    }
    
    @Test
    public void testUnauthorized() {
        delete("/students/1")
            .then()
            .statusCode(401);
    }
}
```

### 3. Authentication Tests

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class AuthenticationTest {
    
    @LocalServerPort
    private int port;
    
    private String token;
    
    @BeforeEach
    public void setUp() {
        RestAssured.port = port;
        RestAssured.basePath = "/api";
        
        // Login and get token
        token = given()
            .contentType("application/json")
            .body("{\"username\":\"alice\",\"password\":\"password123\"}")
        .when()
            .post("/auth/login")
        .then()
            .statusCode(200)
            .extract()
            .path("token");
    }
    
    @Test
    public void testAuthenticatedRequest() {
        given()
            .header("Authorization", "Bearer " + token)
        .when()
            .get("/students")
        .then()
            .statusCode(200);
    }
    
    @Test
    public void testUnauthorizedWithoutToken() {
        get("/students")
            .then()
            .statusCode(401);
    }
}
```

## Response Extraction

### Extract Values

```java
@Test
public void testExtractData() {
    // Extract single value
    String name = get("/students/1")
        .then()
        .extract()
        .path("name");
    
    // Extract body as object
    StudentDTO student = get("/students/1")
        .then()
        .extract()
        .as(StudentDTO.class);
    
    // Extract full response
    Response response = get("/students/1")
        .then()
        .extract()
        .response();
}
```

### List Assertions

```java
@Test
public void testListAssertions() {
    get("/students")
        .then()
        .body("$", hasSize(greaterThan(0)))
        .body("name", hasItems("Alice", "Bob"))
        .body("gpa", everyItem(greaterThan(3.0)));
}
```

## Common Mistakes

### 1. Ignoring Status Code

```java
// ❌ WRONG - doesn't check status
Response response = get("/students/1").then().extract().response();

// ✅ RIGHT - verify status first
get("/students/1")
    .then()
    .statusCode(200)
    .extract()
    .response();
```

### 2. Not Waiting for Async Operations

```java
// ❌ WRONG - data not ready
given()
    .body(student)
    .post("/students")
    .then()
    .statusCode(201);

// ✅ RIGHT - wait for consistency
Thread.sleep(100);
get("/students/1")
    .then()
    .statusCode(200);
```

### 3. Hardcoded Test Data

```java
// ❌ WRONG - relies on existing data
get("/students/123")
    .then()
    .statusCode(200);

// ✅ RIGHT - create test data
int id = given()
    .body(newStudent)
    .post("/students")
    .then()
    .extract()
    .path("id");

get("/students/" + id)
    .then()
    .statusCode(200);
```

## Testing Tips

1. **Create Test Data** - Don't rely on existing data
2. **Isolate Tests** - Each test should be independent
3. **Clean Up** - Delete test data after tests
4. **Use Fixtures** - @Before/@After for setup/teardown
5. **Test Error Cases** - Not just happy path
6. **Use Matchers** - Makes assertions readable

## Key Takeaways

- ✅ REST-Assured provides fluent API for testing REST endpoints
- ✅ `given()` → `when()` → `then()` pattern for readability
- ✅ Verify status codes, headers, and response body
- ✅ Support for authentication, path params, query params
- ✅ Extract data from responses for chaining tests
- ✅ Test error cases and edge cases
- ✅ Create test data, don't rely on existing data

---

**Next →** Nested Classes: [Nested Classes](/4-Language-Features/04-NestedClasses.md)
