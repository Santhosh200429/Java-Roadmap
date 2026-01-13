# Socket Programming in Java

## What are Sockets?

**Sockets** are endpoints for network communication. A socket represents one end of a network connection.

**Real-world analogy**: Like phone sockets - two phones connect to each other to communicate.

```
Server Socket                TCP Connection              Client Socket
(listening on port)          (established)               (connected)
     |                              |                         |
   bind()  -----  connect() -----  accept()
```

## Client-Server Model

```
Server                                Client
  |                                     |
  | ServerSocket on port 5000           |
  |                                     |
  | listening...                        |
  |                                     |
  |  <--- Socket connect ---------- new Socket
  |                                     |
  | accept()                            |
  | (now have communication)            |
  |                                     |
  | getInputStream() | getOutputStream()|
  |                                     |
  | <--- READ/WRITE ---------> |
  |                                     |
```

## Simple Echo Server

```java
import java.io.*;
import java.net.*;

public class EchoServer {
    
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(5000);
        System.out.println("Server listening on port 5000");
        
        while (true) {
            // Wait for client connection
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " + 
                clientSocket.getInetAddress().getHostAddress());
            
            // Handle client
            handleClient(clientSocket);
        }
    }
    
    private static void handleClient(Socket socket) throws IOException {
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(socket.getInputStream())
        );
        PrintWriter writer = new PrintWriter(
            socket.getOutputStream(), true
        );
        
        String message;
        while ((message = reader.readLine()) != null) {
            System.out.println("Received: " + message);
            
            // Echo back to client
            writer.println("Echo: " + message);
        }
        
        socket.close();
    }
}
```

## Simple Echo Client

```java
import java.io.*;
import java.net.*;
import java.util.*;

public class EchoClient {
    
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("localhost", 5000);
        System.out.println("Connected to server");
        
        // Setup communication
        BufferedReader reader = new BufferedReader(
            new InputStreamReader(socket.getInputStream())
        );
        PrintWriter writer = new PrintWriter(
            socket.getOutputStream(), true
        );
        Scanner scanner = new Scanner(System.in);
        
        // Send/receive messages
        while (true) {
            System.out.print("Enter message: ");
            String message = scanner.nextLine();
            
            if (message.equals("quit")) break;
            
            writer.println(message);
            String response = reader.readLine();
            System.out.println("Server: " + response);
        }
        
        socket.close();
        scanner.close();
    }
}

// Usage:
// Terminal 1: java EchoServer
// Terminal 2: java EchoClient
// Terminal 2: Enter message: hello
// Server: Echo: hello
```

## Multi-threaded Server

Handling multiple clients concurrently:

```java
import java.io.*;
import java.net.*;

public class MultiClientServer {
    
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(6000);
        System.out.println("Multi-client server on port 6000");
        
        int clientCount = 0;
        
        while (true) {
            Socket clientSocket = serverSocket.accept();
            clientCount++;
            System.out.println("Client #" + clientCount + " connected");
            
            // Handle each client in separate thread
            new Thread(new ClientHandler(clientSocket, clientCount)).start();
        }
    }
}

class ClientHandler implements Runnable {
    
    private Socket socket;
    private int clientId;
    
    ClientHandler(Socket socket, int clientId) {
        this.socket = socket;
        this.clientId = clientId;
    }
    
    public void run() {
        try {
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            PrintWriter writer = new PrintWriter(
                socket.getOutputStream(), true
            );
            
            String message;
            while ((message = reader.readLine()) != null) {
                System.out.println("Client #" + clientId + ": " + message);
                
                // Process and respond
                String response = processMessage(message);
                writer.println(response);
            }
            
            socket.close();
            System.out.println("Client #" + clientId + " disconnected");
            
        } catch (IOException e) {
            System.err.println("Client #" + clientId + " error: " + e);
        }
    }
    
    private String processMessage(String msg) {
        return msg.toUpperCase();
    }
}
```

## Complete Chat Application

### Server

```java
import java.io.*;
import java.net.*;
import java.util.*;

public class ChatServer {
    
    private static Set<ChatClientHandler> clients = new HashSet<>();
    
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(7000);
        System.out.println("Chat server on port 7000");
        
        while (true) {
            Socket clientSocket = serverSocket.accept();
            System.out.println("New connection from " + 
                clientSocket.getInetAddress().getHostAddress());
            
            ChatClientHandler handler = new ChatClientHandler(clientSocket);
            clients.add(handler);
            new Thread(handler).start();
        }
    }
    
    public static void broadcast(String message, ChatClientHandler sender) {
        for (ChatClientHandler client : clients) {
            if (client != sender) {
                client.sendMessage(message);
            }
        }
    }
    
    public static void removeClient(ChatClientHandler client) {
        clients.remove(client);
    }
}

class ChatClientHandler implements Runnable {
    
    private Socket socket;
    private PrintWriter writer;
    private String username;
    
    ChatClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        this.writer = new PrintWriter(
            socket.getOutputStream(), true
        );
    }
    
    public void run() {
        try {
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            
            // Get username
            writer.println("Enter username:");
            username = reader.readLine();
            writer.println("Welcome " + username);
            
            System.out.println(username + " joined");
            ChatServer.broadcast(username + " joined the chat", this);
            
            // Handle messages
            String message;
            while ((message = reader.readLine()) != null) {
                System.out.println(username + ": " + message);
                ChatServer.broadcast(username + ": " + message, this);
            }
            
            socket.close();
            ChatServer.removeClient(this);
            System.out.println(username + " left");
            ChatServer.broadcast(username + " left the chat", this);
            
        } catch (IOException e) {
            System.err.println("Error: " + e);
        }
    }
    
    public void sendMessage(String message) {
        writer.println(message);
    }
}
```

