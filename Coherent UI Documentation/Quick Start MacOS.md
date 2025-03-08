
# Quick Start Guide MacOSX

## Table of Contents

- Installation
- Integration
    - Initialization and Update
    - Rendering Surfaces
    - Rendering
    - Debugging
    - Deployment

This guide will show you how to

    Add Coherent UI as a library to project
    Create a Coherent::UI::ViewContext and create a single view
    Create surfaces to be used by this view
    Display the view using OpenGL
    Deploy the executable

The sample for this guide is HelloHTMLCocoa
Installation

    Unzip CoherentUI.zip in a directory of your choice. This directory is referred as CoherentInstallDir
    Add CoherentInstallDir\include to your include directories.
    Add CoherentInstallDir\lib to your library directories.
    Add CoherentUI.lib to your project library inputs
    To try the samples and use the Debugger run bootstrap.sh.

Note
    For MacOSX HelloHTMLCocoa is shipped with an XCode project - it is a hybrid Objective-C & C++ project. It has been tested with XCode 4.4. The Cocoa sample requires XCode command line tools to run. All Coherent UI samples depend on GLEW 1.9.0 on MacOSX.

Integration

Start by including the necessary headers:
#include <Coherent/UI/ViewContext.h>
#include <Coherent/UI/ViewInfo.h>
#include <Coherent/UI/ViewListener.h>
Initialization and Update

First, initialize CoherentUI with the appropriate factory settings via InitializeCoherentUI. If it succeeds, it returns a pointer to working ViewContextFactory, which you can later use to create view contexts.

Then create a view context with the appropriate settings and a listener for context events. The listener will be notified when the ViewContext is ready to create views:
ViewEventListener viewListener;
ContextEventListener listener(width, height, &viewListener);
Coherent::UI::ContextSettings settings;
Coherent::UI::ViewContext* context = viewContextFactory->CreateViewContext(
    settings,
    &listener,
    nullptr);

Coherent UI requires a license key as it's first initialization parameter. Trial versions come with a pre-bundled "License.h" file containing the key. Pro licensees should have received their key upon purchase. All samples presume that there is a "License.h" in the Coherent/UI folder and in it there is a COHERENT_KEY string with your license. However you can type the string wherever you want and pass it to the initialization function.

The "ViewEventListener" and "ContextEventListener" are classes inherited from Coherent::UI::ViewListener and Coherent::UI::EventListener respectively. They should implement the callbacks that a Coherent UI context will invoke upon certain events. If you are uncertain on how to initialize he factory, or the context or wire simple drawing please consult the HelloHTML samples bundled in the Coherent UI package.

Coherent::UI::ViewContext::Update has to be called in the main loop. It processes the incoming events and executes the appropriate callbacks. Coherent::UI::ViewContext::FetchSurfaces checks if new rendered surfaces are available for the active views. It calls Coherent::UI::ViewListener::OnDraw and might request the creation or destruction of surfaces. The context is split in those two calls to allow the user to more easily accomodate a distinction between the logical update of the state of the views and their drawing. Check the Best Practices guide for tips on how to optimally organize calls to Coherent UI in your frame. In the Cocoa sample a 'ViewContext' bridge class has been created to aid the Objective-C <-> C++ interoperability.

Note
    All event handlers and callbacks are executed inside Coherent::UI::ViewContext::Update and Coherent::UI::ViewContext::FetchSurfaces.

void CoherentViewContext::Update()
{
    if(m_ViewContext)
    {
        m_ViewContext->Update();
        m_ViewContext->FetchSurfaces();
    }
}
- (void) update:(NSTimer*) timer
{
    if (m_Context)
    {
        m_Context->Update();
    }
    [self setNeedsDisplay:YES];
}

When the context is up and running it will call the ContextReady method of listener and that is the appropriate time to create a view. To create a view you need a ViewInfo struct with the properties of the view, a URL for the view and a ViewListener for its events.

Coherent UI provides a custom protocol for URLs - coui. All files that are display through this protocol will be loaded from a custom FileHandler. The default one loads the files using the current working directory as root, so for our project - coui://html/hello.html will be read from html/hello.html using the application working directory as base.
void ContextEventListener::ContextReady()
{
    Coherent::UI::ViewInfo info;
    info.Width = DEFAULT_VIEW_WIDTH;
    info.Height = DEFAULT_VIEW_HEIGHT;
    info.UsesSharedMemory = false;
    m_Context->GetViewContext()->CreateView(
        info, L"coui://html/hello.html", m_Context->GetViewListener());
}
Rendering Surfaces

