# ViewContext

The `ViewContext` is the central class in Coherent UI that handles the creation and management of UI views.

## Namespace

```cpp
namespace Coherent::UI
```

## Class Definition

```cpp
class ViewContext
```

## Description

The `ViewContext` class is responsible for creating and managing UI views, handling their lifecycle, and processing events. It serves as the main interface between your game and the Coherent UI system.

## Methods

### Initialize

```cpp
bool Initialize(const ContextSettings& settings);
```

Initializes the ViewContext with the specified settings.

#### Parameters
- `settings`: The settings for the context.

#### Returns
`true` if initialization was successful, `false` otherwise.

### Uninitialize

```cpp
void Uninitialize();
```

Uninitializes the ViewContext and releases all resources.

### CreateView

```cpp
View* CreateView(const ViewInfo& info, const wchar_t* url, ViewListener* listener);
```

Creates a new view with the specified parameters.

#### Parameters
- `info`: Information about the view to be created.
- `url`: The URL to load in the view.
- `listener`: The listener for view events.

#### Returns
A pointer to the created `View` or `nullptr` if creation failed.

### Update

```cpp
void Update();
```

Updates the ViewContext, processing all pending events.

### FetchSurfaces

```cpp
void FetchSurfaces();
```

Fetches available surfaces for rendering.

### SetIMEPosition

```cpp
void SetIMEPosition(int x, int y);
```

Sets the position of the Input Method Editor.

#### Parameters
- `x`: The x-coordinate of the IME.
- `y`: The y-coordinate of the IME.

## Example Usage

```cpp
// Initialize the ViewContext
Coherent::UI::ContextSettings settings;
settings.DebuggerPort = 1234;  // Enable debugging on port 1234
Coherent::UI::ViewContext* context = factory->CreateViewContext(settings, &listener, nullptr);

// Create a view
Coherent::UI::ViewInfo info;
info.Width = 800;
info.Height = 600;
info.UsesSharedMemory = false;
Coherent::UI::View* view = context->CreateView(info, L"coui://html/interface.html", &viewListener);

// In the main loop
while (running) {
	// Process events
	context->Update();
	
	// Render the UI
	context->FetchSurfaces();
	
	// ... Game rendering code ...
}

// Cleanup
context->Uninitialize();
```

## See Also

- [View](View.md)
- [ViewInfo](ViewInfo.md)
- [ViewListener](ViewListener.md)
- [EventListener](EventListener.md) 