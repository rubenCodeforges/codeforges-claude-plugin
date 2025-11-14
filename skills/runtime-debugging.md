# Runtime Debugging Patterns

Advanced techniques for debugging web application freezes, hangs, and performance issues.

## Common Runtime Issues

### 1. Memory Leaks

**Symptoms:**
- Gradually increasing memory usage
- Browser tab becomes unresponsive over time
- Page crashes with "Aw, Snap!" error

**Common Causes:**
```javascript
// Detached DOM nodes
let elements = [];
document.addEventListener('click', () => {
  const div = document.createElement('div');
  document.body.appendChild(div);
  elements.push(div); // Keeping reference after removal
  document.body.removeChild(div); // DOM node removed but still in memory
});

// Event listener accumulation
class Component {
  constructor() {
    // Missing cleanup in componentWillUnmount/ngOnDestroy
    window.addEventListener('resize', this.handleResize);
  }
}

// Closure traps
function createLeak() {
  const largeData = new Array(1000000).fill('data');
  return function() {
    // largeData is retained even if not used
    console.log('callback');
  };
}
```

**Detection:**
- Use Chrome DevTools Memory Profiler
- Take heap snapshots and compare
- Look for objects with increasing retain counts

### 2. Infinite Loops

**JavaScript Infinite Loops:**
```javascript
// Synchronous infinite loop - blocks immediately
while (condition) {
  // condition never becomes false
}

// Recursive setTimeout - gradual degradation
function loop() {
  // Do something
  setTimeout(loop, 0); // Keeps scheduling
}
```

**Angular Change Detection Loops:**
```typescript
// Component causing infinite change detection
@Component({
  template: '{{ getComputedValue() }}'
})
class BadComponent {
  getComputedValue() {
    // Returns different value each time
    return Math.random(); // Triggers new change detection
  }
}

// Zone.js microtask explosion
someObservable.subscribe(value => {
  this.property = value;
  // Triggers change detection
  this.anotherObservable.next(this.property);
  // Which triggers another change...
});
```

**React Re-render Loops:**
```jsx
// Missing dependencies
function Component() {
  const [state, setState] = useState(0);

  useEffect(() => {
    setState(state + 1); // Missing dependency array
  }); // Runs on every render

  return <div>{state}</div>;
}

// Object/Array recreation
function Parent() {
  // New object every render
  const config = { key: 'value' };

  return <Child config={config} />;
  // Child re-renders every time
}
```

### 3. Main Thread Blocking

**Long-Running JavaScript:**
```javascript
// Heavy computation on main thread
function processLargeDataset(data) {
  for (let i = 0; i < 1000000; i++) {
    // Complex calculations
    data[i] = expensiveOperation(data[i]);
  }
}

// Solution: Use Web Workers
const worker = new Worker('processor.js');
worker.postMessage({ cmd: 'process', data: largeData });
worker.onmessage = (e) => {
  // Handle processed data
};

// Or chunk the work
async function processInChunks(data) {
  const chunkSize = 100;
  for (let i = 0; i < data.length; i += chunkSize) {
    const chunk = data.slice(i, i + chunkSize);
    processChunk(chunk);
    // Yield to browser
    await new Promise(resolve => setTimeout(resolve, 0));
  }
}
```

### 4. Network Request Issues

**Request Queue Blocking:**
```javascript
// Browser limits concurrent requests (6 per domain)
for (let i = 0; i < 100; i++) {
  fetch(`/api/item/${i}`); // Only 6 run in parallel
}

// Solution: Batch requests
const ids = Array.from({ length: 100 }, (_, i) => i);
fetch('/api/items/batch', {
  method: 'POST',
  body: JSON.stringify({ ids })
});
```

**CORS Preflight Accumulation:**
```javascript
// Each cross-origin request triggers OPTIONS
for (let endpoint of endpoints) {
  fetch(endpoint, {
    headers: {
      'Custom-Header': 'value' // Triggers preflight
    }
  });
}
```

## Framework-Specific Patterns

### Angular Debugging

**Zone.js Task Tracking:**
```typescript
// Monitor Zone.js tasks
Zone.current.fork({
  name: 'debugZone',
  onScheduleTask: (delegate, current, target, task) => {
    console.log('Task scheduled:', task.type, task.source);
    return delegate.scheduleTask(target, task);
  },
  onInvokeTask: (delegate, current, target, task, applyThis, applyArgs) => {
    console.log('Task invoked:', task.type);
    return delegate.invokeTask(target, task, applyThis, applyArgs);
  }
}).run(() => {
  // Your Angular app code
});
```