The ViewListener is notified for all view related events, such as when the view has been created, finished loading, etc. It is also responsible for creating and destroying the rendering surfaces for that view. There are at least two rendering surfaces for each view - while the listener is handling a surface, the next frame is being drawn on the other. On MacOSX Coherent UI can use both 'shared textures' (through IOSurfaces) and shared memory to pass the drawn surfaces to the client. The shared textures is the preferred way because the surfaces never leave the GPU memory allowing for optimal performance.
void CoherentViewListener::CreateSurface(bool, unsigned width, unsigned height, Coherent::UI::SurfaceResponse* response)
{
    Coherent::UI::CoherentHandle result(0);
    if (sharedMem)
    {
        std::ostringstream stream;
        stream << "/tmp/buffer_" << rand() << '_' << rand();
        std::string name = stream.str();
        int fd = open(name.c_str(), O_RDWR | O_CREAT, 0666);
        if (fd == -1)
        {
            std::cerr << "Could not create file " << name << " error " << errno;
        }
        ftruncate(fd, width * height * 4);
        result = Coherent::UI::CoherentHandle(fd, name.c_str());
    }
    else
    {
        int sharedHandle(0);
        int id = m_Context->GetGLUtility()->CreateTexture(
            width, height, &sharedHandle);
        if (id == GLUtility::INVALID_ID)
        {
            response->Signal(Coherent::UI::CoherentHandle(0));
        }
        result = Coherent::UI::CoherentHandle(sharedHandle);
        bool insert = m_Buffers.insert(std::make_pair(result, id)).second;
        assert(insert && "duplicated handles");
    }
    response->Signal(result);
}
void CoherentViewListener::DestroySurface(CoherentHandle surface, bool usesSharedMemory)
{
    if (useSharedMem)
    {
        close(buffer.Handle);
        unlink(buffer.SharedMemoryName);
    }
    else
    {
        HandleToBuffersMap::iterator bufferTex = m_Buffers.find(buffer);
        if (bufferTex != m_Buffers.end())
        {
            return;
        }
        IOSurfaceRef ioSurface = IOSurfaceLookup((IOSurfaceID)(size_t)bufferTex->first);
        if (ioSurface)
        {
            CFRelease(ioSurface);
        }
        m_Context->GetGLUtility()->DestroyTexture(bufferTex->second);
        m_Buffers.erase(bufferTex);
    }
}

The class GLUtility in the sample shows how to create the needed IOSurface and bind it to the application's OpenGL context.
Rendering

Coherent UI draws lazily all the views - if no change is triggered (either by an event or animation) in the view, no call to Coherent::UI::ViewListener::OnDraw will be made. In that case you must present the last received rendered frame of that view. Therefore when a Coherent::UI::ViewListener::OnDraw event occurs, we copy the frame to a texture that is going to be used during the rendering of the scene.
void ViewEventListener::OnDraw(CoherentHandle handle, bool usesSharedMemory, int width, int height)
{
    if (useSharedMem)
    {
        size_t memSize = width * height * 4;
        void* memory = mmap(nullptr, memSize, PROT_READ, MAP_SHARED, handle.Handle, 0);
        m_Context->GetGLUtility()->UpdateTextureRect(
            m_Context->GetTextureFromHost(), 0, 0, width, height, memory);
        munmap(memory, memSize);
    }
    else
    {
        HandleToBuffersMap::iterator it = m_Buffers.find(handle);
        if (it == m_Buffers.end())
        {
            return;
        }
        int texId = GetTexture(handle);
        if (texId != GLUtility::INVALID_ID)
        {
            m_Context->GetGLUtility()->StretchTexture(
                texId, m_Context->GetTextureFromHost(), true);
        }
    }
}

Again refer to the GLUtility class for the details regarding the update of the OpenGL texture itself. The sample creates Framebuffers for the textures it uses and performs a glBlitFramebuffer to copy from the Coherent UI surface to the one used to display the interface on screen. IOSurfaces automatically take care to update the textures bound to them. If you have created, as in the sample, a texture bound to the IOSurface requested in CreateSurface, it'll always be up-to-date in the OnDraw callback.

Note
    You should not bind the IOSurface on every call to OnDraw. Instead do as in the sample - create a texture and bind it to the IOSurface in the CreateSurface method. Then in OnDraw directly use the texture - it will be up-to-date.

When a Coherent::UI::View is no longer used it should be destroyed. Same goes for ViewContext - it should be uninitialized when no longer needed.

Note
    Uninitializing the context does destroy all the views and callbacks related to it will be called.

Coherent::UI::View* view = viewListener.GetView();
g_ViewListener->Destroy();
g_ViewContext->Uninitialize();
Debugging

To use the Debugger, please make sure that you have run bootstrap.sh on your installation.

To enable debugging of the views:

    Coherent::UI::ContextSettings::DebuggerPort to PORT - the port to be used by the remote debugger
    Launch the Debugger available in the Debugger folder in your Cohernet UI package
    Create your views in type http://localhost:PORT in the Debugger's address bar. Click GO.
    A list of views currently active will be available - select the view you want to debug

Deployment

To deploy an application using Coherent UI you need to deploy the following files:

    CoherentUI.dylib - in same directory as the application executable
    CoherentUI_Host and all the other *.so* and *.dylib* files and the folder locales from CoherentInstallDir\lib should be in the directory HostDirectory that is given when ViewContext is initialized.

