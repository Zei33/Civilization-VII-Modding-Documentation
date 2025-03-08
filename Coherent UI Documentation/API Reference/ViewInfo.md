# ViewInfo

The `ViewInfo` struct contains configuration settings for creating a UI view in Coherent UI.

## Namespace

```cpp
namespace Coherent::UI
```

## Struct Definition

```cpp
struct ViewInfo
```

## Description

The `ViewInfo` struct holds all the configuration parameters needed when creating a view with `ViewContext::CreateView`. It allows you to specify the view's dimensions, rendering mode, target frame rate, and other important properties.

## Properties

### Width

```cpp
unsigned Width;
```

The width of the view in pixels.

### Height

```cpp
unsigned Height;
```

The height of the view in pixels.

### IsTransparent

```cpp
bool IsTransparent;
```

Whether the view background is transparent. Default is `false`.

### IsBuffered

```cpp
bool IsBuffered;
```

Whether the view is buffered (continuous rendering) or on-demand (render only when content changes). Default is `true` (buffered).

### FPS

```cpp
unsigned FPS;
```

The target frames per second for buffered views. Default is `60`.

### UsesSharedMemory

```cpp
bool UsesSharedMemory;
```

Whether to use shared memory for rendering surfaces. If `false`, shared textures will be used instead. Default is `false`.

### EnableWebGL

```cpp
bool EnableWebGL;
```

Whether to enable WebGL content in the view. Default is `false`.

### EnableAcceleratedPainting

```cpp
bool EnableAcceleratedPainting;
```

Whether to use hardware acceleration for painting. Default is `true`.

### EnableWebAudio

```cpp
bool EnableWebAudio;
```

Whether to enable Web Audio API support. Default is `false`.

### AllowTransparency

```cpp
bool AllowTransparency;
```

Whether to allow transparency in the view. This may impact performance. Default is `false`.

### EnableFileSystemQueries

```cpp
bool EnableFileSystemQueries;
```

Whether to allow JavaScript to access the file system through HTML5 APIs. Default is `false`.

### IgnoreCertificateErrors

```cpp
bool IgnoreCertificateErrors;
```

Whether to ignore SSL certificate errors when loading content over HTTPS. Default is `false`.

### DisableContextMenu

```cpp
bool DisableContextMenu;
```

Whether to disable the right-click context menu. Default is `true`.

### DisableDragAndDrop

```cpp
bool DisableDragAndDrop;
```

Whether to disable drag and drop functionality. Default is `true`.

### HostAPI

```cpp
std::size_t HostAPI;
```

The rendering API used by the host application (e.g., DirectX 11, OpenGL). See the `HostAPIType` enum for possible values.

## Example Usage

```cpp
// Create view info for a standard UI view
Coherent::UI::ViewInfo info;
info.Width = 1280;
info.Height = 720;
info.IsBuffered = true;
info.FPS = 30;
info.UsesSharedMemory = false;
info.EnableWebGL = true;

// Create the view
Coherent::UI::View* view = viewContext->CreateView(info, L"coui://ui/main.html", &viewListener);

// Create view info for a transparent on-demand view
Coherent::UI::ViewInfo overlayInfo;
overlayInfo.Width = 1280;
overlayInfo.Height = 720;
overlayInfo.IsBuffered = false;  // On-demand rendering
overlayInfo.IsTransparent = true;
overlayInfo.AllowTransparency = true;
overlayInfo.UsesSharedMemory = false;

// Create the overlay view
Coherent::UI::View* overlayView = viewContext->CreateView(overlayInfo, L"coui://ui/overlay.html", &overlayListener);
```

## Buffered vs. On-Demand Views

The `IsBuffered` property determines whether a view is rendered continuously or only when content changes:

- **Buffered Views** (`IsBuffered = true`): Render continuously at the specified FPS, providing smooth animations and transitions but using more system resources.

- **On-Demand Views** (`IsBuffered = false`): Render only when content changes or when explicitly requested, using fewer system resources but potentially less smooth for animations.

See the [View Types Guide](../Guides/View_Types.md) for more information.

## Shared Memory vs. Shared Textures

The `UsesSharedMemory` property determines how rendered content is transferred between processes:

- **Shared Memory** (`UsesSharedMemory = true`): Content is transferred through system memory, which works on all platforms but may be slower.

- **Shared Textures** (`UsesSharedMemory = false`): Content remains on the GPU, offering better performance but requiring platform-specific implementation.

See the [Rendering Integration Guide](../Guides/Rendering_Integration.md) for more information.

## Default Values

When you create a new `ViewInfo` struct, it is initialized with these default values:

```cpp
ViewInfo info;
// info.Width = 800
// info.Height = 600
// info.IsTransparent = false
// info.IsBuffered = true
// info.FPS = 60
// info.UsesSharedMemory = false
// info.EnableWebGL = false
// info.EnableAcceleratedPainting = true
// info.EnableWebAudio = false
// info.AllowTransparency = false
// info.EnableFileSystemQueries = false
// info.IgnoreCertificateErrors = false
// info.DisableContextMenu = true
// info.DisableDragAndDrop = true
```

## See Also

- [ViewContext](ViewContext.md)
- [View](View.md)
- [View Types](../Guides/View_Types.md)
- [Rendering Integration](../Guides/Rendering_Integration.md) 