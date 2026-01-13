# Networking Fundamentals in Java

## What is Networking?

**Networking** allows Java programs to communicate over networks (Internet/LAN) using protocols like TCP/IP.

**Real-world analogy**: Like mail system - sender (client) sends data to receiver (server) at a specific address (IP) and location (port).

## Network Basics

### Key Concepts

```
Client                    Server
  |                         |
  |-- Request Data -------> |
  |                         |
  | <----- Response ------- |
  |
```

**IP Address**: Unique identifier for computer on network (e.g., 192.168.1.1)

**Port**: Channel on computer for specific application (e.g., 8080, 3306)

**Protocol**: Rules for communication (TCP = reliable, UDP = fast)

## TCP/IP Model

```
Layer 4: Application (HTTP, SMTP, FTP, Java apps)
Layer 3: Transport (TCP, UDP)
Layer 2: Internet (IP addressing)
Layer 1: Link (physical cables)
```

## Working with URLs

### Reading Web Content

```java
import java.io.*;
import java.net.*;

public class URLReader {
    
    public static void main(String[] args) throws Exception {
        URL url = new URL("https://jsonplaceholder.typicode.com/users/1");
        
        // Open connection
        URLConnection connection = url.openConnection();
        
        // Read response
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(connection.getInputStream())
        );
        
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }
        
        reader.close();
    }
}

// Output:
// {
//   "id": 1,
//   "name": "Leanne Graham",
//   ...
// }
```

### URL Components

```java
import java.net.*;

public class URLInfo {
    
    public static void main(String[] args) throws MalformedURLException {
        URL url = new URL("https://api.example.com:8080/users?id=123#profile");
        
        System.out.println("Protocol: " + url.getProtocol());      // https
        System.out.println("Host: " + url.getHost());              // api.example.com
        System.out.println("Port: " + url.getPort());              // 8080
        System.out.println("Path: " + url.getPath());              // /users
        System.out.println("Query: " + url.getQuery());            // id=123
        System.out.println("Ref: " + url.getRef());                // profile
    }
}
```

## HTTP Requests

### Simple GET Request

```java
import java.net.*;
import java.io.*;

public class SimpleHTTPGet {
    
    public static void main(String[] args) throws Exception {
        URL url = new URL("https://jsonplaceholder.typicode.com/posts/1");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(5000);
        
        int status = connection.getResponseCode();
        System.out.println("Status: " + status);
        
        if (status == 200) {
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(connection.getInputStream())
            );
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            reader.close();
        }
        
        connection.disconnect();
    }
}
```

### POST Request

```java
import java.net.*;
import java.io.*;

public class HTTPPost {
    
    public static void main(String[] args) throws Exception {
        URL url = new URL("https://jsonplaceholder.typicode.com/posts");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        // Configure POST
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);
        
        // Send JSON body
        String jsonBody = "{\"title\":\"New Post\",\"body\":\"Content here\",\"userId\":1}";
        
        OutputStream out = connection.getOutputStream();
        out.write(jsonBody.getBytes());
        out.flush();
        out.close();
        
        // Get response
        int status = connection.getResponseCode();
        System.out.println("Status: " + status);
        
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(connection.getInputStream())
        );
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }
        reader.close();
    }
}
```

## DNS (Domain Name System)

### Looking Up IP Addresses

```java
import java.net.*;

public class DNSLookup {
    
    public static void main(String[] args) throws UnknownHostException {
        // Domain to IP
        InetAddress address = InetAddress.getByName("google.com");
        System.out.println("Host: " + address.getHostName());
        System.out.println("IP: " + address.getHostAddress());
        
        // Get all addresses for a domain
        InetAddress[] addresses = InetAddress.getAllByName("google.com");
        System.out.println("All IPs for google.com:");
        for (InetAddress addr : addresses) {
            System.out.println(addr.getHostAddress());
        }
        
        // IP to domain
        InetAddress reverseAddress = InetAddress.getByName("8.8.8.8");
        System.out.println("Domain: " + reverseAddress.getCanonicalHostName());
    }
}

// Output:
// Host: google.com
// IP: 172.217.19.46
```

## Network Utilities

### Checking Internet Connectivity

```java
import java.net.*;

public class ConnectivityCheck {
    
    public static boolean isReachable(String host) {
        try {
            InetAddress address = InetAddress.getByName(host);
            return address.isReachable(5000);  // 5 second timeout
        } catch (Exception e) {
            return false;
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Google reachable: " + isReachable("8.8.8.8"));
        System.out.println("Local reachable: " + isReachable("localhost"));
    }
}
```

### Getting Local Network Info