### Client

```java
import java.io.*;
import java.net.*;
import java.util.*;

public class ChatClient {
    
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("localhost", 7000);
        System.out.println("Connected to chat server");
        
        // Threads for reading and writing
        new Thread(new MessageReceiver(socket)).start();
        new Thread(new MessageSender(socket)).start();
    }
}

class MessageReceiver implements Runnable {
    private Socket socket;
    
    MessageReceiver(Socket socket) {
        this.socket = socket;
    }
    
    public void run() {
        try {
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            
            String message;
            while ((message = reader.readLine()) != null) {
                System.out.println("\n" + message);
                System.out.print("> ");
            }
        } catch (IOException e) {
            System.err.println("Connection lost: " + e);
        }
    }
}

class MessageSender implements Runnable {
    private Socket socket;
    
    MessageSender(Socket socket) {
        this.socket = socket;
    }
    
    public void run() {
        try {
            PrintWriter writer = new PrintWriter(
                socket.getOutputStream(), true
            );
            Scanner scanner = new Scanner(System.in);
            
            String message;
            while (true) {
                System.out.print("> ");
                message = scanner.nextLine();
                writer.println(message);
            }
        } catch (IOException e) {
            System.err.println("Error: " + e);
        }
    }
}

// Usage:
// Terminal 1: java ChatServer
// Terminal 2: java ChatClient
// Terminal 3: java ChatClient
// Now both clients can chat with each other!
```

## UDP Sockets (Connectionless)

```java
// UDP Server
import java.net.*;

public class UDPServer {
    public static void main(String[] args) throws Exception {
        DatagramSocket socket = new DatagramSocket(8888);
        System.out.println("UDP Server on port 8888");
        
        byte[] buffer = new byte[1024];
        
        while (true) {
            DatagramPacket packet = new DatagramPacket(
                buffer, buffer.length
            );
            
            socket.receive(packet);  // Wait for message
            
            String message = new String(
                packet.getData(), 0, packet.getLength()
            );
            System.out.println("Received: " + message);
            
            // Send response back
            String response = "Echo: " + message;
            DatagramPacket reply = new DatagramPacket(
                response.getBytes(),
                response.length(),
                packet.getAddress(),
                packet.getPort()
            );
            socket.send(reply);
        }
    }
}

// UDP Client
public class UDPClient {
    public static void main(String[] args) throws Exception {
        DatagramSocket socket = new DatagramSocket();
        
        String message = "Hello UDP";
        DatagramPacket packet = new DatagramPacket(
            message.getBytes(),
            message.length(),
            InetAddress.getLocalHost(),
            8888
        );
        
        socket.send(packet);
        System.out.println("Sent: " + message);
        
        // Receive response
        byte[] buffer = new byte[1024];
        DatagramPacket response = new DatagramPacket(
            buffer, buffer.length
        );
        socket.receive(response);
        
        System.out.println("Response: " + 
            new String(response.getData(), 0, response.getLength())
        );
        
        socket.close();
    }
}
```

## Socket Configuration

```java
import java.net.*;

public class SocketConfig {
    
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("example.com", 80);
        
        // Set socket options
        socket.setTcpNoDelay(true);           // Disable Nagle's algorithm
        socket.setKeepAlive(true);            // Keep connection alive
        socket.setSoTimeout(10000);           // 10 second timeout
        socket.setSendBufferSize(32768);      // Send buffer size
        socket.setReceiveBufferSize(65536);   // Receive buffer size
        
        // Get socket info
        System.out.println("Local port: " + socket.getLocalPort());
        System.out.println("Remote address: " + socket.getInetAddress());
        System.out.println("Connected: " + socket.isConnected());
        
        socket.close();
    }
}
```

## Common Socket Exceptions

```java
public class SocketExceptions {
    
    public static void main(String[] args) {
        try {
            // ConnectionException - host refused connection
            Socket socket = new Socket("localhost", 9999);
        } catch (ConnectException e) {
            System.out.println("Connection refused - server not running");
        }
        
        try {
            // SocketTimeoutException - timeout
            Socket socket = new Socket("example.com", 80);
            socket.setSoTimeout(1000);
            socket.getInputStream().read();
        } catch (SocketTimeoutException e) {
            System.out.println("Socket timeout");
        }
        
        try {
            // SocketException - general socket error
            Socket socket = new Socket("example.com", 80);
            socket.close();
            socket.getInputStream();  // Error!
        } catch (SocketException e) {
            System.out.println("Socket closed");
        }
    }
}
```

## Best Practices

```java
// ✅ Always close resources
try (Socket socket = new Socket("localhost", 8000)) {
    // Use socket
} catch (IOException e) {
    System.err.println("Error: " + e);
}

// ✅ Use timeouts to prevent hanging
socket.setSoTimeout(30000);  // 30 second timeout

// ✅ Handle disconnections gracefully
try {
    String message = reader.readLine();
    if (message == null) {
        System.out.println("Client disconnected");
        return;
    }
} catch (IOException e) {
    System.out.println("Connection error: " + e);
}

// ✅ Use separate threads for concurrent clients
for (Socket client : clients) {
    new Thread(new ClientHandler(client)).start();
}
```

## Key Takeaways

- ✅ ServerSocket listens for incoming connections
- ✅ Socket represents a connection to a server
- ✅ Use streams for reading/writing data
- ✅ TCP for reliable, UDP for fast
- ✅ Always close sockets when done
- ✅ Use timeouts to prevent hanging
- ✅ Handle multiple clients with threads
- ✅ Be graceful with disconnections

---

**Next →** Date/Time API: [Modern Date Handling](/8-I-O-Networking/05-Date-And-Time.md)
