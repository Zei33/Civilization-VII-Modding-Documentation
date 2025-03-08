# Quick Start Guide Windows

## Table of Contents

- Installation
- Integration
	- Initialization and Update
	- Rendering Surfaces
	- Rendering
- Debugging
- Deployment

## Introduction

This guide will show you how to:

- Add Coherent UI as a library to project
- Create a Coherent::UI::ViewContext and create a single view
- Create surfaces to be used by this view
- Display the view using DirectX
- Deploy the executable

The sample for this guide is HelloHTMLDx9.

## Installation

1. Unzip CoherentUI.zip in a directory of your choice. This directory is referred as CoherentInstallDir
2. Add CoherentInstallDir\include to your project include directories.
   ![include_directories.png](include_directories.png)
   *Adding Coherent\include to project include directories*
3. Add CoherentInstallDir\lib to your project library directories.
   ![library_directories.png](library_directories.png)
   *Adding Coherent\lib to project library directories*
4. Add CoherentUI.lib to your project library inputs.
   ![libraries_input.png](libraries_input.png)
   *Adding CoherentUI.lib to project library inputs*
5. To try the samples and use the Debugger run bootstrap.bat.

## Integration

Start by including the necessary headers:

```cpp
#include <Coherent/UI/ViewContext.h>
#include <Coherent/UI/ViewInfo.h>
#include <Coherent/UI/ViewListener.h>
```

### Initialization and Update

First, initialize CoherentUI with the appropriate factory settings via InitializeCoherentUI. If it succeeds, it returns a pointer to working ViewContextFactory, which you can later use to create view contexts.

Then create a view context with the appropriate settings and a listener for context events. The listener will be notified when the ViewContext is ready to create views:

```cpp
ViewEventListener viewListener;
ContextEventListener listener(width, height, &viewListener);
Coherent::UI::ContextSettings settings;
Coherent::UI::ViewContext* context = viewContextFactory->CreateViewContext(
	settings,
	&listener,
	nullptr);
```

Coherent UI requires a license key as it's first initialization parameter. Starter and trial versions come with a pre-bundled "License.h" file containing the key. Pro licensees should have received their key upon purchase. All samples presume that there is a "License.h" in the Coherent/UI folder and in it there is a COHERENT_KEY string with your license. However you can type the string wherever you want and pass it to the initialization function.

The "ViewEventListener" and "ContextEventListener" are classes inherited from Coherent::UI::ViewListener and Coherent::UI::EventListener respectively. They should implement the callbacks that a Coherent UI context will invoke upon certain events. If you are uncertain on how to initialize the factory, or the context or wire simple drawing please consult the HelloHTML samples bundled in the Coherent UI package.

Coherent::UI::ViewContext::Update has to be called in the main loop. It processes the incoming events and executes the appropriate callbacks. Coherent::UI::ViewContext::FetchSurfaces checks if new rendered surfaces are available for the active views. It calls Coherent::UI::ViewListener::OnDraw and might request the creation or destruction of surfaces. The context is split in those two calls to allow the user to more easily accommodate a distinction between the logical update of the state of the views and their drawing. Check the Best Practices guide for tips on how to optimally organize calls to Coherent UI in your frame.

> **Note**: All event handlers and callbacks are executed inside Coherent::UI::ViewContext::Update and Coherent::UI::ViewContext::FetchSurfaces.

```cpp
while (msg.message != WM_QUIT)
{
	if (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	else
	{
		context->Update();
		context->FetchSurfaces();
		renderer.DrawScene();
	}
}
```

When a context is up and running it will call the ContextReady method of listener and that is the appropriate time to create a view. To create a view you need a ViewInfo struct with the properties of the view, a URL for the view and a ViewListener for its events.

Coherent UI provides a custom protocol for URLs - coui. All files that are display through this protocol will be loaded from a custom FileHandler. The default one loads the files using the current working directory as root, so for our project - coui://html/hello.html will be read from html/hello.html using the application working directory as base.

