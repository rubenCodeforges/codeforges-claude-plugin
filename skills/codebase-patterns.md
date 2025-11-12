---
name: codebase-patterns
description: Common codebase patterns, anti-patterns, and architectural conventions. Auto-loaded when analyzing code structure or discussing architecture.
---

# Common Codebase Patterns

## Architecture Patterns

### MVC (Model-View-Controller)
- **Models**: Data and business logic
- **Views**: UI/presentation layer
- **Controllers**: Handle requests, coordinate models/views
- Common in: Rails, Django, Laravel, ASP.NET MVC

### Layered Architecture
- **Presentation**: UI components
- **Business Logic**: Core application logic
- **Data Access**: Database interactions
- **Common separation**: `/controllers`, `/services`, `/repositories`

### Microservices
- Independent services with own databases
- Communication via REST/gRPC/message queues
- Look for: Docker, Kubernetes configs, service directories

### Repository Pattern
```
/repositories
  - UserRepository.ts
  - ProductRepository.ts
```
Abstracts data access logic

### Service Layer Pattern
```
/services
  - AuthService.ts
  - PaymentService.ts
```
Business logic separation from controllers

## Common Anti-Patterns

### God Class/Object
- Class with too many responsibilities
- **Signs**: 500+ lines, handles everything
- **Fix**: Split into smaller, focused classes

### Spaghetti Code
- Complex, tangled dependencies
- **Signs**: Hard to follow flow, circular dependencies
- **Fix**: Refactor to clear dependencies

### Magic Numbers/Strings
```javascript
// Bad
if (status === 1) { }

// Good
const STATUS_ACTIVE = 1;
if (status === STATUS_ACTIVE) { }
```

### N+1 Query Problem
```python
# Bad - N+1 queries
for user in users:
    user.posts  # Separate query for each user

# Good - Single query
users = User.objects.prefetch_related('posts')
```

## File Organization Patterns

### Feature-based
```
/features
  /auth
    - login.ts
    - signup.ts
  /dashboard
    - dashboard.ts
```

### Layer-based
```
/controllers
/models
/views
/services
```

### Domain-driven Design
```
/domain
  /user
  /order
  /payment
```

## Naming Conventions

### Functions
- **JavaScript/TypeScript**: `camelCase` - `getUserById()`
- **Python**: `snake_case` - `get_user_by_id()`
- **Go**: `PascalCase` for exported - `GetUserByID()`

### Classes
- **All languages**: `PascalCase` - `UserController`, `PaymentService`

### Constants
- **All languages**: `SCREAMING_SNAKE_CASE` - `MAX_RETRIES`, `API_URL`

### Files
- **React**: `PascalCase.tsx` - `UserProfile.tsx`
- **Others**: `kebab-case` or `snake_case` - `user-service.ts`

## Common Directory Structures

### React/Next.js
```
/app or /pages
/components
/lib or /utils
/hooks
/styles
/public
```

### Express/Node
```
/routes
/controllers
/models
/middleware
/services
/config
```

### Django
```
/app_name
  /models
  /views
  /templates
  /migrations
```

### Go
```
/cmd
/internal
/pkg
/api
/configs
```

Use these patterns to quickly understand and navigate unfamiliar codebases.