```java
import java.net.*;

public class LocalNetworkInfo {
    
    public static void main(String[] args) throws SocketException {
        // Get localhost
        InetAddress localhost = InetAddress.getLocalHost();
        System.out.println("Computer name: " + localhost.getHostName());
        System.out.println("Local IP: " + localhost.getHostAddress());
        
        // Get all network interfaces
        for (NetworkInterface ni : Collections.list(
             NetworkInterface.getNetworkInterfaces())) {
            
            if (ni.isUp()) {
                System.out.println("\nInterface: " + ni.getName());
                
                for (InetAddress addr : Collections.list(ni.getInetAddresses())) {
                    System.out.println("  IP: " + addr.getHostAddress());
                }
            }
        }
    }
}
```

## Complete Examples

### 1. Web Scraper

```java
import java.net.*;
import java.io.*;

public class WebScraper {
    
    public static String fetchHTML(String urlString) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("User-Agent", 
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
        
        int status = connection.getResponseCode();
        if (status != 200) {
            throw new Exception("HTTP Error: " + status);
        }
        
        StringBuilder content = new StringBuilder();
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(connection.getInputStream())
        );
        
        String line;
        while ((line = reader.readLine()) != null) {
            content.append(line).append("\n");
        }
        
        reader.close();
        connection.disconnect();
        
        return content.toString();
    }
    
    public static void main(String[] args) throws Exception {
        String html = fetchHTML("https://example.com");
        System.out.println(html);
    }
}
```

### 2. API Client

```java
import java.net.*;
import java.io.*;

public class APIClient {
    
    private static final String BASE_URL = "https://jsonplaceholder.typicode.com";
    
    public String getUsers() throws Exception {
        return makeRequest("/users", "GET", null);
    }
    
    public String getUser(int id) throws Exception {
        return makeRequest("/users/" + id, "GET", null);
    }
    
    public String createPost(String title, String body) throws Exception {
        String json = String.format(
            "{\"title\":\"%s\",\"body\":\"%s\",\"userId\":1}",
            title, body
        );
        return makeRequest("/posts", "POST", json);
    }
    
    private String makeRequest(String endpoint, String method, 
                               String body) throws Exception {
        URL url = new URL(BASE_URL + endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod(method);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        
        if (body != null) {
            conn.setDoOutput(true);
            OutputStream out = conn.getOutputStream();
            out.write(body.getBytes());
            out.close();
        }
        
        int status = conn.getResponseCode();
        if (status < 200 || status >= 300) {
            throw new Exception("HTTP " + status);
        }
        
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(conn.getInputStream())
        );
        
        StringBuilder result = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            result.append(line);
        }
        
        reader.close();
        conn.disconnect();
        
        return result.toString();
    }
    
    public static void main(String[] args) throws Exception {
        APIClient client = new APIClient();
        
        // Get all users
        String users = client.getUsers();
        System.out.println("Users: " + users);
        
        // Get specific user
        String user = client.getUser(1);
        System.out.println("User 1: " + user);
        
        // Create post
        String newPost = client.createPost("My Title", "My content");
        System.out.println("New post: " + newPost);
    }
}
```

### 3. Network Monitor

```java
import java.net.*;
import java.util.*;

public class NetworkMonitor {
    
    public static void main(String[] args) throws Exception {
        String[] hosts = {"google.com", "github.com", "stackoverflow.com"};
        
        while (true) {
            System.out.println("\n=== Network Status ===");
            for (String host : hosts) {
                checkHost(host);
            }
            
            Thread.sleep(5000);  // Check every 5 seconds
        }
    }
    
    private static void checkHost(String host) {
        try {
            long start = System.currentTimeMillis();
            InetAddress address = InetAddress.getByName(host);
            boolean reachable = address.isReachable(3000);
            long time = System.currentTimeMillis() - start;
            
            String status = reachable ? "✓ UP" : "✗ DOWN";
            System.out.println(host + ": " + status + " (" + time + "ms)");
        } catch (Exception e) {
            System.out.println(host + ": ✗ ERROR - " + e.getMessage());
        }
    }
}
```

## Common Network Errors

```java
// UnknownHostException - hostname not found
try {
    InetAddress.getByName("invalid.domain.xyz");
} catch (UnknownHostException e) {
    System.out.println("Host not found");
}

// SocketException - connection issues
try {
    URL url = new URL("http://example.com");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setConnectTimeout(2000);
    conn.connect();
} catch (SocketException e) {
    System.out.println("Network connection error");
}

// SocketTimeoutException - request took too long
try {
    URL url = new URL("http://slow-site.com");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setReadTimeout(5000);
    conn.getInputStream();
} catch (SocketTimeoutException e) {
    System.out.println("Request timeout");
}
```

## Key Takeaways

- ✅ IP addresses identify computers on network
- ✅ Ports identify specific applications
- ✅ Use URL class for parsing web addresses
- ✅ Use HttpURLConnection for HTTP requests
- ✅ GET for retrieving data, POST for sending data
- ✅ Always set timeouts for network operations
- ✅ Handle NetworkException, SocketException, UnknownHostException
- ✅ Disconnect connections when done

---

**Next →** Sockets: [Socket Programming](/8-I-O-Networking/04-Sockets.md)
