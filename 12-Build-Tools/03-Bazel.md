# Bazel Build System

## What is Bazel?

**Bazel** is a fast, scalable build system by Google for multi-language projects.

**Key Features:**
- Fast builds (incremental, parallel)
- Scalable to large codebases
- Reproducible builds (same inputs = same outputs)
- Multi-language support (Java, C++, Python, etc.)
- Dependency management

## Bazel vs Maven vs Gradle

```
Feature          | Maven  | Gradle | Bazel
-----------------|--------|--------|--------
Speed            | Good   | Good   | Fast -
Scalability      | Good   | Good   | Excellent -
Configuration    | XML    | Groovy | Starlark
Build Cache      | No     | Yes    | Yes -
Reproducibility  | Good   | Good   | Excellent -
Learning Curve   | Easy   | Medium | Hard
```

## Setting Up Bazel

### Installation

```bash
# macOS (using Homebrew)
brew install bazel

# Ubuntu/Debian
sudo apt-get install bazel

# Windows (using Chocolatey)
choco install bazel

# Verify installation
bazel version
```

## Bazel Project Structure

```
my-java-project/
"oe"" WORKSPACE              # Root file defining project
"oe"" BUILD                  # Build rules for root
"oe"" src/
"   "oe"" main/
"   "   "oe"" java/
"   "   "   """" com/example/
"   "   "       "oe"" BUILD
"   "   "       "oe"" Main.java
"   "   "       """" Helper.java
"   "   """" resources/
"   "       """" BUILD
"   """" test/
"       "oe"" java/
"       "   """" com/example/
"       "       "oe"" BUILD
"       "       """" HelperTest.java
"       """" resources/
"""" bazelisk.json          # Bazel version management
```

## WORKSPACE File

The `WORKSPACE` file marks the root of the Bazel repository.

```python
# WORKSPACE

workspace(name = "my_java_project")

# Load Maven dependencies
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Define external dependencies
RULES_JVM_EXTERNAL_TAG = "6.0"
RULES_JVM_EXTERNAL_SHA = "..."

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/releases/download/%s/rules_jvm_external-%s.tar.gz" % (RULES_JVM_EXTERNAL_TAG, RULES_JVM_EXTERNAL_TAG),
    sha256 = RULES_JVM_EXTERNAL_SHA,
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")
rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")
rules_jvm_external_setup()

# Declare Maven dependencies
load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "junit:junit:4.13.2",
        "org.mockito:mockito-core:5.0.1",
        "com.google.guava:guava:31.1-jre",
    ],
    repositories = [
        "https://repo1.maven.org/maven2",
        "https://maven.google.com",
    ],
)
```

## BUILD Files

`BUILD` files define build targets for directories.

### Simple Application

```python
# src/main/java/com/example/BUILD

load("@rules_java//java:defs.bzl", "java_library", "java_binary")

java_library(
    name = "helper",
    srcs = ["Helper.java"],
    visibility = ["//src/main/java/com/example:__pkg__"],
)

java_binary(
    name = "app",
    srcs = ["Main.java"],
    deps = [":helper"],
    main_class = "com.example.Main",
)
```

### With Dependencies

```python
# src/main/java/com/example/BUILD

load("@rules_java//java:defs.bzl", "java_library", "java_binary")

java_library(
    name = "lib",
    srcs = glob(["*.java"]),
    deps = [
        "@maven//:com_google_guava_guava",
        "@maven//:org_slf4j_slf4j_api",
    ],
)

java_binary(
    name = "app",
    srcs = ["Main.java"],
    deps = [":lib"],
    main_class = "com.example.Main",
)
```

### With Tests

```python
# src/test/java/com/example/BUILD

load("@rules_java//java:defs.bzl", "java_test")

java_test(
    name = "helper_test",
    srcs = ["HelperTest.java"],
    deps = [
        "//src/main/java/com/example:helper",
        "@maven//:junit_junit",
        "@maven//:org_mockito_mockito_core",
    ],
)
```

## Complete Example Project

### WORKSPACE

```python
workspace(name = "java_calculator")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

RULES_JVM_EXTERNAL_TAG = "6.0"
RULES_JVM_EXTERNAL_SHA = "8701bc2154a91a8c5e4046c6adbf53f8fb1f80c3d3c4f7fd2cfe9dc0c77a1a1"

http_archive(
    name = "rules_jvm_external",
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
    sha256 = RULES_JVM_EXTERNAL_SHA,
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")
rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")
rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "junit:junit:4.13.2",
    ],
    repositories = [
        "https://repo1.maven.org/maven2",
    ],
)
```