```cpp
void ContextEventListener::ContextReady()
{
	Coherent::UI::ViewInfo info;
	info.Width = m_Width;
	info.Height = m_Height;
	m_Context->CreateView(info, "coui://html/hello.html", m_ViewListener);
}
```

### Rendering Surfaces

The ViewListener is notified for all view related events, such as when the view has been created, finished loading, etc. It is also responsible for creating and destroying the rendering surfaces for that view. There are at least two rendering surfaces for each view - while the listener is handling a surface, the next frame is being drawn on the other. By default Coherent UI uses shared textures to allow high performance rendering of the views.

```cpp
void ViewEventListener::CreateSurface(bool sharedMemory, unsigned width, unsigned height, SurfaceResponse* response)
{
	HANDLE sharedHandle;
	IDirect3DTexture9* texture;
	// create a shared texture
	m_Renderer->GetDevice()->CreateTexture(width, height, 1, D3DUSAGE_RENDERTARGET, D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &texture, &sharedHandle);
	m_Buffers.insert(std::make_pair(sharedHandle, texture));
	response->Signal(Coherent::UI::CoherentHandle(sharedHandle));
}

void ViewEventListener::DestroySurface(CoherentHandle surface, bool usesSharedMemory)
{
	HandleToBufferMap::iterator buffer = m_Buffers.find(surface);
	if (buffer != m_Buffers.end())
	{
		m_Renderer->DestroyTexture(buffer->second);
		m_Buffers.erase(buffer);
	}
}
```

### Rendering

Coherent UI draws lazily all the views - if no change is triggered (either by an event or animation) in the view, no call to Coherent::UI::ViewListener::OnDraw will be made. In that case you must present the last received rendered frame of that view. Therefore when a Coherent::UI::ViewListener::OnDraw event occurs, we copy the frame to a texture that is going to be used during the rendering of the scene.

```cpp
void ViewEventListener::OnDraw(CoherentHandle handle, bool usesSharedMemory, int width, int height)
{
	IDirect3DTexture9* texture = m_Buffers[handle];
	IDirect3DSurface9* surfaceSource;
	texture->GetSurfaceLevel(0, &surfaceSource);
	IDirect3DSurface9* surfaceDest;
	m_Renderer->GetTexture()->GetSurfaceLevel(0, &surfaceDest);
	m_Renderer->GetDevice()->StretchRect(surfaceSource, nullptr, surfaceDest, nullptr, D3DTEXF_NONE);
	surfaceSource->Release();
	surfaceDest->Release();
}
```

When a Coherent::UI::View is no longer used it should be destroyed. Same goes for ViewContext - it should be uninitialized when no longer needed.

> **Note**: Uninitializing the context does destroy all the views and callbacks related to it will be called.

```cpp
Coherent::UI::View* view = viewListener.GetView();
if (view)
{
	view->Destroy();
}
context->Uninitialize();
```

## Debugging

To use the Debugger, please make sure that you have run bootstrap.bat on your installation.

To enable debugging of the views:

1. Set Coherent::UI::ContextSettings::DebuggerPort to PORT - the port to be used by the remote debugger
2. Launch the Debugger available in the Debugger folder in your Coherent UI package
3. Create your views in type http://localhost:PORT in the Debugger's address bar. Click GO.
4. A list of views currently active will be available - select the view you want to debug

## Deployment

To deploy an application using Coherent UI you need to deploy the following files:

- CoherentUI.dll - in same directory as the application executable
- CoherentUI_Host.exe and all the other DLL files and the folder locales from CoherentInstallDir\lib should be set in the `HostDirectory` member of the FactorySettings struct, that is given to InitializeCoherentUI method.

For example, if HostDirectory is "" (meaning the same directory as the executable), a deployed application will look like:

![deployment.png](deployment.png)
*Directory Listing of a deployed application*
