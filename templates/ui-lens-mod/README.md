# UI Lens Mod Template

This template demonstrates how to create a custom map lens for Civilization VII. It includes a sample resource potential lens that highlights tiles based on their potential for different types of resources.

## Structure

- `ui-lens-mod.modinfo`: The mod definition file
- `ui/scripts/resource-potential-lens.js`: JavaScript code for the lens functionality
- `ui/styles/resource-lens.css`: CSS styling for the lens UI elements
- `ui/icons/resource_lens_icon.png`: Icon for the lens button
- `text/en_us/LensText.xml`: Localization for lens text

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Modify the JavaScript and CSS files to implement your custom lens
4. Update the localization text to match your lens
5. Test your mod in-game

## How Map Lenses Work

Map lenses in Civilization VII allow players to view the map with specialized overlays that highlight specific information. This template demonstrates:

1. **Registering a Lens**: Adding your lens to the game's lens system
2. **Activating/Deactivating**: Handling lens toggle events
3. **Coloring Hexes**: Applying colors to the map based on custom logic
4. **UI Integration**: Adding a button to the lens bar
5. **Styling**: Customizing the appearance of lens UI elements

## Customizing the Lens

The resource potential lens in this template is just one example. You can create lenses for many purposes:

- **Appeal Lens**: Highlight tiles based on appeal values
- **Defense Lens**: Show defensive bonuses for units
- **Expansion Lens**: Highlight optimal city locations
- **Danger Lens**: Show areas threatened by enemy units
- **Yield Lens**: Visualize potential yields from improvements

## Reference Documentation

For more information on UI modding and lenses, refer to:
- [UI Modding Guide](../ui-modding.md) - For detailed information on UI modding
- [CSS Styling Guide](../css-styling-guide.md) - For styling UI elements
- [Game Event Reference](../game-event-reference.md) - For understanding game events
- [UI Component Reference](../ui-component-reference.md) - For working with UI components

## Tips

- Use the browser console (accessible through the in-game developer tools) to debug your lens
- Test your lens with different map types and game settings
- Consider performance implications when processing many map tiles
- Use clear, distinguishable colors for different lens categories
- Add a legend to help players understand what the colors mean 