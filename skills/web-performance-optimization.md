---
name: web-performance-optimization
description: Comprehensive guide to web performance optimization techniques, Core Web Vitals, and best practices across frameworks
---

# Web Performance Optimization Guide

This skill provides comprehensive knowledge about web performance optimization, Core Web Vitals, and practical techniques for improving website speed and user experience.

## Core Web Vitals

### 1. Largest Contentful Paint (LCP)

**What it measures:** Loading performance - time until the largest content element is visible.

**Good:** < 2.5s | **Needs Improvement:** 2.5s - 4.0s | **Poor:** > 4.0s

**Common causes of poor LCP:**
- Slow server response times
- Render-blocking JavaScript and CSS
- Slow resource load times
- Client-side rendering

**Optimization strategies:**

```html
<!-- Preload critical resources -->
<link rel="preload" as="image" href="hero-image.jpg">
<link rel="preload" as="font" href="font.woff2" type="font/woff2" crossorigin>

<!-- Optimize images -->
<img src="hero.webp" alt="Hero" loading="eager" fetchpriority="high">

<!-- Lazy load below-the-fold images -->
<img src="image.jpg" loading="lazy" alt="Description">
```

```javascript
// Implement adaptive loading based on network
if (navigator.connection && navigator.connection.effectiveType === '4g') {
    // Load high-res images
} else {
    // Load lower-res images
}
```

### 2. First Input Delay (FID) / Interaction to Next Paint (INP)

**What it measures:** Interactivity - time from first user interaction to browser response.

**Good (FID):** < 100ms | **Needs Improvement:** 100ms - 300ms | **Poor:** > 300ms
**Good (INP):** < 200ms | **Needs Improvement:** 200ms - 500ms | **Poor:** > 500ms

**Common causes:**
- Heavy JavaScript execution
- Long tasks blocking main thread
- Large bundle sizes

**Optimization strategies:**

```javascript
// Code splitting - load only what's needed
import('./heavy-module.js').then(module => {
    module.init();
});

// Use web workers for heavy computation
const worker = new Worker('worker.js');
worker.postMessage({data: largeDataset});

// Debounce expensive operations
const debouncedSearch = debounce((query) => {
    performSearch(query);
}, 300);

// Use requestIdleCallback for non-critical work
requestIdleCallback(() => {
    analytics.track('page_view');
});
```

### 3. Cumulative Layout Shift (CLS)

**What it measures:** Visual stability - unexpected layout shifts during page load.

**Good:** < 0.1 | **Needs Improvement:** 0.1 - 0.25 | **Poor:** > 0.25

**Common causes:**
- Images without dimensions
- Dynamically injected content
- Web fonts causing FOIT/FOUT
- Ads, embeds, iframes

**Optimization strategies:**

```html
<!-- Always specify image dimensions -->
<img src="image.jpg" width="800" height="600" alt="Description">

<!-- Use aspect-ratio CSS for responsive images -->
<style>
.responsive-image {
    width: 100%;
    aspect-ratio: 16 / 9;
    object-fit: cover;
}
</style>

<!-- Reserve space for dynamic content -->
<div style="min-height: 400px;">
    <!-- Content loaded here -->
</div>

<!-- Font loading strategies -->
<link rel="preload" as="font" href="font.woff2" type="font/woff2" crossorigin>
<style>
@font-face {
    font-family: 'CustomFont';
    src: url('font.woff2') format('woff2');
    font-display: swap; /* or optional */
}
</style>
```

## Performance Optimization Techniques

### 1. Resource Optimization

#### Image Optimization

```bash
# Convert to WebP (90% smaller than JPEG)
cwebp input.jpg -q 80 -o output.webp

# Generate responsive images
convert input.jpg -resize 400x output-400w.jpg
convert input.jpg -resize 800x output-800w.jpg
convert input.jpg -resize 1200x output-1200w.jpg
```

```html
<!-- Responsive images with WebP -->
<picture>
    <source type="image/webp" srcset="image-400.webp 400w, image-800.webp 800w, image-1200.webp 1200w">
    <source type="image/jpeg" srcset="image-400.jpg 400w, image-800.jpg 800w, image-1200.jpg 1200w">
    <img src="image-800.jpg" alt="Description" loading="lazy">
</picture>
```

#### JavaScript Optimization

```javascript
// Tree shaking - import only what you need
import { debounce } from 'lodash-es'; // Good
// import _ from 'lodash'; // Bad - imports everything

// Dynamic imports for route-based code splitting
const Home = lazy(() => import('./pages/Home'));
const About = lazy(() => import('./pages/About'));

// Minimize third-party scripts
// Use Partytown for offloading to web worker
<script type="text/partytown">
    // Analytics, ads, etc. run in worker
</script>
```

