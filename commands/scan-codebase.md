---
name: scan-codebase
description: Comprehensive codebase scan and structure mapping
---

Perform a comprehensive codebase scan by:

1. Use bash tools to scan the project structure respecting .gitignore
2. Exclude common directories: node_modules, .git, __pycache__, venv, dist, build
3. Generate a hierarchical file tree
4. Provide statistics:
   - Total files by type
   - Directory structure overview
   - Language breakdown
   - Key directories identified

5. Identify patterns:
   - Project type (React, Django, Go, etc.)
   - Architecture style (MVC, microservices, etc.)
   - Key entry points
   - Configuration files

Present results as organized report with tree structure and statistics.
