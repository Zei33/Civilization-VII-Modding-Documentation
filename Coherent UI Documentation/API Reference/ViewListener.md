# ViewListener

The `ViewListener` is an interface that allows your application to receive notifications about view-related events, such as view creation, navigation, loading, and surface management.

## Namespace

```cpp
namespace Coherent::UI
```

## Class Definition

```cpp
class ViewListener
```

## Description

The `ViewListener` class is an interface (abstract base class) that your application must implement to handle view-related events. When you create a view using `ViewContext::CreateView`, you provide a pointer to your `ViewListener` implementation.

The methods in this interface are called by Coherent UI when certain events occur, such as when a view is ready, when a page has loaded, or when rendering surfaces need to be created or destroyed.

## Methods

### CreateSurface

```cpp
virtual void CreateSurface(bool usesSharedMemory, unsigned width, unsigned height, SurfaceResponse* response) = 0;
```

Called when Coherent UI needs a new surface to render content.

#### Parameters
- `usesSharedMemory`: Whether to use shared memory (`true`) or shared textures (`false`).
- `width`: The width of the surface in pixels.
- `height`: The height of the surface in pixels.
- `response`: A pointer to a `SurfaceResponse` object that must be signaled with the created surface.

#### Implementation Notes
- Your implementation should create a rendering surface of the specified dimensions.
- For shared memory, allocate a block of memory.
- For shared textures, create a texture and obtain a handle to it.
- Call `response->Signal(handle)` with the handle to your created surface.

### DestroySurface

```cpp
virtual void DestroySurface(CoherentHandle surface, bool usesSharedMemory) = 0;
```

Called when a surface is no longer needed and should be destroyed.

#### Parameters
- `surface`: The handle to the surface that should be destroyed.
- `usesSharedMemory`: Whether the surface uses shared memory.

#### Implementation Notes
- Release the resources associated with the surface.
- For shared memory, close and unlink the shared memory.
- For shared textures, destroy the texture.

### OnDraw

```cpp
virtual void OnDraw(CoherentHandle surface, bool usesSharedMemory, int width, int height) = 0;
```

Called when Coherent UI has finished drawing to a surface and it's ready to be used by your application.

#### Parameters
- `surface`: The handle to the surface that has been drawn.
- `usesSharedMemory`: Whether the surface uses shared memory.
- `width`: The width of the drawn content in pixels.
- `height`: The height of the drawn content in pixels.

#### Implementation Notes
- For shared memory, map the memory, copy the content to a texture, then unmap.
- For shared textures, the content is already on the GPU and can be used directly.

### ViewCreated

```cpp
virtual void ViewCreated(View* view) = 0;
```

Called when a view has been created.

#### Parameters
- `view`: A pointer to the created view.

### ViewReady

```cpp
virtual void ViewReady(View* view) = 0;
```

Called when a view is ready to be used.

#### Parameters
- `view`: A pointer to the ready view.

### BeforeViewDestroyed

```cpp
virtual void BeforeViewDestroyed(View* view) = 0;
```

Called before a view is destroyed.

#### Parameters
- `view`: A pointer to the view that will be destroyed.

### FinishViewDestroyed

```cpp
virtual void FinishViewDestroyed(View* view) = 0;
```

Called after a view has been destroyed.

#### Parameters
- `view`: A pointer to the view that was destroyed.

### NavigationBegin

```cpp
virtual void NavigationBegin(View* view, const wchar_t* url) = 0;
```

Called when navigation to a new URL begins.

#### Parameters
- `view`: A pointer to the view that is navigating.
- `url`: The URL to which navigation has begun.

### NavigationComplete

```cpp
virtual void NavigationComplete(View* view, const wchar_t* url, bool success) = 0;
```

Called when navigation to a URL completes.

#### Parameters
- `view`: A pointer to the view that completed navigation.
- `url`: The URL to which navigation was attempted.
- `success`: Whether the navigation was successful.

### LoadEnd

```cpp
virtual void LoadEnd(View* view, const wchar_t* url, bool success, int statusCode) = 0;
```

Called when the loading of a page has finished.

#### Parameters
- `view`: A pointer to the view that finished loading.
- `url`: The URL that was loaded.
- `success`: Whether the load was successful.
- `statusCode`: The HTTP status code (if applicable).

### ViewError

```cpp
virtual void ViewError(View* view, const ViewError& error) = 0;
```

Called when an error occurs in a view.

#### Parameters
- `view`: A pointer to the view where the error occurred.
- `error`: Information about the error that occurred.

## Example Implementation

```cpp
class MyViewListener : public Coherent::UI::ViewListener {
public:
	void CreateSurface(bool usesSharedMemory, unsigned width, unsigned height, 
                     Coherent::UI::SurfaceResponse* response) override {
		if (usesSharedMemory) {
			// Create shared memory surface
			std::string name = "/tmp/coherent_surface_" + std::to_string(rand());
			int fd = open(name.c_str(), O_RDWR | O_CREAT, 0666);
			ftruncate(fd, width * height * 4);
			Coherent::UI::CoherentHandle handle(fd, name.c_str());
			response->Signal(handle);
		} else {
			// Create shared texture
			// Implementation depends on your rendering API (OpenGL, D3D, etc.)
			Coherent::UI::CoherentHandle handle = CreateSharedTexture(width, height);
			m_Textures[handle] = textureId;
			response->Signal(handle);
		}
	}
	
	void DestroySurface(Coherent::UI::CoherentHandle surface, bool usesSharedMemory) override {
		if (usesSharedMemory) {
			close(surface.Handle);
			unlink(surface.SharedMemoryName);
		} else {
			// Release shared texture
			DestroySharedTexture(m_Textures[surface]);
			m_Textures.erase(surface);
		}
	}
	
	void OnDraw(Coherent::UI::CoherentHandle surface, bool usesSharedMemory, 
              int width, int height) override {
		// Save the current surface for rendering
		m_CurrentSurface = surface;
		m_UsesSharedMemory = usesSharedMemory;
		m_Width = width;
		m_Height = height;
	}
	
	void ViewCreated(Coherent::UI::View* view) override {
		std::cout << "View created\n";
		m_View = view;
	}
	
	void ViewReady(Coherent::UI::View* view) override {
		std::cout << "View ready\n";
	}
	
	// ... implement other methods ...
	
private:
	Coherent::UI::View* m_View = nullptr;
	Coherent::UI::CoherentHandle m_CurrentSurface;
	bool m_UsesSharedMemory = false;
	int m_Width = 0;
	int m_Height = 0;
	std::map<Coherent::UI::CoherentHandle, TextureId> m_Textures;
};
```

## Base Class

Coherent UI provides a base implementation of this interface called `ViewListenerBase`, which implements all methods with empty bodies. You can derive from `ViewListenerBase` instead of `ViewListener` if you only need to override specific methods.

## See Also

- [ViewContext](ViewContext.md)
- [View](View.md)
- [SurfaceResponse](SurfaceResponse.md)
- [Rendering Integration](../Guides/Rendering_Integration.md) 