#### CSS Optimization

```html
<!-- Inline critical CSS -->
<style>
    /* Above-the-fold styles only */
    .header { display: flex; }
    .hero { min-height: 400px; }
</style>

<!-- Defer non-critical CSS -->
<link rel="preload" href="styles.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="styles.css"></noscript>

<!-- Remove unused CSS -->
<!-- Use PurgeCSS, UnCSS, or built-in framework tools -->
```

### 2. Network Optimization

#### Compression

```nginx
# Enable gzip/brotli compression (nginx)
gzip on;
gzip_types text/plain text/css application/json application/javascript;
gzip_min_length 1000;

# Brotli (better compression)
brotli on;
brotli_types text/plain text/css application/json application/javascript;
```

#### HTTP/2 & HTTP/3

```nginx
# Enable HTTP/2
listen 443 ssl http2;

# Enable HTTP/3 (QUIC)
listen 443 quic reuseport;
add_header Alt-Svc 'h3=":443"; ma=86400';
```

#### Caching Strategy

```javascript
// Service Worker caching
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open('v1').then((cache) => {
            return cache.addAll([
                '/',
                '/styles.css',
                '/script.js',
                '/logo.svg'
            ]);
        })
    );
});

// Cache-first strategy for static assets
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request);
        })
    );
});
```

```nginx
# HTTP caching headers
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### 3. Rendering Optimization

#### Critical Rendering Path

```html
<!-- Optimize the critical rendering path -->
<!DOCTYPE html>
<html>
<head>
    <!-- Preconnect to required origins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="dns-prefetch" href="https://analytics.example.com">

    <!-- Inline critical CSS -->
    <style>/* Critical styles */</style>

    <!-- Async non-critical CSS -->
    <link rel="preload" href="non-critical.css" as="style" onload="this.rel='stylesheet'">
</head>
<body>
    <!-- Content -->

    <!-- Defer JavaScript -->
    <script defer src="app.js"></script>
</body>
</html>
```

#### Server-Side Rendering (SSR) vs Client-Side Rendering (CSR)

```javascript
// Next.js - Hybrid approach
export async function getServerSideProps() {
    // Fetch data on server
    const data = await fetch('https://api.example.com/data');
    return { props: { data } };
}

// Static generation for faster TTFB
export async function getStaticProps() {
    const data = await fetch('https://api.example.com/data');
    return {
        props: { data },
        revalidate: 60 // ISR - revalidate every 60s
    };
}
```

### 4. Framework-Specific Optimizations

#### React

```javascript
// Lazy load components
const HeavyComponent = lazy(() => import('./HeavyComponent'));

// Memoization
const MemoizedComponent = React.memo(({ data }) => {
    return <div>{data}</div>;
});

// useMemo for expensive computations
const expensiveValue = useMemo(() => {
    return computeExpensiveValue(a, b);
}, [a, b]);

// useCallback for function references
const handleClick = useCallback(() => {
    doSomething(a);
}, [a]);

// Virtualization for long lists
import { FixedSizeList } from 'react-window';

<FixedSizeList
    height={400}
    itemCount={1000}
    itemSize={50}
>
    {Row}
</FixedSizeList>
```

#### Vue

```javascript
// Async components
const AsyncComponent = defineAsyncComponent(() =>
    import('./HeavyComponent.vue')
);

// Keep-alive for component caching
<keep-alive>
    <component :is="currentView" />
</keep-alive>

// v-once for static content
<div v-once>{{ staticContent }}</div>

// Virtual scrolling
import { RecycleScroller } from 'vue-virtual-scroller';

<RecycleScroller
    :items="items"
    :item-size="50"
>
</RecycleScroller>
```

#### Angular

```typescript
// Lazy loading routes
const routes: Routes = [
    {
        path: 'feature',
        loadChildren: () => import('./feature/feature.module').then(m => m.FeatureModule)
    }
];

// OnPush change detection
@Component({
    selector: 'app-component',
    changeDetection: ChangeDetectionStrategy.OnPush
})

// TrackBy for *ngFor
<div *ngFor="let item of items; trackBy: trackByFn">
    {{ item.name }}
</div>

trackByFn(index, item) {
    return item.id;
}
```

## Database & Backend Optimization

### N+1 Query Problem

```javascript
// Bad - N+1 queries
const users = await User.findAll();
for (const user of users) {
    const posts = await Post.findAll({ where: { userId: user.id } });
}

