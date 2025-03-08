# UI Component Reference for Civilization VII

This reference document outlines all the standard UI components available in Civilization VII's UI system. Understanding these components is essential for creating and modifying UI elements in your mods.

## Table of Contents
- [Introduction](#introduction)
- [Common Attributes](#common-attributes)
- [Layout Components](#layout-components)
  - [Panel](#panel)
  - [Container](#container)
  - [Stack](#stack)
  - [Grid](#grid)
  - [Scroll Panel](#scroll-panel)
- [Display Components](#display-components)
  - [Label](#label)
  - [Image](#image)
  - [Movie](#movie)
  - [Tooltip](#tooltip)
- [Interactive Components](#interactive-components)
  - [Button](#button)
  - [CheckBox](#checkbox)
  - [Slider](#slider)
  - [Dropdown](#dropdown)
  - [TextEntry](#textentry)
- [Game-Specific Components](#game-specific-components)
  - [ResourceDisplay](#resourcedisplay)
  - [CivIcon](#civicon)
  - [LeaderIcon](#leadericon)
  - [TechIcon](#techicon)
  - [UnitIcon](#uniticon)
- [Custom Components](#custom-components)
- [Component Usage Examples](#component-usage-examples)
- [Related Documentation](#related-documentation)

## Introduction

Civilization VII's UI system, powered by Coherent UI, provides a range of pre-built components for creating user interfaces. These components can be instantiated in XML files and manipulated via JavaScript.

The component system follows a hierarchical structure, with parent elements containing and positioning child elements. Most components share common attributes, while also having their own unique properties.

## Common Attributes

These attributes are available on most UI components:

| Attribute | Type | Description | Example |
|-----------|------|-------------|---------|
| `ID` | String | Unique identifier for the element | `ID="TechButton"` |
| `Size` | String | Width and height in pixels | `Size="200,50"` |
| `Offset` | String | Position offset from parent | `Offset="10,5"` |
| `Anchor` | String | Anchoring point within parent | `Anchor="L,T"` |
| `Style` | String | Reference to a style class | `Style="StandardButton"` |
| `Texture` | String | Path to texture/image | `Texture="Button.dds"` |
| `Color` | String | RGBA color value | `Color="255,255,255,255"` |
| `String` | String | Text content or localization key | `String="LOC_BUTTON_CONFIRM"` |
| `ToolTip` | String | Tooltip text/key | `ToolTip="LOC_TOOLTIP_TECH"` |
| `Hidden` | Boolean | Whether element is initially hidden | `Hidden="1"` |
| `Disabled` | Boolean | Whether element is initially disabled | `Disabled="0"` |

## Layout Components

Layout components control the arrangement and positioning of other UI elements.

### Panel

The `Panel` component is the root element for most UI screens and panels.

```xml
<Panel ID="MainPanel" Size="800,600">
	<!-- Child elements go here -->
</Panel>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Padding` | String | Internal padding | `"0,0,0,0"` |
| `ConsumeMouseOver` | Boolean | Whether it captures mouse events | `true` |
| `ConsumeMouseButton` | Boolean | Whether it captures click events | `true` |

### Container

A basic container for grouping and positioning elements.

```xml
<Container ID="ResourceContainer" Size="200,100" Texture="PanelBackground.dds">
	<!-- Child elements go here -->
</Container>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Texture` | String | Background texture | `""` |
| `TextureOffset` | String | Offset for the background texture | `"0,0"` |
| `TextureSize` | String | Size of the background texture | `"0,0"` (full size) |

### Stack

A container that arranges its children in a horizontal or vertical stack.

```xml
<Stack ID="ButtonStack" StackGrowth="Right" Padding="5,5">
	<Button ID="Button1" Size="100,40" String="First" />
	<Button ID="Button2" Size="100,40" String="Second" />
	<Button ID="Button3" Size="100,40" String="Third" />
</Stack>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `StackGrowth` | String | Direction of growth ("Up", "Down", "Left", "Right") | `"Down"` |
| `Padding` | String | Space between elements | `"0,0"` |
| `WrapWidth` | Integer | Width at which to wrap elements | `0` (no wrap) |
| `WrapGrowth` | String | Secondary growth direction when wrapping | `"Down"` |

### Grid

A container that arranges its children in a grid layout.

```xml
<Grid ID="ResourceGrid" Columns="3" Padding="5,5">
	<Image ID="Food" Texture="FoodIcon.dds" Size="32,32" />
	<Image ID="Production" Texture="ProductionIcon.dds" Size="32,32" />
	<Image ID="Gold" Texture="GoldIcon.dds" Size="32,32" />
	<Label ID="FoodValue" String="0" />
	<Label ID="ProductionValue" String="0" />
	<Label ID="GoldValue" String="0" />
</Grid>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Columns` | Integer | Number of columns | `1` |
| `Padding` | String | Space between elements | `"0,0"` |
| `FillDown` | Boolean | Fill grid down first, then across | `false` |
| `FillUniformly` | Boolean | Make all grid cells the same size | `false` |

### Scroll Panel

A container that provides scrolling functionality for content that exceeds its dimensions.

```xml
<ScrollPanel ID="TechTreeScroll" Size="800,400" Vertical="1">
	<Stack ID="TechTree" StackGrowth="Right" Padding="10,10">
		<!-- Tech tree elements go here -->
	</Stack>
</ScrollPanel>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Vertical` | Boolean | Enable vertical scrolling | `false` |
| `Horizontal` | Boolean | Enable horizontal scrolling | `false` |
| `ScrollValue` | Float | Initial scroll position (0.0-1.0) | `0.0` |
| `ScrollStep` | Float | Scroll step per wheel click | `0.1` |

## Display Components

Display components present information to the user without necessarily providing interactivity.

### Label

Displays text to the user.

```xml
<Label ID="Title" Style="HeaderText" String="LOC_TECH_TREE_TITLE" Anchor="C,T" Offset="0,10" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `String` | String | Text content or localization key | `""` |
| `Font` | String | Font family | `"Arial"` |
| `FontSize` | Integer | Font size in pixels | `16` |
| `Color` | String | Text color (RGBA) | `"255,255,255,255"` |
| `Align` | String | Text alignment ("Left", "Center", "Right") | `"Left"` |
| `WrapWidth` | Integer | Width at which to wrap text | `0` (no wrap) |
| `TruncateWidth` | Integer | Width at which to truncate text | `0` (no truncate) |

### Image

Displays an image or texture.

```xml
<Image ID="ResourceIcon" Texture="GoldIcon.dds" Size="32,32" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Texture` | String | Path to the texture | `""` |
| `TextureOffset` | String | Offset within texture | `"0,0"` |
| `TextureSize` | String | Size of texture region to use | `"0,0"` (full texture) |
| `Color` | String | Tint color (RGBA) | `"255,255,255,255"` |
| `Scale` | Float | Scale factor | `1.0` |

### Movie

Displays a video or animated sequence.

```xml
<Movie ID="IntroMovie" Size="800,450" Texture="Videos/Intro.bk2" Loop="0" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Texture` | String | Path to the video file | `""` |
| `Loop` | Boolean | Whether the video should loop | `false` |
| `StartFrame` | Integer | Frame to start playback from | `0` |
| `AutoPlay` | Boolean | Whether to play automatically | `false` |

### Tooltip

Displays information when hovering over an element.

```xml
<Tooltip ID="BuildingTooltip">
	<Label String="LOC_BUILDING_TOOLTIP" WrapWidth="300" />
</Tooltip>
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Delay` | Integer | Delay before showing (milliseconds) | `500` |
| `Offset` | String | Offset from mouse position | `"15,15"` |
| `FollowMouse` | Boolean | Whether the tooltip follows the mouse | `false` |

## Interactive Components

Interactive components allow user input and interaction.

### Button

A clickable button element.

```xml
<Button ID="ConfirmButton" Size="150,40" String="LOC_CONFIRM" Style="StandardButton" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `String` | String | Button label text | `""` |
| `Texture` | String | Button background texture | `""` |
| `TextureOffsetNormal` | String | Texture offset for normal state | `"0,0"` |
| `TextureOffsetHover` | String | Texture offset for hover state | `"0,0"` |
| `TextureOffsetPressed` | String | Texture offset for pressed state | `"0,0"` |
| `TextureOffsetDisabled` | String | Texture offset for disabled state | `"0,0"` |
| `StateOffsetIncrement` | String | Increment for state offsets | `"0,0"` |
| `ClickSound` | String | Sound to play when clicked | `""` |

### CheckBox

A toggle control that can be checked or unchecked.

```xml
<CheckBox ID="ShowMapLabels" Size="32,32" Texture="Checkbox.dds" TextureOffset="0,0" StateOffsetIncrement="0,32" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Checked` | Boolean | Initial state (checked/unchecked) | `false` |
| `Texture` | String | Checkbox texture | `""` |
| `TextureOffset` | String | Base texture offset | `"0,0"` |
| `StateOffsetIncrement` | String | Offset increment for different states | `"0,0"` |

### Slider

A control for selecting a value from a continuous range.

```xml
<Slider ID="VolumeControl" Size="200,20" Texture="SliderBG.dds" ThumbTexture="SliderThumb.dds" Min="0" Max="100" Step="1" InitValue="50" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `Min` | Float | Minimum value | `0.0` |
| `Max` | Float | Maximum value | `100.0` |
| `Step` | Float | Value increment | `1.0` |
| `InitValue` | Float | Initial value | `0.0` |
| `Texture` | String | Background texture | `""` |
| `ThumbTexture` | String | Thumb/handle texture | `""` |
| `ThumbSize` | String | Size of thumb/handle | `"20,20"` |
| `Vertical` | Boolean | Vertical orientation | `false` |

### Dropdown

A control for selecting one option from a list.

```xml
<Dropdown ID="ResolutionDropdown" Size="200,40" String="LOC_OPTIONS_RESOLUTION" Style="StandardDropdown" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `String` | String | Label text | `""` |
| `Texture` | String | Background texture | `""` |
| `SelectedIndex` | Integer | Initial selected index | `0` |
| `MaxHeight` | Integer | Maximum height of dropdown list | `300` |
| `ScrollThreshold` | Integer | Item count before scrolling | `10` |

### TextEntry

A control for text input.

```xml
<TextEntry ID="SearchBox" Size="300,40" PlaceholderText="LOC_SEARCH_PLACEHOLDER" MaxLength="100" Style="StandardTextEntry" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `String` | String | Initial text | `""` |
| `PlaceholderText` | String | Placeholder text | `""` |
| `MaxLength` | Integer | Maximum text length | `0` (unlimited) |
| `TextColor` | String | Text color (RGBA) | `"255,255,255,255"` |
| `PlaceholderColor` | String | Placeholder text color | `"150,150,150,255"` |
| `Multiline` | Boolean | Allow multiple lines | `false` |
| `Password` | Boolean | Hide input (for passwords) | `false` |

## Game-Specific Components

These components are specific to Civilization VII's UI system and provide specialized functionality.

### ResourceDisplay

Displays a game resource with icon and amount.

```xml
<ResourceDisplay ID="GoldDisplay" ResourceType="RESOURCE_GOLD" Size="80,32" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `ResourceType` | String | Type of resource to display | `""` |
| `ShowIcon` | Boolean | Whether to show the resource icon | `true` |
| `ShowAmount` | Boolean | Whether to show the resource amount | `true` |
| `TextStyle` | String | Style for the amount text | `"ResourceText"` |
| `IconSize` | String | Size of the resource icon | `"24,24"` |

### CivIcon

Displays a civilization icon.

```xml
<CivIcon ID="PlayerCiv" CivType="CIVILIZATION_AMERICA" Size="64,64" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `CivType` | String | Civilization type to display | `""` |
| `Size` | String | Size of the icon | `"64,64"` |
| `ShowOutline` | Boolean | Whether to show civ color outline | `true` |
| `ShowTooltip` | Boolean | Whether to show tooltip on hover | `true` |

### LeaderIcon

Displays a leader portrait.

```xml
<LeaderIcon ID="PlayerLeader" LeaderType="LEADER_TRAJAN" Size="128,128" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `LeaderType` | String | Leader type to display | `""` |
| `Size` | String | Size of the portrait | `"128,128"` |
| `DisplayMode` | String | Display mode ("Portrait", "FullBody") | `"Portrait"` |
| `ShowTooltip` | Boolean | Whether to show tooltip on hover | `true` |

### TechIcon

Displays a technology icon.

```xml
<TechIcon ID="CurrentTech" TechType="TECH_WRITING" Size="48,48" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `TechType` | String | Technology type to display | `""` |
| `Size` | String | Size of the icon | `"48,48"` |
| `ShowProgress` | Boolean | Whether to show research progress | `false` |
| `ShowName` | Boolean | Whether to show tech name | `false` |
| `ShowTooltip` | Boolean | Whether to show tooltip on hover | `true` |

### UnitIcon

Displays a unit icon.

```xml
<UnitIcon ID="SelectedUnit" UnitType="UNIT_WARRIOR" Size="48,48" />
```

#### Attributes

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `UnitType` | String | Unit type to display | `""` |
| `Size` | String | Size of the icon | `"48,48"` |
| `ShowHealth` | Boolean | Whether to show unit health | `false` |
| `ShowStrength` | Boolean | Whether to show combat strength | `false` |
| `ShowTooltip` | Boolean | Whether to show tooltip on hover | `true` |

## Custom Components

You can create custom components by combining existing ones. Here's an example of a custom panel component:

```xml
<!-- ResearchPanel.xml -->
<Panel ID="CustomResearchPanel">
  <Container ID="Background" Size="300,150" Texture="ResearchPanelBG.dds">
    <Stack ID="Content" StackGrowth="Down" Padding="10,10">
      <Label ID="Title" String="LOC_CURRENT_RESEARCH" Style="HeaderText" />
      <Grid Columns="2" Padding="5,5">
        <TechIcon ID="CurrentTech" TechType="TECH_WRITING" Size="64,64" />
        <Stack ID="TechInfo" StackGrowth="Down" Padding="0,5">
          <Label ID="TechName" String="LOC_TECH_WRITING_NAME" Style="SubheaderText" />
          <Label ID="TechProgress" String="5/20 Turns" Style="BodyText" />
          <Label ID="TechBoosts" String="LOC_TECH_WRITING_BOOST" Style="BodyText" WrapWidth="200" />
        </Stack>
      </Grid>
      <Button ID="ChangeTech" Size="280,40" String="LOC_CHOOSE_RESEARCH" />
    </Stack>
  </Container>
</Panel>
```

## Component Usage Examples

### Creating a Resource Bar

```xml
<Stack ID="ResourceBar" StackGrowth="Right" Padding="10,0" Size="800,40">
  <ResourceDisplay ID="FoodDisplay" ResourceType="RESOURCE_FOOD" Size="80,32" />
  <ResourceDisplay ID="ProductionDisplay" ResourceType="RESOURCE_PRODUCTION" Size="80,32" />
  <ResourceDisplay ID="GoldDisplay" ResourceType="RESOURCE_GOLD" Size="80,32" />
  <ResourceDisplay ID="ScienceDisplay" ResourceType="RESOURCE_SCIENCE" Size="80,32" />
  <ResourceDisplay ID="CultureDisplay" ResourceType="RESOURCE_CULTURE" Size="80,32" />
  <ResourceDisplay ID="FaithDisplay" ResourceType="RESOURCE_FAITH" Size="80,32" />
</Stack>
```

### Creating a Unit Info Panel

```xml
<Panel ID="UnitInfoPanel" Size="300,400">
  <Container ID="Background" Size="300,400" Texture="UnitPanelBG.dds">
    <Stack ID="Content" StackGrowth="Down" Padding="10,10">
      <Label ID="UnitName" String="Warrior" Style="HeaderText" />
      <UnitIcon ID="UnitIcon" UnitType="UNIT_WARRIOR" Size="64,64" />
      
      <Grid ID="UnitStats" Columns="2" Padding="5,5">
        <Label String="LOC_STRENGTH" Style="BodyTextBold" />
        <Label ID="UnitStrength" String="20" Style="BodyText" />
        
        <Label String="LOC_MOVEMENT" Style="BodyTextBold" />
        <Label ID="UnitMovement" String="2/2" Style="BodyText" />
        
        <Label String="LOC_HEALTH" Style="BodyTextBold" />
        <Label ID="UnitHealth" String="100%" Style="BodyText" />
      </Grid>
      
      <Label String="LOC_PROMOTIONS" Style="SubheaderText" />
      <ScrollPanel ID="PromotionsScroll" Size="280,100" Vertical="1">
        <Stack ID="PromotionsList" StackGrowth="Down" Padding="0,5">
          <!-- Promotions would be added here dynamically -->
        </Stack>
      </ScrollPanel>
      
      <Stack ID="ActionButtons" StackGrowth="Right" Padding="5,0">
        <Button ID="PromoteButton" Size="90,40" String="LOC_PROMOTE" />
        <Button ID="MoveButton" Size="90,40" String="LOC_MOVE" />
        <Button ID="AttackButton" Size="90,40" String="LOC_ATTACK" />
      </Stack>
    </Stack>
  </Container>
</Panel>
```

### Creating a Tech Tree Node

```xml
<Container ID="TechNode" Size="150,180">
  <Stack StackGrowth="Down" Padding="0,5">
    <TechIcon ID="TechIcon" TechType="TECH_WRITING" Size="64,64" />
    <Label ID="TechName" String="LOC_TECH_WRITING_NAME" Style="TechNameText" WrapWidth="150" />
    <Label ID="TechCost" String="20 Turns" Style="TechCostText" />
    <Stack ID="UnlockIcons" StackGrowth="Right" Padding="5,0">
      <!-- Unlock icons would be added here dynamically -->
    </Stack>
    <Button ID="ResearchButton" Size="140,30" String="LOC_RESEARCH" />
  </Stack>
</Container>
```

## Related Documentation

For more information about UI development in Civilization VII, refer to these guides:

- [UI Modding Guide](./ui-modding.md) - Comprehensive guide to modifying the UI
- [Coherent UI Readme](./coherent-ui-readme.md) - Introduction to Coherent UI in Civilization VII
- [CSS Styling Guide](./css-styling-guide.md) - Guide to styling UI components
- [Game Event Reference](./game-event-reference.md) - Reference for game events used in UI scripting

---

*This reference guide is based on Civilization VII's UI components as of the current game version. Component availability and properties may change with game updates.* 