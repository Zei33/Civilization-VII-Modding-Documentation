# Architecture Overview

This document provides an overview of the architecture of Coherent UI.

## Table of Contents

- [Multiprocess Architecture](#multiprocess-architecture)
- [Asynchronous Design](#asynchronous-design)
- [Thread Safety](#thread-safety)

## Multiprocess Architecture

In order to exploit the full capabilities of the underlying platform, Coherent UI has a multiprocess architecture. It consists of the following processes:

1. **Host Process** - This is the process that communicates with your game and all the other processes of Coherent UI.

2. **Render Process** - This is the process that performs the layout of the view. All JavaScript runs in this process. There is one Render process per view.

3. **GPU Process** - This is the process that draws the view on the GPU. There may be only one GPU process.

This multiprocess architecture provides isolation and stability. If one view crashes, it won't affect the rest of your game or other UI views.

## Asynchronous Design

Almost everything in Coherent UI is asynchronous. Most calls to Coherent UI require a callback or listener that will be notified when the result is ready or some event has occurred.

> **Note:** *All* callbacks are executed and *all* listeners are notified **inside** the `Coherent::UI::ViewContext::Update` method.

This asynchronous design allows your game to continue running smoothly while UI operations are being processed. It also enables complex UI interactions without blocking the main game thread.

## Thread Safety

Coherent UI is **not** thread safe, except for parts that are explicitly marked as such. All view manipulations and events triggering must always happen in the same thread that calls `Coherent::UI::ViewContext::Update`.

However, to support applications with multi-threaded rendering architectures, Coherent UI supports fetching surfaces from a thread different than the one that calls `ViewContext::Update`. This results in the `ViewListener::OnDraw` callback being executed on that other thread.

Rendering resource creation and destruction can also happen in secondary threads through the response object mechanism.

### Thread Safety Guidelines

1. Always call `ViewContext::Update` from the same thread
2. Keep all UI manipulation code in the same thread as `ViewContext::Update`
3. Rendering operations can be safely performed from a separate thread
4. Use thread-safe mechanisms for any communication between the UI thread and render thread

## Architecture Diagram

```
+-------------------+      +-------------------+      +-------------------+
|                   |      |                   |      |                   |
|     Your Game     |<---->|    Host Process   |<---->|   GPU Process     |
|                   |      |                   |      |                   |
+-------------------+      +-------------------+      +-------------------+
                                   ^
                                   |
                                   v
                           +-------------------+
                           |                   |
                           | Render Process(es)|
                           |    (one per view) |
                           +-------------------+
```

## See Also

- [View Types](View_Types.md)
- [Rendering Integration](Rendering_Integration.md)
- [Best Practices](Best_Practices.md) 