**Change Detection Profiling:**
```typescript
// Enable Angular DevTools Profiler
import { enableDebugTools } from '@angular/platform-browser';
import { ApplicationRef } from '@angular/core';

platformBrowserDynamic().bootstrapModule(AppModule)
  .then(module => {
    const appRef = module.injector.get(ApplicationRef);
    const componentRef = appRef.components[0];
    enableDebugTools(componentRef);
    // Now use: ng.profiler.timeChangeDetection()
  });
```

### React Debugging

**React Profiler API:**
```jsx
import { Profiler } from 'react';

function onRenderCallback(id, phase, actualDuration) {
  console.log(`${id} (${phase}) took ${actualDuration}ms`);
}

<Profiler id="App" onRender={onRenderCallback}>
  <App />
</Profiler>
```

**Why Did You Render:**
```javascript
// Setup why-did-you-render
import React from 'react';
if (process.env.NODE_ENV === 'development') {
  const whyDidYouRender = require('@welldone-software/why-did-you-render');
  whyDidYouRender(React, {
    trackAllPureComponents: true,
  });
}

// Track specific component
Component.whyDidYouRender = true;
```

### Vue Debugging

**Vue Performance Tracking:**
```javascript
// Vue 2
Vue.config.performance = true;

// Vue 3
const app = createApp(App);
app.config.performance = true;

// Now use Performance DevTools to see component timings
```

## Browser APIs for Debugging

### Performance Observer API

```javascript
// Monitor long tasks
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) {
      console.warn('Long task detected:', {
        duration: entry.duration,
        startTime: entry.startTime,
        name: entry.name
      });

      // Send to analytics
      analytics.track('long_task', {
        duration: entry.duration,
        url: window.location.href
      });
    }
  }
});

observer.observe({
  entryTypes: ['longtask', 'measure', 'navigation']
});
```

### Memory API

```javascript
// Monitor memory usage (Chrome only)
if (performance.memory) {
  setInterval(() => {
    const memInfo = performance.memory;
    const usedMB = Math.round(memInfo.usedJSHeapSize / 1048576);
    const totalMB = Math.round(memInfo.totalJSHeapSize / 1048576);
    const limitMB = Math.round(memInfo.jsHeapSizeLimit / 1048576);

    console.log(`Memory: ${usedMB}/${totalMB}MB (limit: ${limitMB}MB)`);

    // Alert if using >90% of limit
    if (memInfo.usedJSHeapSize > memInfo.jsHeapSizeLimit * 0.9) {
      console.error('Memory usage critical!');
    }
  }, 5000);
}
```

### Request Idle Callback

```javascript
// Defer non-critical work
const tasksQueue = [];

function scheduleTasks(tasks) {
  tasksQueue.push(...tasks);
  processTaskQueue();
}

function processTaskQueue(deadline) {
  while (deadline.timeRemaining() > 0 && tasksQueue.length > 0) {
    const task = tasksQueue.shift();
    task();
  }

  if (tasksQueue.length > 0) {
    requestIdleCallback(processTaskQueue);
  }
}

requestIdleCallback(processTaskQueue);
```

## Headless Browser Debugging

### Puppeteer Performance Monitoring

```javascript
const puppeteer = require('puppeteer');

async function analyzePerformance(url) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Enable CDP domains
  const client = await page.target().createCDPSession();
  await client.send('Performance.enable');
  await client.send('Network.enable');

  // Collect metrics
  const metrics = [];

  // Monitor metrics over time
  const interval = setInterval(async () => {
    const { metrics: perfMetrics } = await client.send('Performance.getMetrics');
    const timestamp = Date.now();

    metrics.push({
      timestamp,
      heap: perfMetrics.find(m => m.name === 'JSHeapUsedSize').value,
      documents: perfMetrics.find(m => m.name === 'Documents').value,
      frames: perfMetrics.find(m => m.name === 'Frames').value,
      nodes: perfMetrics.find(m => m.name === 'Nodes').value,
      layoutCount: perfMetrics.find(m => m.name === 'LayoutCount').value,
      jsEventListeners: perfMetrics.find(m => m.name === 'JSEventListeners').value
    });
  }, 1000);

  // Navigate and wait
  await page.goto(url, { waitUntil: 'networkidle0' });
  await page.waitForTimeout(10000);

  clearInterval(interval);

  // Analyze trends
  const analysis = analyzeMetricTrends(metrics);

  await browser.close();
  return analysis;
}

function analyzeMetricTrends(metrics) {
  const heapGrowth = metrics[metrics.length - 1].heap - metrics[0].heap;
  const avgHeapGrowthPerSec = heapGrowth / metrics.length;

  return {
    memoryLeak: avgHeapGrowthPerSec > 100000, // >100KB/s growth
    domLeak: metrics[metrics.length - 1].nodes > 1500,
    listenerLeak: metrics[metrics.length - 1].jsEventListeners > 500,
    metrics: metrics
  };
}
```

