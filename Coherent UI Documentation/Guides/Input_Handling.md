# Input Handling

This guide explains how to handle user input in Coherent UI, including mouse, keyboard, and touch events.

## Overview

Coherent UI provides a comprehensive input system that allows you to:

1. Inject input events from your game into the UI
2. Determine whether input should go to the UI or the game
3. Handle input in JavaScript for UI interactions
4. Support various input devices (mouse, keyboard, touch)

## Input Flow

When a user interacts with your game, input events need to be routed appropriately:

1. Input is received by your game from the operating system
2. Your game determines whether the input is over a UI element
3. If it's over the UI, the input is injected into the appropriate view
4. The input event is processed by the HTML/JavaScript
5. Input not handled by the UI is passed back to the game

## Detecting Input Over UI

To determine if input should go to the UI, you need to check if the mouse cursor is over a UI element:

```cpp
bool IsMouseOverUI(int x, int y) {
	// Iterate through all views, front to back
	for (auto* view : m_Views) {
		// Convert screen coordinates to view coordinates
		int viewX = x - view->GetPositionX();
		int viewY = y - view->GetPositionY();
		
		// Check if the point is within the view bounds
		if (viewX >= 0 && viewX < view->GetWidth() &&
			viewY >= 0 && viewY < view->GetHeight()) {
			
			// Check if the view has input at this point
			if (view->HasInputAtPoint(viewX, viewY)) {
				return true;
			}
		}
	}
	
	return false;
}
```

The `View::HasInputAtPoint` method will return `true` if there is a non-transparent UI element at the specified point.

## Mouse Input

### Injecting Mouse Movement

```cpp
void InjectMouseMove(Coherent::UI::View* view, int x, int y) {
	// Create mouse modifiers (Shift, Ctrl, Alt, etc.)
	Coherent::UI::EventMouseModifiersState modifiers;
	modifiers.IsShiftDown = (GetAsyncKeyState(VK_SHIFT) & 0x8000) != 0;
	modifiers.IsControlDown = (GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0;
	modifiers.IsAltDown = (GetAsyncKeyState(VK_MENU) & 0x8000) != 0;
	
	// Inject the mouse move event
	view->InjectMouseMove(x, y, modifiers);
}
```

### Injecting Mouse Buttons

```cpp
void InjectMouseDown(Coherent::UI::View* view, int x, int y, int button) {
	Coherent::UI::EventMouseModifiersState modifiers;
	// ... set modifiers ...
	
	Coherent::UI::MouseButton mouseButton;
	switch (button) {
		case 0: mouseButton = Coherent::UI::MouseButton::Left; break;
		case 1: mouseButton = Coherent::UI::MouseButton::Middle; break;
		case 2: mouseButton = Coherent::UI::MouseButton::Right; break;
		default: return;
	}
	
	view->InjectMouseDown(x, y, mouseButton, modifiers);
}

void InjectMouseUp(Coherent::UI::View* view, int x, int y, int button) {
	Coherent::UI::EventMouseModifiersState modifiers;
	// ... set modifiers ...
	
	Coherent::UI::MouseButton mouseButton;
	// ... determine mouse button ...
	
	view->InjectMouseUp(x, y, mouseButton, modifiers);
}
```

### Injecting Mouse Wheel

```cpp
void InjectMouseWheel(Coherent::UI::View* view, int x, int y, int delta) {
	Coherent::UI::EventMouseModifiersState modifiers;
	// ... set modifiers ...
	
	view->InjectMouseWheel(x, y, delta, modifiers);
}
```

## Keyboard Input

### Injecting Keyboard Events

```cpp
void InjectKeyDown(Coherent::UI::View* view, int key, int character) {
	Coherent::UI::EventModifiersState modifiers;
	// ... set modifiers ...
	
	view->InjectKeyboardEvent(Coherent::UI::KeyEventType::KeyDown, key, character, modifiers);
}

void InjectKeyUp(Coherent::UI::View* view, int key, int character) {
	Coherent::UI::EventModifiersState modifiers;
	// ... set modifiers ...
	
	view->InjectKeyboardEvent(Coherent::UI::KeyEventType::KeyUp, key, character, modifiers);
}

void InjectKeyChar(Coherent::UI::View* view, int character) {
	Coherent::UI::EventModifiersState modifiers;
	// ... set modifiers ...
	
	view->InjectKeyboardEvent(Coherent::UI::KeyEventType::Char, 0, character, modifiers);
}
```

### Key Codes

Coherent UI uses standard key codes that are compatible with the JavaScript key codes used in web browsers. For example:

```cpp
// Key codes
const int KEY_BACKSPACE = 8;
const int KEY_TAB = 9;
const int KEY_ENTER = 13;
const int KEY_SHIFT = 16;
const int KEY_CONTROL = 17;
const int KEY_ALT = 18;
const int KEY_ESCAPE = 27;
const int KEY_SPACE = 32;
// ... and so on
```

## Touch Input

For touch-enabled devices, Coherent UI supports touch events:

