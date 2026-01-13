# IDE Setup for Java

## Overview

An Integrated Development Environment (IDE) is essential for Java development. It provides tools for writing, debugging, and testing code efficiently. This guide covers the setup of popular Java IDEs.

## Popular Java IDEs

### 1. IntelliJ IDEA
**Best for:** Professional development, full-featured IDE

#### Installation Steps:
1. Download from [JetBrains IntelliJ IDEA](https://www.jetbrains.com/idea/)
2. Choose between Community Edition (free) or Ultimate Edition (paid)
3. Run the installer and follow the setup wizard
4. During installation, select Java SDK installation option
5. Launch IntelliJ and complete the initial configuration

#### Key Features:
- Advanced code completion and intelligent refactoring
- Built-in version control integration
- Comprehensive debugging tools
- Maven and Gradle support

### 2. Eclipse IDE
**Best for:** Open-source, cross-platform development

#### Installation Steps:
1. Download from [Eclipse.org](https://www.eclipse.org/downloads/)
2. Choose "Eclipse IDE for Java Developers"
3. Extract the downloaded file
4. Run `eclipse.exe` (Windows) or `eclipse` (Linux/Mac)
5. Select your workspace directory on first launch

#### Key Features:
- Free and open-source
- Extensive plugin ecosystem
- Strong refactoring capabilities
- Good for enterprise projects

### 3. Visual Studio Code
**Best for:** Lightweight, quick setup

#### Installation Steps:
1. Download from [Visual Studio Code](https://code.visualstudio.com/)
2. Install the Extension Pack for Java
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Extension Pack for Java"
   - Click Install
3. Required extensions will install automatically

#### Key Features:
- Lightweight and fast
- Excellent for beginners
- Great community support
- Minimal resource usage

## JDK Installation

Before setting up your IDE, ensure Java Development Kit (JDK) is installed:

### Verify JDK Installation:
```bash
java -version
javac -version
```

### If JDK is not installed:
1. Download JDK from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://jdk.java.net/)
2. Run the installer
3. Follow the installation wizard
4. Add JDK to system PATH (if not done automatically)

## First Project Setup

### Creating a New Java Project in IntelliJ IDEA:
1. File → New → Project
2. Select Java as project type
3. Configure JDK path
4. Choose project template (Console App)
5. Name your project and click Create

### Creating a New Java Project in Eclipse:
1. File → New → Java Project
2. Enter project name
3. Configure JDK version
4. Click Finish
5. Create a new Java class (right-click src → New → Class)

### Creating a New Java Project in VS Code:
1. Open Command Palette (Ctrl+Shift+P)
2. Type "Java: Create Java Project"
3. Select Maven or Gradle template
4. Choose archetype and specify project details
5. Open the created project folder

## Basic IDE Configuration

### Set JDK Version:
- **IntelliJ:** File → Project Structure → Project Settings → JDK
- **Eclipse:** Window → Preferences → Java → Installed JREs
- **VS Code:** Settings → Extensions → Extension Pack for Java → Java Home

### Configure Code Style:
- **IntelliJ:** File → Settings → Editor → Code Style → Java
- **Eclipse:** Window → Preferences → Java → Code Style
- **VS Code:** Settings → [Language] → Format

### Enable Auto-Save:
- **IntelliJ:** File → Settings → Appearance & Behavior → System Settings → Save Files
- **Eclipse:** Window → Preferences → General → Editors → Text Editors → Auto Save
- **VS Code:** File → Preferences → Settings → Auto Save

## Essential Plugins/Extensions

### IntelliJ IDEA:
- Lombok Plugin (simplify boilerplate code)
- SonarLint (code quality analysis)
- CheckStyle (code style checking)

### Eclipse:
- Lombok Support
- SonarQube for Eclipse
- Git integration (EGit)

### VS Code:
- Debugger for Java
- Test Runner for Java
- Maven for Java
- Project Manager for Java

## Running Your First Program

### Example Java Program:
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

### Running:
- **IntelliJ:** Right-click → Run 'HelloWorld.main()'
- **Eclipse:** Right-click → Run As → Java Application
- **VS Code:** Terminal → Run Java or use CodeLens

## Debugging

All three IDEs provide debugging capabilities:

1. Set breakpoints by clicking on line numbers
2. Right-click file → Debug As → Java Application
3. Use Debug view to inspect variables
4. Step through code (Step Over, Step Into, Step Out)
5. Watch expressions and variables

## Tips for Productivity

1. Learn keyboard shortcuts for your chosen IDE
2. Use code templates and snippets
3. Enable code inspections for real-time error detection
4. Configure version control integration (Git)
5. Customize your IDE theme and editor preferences
6. Use IDE's refactoring tools for cleaner code

## Next Steps

- Complete the Hello World program setup
- Explore IDE features and shortcuts
- Configure your development environment
- Start learning Java fundamentals

## Resources

- [IntelliJ IDEA Documentation](https://www.jetbrains.com/help/idea/)
- [Eclipse Documentation](https://help.eclipse.org/)
- [VS Code Java Documentation](https://code.visualstudio.com/docs/java/java-tutorial)
- [OpenJDK Documentation](https://openjdk.org/)
