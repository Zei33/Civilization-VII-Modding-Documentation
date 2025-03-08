# View Types

Coherent UI supports different types of views to accommodate various performance and rendering needs. This guide explains the different view types and when to use each one.

## Overview

Coherent UI provides two main types of views:

1. **Buffered Views** - Views that continuously render their content
2. **On-Demand Views** - Views that only render when their content changes

Each type has specific use cases and performance characteristics.

## Buffered Views

Buffered views are the default view type in Coherent UI. They continuously render their content at a specified frame rate, regardless of whether the content has changed.

### Characteristics

- Content is constantly rendered
- Animation and video playback are smooth
- Use more system resources (CPU, GPU, memory)
- Ideal for dynamic UIs with frequent updates

### When to Use

Buffered views are best suited for:

- UIs with frequent animations or transitions
- Interfaces that display real-time data
- Views that contain video or dynamic content
- Main game HUDs and interfaces that are always visible

### Configuration

To create a buffered view, simply use the default `ViewInfo` settings:

```cpp
Coherent::UI::ViewInfo info;
info.Width = 800;
info.Height = 600;
info.UsesSharedMemory = false;  // Use GPU textures when possible
info.IsBuffered = true;  // Default is true, so this is optional

// Create the view
Coherent::UI::View* view = viewContext->CreateView(info, L"coui://ui/main.html", &viewListener);
```

You can also specify a target frame rate for buffered views:

```cpp
info.FPS = 30;  // Set to 30 frames per second
```

## On-Demand Views

On-demand views only render when their content changes, either due to a JavaScript event, a CSS animation, or an explicit request to redraw. This makes them more efficient in terms of CPU and GPU usage.

### Characteristics

- Only render when content changes
- Use fewer system resources
- May appear less smooth for animations
- Require special consideration for interactive elements

### When to Use

On-demand views are best suited for:

- Static UIs with infrequent updates
- Menus, inventory screens, or other occasionally used interfaces
- UIs with no animations or simple transitions
- Systems with limited resources where performance is critical

### Configuration

To create an on-demand view, set the `IsBuffered` property to `false`:

```cpp
Coherent::UI::ViewInfo info;
info.Width = 800;
info.Height = 600;
info.UsesSharedMemory = false;
info.IsBuffered = false;  // Create an on-demand view

// Create the view
Coherent::UI::View* view = viewContext->CreateView(info, L"coui://ui/inventory.html", &viewListener);
```

### Triggering Redraws

For on-demand views, you need to explicitly request redraws when the content changes. You can do this from JavaScript:

```javascript
// This will cause the view to redraw
engine.trigger('Coherent.UI.Redraw');
```

Or from C++:

```cpp
// Trigger a redraw from C++
view->TriggerEvent("Coherent.UI.Redraw");
```

### JavaScript Considerations

When using on-demand views, you should structure your JavaScript code to request redraws when needed:

```javascript
function updateInventory(items) {
	// Update the DOM
	var container = document.getElementById('inventoryItems');
	container.innerHTML = '';
	
	for (var i = 0; i < items.length; i++) {
		var item = items[i];
		var element = document.createElement('div');
		element.className = 'item';
		element.innerHTML = item.name;
		container.appendChild(element);
	}
	
	// Request a redraw
	engine.trigger('Coherent.UI.Redraw');
}
```

## Performance Considerations

### Memory Usage

- Buffered views use more memory as they maintain rendering resources continuously
- On-demand views use memory more efficiently as they only allocate resources when needed

### CPU and GPU Usage

- Buffered views have a constant CPU and GPU cost
- On-demand views only use CPU and GPU resources when redrawing

### Responsiveness

- Buffered views appear more responsive as they are always rendering
- On-demand views may have a slight delay when interacting after a period of inactivity

## Switching Between View Types

You cannot change a view's type after creation. If you need to switch between buffered and on-demand rendering, you should:

1. Destroy the current view
2. Create a new view with the desired type
3. Load the same URL in the new view

```cpp
// Destroy the current view
currentView->Destroy();

// Create a new view with a different type
Coherent::UI::ViewInfo info;
info.Width = width;
info.Height = height;
info.UsesSharedMemory = false;
info.IsBuffered = !wasBuffered;  // Switch the view type

// Create the new view
Coherent::UI::View* newView = viewContext->CreateView(info, url, &viewListener);
```

## Best Practices

1. **Use Buffered Views for Primary Interfaces**: For main game HUDs and frequently used interfaces, use buffered views for better responsiveness.

2. **Use On-Demand Views for Secondary Interfaces**: For menus, inventory screens, and other occasionally used interfaces, use on-demand views to save resources.

3. **Consider Resource Limitations**: On platforms with limited resources, prefer on-demand views where possible.

4. **Test Both Options**: In some cases, the performance difference may not be significant. Test both options to determine the best approach for your specific UI.

5. **Coordinate Redraws**: For on-demand views, coordinate redraws to minimize the number of rendering passes. Group DOM updates before requesting a redraw.

## See Also

- [ViewInfo API](../API%20Reference/ViewInfo.md)
- [View API](../API%20Reference/View.md)
- [Best Practices](Best_Practices.md)
- [On-Demand Views Sample](../Samples/On_Demand_Views.md) 