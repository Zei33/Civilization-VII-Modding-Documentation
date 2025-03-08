# Rendering Integration

This guide explains how to integrate Coherent UI rendering with your game's rendering pipeline.

## Overview

Coherent UI renders your UI views to surfaces that your game engine can use as textures. These textures can then be mapped onto 2D quads for HUD elements or onto 3D meshes for in-game interfaces.

## Surface Types

Coherent UI supports two types of rendering surfaces:

1. **Shared Memory Surfaces**: The rendered content is stored in shared memory accessible to both the UI process and your game.
2. **Shared Textures**: The rendered content stays on the GPU using platform-specific mechanisms (e.g., IOSurface on macOS, DXGI shared handles on Windows).

Shared textures provide better performance as the surfaces never leave the GPU memory, but shared memory is available on all platforms.

## Rendering Lifecycle

The rendering lifecycle follows these steps:

1. **Surface Creation**: When Coherent UI needs to render a view, it requests your application to create a surface through the `ViewListener::CreateSurface` callback.
2. **Rendering**: Coherent UI renders the HTML content to the surface.
3. **Surface Ready**: When a new frame is ready, Coherent UI notifies your application through the `ViewListener::OnDraw` callback.
4. **Surface Usage**: Your application uses the surface as a texture in its rendering pipeline.
5. **Surface Destruction**: When a surface is no longer needed, Coherent UI requests your application to destroy it through the `ViewListener::DestroySurface` callback.

## Implementation Example (OpenGL)

### Creating Surfaces

```cpp
void MyViewListener::CreateSurface(bool usesSharedMemory, unsigned width, unsigned height, 
                                  Coherent::UI::SurfaceResponse* response)
{
	if (usesSharedMemory) {
		// Create shared memory surface
		std::string name = "/tmp/coherent_surface_" + std::to_string(rand());
		int fd = open(name.c_str(), O_RDWR | O_CREAT, 0666);
		ftruncate(fd, width * height * 4);
		Coherent::UI::CoherentHandle handle(fd, name.c_str());
		response->Signal(handle);
	} else {
		// Create shared texture
		int sharedHandle = 0;
		GLuint textureId = CreateTexture(width, height, &sharedHandle);
		Coherent::UI::CoherentHandle handle(sharedHandle);
		m_Textures[handle] = textureId;
		response->Signal(handle);
	}
}
```

### Handling Draw Events

```cpp
void MyViewListener::OnDraw(Coherent::UI::CoherentHandle handle, bool usesSharedMemory, 
                           int width, int height)
{
	if (usesSharedMemory) {
		// Update texture from shared memory
		size_t memSize = width * height * 4;
		void* memory = mmap(nullptr, memSize, PROT_READ, MAP_SHARED, handle.Handle, 0);
		
		GLuint textureId = m_RenderingTexture; // The texture used for rendering
		glBindTexture(GL_TEXTURE_2D, textureId);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, 
                        GL_BGRA, GL_UNSIGNED_BYTE, memory);
		
		munmap(memory, memSize);
	} else {
		// The texture is already updated on the GPU
		// Just need to copy or use it directly
		GLuint sourceTexture = m_Textures[handle];
		GLuint destTexture = m_RenderingTexture;
		
		// Copy using framebuffer blit or use directly
		CopyTexture(sourceTexture, destTexture);
	}
}
```

### Destroying Surfaces

```cpp
void MyViewListener::DestroySurface(Coherent::UI::CoherentHandle handle, bool usesSharedMemory)
{
	if (usesSharedMemory) {
		close(handle.Handle);
		unlink(handle.SharedMemoryName);
	} else {
		GLuint textureId = m_Textures[handle];
		glDeleteTextures(1, &textureId);
		m_Textures.erase(handle);
	}
}
```

## Platform-Specific Considerations

### Windows (Direct3D)

When using Direct3D, shared textures are implemented using DXGI shared handles:

```cpp
// Creating a shared texture in D3D11
ID3D11Texture2D* pTexture = nullptr;
D3D11_TEXTURE2D_DESC desc = {};
desc.Width = width;
desc.Height = height;
desc.MipLevels = 1;
desc.ArraySize = 1;
desc.Format = DXGI_FORMAT_B8G8R8A8_UNORM;
desc.SampleDesc.Count = 1;
desc.Usage = D3D11_USAGE_DEFAULT;
desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
desc.MiscFlags = D3D11_RESOURCE_MISC_SHARED;

pDevice->CreateTexture2D(&desc, nullptr, &pTexture);

IDXGIResource* pDXGIResource = nullptr;
pTexture->QueryInterface(__uuidof(IDXGIResource), (void**)&pDXGIResource);

HANDLE sharedHandle;
pDXGIResource->GetSharedHandle(&sharedHandle);
pDXGIResource->Release();

// Return the shared handle to Coherent UI
response->Signal(Coherent::UI::CoherentHandle(sharedHandle));
```

### macOS (OpenGL)

On macOS, shared textures are implemented using IOSurface:

```cpp
// Creating an IOSurface-backed texture
GLuint textureId;
glGenTextures(1, &textureId);
glBindTexture(GL_TEXTURE_RECTANGLE_ARB, textureId);

NSDictionary* options = @{
	(NSString*)kIOSurfaceWidth: @(width),
	(NSString*)kIOSurfaceHeight: @(height),
	(NSString*)kIOSurfaceBytesPerElement: @(4)
};
IOSurfaceRef ioSurface = IOSurfaceCreate((CFDictionaryRef)options);

CGLContextObj cgl_ctx = (CGLContextObj)[[NSOpenGLContext currentContext] CGLContextObj];
CGLError err = CGLTexImageIOSurface2D(cgl_ctx, GL_TEXTURE_RECTANGLE_ARB, GL_RGBA, 
                                     width, height, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV,
                                     ioSurface, 0);

// Return the IOSurface ID to Coherent UI
IOSurfaceID surfaceID = IOSurfaceGetID(ioSurface);
response->Signal(Coherent::UI::CoherentHandle((void*)(size_t)surfaceID));
```

## Best Practices

1. **Use shared textures when possible** for better performance.
2. **Maintain a double buffer** of textures to avoid visual artifacts while updating.
3. **Don't bind shared textures on every frame** - once created and bound, they automatically update.
4. **Consider view visibility** - only update visible views to conserve resources.
5. **Synchronize rendering** - ensure your game's render thread and the UI thread are properly synchronized.

## See Also

- [View Types](View_Types.md)
- [ViewListener API](../API%20Reference/ViewListener.md)
- [Live Game Views](Live_Game_Views.md)
- [Multiple GPUs](Multiple_GPUs.md) 