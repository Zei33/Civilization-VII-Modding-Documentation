# Hello HTML Sample

This guide walks through the "Hello HTML" sample included with Coherent UI, which demonstrates the basic setup and usage of Coherent UI in a simple application.

## Overview

The "Hello HTML" sample is a minimal application that loads and displays a simple HTML page using Coherent UI. It demonstrates:

1. Initializing Coherent UI
2. Creating a view
3. Setting up rendering
4. Handling input
5. Cleaning up resources

## Sample Files

The sample includes the following key files:

- `Main.cpp` - The main application entry point
- `HelloHTML.cpp` - The sample implementation
- `HelloHTML.h` - The sample header file
- `html/hello.html` - The HTML file displayed by the sample

## HTML Content

The sample loads a simple HTML file (`html/hello.html`) that displays "Hello, World!" and demonstrates basic styling:

```html
<!DOCTYPE html>
<html>
<head>
	<title>Hello Coherent UI</title>
	<style type="text/css">
		body {
			font-family: Arial, sans-serif;
			background-color: #f0f0f0;
			color: #333;
			text-align: center;
		}
		.container {
			margin: 100px auto;
			padding: 20px;
			width: 400px;
			background-color: white;
			border-radius: 10px;
			box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		}
		h1 {
			color: #0078d7;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1>Hello, World!</h1>
		<p>This is a simple HTML page rendered with Coherent UI.</p>
	</div>
</body>
</html>
```

## Implementation Walkthrough

### 1. Setting Up the Application

The sample begins by setting up a window and initializing OpenGL:

```cpp
int main(int argc, char* argv[])
{
	// Create a window and initialize OpenGL
	Window window;
	window.Create(800, 600, "Coherent UI - Hello HTML");
	
	// Initialize the sample
	HelloHTML sample;
	sample.Initialize(window.GetWidth(), window.GetHeight());
	
	// Main loop
	while (window.ProcessEvents()) {
		sample.Update();
		sample.Render();
		window.SwapBuffers();
	}
	
	// Cleanup
	sample.Shutdown();
	window.Destroy();
	
	return 0;
}
```

### 2. Initializing Coherent UI

In the `HelloHTML::Initialize` method, Coherent UI is initialized:

```cpp
bool HelloHTML::Initialize(int width, int height)
{
	// Initialize the view context factory
	m_Factory = Coherent::UI::CreateViewContextFactory();
	
	// Initialize event listener
	m_ContextListener = new ContextEventListener(width, height, this);
	
	// Create context settings
	Coherent::UI::ContextSettings settings;
	settings.DebuggerPort = 1234;  // Enable debugging on port 1234
	
	// Create view context
	m_ViewContext = m_Factory->CreateViewContext(settings, m_ContextListener, nullptr);
	
	return true;
}
```

### 3. Creating a View

When the context is ready, the sample creates a view:

```cpp
void ContextEventListener::ContextReady()
{
	// Create view info
	Coherent::UI::ViewInfo info;
	info.Width = m_Width;
	info.Height = m_Height;
	info.UsesSharedMemory = false;
	
	// Create view
	m_ViewContext->CreateView(info, L"coui://html/hello.html", m_ViewListener);
}
```

### 4. Handling Rendering

The sample implements the `ViewListener` interface to handle view events:

```cpp
// Creating surfaces
void HelloHTML::CreateSurface(bool usesSharedMemory, unsigned width, unsigned height, 
                            Coherent::UI::SurfaceResponse* response)
{
	// Create surface...
	Coherent::UI::CoherentHandle handle = CreateSharedTexture(width, height);
	response->Signal(handle);
}

// Handling draw events
void HelloHTML::OnDraw(Coherent::UI::CoherentHandle handle, bool usesSharedMemory, 
                     int width, int height)
{
	// The UI has been drawn to the surface, save it for rendering
	m_CurrentSurface = handle;
}

// Rendering
void HelloHTML::Render()
{
	// Clear the screen
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Render the UI if a surface is available
	if (m_CurrentSurface) {
		RenderSurface(m_CurrentSurface);
	}
}
```

### 5. Cleanup

The sample cleans up all resources when shutting down:

```cpp
void HelloHTML::Shutdown()
{
	// Destroy view
	if (m_View) {
		m_View->Destroy();
		m_View = nullptr;
	}
	
	// Uninitialize view context
	if (m_ViewContext) {
		m_ViewContext->Uninitialize();
		m_ViewContext = nullptr;
	}
	
	// Release factory
	if (m_Factory) {
		m_Factory->Release();
		m_Factory = nullptr;
	}
	
	// Delete listeners
	delete m_ContextListener;
	m_ContextListener = nullptr;
}
```

## Running the Sample

To run the sample:

1. Make sure Coherent UI is properly installed
2. Build the sample using the provided project files
3. Run the compiled executable
4. You should see a window with the "Hello, World!" HTML content

## Debugging

To debug the sample:

1. Enable the debugger port in the context settings (as shown in the sample)
2. Run the Coherent UI Debugger
3. Connect to `http://localhost:1234` in the debugger
4. Select the view from the list of available views

## Next Steps

After understanding this basic sample, you can explore more advanced features:

- [Custom File Handler](Custom_File_Handler.md)
- [Multiple Views](Multiple_Views.md)
- [C++ and JavaScript Binding](CPP_JS_Binding.md)

## See Also

- [ViewContext API](../API%20Reference/ViewContext.md)
- [View API](../API%20Reference/View.md)
- [ViewListener API](../API%20Reference/ViewListener.md) 