// Good - Single query with join
const users = await User.findAll({
    include: [{ model: Post }]
});
```

### Caching Strategies

```javascript
// Redis caching
const cached = await redis.get(`user:${id}`);
if (cached) {
    return JSON.parse(cached);
}

const user = await db.users.findById(id);
await redis.set(`user:${id}`, JSON.stringify(user), 'EX', 3600);
return user;

// Memoization
const memoize = (fn) => {
    const cache = new Map();
    return (...args) => {
        const key = JSON.stringify(args);
        if (cache.has(key)) return cache.get(key);
        const result = fn(...args);
        cache.set(key, result);
        return result;
    };
};
```

### Database Indexing

```sql
-- Create indexes for frequently queried columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Composite indexes for multi-column queries
CREATE INDEX idx_posts_user_date ON posts(user_id, created_at);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM posts WHERE user_id = 123;
```

## Performance Monitoring

### Real User Monitoring (RUM)

```javascript
// Web Vitals API
import {getCLS, getFID, getFCP, getLCP, getTTFB} from 'web-vitals';

getCLS(console.log);
getFID(console.log);
getFCP(console.log);
getLCP(console.log);
getTTFB(console.log);

// Send to analytics
function sendToAnalytics({name, value, id}) {
    analytics.track('web-vital', {
        metric: name,
        value: Math.round(value),
        id
    });
}

getCLS(sendToAnalytics);
getLCP(sendToAnalytics);
```

### Performance Observer API

```javascript
// Observe long tasks
const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        if (entry.duration > 50) {
            console.warn('Long task detected:', entry);
        }
    }
});
observer.observe({entryTypes: ['longtask']});

// Monitor resource timing
new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        console.log('Resource:', entry.name, 'Duration:', entry.duration);
    }
}).observe({entryTypes: ['resource']});
```

## Common Performance Anti-Patterns

### 1. Blocking the Main Thread

```javascript
// Bad - blocks UI
for (let i = 0; i < 1000000; i++) {
    // Heavy computation
}

// Good - chunk work
function processInChunks(data, chunkSize = 100) {
    let index = 0;

    function processChunk() {
        const chunk = data.slice(index, index + chunkSize);
        // Process chunk

        index += chunkSize;
        if (index < data.length) {
            requestIdleCallback(processChunk);
        }
    }

    processChunk();
}
```

### 2. Memory Leaks

```javascript
// Bad - creates memory leak
class Component {
    constructor() {
        setInterval(() => {
            this.updateState();
        }, 1000);
    }
}

// Good - cleanup
class Component {
    constructor() {
        this.interval = setInterval(() => {
            this.updateState();
        }, 1000);
    }

    destroy() {
        clearInterval(this.interval);
    }
}
```

### 3. Excessive Re-renders

```javascript
// Bad - re-renders on every parent update
function Child({ items }) {
    return items.map(item => <div key={item.id}>{item.name}</div>);
}

// Good - memoized
const Child = React.memo(function Child({ items }) {
    return items.map(item => <div key={item.id}>{item.name}</div>);
}, (prevProps, nextProps) => {
    return prevProps.items === nextProps.items;
});
```

## Performance Budget

Set and enforce performance budgets:

```json
{
  "budgets": [
    {
      "resourceSizes": [
        {"resourceType": "script", "budget": 300},
        {"resourceType": "image", "budget": 500},
        {"resourceType": "stylesheet", "budget": 50}
      ],
      "resourceCounts": [
        {"resourceType": "third-party", "budget": 10}
      ],
      "timings": [
        {"metric": "interactive", "budget": 3000},
        {"metric": "first-contentful-paint", "budget": 1500}
      ]
    }
  ]
}
```

## Testing Tools

- **Lighthouse**: Automated audits
- **WebPageTest**: Real device testing
- **Chrome DevTools**: Performance profiling
- **bundlephobia.com**: Check package sizes
- **web.dev**: Best practices and guides

## Key Takeaways

1. **Measure first**: Use Lighthouse, Web Vitals, RUM
2. **Optimize critical path**: Inline critical CSS, defer JS
3. **Reduce bundle size**: Code splitting, tree shaking
4. **Optimize images**: WebP, lazy loading, responsive images
5. **Cache effectively**: Service workers, HTTP caching
6. **Minimize main thread work**: Web workers, chunking
7. **Monitor continuously**: Real user monitoring
8. **Set budgets**: Enforce performance standards