### src/main/java/com/example/BUILD

```python
load("@rules_java//java:defs.bzl", "java_library", "java_binary")

java_library(
    name = "calculator_lib",
    srcs = [
        "Calculator.java",
        "Operation.java",
    ],
)

java_binary(
    name = "calculator",
    srcs = ["CalculatorApp.java"],
    main_class = "com.example.CalculatorApp",
    deps = [":calculator_lib"],
)
```

### src/test/java/com/example/BUILD

```python
load("@rules_java//java:defs.bzl", "java_test")

java_test(
    name = "calculator_test",
    srcs = ["CalculatorTest.java"],
    deps = [
        "//src/main/java/com/example:calculator_lib",
        "@maven//:junit_junit",
    ],
)
```

## Running Bazel Commands

```bash
# Build entire project
bazel build ...

# Build specific target
bazel build //src/main/java/com/example:app

# Run application
bazel run //src/main/java/com/example:app

# Run tests
bazel test ...

# Run specific test
bazel test //src/test/java/com/example:calculator_test

# Clean build artifacts
bazel clean

# View build graph
bazel query --output=graph '//...'

# Get dependency info
bazel query 'deps(//src/main/java/com/example:app)'
```

## Bazel Configuration File

### .bazelrc

```
# .bazelrc

# Common flags
common --enable_platform_specific_config

# Java settings
build:java --java_language_version=17
build:java --java_runtime_version=remotejdk17_linux

# Test settings
test --test_output=short

# Debug settings
build:debug -c dbg
build:debug --strip=never

# Release settings
build:release -c opt
build:release --strip=always
```

## Building Java Libraries

### Library with Resources

```python
load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "data_lib",
    srcs = glob(["src/**/*.java"]),
    resources = glob(["resources/**"]),
    resource_jars = [
        "//third_party:config_jar",
    ],
    deps = [
        "@maven//:org_yaml_snakeyaml",
    ],
)
```

## Advanced Bazel Rules

### Custom Java Rule

```python
# Create custom rule for specific pattern

def custom_java_binary(
    name,
    srcs,
    main_class,
    deps = None,
    jvm_flags = None):
    
    if jvm_flags is None:
        jvm_flags = []
    
    native.java_binary(
        name = name,
        srcs = srcs,
        main_class = main_class,
        deps = deps or [],
        jvm_flags = jvm_flags + ["-Xmx512m"],
    )
```

## Troubleshooting

### Clean Build Issues

```bash
# Complete clean
bazel clean --expunge

# Remove specific target
rm -rf bazel-bin
bazel build //path/to:target
```

### Dependency Issues

```bash
# Check dependencies
bazel query 'deps(//src/main/java/com/example:app)'

# Find missing dependencies
bazel build //src/main/java/com/example:app 2>&1 | grep -i "missing"

# Update WORKSPACE manually if needed
```

### Build Performance

```bash
# Parallel builds
bazel build --jobs=8 ...

# Incremental builds
bazel build --incremental ...

# Monitor build
bazel build --show_progress ...
```

## Comparison with Maven/Gradle

### Maven Example
```xml
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
    </dependency>
</dependencies>
```

### Gradle Example
```gradle
dependencies {
    testImplementation 'junit:junit:4.13.2'
}
```

### Bazel Equivalent
```python
maven_install(
    artifacts = [
        "junit:junit:4.13.2",
    ],
)

# In BUILD file:
deps = ["@maven//:junit_junit"]
```

## When to Use Bazel

### Use Bazel When:
- Large monorepo with multiple languages
- Need reproducible builds
- Want fast incremental builds
- Complex dependency graphs
- Enterprise-scale projects

### [WRONG] Better Alternatives When:
- Small single-language project
- Team unfamiliar with Bazel
- Simple Maven/Gradle setup works
- Need quick project setup

## Key Takeaways

- Bazel is fast, scalable build system
- Fast incremental builds and parallel execution
- WORKSPACE file defines project scope
- BUILD files define build targets
- Maven dependencies via maven_install
- java_library for libraries
- java_binary for applications
- java_test for unit tests
- Reproducible builds across machines
- Good for large, complex projects

---


