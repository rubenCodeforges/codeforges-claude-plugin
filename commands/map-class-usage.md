---
name: map-class-usage
description: Build comprehensive usage map for a class showing all methods and fields with their usages
---

Invoke the @usage-finder sub-agent to build a comprehensive usage map for the specified class.

The usage map should include:

1. **Class Analysis**:
   - Extract all public methods with their signatures
   - Extract all public fields/properties with their types
   - Identify constructors and static members
   - Note any inherited classes or interfaces

2. **Usage Search**:
   - Find all usages of each method across the codebase
   - Find all usages of each field/property
   - Categorize usages by type (method calls, field access, inheritance, etc.)
   - Include file paths and line numbers for each usage

3. **Structured Output**:
   - Generate JSON format for programmatic consumption
   - Include usage counts and location summaries
   - Provide actionable insights (dead code, high coupling, refactoring opportunities)

4. **Analysis Summary**:
   - Most used methods/fields
   - Unused members (dead code candidates)
   - Breaking change impact assessment
   - Refactoring recommendations

**Usage**: `/map-class-usage <ClassName>` or `/map-class-usage <path/to/ClassFile>`

**Examples**:
- `/map-class-usage UserService`
- `/map-class-usage src/services/PaymentProcessor.java`
- `/map-class-usage DatabaseManager --exclude-tests`

The agent will search for the class, analyze its structure, find all usages, and present results in both JSON (for machines) and Markdown table (for humans) formats.