### Playwright Network Monitoring

```javascript
const { chromium } = require('playwright');

async function monitorNetworkPerformance(url) {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  const slowRequests = [];
  const failedRequests = [];

  // Monitor all requests
  page.on('request', request => {
    request._startTime = Date.now();
  });

  page.on('response', response => {
    const request = response.request();
    const duration = Date.now() - request._startTime;

    if (duration > 3000) {
      slowRequests.push({
        url: request.url(),
        method: request.method(),
        duration: duration,
        status: response.status()
      });
    }
  });

  page.on('requestfailed', request => {
    failedRequests.push({
      url: request.url(),
      method: request.method(),
      failure: request.failure()
    });
  });

  await page.goto(url);
  await page.waitForTimeout(10000);

  await browser.close();

  return { slowRequests, failedRequests };
}
```

## Production Monitoring

### Client-Side Monitoring Script

```javascript
// Add to your production app
(function() {
  const perfData = {
    longTasks: [],
    errors: [],
    metrics: []
  };

  // Long task monitoring
  if (window.PerformanceObserver) {
    new PerformanceObserver((list) => {
      for (const entry of list.getEntries()) {
        perfData.longTasks.push({
          duration: entry.duration,
          timestamp: Date.now()
        });

        // Send to backend if critical
        if (entry.duration > 1000) {
          sendToAnalytics('critical_long_task', {
            duration: entry.duration,
            url: window.location.href
          });
        }
      }
    }).observe({ entryTypes: ['longtask'] });
  }

  // Error monitoring
  window.addEventListener('error', (e) => {
    perfData.errors.push({
      message: e.message,
      stack: e.error?.stack,
      timestamp: Date.now()
    });

    sendToAnalytics('js_error', {
      message: e.message,
      url: window.location.href
    });
  });

  // Periodic metrics collection
  setInterval(() => {
    if (performance.memory) {
      perfData.metrics.push({
        heap: performance.memory.usedJSHeapSize,
        timestamp: Date.now()
      });
    }
  }, 10000);

  // Send aggregated data on page unload
  window.addEventListener('beforeunload', () => {
    navigator.sendBeacon('/api/performance', JSON.stringify(perfData));
  });

  function sendToAnalytics(event, data) {
    // Your analytics implementation
    if (typeof gtag !== 'undefined') {
      gtag('event', event, data);
    }
  }
})();
```

## Quick Diagnosis Checklist

When app freezes/hangs:

1. **Check Console**: Any errors or warnings?
2. **Check Network Tab**: Pending requests?
3. **Check Performance Tab**: Recording shows long tasks?
4. **Check Memory Tab**: Heap size growing?
5. **Framework DevTools**:
   - Angular: Check Zone.js tasks
   - React: Check component renders
   - Vue: Check watcher count
6. **Take Heap Snapshot**: Compare before/after
7. **Record CPU Profile**: Identify hot functions
8. **Check Event Listeners**: Growing count?
9. **Inspect DOM**: Node count excessive?
10. **Test in Incognito**: Extensions causing issues?

## Best Practices

1. **Always clean up**:
   - Remove event listeners
   - Cancel timers/intervals
   - Unsubscribe from observables
   - Clear WeakMaps/WeakSets

2. **Optimize renders**:
   - Use React.memo/useMemo
   - Use Angular OnPush strategy
   - Use Vue computed properties

3. **Defer work**:
   - Use requestIdleCallback
   - Use Web Workers
   - Implement virtual scrolling

4. **Monitor production**:
   - Add performance monitoring
   - Track key metrics
   - Set up alerts

5. **Test performance**:
   - Use Lighthouse CI
   - Add performance budgets
   - Test on slow devices