```cpp
void InjectTouchEvent(Coherent::UI::View* view, Coherent::UI::TouchEventType type, 
                     const std::vector<Coherent::UI::TouchPoint>& points) {
	view->InjectTouchEvent(type, points);
}

// Example: Injecting a touch start event
void InjectTouchStart(Coherent::UI::View* view, int x, int y, int id) {
	std::vector<Coherent::UI::TouchPoint> points;
	
	Coherent::UI::TouchPoint point;
	point.Id = id;
	point.X = x;
	point.Y = y;
	
	points.push_back(point);
	
	view->InjectTouchEvent(Coherent::UI::TouchEventType::Start, points);
}
```

## Input Focus

Coherent UI views can have input focus, which determines which view receives keyboard events:

```cpp
// Give focus to a view
view->SetFocus(true);

// Remove focus from a view
view->SetFocus(false);
```

Only one view should have focus at a time. You'll need to manage this yourself by removing focus from other views when setting focus on a new view.

## JavaScript Event Handling

In your HTML/JavaScript, you can handle input events using standard web event listeners:

```javascript
// Mouse events
document.addEventListener('mousedown', function(e) {
	console.log('Mouse down at: ' + e.clientX + ', ' + e.clientY);
});

document.addEventListener('mouseup', function(e) {
	console.log('Mouse up at: ' + e.clientX + ', ' + e.clientY);
});

document.addEventListener('mousemove', function(e) {
	console.log('Mouse move at: ' + e.clientX + ', ' + e.clientY);
});

// Keyboard events
document.addEventListener('keydown', function(e) {
	console.log('Key down: ' + e.keyCode);
});

document.addEventListener('keyup', function(e) {
	console.log('Key up: ' + e.keyCode);
});

// Touch events
document.addEventListener('touchstart', function(e) {
	for (var i = 0; i < e.touches.length; i++) {
		var touch = e.touches[i];
		console.log('Touch start at: ' + touch.clientX + ', ' + touch.clientY);
	}
});
```

## 3D Input

Coherent UI can also be used in 3D environments, where UIs might be placed on objects in the 3D world. In this case, you need to:

1. Perform a ray cast from the camera through the mouse position
2. Check if the ray intersects a UI surface
3. Transform the intersection point to UI coordinates
4. Inject input events at those coordinates

```cpp
void HandleMouseInputIn3D(int screenX, int screenY) {
	// Calculate ray from camera through mouse position
	Ray ray = CalculateRayFromScreen(screenX, screenY);
	
	// Check intersection with UI surfaces
	RaycastResult result;
	if (Raycast(ray, result)) {
		// Get the view attached to the hit object
		Coherent::UI::View* view = GetViewForObject(result.HitObject);
		if (view) {
			// Convert 3D intersection point to view coordinates
			int viewX, viewY;
			ConvertWorldToView(result.HitPoint, view, viewX, viewY);
			
			// Inject mouse event
			InjectMouseMove(view, viewX, viewY);
		}
	}
}
```

## Input Method Editor (IME)

For languages that require complex input methods (like Chinese, Japanese, or Korean), Coherent UI supports IME:

```cpp
// Position the IME at a specific location (e.g., near a text input)
viewContext->SetIMEPosition(x, y);
```

See the [IME Support](IME_Support.md) guide for more details.

## Best Practices

1. **Always check for UI input first**: Process UI input before game input to ensure the UI gets priority.

2. **Maintain input state**: Keep track of which mouse buttons are down and which keys are pressed to handle edge cases.

3. **Support hover states**: Inject mouse moves even when no buttons are pressed to enable hover effects.

4. **Handle focus properly**: Only send keyboard events to the view that has focus.

5. **Consider device-specific input**: Adapt your input handling for different devices (desktop, mobile, console).

6. **Optimize input injection**: Only inject input events when necessary to minimize overhead.

## Common Issues

### Mouse Position Offset

If mouse position seems offset from the actual UI elements, check:
- The view's position in the game window
- Any scaling applied to the UI
- Differences between logical and physical pixels on high-DPI displays

### Keyboard Focus

If keyboard input isn't working properly:
- Ensure the view has focus (`view->SetFocus(true)`)
- Verify that the correct key codes are being used
- Check that keyboard events are being injected in the right order (down → char → up)

### Touch Input Not Working

For touch input issues:
- Ensure touch events are being properly translated from platform-specific formats
- Verify touch point IDs are consistent across touch move and touch end events
- Check that multi-touch gestures are properly handled

## See Also

- [View API](../API%20Reference/View.md)
- [ViewContext API](../API%20Reference/ViewContext.md)
- [EventModifiersState API](../API%20Reference/EventModifiersState.md)
- [MouseEventData API](../API%20Reference/MouseEventData.md)
- [KeyEventData API](../API%20Reference/KeyEventData.md)
- [TouchEventData API](../API%20Reference/TouchEventData.md)
- [IME Support](IME_Support.md)
- [Input in 2D Sample](../Samples/Input_2D.md)
- [Input in 3D Sample](../Samples/Input_3D.md) 