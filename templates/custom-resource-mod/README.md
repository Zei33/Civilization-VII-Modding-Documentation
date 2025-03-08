# Custom Resource Mod Template

This template demonstrates how to add new resources to Civilization VII. It includes examples of two luxury resources: Coffee and Jade, with complete database entries, localization, and icon placeholders.

## Structure

- `custom-resource-mod.modinfo`: The mod definition file
- `data/resources.sql`: SQL definitions for the new resources
- `text/en_us/ResourceText.xml`: Localized text for the resources
- `art/icons/`: Directory for resource icons (includes sample icons for Coffee and Jade)

## Getting Started

1. Rename the mod folder and `.modinfo` file to match your mod's unique name
2. Update the mod ID in the `.modinfo` file to something unique (e.g., "com.yourusername.yourmodname")
3. Edit the SQL file to define your custom resources
4. Update the localization text to match your resources
5. Create and add custom icons for your resources
6. Test your mod in-game

## Resource Types

Civilization VII has several resource types that serve different purposes:

1. **Luxury Resources**: Provide Amenities to make citizens happy
2. **Strategic Resources**: Required for certain units and buildings
3. **Bonus Resources**: Provide extra yields but no special bonuses

This template focuses on luxury resources, but you can modify it to create any resource type.

## Key Components of a Resource

To create a complete resource, you need to define:

1. **Basic Properties**: Name, description, resource class
2. **Placement Rules**: Where the resource can appear on maps
3. **Yields**: What bonuses the resource provides
4. **Improvements**: How the resource can be developed
5. **Visibility**: What technology reveals the resource
6. **Consumption**: How the resource is used by buildings/units
7. **Icons**: Visual representation of the resource

The template shows examples of all these components.

## Customizing Resources

When creating your own resources, consider:

- **Historical Basis**: Choose resources that make historical sense
- **Gameplay Impact**: How will the resource affect game balance?
- **Geographic Distribution**: Where should the resource appear?
- **Visual Design**: Create distinctive, recognizable icons

## Reference Documentation

For more information on creating resources, refer to:
- [Database Modding Guide](../database-modding.md) - For understanding the database structure
- [Asset Creation Guide](../asset-creation.md) - For creating resource icons
- [Gameplay Modding Guide](../gameplay-modding.md) - For integrating resources with gameplay

## Tips

- Test your resources on different map types to ensure proper distribution
- Balance your resource yields against existing ones
- Consider creating resource-specific improvements for more unique gameplay
- Add detailed civilopedia entries to enhance immersion 