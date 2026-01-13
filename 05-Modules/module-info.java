/**
 * Module definition for Java Roadmap Learning Module
 * 
 * This module demonstrates the Java Module System (Project Jigsaw)
 * introduced in Java 9, which allows for better encapsulation and
 * dependency management.
 */
module javaRoadmap {
    // This module doesn't require any other modules currently
    // In a real project, you would declare dependencies like:
    // requires java.base;
    // requires some.other.module;
    
    // This module exports its packages to other modules
    // exports com.example.api;
    
    // For example, if you wanted to export conditionally:
    // exports com.example.api to module.a, module.b;
}
