# Installing the Java Development Kit (JDK)

## What is the JDK?

The **Java Development Kit (JDK)** is the fundamental software you need to write, compile, and run Java programs. Think of it as your toolkit for Java development - without it, your computer doesn't understand Java code.

### Components of the JDK:

1. **Compiler (javac)**: Converts your Java code into bytecode that the JVM can understand
2. **Java Runtime Environment (JRE)**: Allows your computer to run Java programs
3. **Development Tools**: Utilities for debugging, documentation, and more
4. **Java Standard Library**: Pre-built code that you can use in your programs

## System Requirements

Before installing, make sure your computer meets these minimum requirements:

- **OS**: Windows, macOS, or Linux
- **Disk Space**: At least 200 MB free
- **Memory**: 512 MB RAM (1 GB recommended)
- **Administrator Access**: You'll need admin rights to install

## Step-by-Step Installation Guide

### Windows Installation

#### Step 1: Download the JDK

1. Visit the official Oracle website: https://www.oracle.com/java/technologies/downloads/
2. Look for **Java 21** (Latest) or **Java 17** (LTS - Long Term Support)
3. Select **Windows** â†’ **x64 Installer**
4. Accept the license agreement
5. Click **Download** and save the file

**What's LTS?** Long Term Support means Oracle will support it for many years. Java 21 is the latest, but Java 17 is more stable for beginners.

#### Step 2: Run the Installer

1. Find the downloaded file (usually in your Downloads folder)
2. Double-click the `.exe` file
3. A window will appear - click **Next** to proceed
4. Accept the license agreement
5. Choose installation location (default is fine for most users)
6. Click **Next** and **Finish**

**Installation Location**: The default location is usually `C:\Program Files\Java\jdkXX` where XX is the version number.

#### Step 3: Verify Installation

Open Command Prompt and verify Java is installed:

```cmd
java -version
```

You should see output like:
```
java version "21.0.1" 2023-10-17
Java(TM) SE Runtime Environment (build 21.0.1+12-LTS-26)
```

Also check the compiler:
```cmd
javac -version
```

You should see:
```
javac 21.0.1
```

### macOS Installation

#### Step 1: Download the JDK

1. Visit https://www.oracle.com/java/technologies/downloads/
2. Select **Java 21** or **Java 17**
3. Choose **macOS** â†’ **x64 DMG Installer** (or ARM64 if you have Apple Silicon)
4. Download the file

#### Step 2: Install

1. Double-click the `.dmg` file
2. Follow the installer instructions
3. The JDK will be installed to `/Library/Java/JavaVirtualMachines/`

#### Step 3: Verify Installation

Open Terminal and run:
```bash
java -version
javac -version
```

### Linux Installation

Linux installations vary by distribution. Here's for Ubuntu/Debian:

```bash
# Update package manager
sudo apt update

# Install OpenJDK 21 (free, open-source alternative to Oracle JDK)
sudo apt install openjdk-21-jdk

# Verify installation
java -version
javac -version
```

**Alternative**: You can also download Oracle JDK from the website and follow manual installation steps.

## Setting Up Environment Variables (Windows)

Environment variables tell your system where Java is installed. Here's how to set them up:

### Step 1: Find Your JDK Installation Path

1. Open Command Prompt
2. Run: `where javac`
3. Copy the path that appears (e.g., `C:\Program Files\Java\jdk21\bin\javac.exe`)
4. Remove `\bin\javac.exe` from the end - this is your JDK path

### Step 2: Set JAVA_HOME Variable

1. Press `Windows Key` and search for "Environment Variables"
2. Click "Edit the system environment variables"
3. Click the "Environment Variables" button
4. Under "System variables", click "New"
5. Variable name: `JAVA_HOME`
6. Variable value: (Paste your JDK path from Step 1)
7. Click "OK"

### Step 3: Update PATH Variable

1. In Environment Variables window, find the "Path" variable under System variables
2. Click "Edit"
3. Click "New"
4. Add: `%JAVA_HOME%\bin`
5. Click "OK" and close all windows
6. Restart Command Prompt

### Step 4: Verify

Open a new Command Prompt and run:
```cmd
echo %JAVA_HOME%
```

You should see your JDK installation path.

## Installing Multiple Java Versions

Sometimes you'll need multiple Java versions for different projects. This is possible:

### Windows

Install each version in a separate folder:
- `C:\Program Files\Java\jdk17`
- `C:\Program Files\Java\jdk21`

Then use only one as your `JAVA_HOME` environment variable, or switch it as needed.

### macOS/Linux

Multiple versions can coexist. Switch between them:

```bash
# List installed versions
/usr/libexec/java_home -V

# Use a specific version
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
```

## Testing Your Installation

Create a simple test to ensure everything works:

1. Open a text editor (Notepad, VS Code, etc.)
2. Type:
```java
public class Test {
    public static void main(String[] args) {
        System.out.println("Java is working!");
    }
}
```

3. Save as `Test.java`
4. Open Command Prompt in the same folder
5. Compile: `javac Test.java`
6. Run: `java Test`

If you see "Java is working!" - congratulations! Your JDK is properly installed.

## Troubleshooting Common Issues

### "javac is not recognized"

**Problem**: Command Prompt doesn't recognize javac command.

**Solution**:
1. Verify JDK is installed: Check your Program Files folder
2. Set environment variables correctly (follow Step 2 above)
3. Restart Command Prompt completely
4. If still not working, restart your computer

### "java -version" shows one version, but IDE shows another

**Problem**: Multiple Java versions installed, causing confusion.

**Solution**:
1. Decide which version you want as default
2. Set `JAVA_HOME` to that version's path
3. Check IDE settings to make sure it points to the correct JDK

### Installation fails with "Administrator required"

**Problem**: Installation is blocked by security settings.

**Solution**:
1. Right-click the installer
2. Select "Run as administrator"
3. Accept any security prompts

## Next Steps

Once your JDK is installed and verified:
1. Move to [02-IDE-Setup.md](./02-IDE-Setup.md) to set up your development environment
2. Write your first program in [03-HelloWorld.java](./03-HelloWorld.java)
3. Learn basic syntax in [04-BasicSyntax.md](./04-BasicSyntax.md)

## Key Takeaways

- JDK = compiler + runtime + tools for Java development
- Always verify installation with `java -version` and `javac -version`
- Environment variables help your system find Java automatically
- Test your installation with a simple program
- You can install multiple JDK versions if needed

---

**Remember**: This is your foundation. Taking time to set up properly now will save you headaches later!


