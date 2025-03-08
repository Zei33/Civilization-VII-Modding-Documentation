# Coherent UI API Reference

This section contains detailed documentation for all classes, functions, and namespaces in the Coherent UI library.

## Namespaces

- [Coherent Namespace](Coherent_Namespace.md) - The main namespace containing most Coherent UI functionality
- [Coherent::UI Namespace](Coherent_UI_Namespace.md) - Core UI classes and functionality
- [Coherent::UI::Binding Namespace](Binding_Namespace.md) - Classes related to C++ and JavaScript binding

## Core Classes

- [ViewContext](ViewContext.md) - The central class for creating and managing UI views
- [View](View.md) - Represents a single UI view
- [ViewInfo](ViewInfo.md) - Configuration settings for creating views
- [ContextSettings](ContextSettings.md) - Configuration settings for the ViewContext
- [ViewListener](ViewListener.md) - Interface for handling view-related events
- [ViewListenerBase](ViewListenerBase.md) - Base implementation of ViewListener with empty methods
- [EventListener](EventListener.md) - Interface for handling context-related events
- [BrowserView](BrowserView.md) - Extended view class with additional browser functionality
- [BrowserViewListener](BrowserViewListener.md) - Extended listener for browser-specific events

## Rendering and Surfaces

- [CoherentHandle](CoherentHandle.md) - Handle to a rendering surface
- [SurfaceResponse](SurfaceResponse.md) - Interface for responding to surface creation requests
- [ImageData](ImageData.md) - Container for image data

## Input Handling

- [EventModifiersState](EventModifiersState.md) - State of keyboard modifiers for input events
- [EventMouseModifiersState](EventMouseModifiersState.md) - State of mouse modifiers for input events
- [KeyEventData](KeyEventData.md) - Data for keyboard events
- [MouseEventData](MouseEventData.md) - Data for mouse events
- [TouchEventData](TouchEventData.md) - Data for touch events

## JavaScript Binding

- [Binder](Binder.md) - Core class for binding C++ to JavaScript
- [TypeDescription](TypeDescription.md) - Description of C++ types for JavaScript binding
- [Array](Array.md) - Container for array data in bindings
- [ScriptEventWriter](ScriptEventWriter.md) - Utility for writing script events

## File and Network Handling

- [FileHandler](FileHandler.md) - Custom file handling for Coherent UI
- [URLRequest](URLRequest.md) - Represents a URL request
- [URLRequestBase](URLRequestBase.md) - Base class for URL requests
- [ResourceResponse](ResourceResponse.md) - Response for resource requests
- [ResourceData](ResourceData.md) - Container for resource data
- [CustomProtocols](CustomProtocols.md) - Configuration for custom protocols

## Miscellaneous

- [Download](Download.md) - Represents a file download
- [FileSelectRequest](FileSelectRequest.md) - Request for file selection
- [HTTPHeader](HTTPHeader.md) - HTTP header for network requests
- [MediaStreamDevice](MediaStreamDevice.md) - Represents a media device
- [MediaStreamRequest](MediaStreamRequest.md) - Request for media streams
- [URLComponent](URLComponent.md) - Component of a URL
- [URLParser](URLParser.md) - Parser for URLs

## Enumerations

- [KeyEventType](KeyEventType.md) - Types of keyboard events
- [MouseButton](MouseButton.md) - Mouse button identifiers
- [ViewError](ViewError.md) - Error codes for view operations
- [ContextError](ContextError.md) - Error codes for context operations

## Factory Functions

- [CreateViewContextFactory](CreateViewContextFactory.md) - Creates a ViewContextFactory
- [InitializeCoherentUI](InitializeCoherentUI.md) - Initializes the Coherent UI library

## See Also

- [Guides](../Guides/README.md) - Detailed guides on using Coherent UI
- [Samples](../Samples/README.md) - Sample applications demonstrating Coherent UI 