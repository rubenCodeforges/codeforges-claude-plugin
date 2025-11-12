---
name: refactoring-guide
description: Practical refactoring techniques and when to apply them. Auto-loaded when discussing code improvements or refactoring.
---

# Refactoring Guide

## When to Refactor

### Red Flags
- Functions longer than 50 lines
- Classes with 10+ methods
- Nested conditionals 3+ levels deep
- Duplicated code in 3+ places
- Complex boolean conditions
- High cyclomatic complexity (>10)

## Common Refactorings

### Extract Function
**Before:**
```javascript
function processOrder(order) {
  // Calculate total
  let total = 0;
  for (let item of order.items) {
    total += item.price * item.quantity;
  }
  
  // Apply discount
  if (order.customer.isPremium) {
    total *= 0.9;
  }
  
  return total;
}
```

**After:**
```javascript
function processOrder(order) {
  const subtotal = calculateSubtotal(order.items);
  return applyDiscount(subtotal, order.customer);
}

function calculateSubtotal(items) {
  return items.reduce((sum, item) => 
    sum + item.price * item.quantity, 0);
}

function applyDiscount(amount, customer) {
  return customer.isPremium ? amount * 0.9 : amount;
}
```

### Replace Conditional with Polymorphism
**Before:**
```python
def calculate_pay(employee):
    if employee.type == "manager":
        return employee.salary + employee.bonus
    elif employee.type == "engineer":
        return employee.salary + employee.stock_options
    else:
        return employee.salary
```

**After:**
```python
class Employee:
    def calculate_pay(self):
        return self.salary

class Manager(Employee):
    def calculate_pay(self):
        return self.salary + self.bonus

class Engineer(Employee):
    def calculate_pay(self):
        return self.salary + self.stock_options
```

### Extract Constant
**Before:**
```javascript
if (age >= 18 && age <= 65) {
  // eligible
}
```

**After:**
```javascript
const MIN_ELIGIBLE_AGE = 18;
const MAX_ELIGIBLE_AGE = 65;

if (age >= MIN_ELIGIBLE_AGE && age <= MAX_ELIGIBLE_AGE) {
  // eligible
}
```

### Introduce Parameter Object
**Before:**
```typescript
function createUser(
  name: string,
  email: string,
  age: number,
  address: string,
  phone: string
) {
  // ...
}
```

**After:**
```typescript
interface UserData {
  name: string;
  email: string;
  age: number;
  address: string;
  phone: string;
}

function createUser(userData: UserData) {
  // ...
}
```

### Replace Magic Number with Named Constant
**Before:**
```go
func calculateDiscount(price float64) float64 {
    return price * 0.15
}
```

**After:**
```go
const LOYALTY_DISCOUNT_RATE = 0.15

func calculateDiscount(price float64) float64 {
    return price * LOYALTY_DISCOUNT_RATE
}
```

### Decompose Conditional
**Before:**
```javascript
if (date.before(SUMMER_START) || date.after(SUMMER_END)) {
  charge = quantity * winterRate + winterServiceCharge;
} else {
  charge = quantity * summerRate;
}
```

**After:**
```javascript
if (isWinter(date)) {
  charge = winterCharge(quantity);
} else {
  charge = summerCharge(quantity);
}

function isWinter(date) {
  return date.before(SUMMER_START) || date.after(SUMMER_END);
}

function winterCharge(quantity) {
  return quantity * winterRate + winterServiceCharge;
}

function summerCharge(quantity) {
  return quantity * summerRate;
}
```

### Replace Nested Conditional with Guard Clauses
**Before:**
```python
def get_payment(employee):
    if employee.is_active:
        if employee.has_salary:
            return employee.salary
        else:
            return 0
    else:
        return 0
```

**After:**
```python
def get_payment(employee):
    if not employee.is_active:
        return 0
    if not employee.has_salary:
        return 0
    return employee.salary
```

## Large-Scale Refactorings

### Split Module
When a file is too large (500+ lines), split by responsibility:
```
user.ts (1000 lines)
↓
user-model.ts (200 lines)
user-service.ts (300 lines)
user-validator.ts (150 lines)
user-utils.ts (100 lines)
```

### Extract Service Layer
Move business logic from controllers:
```
Before: Controller has 500 lines with business logic
After:
  - Controller: 100 lines (request handling)
  - Service: 400 lines (business logic)
```

### Introduce Repository
Abstract database access:
```
Before: Direct SQL/ORM calls throughout code
After: Repository classes handle all data access
```

## Refactoring Workflow

1. **Ensure tests exist** (or write them first)
2. **Make small changes** (one refactoring at a time)
3. **Run tests** after each change
4. **Commit frequently** with clear messages
5. **Don't mix refactoring with feature work**

## Red Flags to Watch For

- **Premature optimization**: Don't refactor for performance without profiling
- **Over-engineering**: Don't add complexity for theoretical future needs
- **Breaking changes**: Be careful with public APIs
- **Scope creep**: Stick to planned refactoring, don't expand mid-work

## Quick Wins

### Low-hanging fruit for immediate improvement:
1. Rename unclear variables
2. Extract magic numbers to constants
3. Remove commented-out code
4. Fix inconsistent formatting
5. Add missing error handling
6. Remove unused imports/functions
7. Simplify boolean expressions

These refactorings make code more maintainable and easier to understand.
