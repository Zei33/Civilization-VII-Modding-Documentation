# View

The `View` class represents a single UI view in Coherent UI, which displays HTML content and handles interactions with it.

## Namespace

```cpp
namespace Coherent::UI
```

## Class Definition

```cpp
class View
```

## Description

The `View` class encapsulates a single HTML view in your game. A view represents a browser window that can display HTML content and interact with it. Views are created by the `ViewContext` and have their own rendering process.

## Methods

### Destroy

```cpp
void Destroy();
```

Destroys the view and releases all associated resources.

### Resize

```cpp
void Resize(unsigned width, unsigned height);
```

Resizes the view to the specified dimensions.

#### Parameters
- `width`: The new width of the view in pixels.
- `height`: The new height of the view in pixels.

### Reload

```cpp
void Reload();
```

Reloads the current page in the view.

### LoadURL

```cpp
void LoadURL(const wchar_t* url);
```

Loads the specified URL in the view.

#### Parameters
- `url`: The URL to load.

### ExecuteScript

```cpp
void ExecuteScript(const wchar_t* script);
```

Executes the specified JavaScript in the context of the view.

#### Parameters
- `script`: The JavaScript code to execute.

### SetFocus

```cpp
void SetFocus(bool focused);
```

Sets whether the view has focus.

#### Parameters
- `focused`: `true` to give focus to the view, `false` to remove focus.

### InjectMouseMove

```cpp
void InjectMouseMove(int x, int y, const EventMouseModifiersState& modifiers);
```

Injects a mouse move event into the view.

#### Parameters
- `x`: The x-coordinate of the mouse.
- `y`: The y-coordinate of the mouse.
- `modifiers`: The state of keyboard modifiers (Shift, Ctrl, Alt, etc.).

### InjectMouseDown

```cpp
void InjectMouseDown(int x, int y, MouseButton button, const EventMouseModifiersState& modifiers);
```

Injects a mouse button down event into the view.

#### Parameters
- `x`: The x-coordinate of the mouse.
- `y`: The y-coordinate of the mouse.
- `button`: The mouse button that was pressed.
- `modifiers`: The state of keyboard modifiers.

### InjectMouseUp

```cpp
void InjectMouseUp(int x, int y, MouseButton button, const EventMouseModifiersState& modifiers);
```

Injects a mouse button up event into the view.

#### Parameters
- `x`: The x-coordinate of the mouse.
- `y`: The y-coordinate of the mouse.
- `button`: The mouse button that was released.
- `modifiers`: The state of keyboard modifiers.

### InjectMouseWheel

```cpp
void InjectMouseWheel(int x, int y, int delta, const EventMouseModifiersState& modifiers);
```

Injects a mouse wheel event into the view.

#### Parameters
- `x`: The x-coordinate of the mouse.
- `y`: The y-coordinate of the mouse.
- `delta`: The amount of wheel rotation.
- `modifiers`: The state of keyboard modifiers.

### InjectKeyboardEvent

```cpp
void InjectKeyboardEvent(KeyEventType type, int key, int character, const EventModifiersState& modifiers);
```

Injects a keyboard event into the view.

#### Parameters
- `type`: The type of keyboard event (KeyDown, KeyUp, KeyChar).
- `key`: The key code.
- `character`: The character code.
- `modifiers`: The state of keyboard modifiers.

### GetUserObject

```cpp
template<typename T>
T* GetUserObject();
```

Gets the user object associated with the view.

#### Template Parameters
- `T`: The type of the user object.

#### Returns
A pointer to the user object or `nullptr` if no user object is set.

### SetUserObject

```cpp
template<typename T>
void SetUserObject(T* object);
```

Sets the user object associated with the view.

#### Template Parameters
- `T`: The type of the user object.

#### Parameters
- `object`: A pointer to the user object.

## Example Usage

```cpp
// Assuming you have a ViewContext and a ViewListener
Coherent::UI::ViewInfo info;
info.Width = 800;
info.Height = 600;
info.UsesSharedMemory = false;

// Create a view
Coherent::UI::View* view = viewContext->CreateView(info, L"coui://html/interface.html", &viewListener);

// Execute JavaScript
view->ExecuteScript(L"document.getElementById('title').innerText = 'Hello from C++';");

// Handle input (assuming mouse coordinates are known)
Coherent::UI::EventMouseModifiersState modifiers;
view->InjectMouseMove(mouseX, mouseY, modifiers);

// Cleanup when done
view->Destroy();
```

## See Also

- [ViewContext](ViewContext.md)
- [ViewInfo](ViewInfo.md)
- [ViewListener](ViewListener.md)
- [Input Handling](../Guides/Input_Handling.md) 