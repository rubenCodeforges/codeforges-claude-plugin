---
name: performance-patterns
description: Performance optimization patterns and common bottlenecks across languages. Auto-loaded when discussing performance or optimization.
---

# Performance Optimization Patterns

## Common Performance Bottlenecks

### 1. N+1 Query Problem
**Problem**: Making a separate database query for each item in a loop

**Bad:**
```python
# Django ORM
users = User.objects.all()
for user in users:
    print(user.profile.bio)  # Separate query for each user!
```

**Good:**
```python
users = User.objects.select_related('profile').all()
for user in users:
    print(user.profile.bio)  # Single query with JOIN
```

### 2. Unnecessary Re-renders (React)
**Bad:**
```jsx
function Component({ items }) {
  // This creates new object every render!
  const config = { limit: 10, offset: 0 };
  return <List items={items} config={config} />;
}
```

**Good:**
```jsx
const DEFAULT_CONFIG = { limit: 10, offset: 0 };

function Component({ items }) {
  return <List items={items} config={DEFAULT_CONFIG} />;
}

// Or use useMemo for computed values
const config = useMemo(() => ({ 
  limit: 10, 
  offset: page * 10 
}), [page]);
```

### 3. Synchronous Operations in Loops
**Bad:**
```javascript
// Sequential - takes 5 seconds for 5 items
for (const item of items) {
  await fetchData(item);  // 1 second each
}
```

**Good:**
```javascript
// Parallel - takes ~1 second total
await Promise.all(items.map(item => fetchData(item)));

// Or with concurrency limit
const pLimit = require('p-limit');
const limit = pLimit(5);
await Promise.all(items.map(item => limit(() => fetchData(item))));
```

### 4. Large Bundle Sizes
**Bad:**
```javascript
import _ from 'lodash';  // Imports entire library (71KB)
import moment from 'moment';  // 289KB!
```

**Good:**
```javascript
import debounce from 'lodash/debounce';  // Only what you need
import { format } from 'date-fns';  // 12KB vs 289KB
```

### 5. Inefficient Algorithms
**Bad:** O(n²)
```python
def has_duplicates(arr):
    for i in range(len(arr)):
        for j in range(i+1, len(arr)):
            if arr[i] == arr[j]:
                return True
    return False
```

**Good:** O(n)
```python
def has_duplicates(arr):
    return len(arr) != len(set(arr))
```

## Optimization Techniques

### Caching

#### Memoization
```javascript
const cache = new Map();

function expensiveCalculation(n) {
  if (cache.has(n)) {
    return cache.get(n);
  }
  
  const result = /* expensive work */;
  cache.set(n, result);
  return result;
}
```

#### React Query / SWR
```javascript
// Automatic caching, deduplication, and background refetching
const { data } = useQuery('users', fetchUsers);
```

#### HTTP Caching
```javascript
// Set cache headers
res.set('Cache-Control', 'public, max-age=3600');
```

### Lazy Loading

#### Dynamic Imports
```javascript
// Instead of importing at top
// import HeavyComponent from './HeavyComponent';

// Load only when needed
const HeavyComponent = lazy(() => import('./HeavyComponent'));

<Suspense fallback={<Spinner />}>
  <HeavyComponent />
</Suspense>
```

#### Image Lazy Loading
```html
<img src="image.jpg" loading="lazy" />
```

### Debouncing & Throttling

```javascript
// Debounce: Wait until user stops typing
const debouncedSearch = debounce((query) => {
  searchAPI(query);
}, 300);

// Throttle: Execute at most once per interval
const throttledScroll = throttle(() => {
  handleScroll();
}, 100);
```

### Database Optimization

#### Index Critical Columns
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);
```

#### Use Pagination
```javascript
// Bad: Load all records
const users = await User.find();

// Good: Paginate
const users = await User.find()
  .limit(20)
  .skip(page * 20);
```

#### Eager Loading
```python
# Django: Avoid N+1
posts = Post.objects.select_related('author').prefetch_related('comments')

# SQLAlchemy
posts = session.query(Post).options(
    joinedload(Post.author),
    subqueryload(Post.comments)
).all()
```

### Frontend Optimization

#### Virtual Scrolling
```jsx
// For long lists, only render visible items
import { FixedSizeList } from 'react-window';

<FixedSizeList
  height={600}
  itemCount={10000}
  itemSize={35}
>
  {Row}
</FixedSizeList>
```

#### Code Splitting
```javascript
// Webpack
const routes = [
  {
    path: '/dashboard',
    component: () => import('./Dashboard'),
  },
  {
    path: '/profile',
    component: () => import('./Profile'),
  },
];
```

#### Web Workers
```javascript
// Offload heavy computation
const worker = new Worker('worker.js');
worker.postMessage(hugeDataset);
worker.onmessage = (e) => {
  console.log('Result:', e.data);
};
```

## Language-Specific Optimizations

### JavaScript/TypeScript
- Use `Set` for lookups instead of `Array.includes()`
- Use `Map` instead of objects for frequent additions/deletions
- Avoid `delete` operator, set to `undefined` instead
- Use `for` loops instead of `.forEach()` for hot paths

### Python
- Use list comprehensions instead of loops
- Use generators for large datasets
- Use `__slots__` for classes with many instances
- Use `set` for membership testing

### Go
- Reuse buffers instead of allocating new ones
- Use sync.Pool for frequently allocated objects
- Prefer value types over pointers for small structs
- Use buffered channels appropriately

### Java
- Use `StringBuilder` for string concatenation in loops
- Prefer `ArrayList` over `LinkedList` (usually)
- Use primitive types instead of wrappers when possible
- Set appropriate initial capacity for collections

## Performance Monitoring

### Profiling Tools
- **JavaScript**: Chrome DevTools, Lighthouse
- **Python**: cProfile, py-spy
- **Go**: pprof
- **Java**: JProfiler, VisualVM

### Key Metrics
- **Time to First Byte (TTFB)**: Server response time
- **First Contentful Paint (FCP)**: When content appears
- **Largest Contentful Paint (LCP)**: Main content loaded (<2.5s)
- **Time to Interactive (TTI)**: When page is interactive
- **Total Blocking Time (TBT)**: How long main thread is blocked

### Quick Checks
```bash
# Measure API response time
time curl https://api.example.com/endpoint

# Check bundle size
npx webpack-bundle-analyzer dist/stats.json

# Profile Python script
python -m cProfile -s cumtime script.py

# Memory usage
/usr/bin/time -v ./program
```

## Golden Rules

1. **Profile before optimizing** - Measure, don't guess
2. **Optimize the critical path** - Focus on what users experience
3. **Start with algorithms** - O(n²) → O(n log n) matters more than micro-optimizations
4. **Cache intelligently** - But watch for stale data
5. **Lazy load everything possible** - Don't load what you don't need
6. **Monitor in production** - Real user performance matters most

Remember: Premature optimization is the root of all evil. Focus on bottlenecks, not micro-optimizations.
