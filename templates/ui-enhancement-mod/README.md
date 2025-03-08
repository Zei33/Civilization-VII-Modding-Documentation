# UI Enhancement Mod Template

This template demonstrates how to create a mod that enhances the Civilization VII user interface using HTML, CSS, and JavaScript. The example focuses on improving tooltips with additional information and styling.

## Structure

- `ui-enhancement-mod.modinfo`: The mod definition file
- `ui/scripts/enhanced-tooltip.js`: JavaScript code to enhance tooltips
- `ui/styles/enhanced-tooltip.css`: CSS styling for enhanced tooltips
- `ui/icons/tooltip_enhancement_icon.png`: Icon for the UI enhancement
- `text/en_us/LocalizedText.xml`: Localization strings for UI enhancements

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Modify the JavaScript, CSS, and localization files to implement your UI enhancements
4. Test your mod in-game

## How It Works

This template demonstrates several key UI modding techniques:

1. **DOM Manipulation**: Using JavaScript to modify the game's HTML elements
2. **Event Handling**: Subscribing to game events to trigger UI changes
3. **Styling**: Applying custom CSS to enhance visual appearance
4. **Localization**: Using localized text for a multilingual experience

## Reference Documentation

For more information on UI modding, refer to:
- [UI Modding Guide](../ui-modding.md)
- [CSS Styling Guide](../css-styling-guide.md)
- [Coherent UI Documentation](../coherent-ui-readme.md)
- [UI Component Reference](../ui-component-reference.md)

## Tips

- Use browser developer tools to inspect the game's UI structure
- Start with small, targeted enhancements before attempting complex UI changes
- Test your mod at different screen resolutions and UI scales
- Consider accessibility when designing UI enhancements
- Review the existing UI components before creating new ones from scratch 