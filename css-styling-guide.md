# CSS Styling Guide for Civilization VII

This guide covers CSS styling techniques, best practices, and conventions for Civilization VII UI modding. Understanding these concepts will help you create visually appealing and consistent user interfaces for your mods.

## Table of Contents
- [Introduction](#introduction)
- [CSS in Civilization VII](#css-in-civilization-vii)
- [Styling Fundamentals](#styling-fundamentals)
- [Selectors and Specificity](#selectors-and-specificity)
- [Layout Techniques](#layout-techniques)
- [Typography and Text](#typography-and-text)
- [Colors and Themes](#colors-and-themes)
- [Animations and Transitions](#animations-and-transitions)
- [Responsive Design](#responsive-design)
- [Performance Optimization](#performance-optimization)
- [Debugging CSS](#debugging-css)
- [Common Patterns](#common-patterns)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Introduction

Civilization VII's user interface is built with Coherent UI, which supports modern CSS features. This allows modders to use familiar web styling techniques to customize the appearance of UI elements. This guide will cover the basics of CSS styling in the context of Civilization VII modding, as well as advanced techniques for creating polished and professional user interfaces.

## CSS in Civilization VII

### CSS File Organization

In Civilization VII mods, CSS files are typically organized as follows:

```
YourMod/
├── ui/
│   ├── Styles/
│   │   ├── Main.css          - Main stylesheet
│   │   ├── Panels.css        - Panel-specific styles
│   │   ├── Components.css    - Reusable component styles
│   │   └── Theme.css         - Color schemes and theming
└── YourMod.modinfo
```

### Adding CSS to Your Mod

To include CSS in your mod, add it to your `.modinfo` file:

```xml
<AddUIScript id="my-mod-styles">
	<File>ui/Styles/Main.css</File>
</AddUIScript>
```

### CSS Loading Order

CSS files load in the order they're listed in the `.modinfo` file. Later styles can override earlier ones, so organize your CSS files accordingly:

```xml
<AddUIScript id="my-mod-base-styles">
	<File>ui/Styles/Theme.css</File>
</AddUIScript>
<AddUIScript id="my-mod-component-styles">
	<File>ui/Styles/Components.css</File>
</AddUIScript>
<AddUIScript id="my-mod-panel-styles">
	<File>ui/Styles/Panels.css</File>
</AddUIScript>
<AddUIScript id="my-mod-override-styles">
	<File>ui/Styles/Overrides.css</File>
</AddUIScript>
```

## Styling Fundamentals

### Basic Syntax

CSS in Civilization VII follows standard CSS syntax:

```css
/* Selector targets an element */
.ResourcePanel {
	background-color: rgba(0, 0, 0, 0.7);
	border: 1px solid #c2ab78;
	padding: 10px;
	border-radius: 5px;
}

/* Multiple selectors can share rules */
.GoldText, .ScienceText, .CultureText {
	font-weight: bold;
	text-shadow: 1px 1px 2px #000000;
}

/* Target specific elements */
.GoldText { color: #FFD700; }
.ScienceText { color: #00BFFF; }
.CultureText { color: #FF69B4; }
```

### Supported CSS Features

Civilization VII's UI system supports most modern CSS features:

- CSS3 selectors
- Flexbox and Grid layout
- Animations and transitions
- Custom properties (CSS variables)
- Transforms and effects
- Media queries

## Selectors and Specificity

Understanding CSS selectors and specificity is crucial for effective UI styling.

### Selector Types

```css
/* Element type selector */
Label {
	font-size: 14px;
}

/* Class selector */
.HeaderText {
	font-size: 24px;
	font-weight: bold;
}

/* ID selector */
#MainPanel {
	background-color: rgba(0, 0, 0, 0.8);
}

/* Attribute selector */
[String="LOC_TECH_TREE_TITLE"] {
	color: gold;
}

/* Descendant selector */
.ResourcePanel .ResourceIcon {
	width: 32px;
	height: 32px;
}

/* Child selector */
.ButtonStack > Button {
	margin: 2px;
}
```

### Specificity Rules

CSS rules follow specificity ranking to determine which styles are applied:

1. Inline styles (highest specificity)
2. ID selectors (`#MainPanel`)
3. Class and attribute selectors (`.HeaderText`, `[String="LOC_TITLE"]`)
4. Element type selectors (`Label`, `Button`)

```css
/* Lower specificity */
Label {
	color: white;
}

/* Medium specificity - overrides the rule above */
.HeaderText {
	color: gold;
}

/* Higher specificity - overrides both rules above */
#GameTitle {
	color: red;
}
```

### Avoiding Specificity Issues

To avoid specificity problems:

1. Use classes instead of IDs when possible
2. Avoid overly specific selectors
3. Organize CSS with a consistent methodology
4. Use `!important` sparingly (only when necessary to override game styles)

```css
/* Avoid this */
.MainPanel .ResourceSection .ResourceList .ResourceItem .ResourceIcon {
	width: 24px;
}

/* Better approach */
.ResourceIcon--small {
	width: 24px;
}
```

## Layout Techniques

Civilization VII's UI supports modern CSS layout techniques.

### Flexbox Layout

Flexbox is ideal for one-dimensional layouts (rows or columns):

```css
.ResourceBar {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
	padding: 5px 10px;
	background-color: rgba(0, 0, 0, 0.7);
}

.ResourceItem {
	display: flex;
	flex-direction: row;
	align-items: center;
	gap: 5px;
}

.Sidebar {
	display: flex;
	flex-direction: column;
	gap: 10px;
}
```

### Grid Layout

Grid is perfect for two-dimensional layouts:

```css
.CityInfoPanel {
	display: grid;
	grid-template-columns: 1fr 2fr 1fr;
	grid-template-rows: auto auto 1fr auto;
	gap: 10px;
	padding: 15px;
}

.CityHeader {
	grid-column: 1 / -1; /* Spans all columns */
}

.CityStats {
	grid-column: 1 / 2;
	grid-row: 2 / 4;
}

.CityBuildings {
	grid-column: 2 / 3;
	grid-row: 2 / 3;
}

.CityProduction {
	grid-column: 3 / 4;
	grid-row: 2 / 3;
}

.CityCitizens {
	grid-column: 2 / 4;
	grid-row: 3 / 4;
}

.CityActions {
	grid-column: 1 / -1;
	grid-row: 4 / 5;
}
```

### Positioning

Different positioning methods are available for specific needs:

```css
/* Static positioning (default) */
.NormalElement {
	/* No positioning properties needed */
}

/* Relative positioning */
.RelativeElement {
	position: relative;
	top: 10px;
	left: 5px;
}

/* Absolute positioning */
.AbsoluteElement {
	position: absolute;
	top: 0;
	right: 0;
}

/* Fixed positioning (relative to viewport) */
.FixedElement {
	position: fixed;
	bottom: 10px;
	right: 10px;
}

/* Sticky positioning */
.StickyHeader {
	position: sticky;
	top: 0;
	z-index: 100;
}
```

## Typography and Text

Typography is crucial for readability and visual hierarchy.

### Font Properties

```css
.HeaderText {
	font-family: "Trajan Pro", serif;
	font-size: 24px;
	font-weight: bold;
	letter-spacing: 1px;
	line-height: 1.2;
	text-transform: uppercase;
}

.BodyText {
	font-family: "Open Sans", sans-serif;
	font-size: 14px;
	font-weight: normal;
	line-height: 1.5;
}

.EmphasisText {
	font-style: italic;
	font-weight: 600;
}
```

### Text Styling

```css
.GoldAmount {
	color: #FFD700;
	text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.8);
}

.ButtonText {
	text-align: center;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.TooltipText {
	text-align: left;
	text-overflow: ellipsis;
	white-space: normal;
	overflow-wrap: break-word;
	max-width: 300px;
}
```

### Text Truncation

```css
.CityName {
	max-width: 150px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
```

## Colors and Themes

Consistent color usage creates a cohesive visual experience.

### Color Variables

Using CSS variables for themes:

```css
:root {
	/* Base colors */
	--color-gold: #FFD700;
	--color-science: #00BFFF;
	--color-culture: #FF69B4;
	--color-faith: #E066FF;
	--color-production: #CD5C5C;
	--color-food: #32CD32;
	
	/* Panel colors */
	--panel-bg: rgba(0, 0, 0, 0.75);
	--panel-border: #c2ab78;
	--panel-header: rgba(50, 40, 20, 0.9);
	
	/* Text colors */
	--text-normal: #F5F5F5;
	--text-dim: #A0A0A0;
	--text-highlight: #FFFFFF;
	--text-warning: #FF6347;
	
	/* UI element colors */
	--button-bg: rgba(40, 35, 25, 0.9);
	--button-hover: rgba(60, 50, 30, 0.9);
	--button-active: rgba(80, 65, 40, 0.9);
	--button-border: #c2ab78;
}

.GoldText { color: var(--color-gold); }
.ScienceText { color: var(--color-science); }

.StandardPanel {
	background-color: var(--panel-bg);
	border: 1px solid var(--panel-border);
}

.StandardButton {
	background-color: var(--button-bg);
	border: 1px solid var(--button-border);
	color: var(--text-normal);
}

.StandardButton:hover {
	background-color: var(--button-hover);
	color: var(--text-highlight);
}
```

### Color Functions

Use RGBA for transparency:

```css
.PanelBackground {
	/* Semi-transparent black background */
	background-color: rgba(0, 0, 0, 0.7);
}

.OverlayText {
	/* Text with shadow for readability */
	color: white;
	text-shadow: 0 0 3px rgba(0, 0, 0, 0.9);
}

.HoverHighlight:hover {
	/* Highlight effect on hover */
	background-color: rgba(255, 255, 255, 0.1);
}
```

## Animations and Transitions

Animations and transitions add polish to your UI.

### Transitions

```css
.StandardButton {
	background-color: var(--button-bg);
	border-color: var(--button-border);
	transition: background-color 0.2s ease, transform 0.1s ease;
}

.StandardButton:hover {
	background-color: var(--button-hover);
	transform: scale(1.05);
}

.StandardButton:active {
	background-color: var(--button-active);
	transform: scale(0.98);
}
```

### Keyframe Animations

```css
@keyframes pulse {
	0% { transform: scale(1); opacity: 1; }
	50% { transform: scale(1.1); opacity: 0.8; }
	100% { transform: scale(1); opacity: 1; }
}

.NotificationIcon {
	animation: pulse 2s infinite ease-in-out;
}

@keyframes fadeIn {
	from { opacity: 0; transform: translateY(10px); }
	to { opacity: 1; transform: translateY(0); }
}

.PanelContent {
	animation: fadeIn 0.3s ease-out forwards;
}
```

### Animation Performance

For better performance:

1. Animate only `transform` and `opacity` properties when possible
2. Use `will-change` for complex animations
3. Keep animations subtle and purposeful

```css
.OptimizedAnimation {
	transform: translateX(0);
	opacity: 1;
	will-change: transform, opacity;
	transition: transform 0.3s ease, opacity 0.3s ease;
}

.OptimizedAnimation.hide {
	transform: translateX(-20px);
	opacity: 0;
}
```

## Responsive Design

While Civilization VII has a fixed resolution, responsive techniques can still be useful for handling different UI states.

### Flexible Layouts

```css
.ResourcePanel {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
}

.ResourceItem {
	flex: 1 1 auto;
	min-width: 80px;
	max-width: 120px;
}
```

### Adapting to UI States

```css
/* Compact mode */
.UI-compact .ResourceText {
	font-size: 12px;
}

.UI-compact .ResourceIcon {
	width: 24px;
	height: 24px;
}

/* Expanded mode */
.UI-expanded .ResourceText {
	font-size: 16px;
}

.UI-expanded .ResourceIcon {
	width: 32px;
	height: 32px;
}
```

## Performance Optimization

Optimize your CSS for better performance.

### Selector Efficiency

```css
/* Inefficient - browser reads right-to-left */
.MainPanel .ResourcePanel .ResourceList .ResourceItem .ResourceName {
	color: gold;
}

/* More efficient */
.ResourceName {
	color: gold;
}
```

### Reducing Reflows

```css
/* Inefficient - causes multiple reflows */
.Button {
	border: 1px solid gold;
	padding: 10px;
	margin: 5px;
	transform: scale(1);
	background-color: black;
}

/* More efficient - group properties */
.Button {
	/* Box model properties together */
	border: 1px solid gold;
	padding: 10px;
	margin: 5px;
	
	/* Visual properties together */
	background-color: black;
	transform: scale(1);
}
```

### Reducing Render-Blocking CSS

Only include necessary styles to minimize processing time:

```css
/* Limit complex selectors */
.SimpleSelector {
	color: white;
}

/* Optimize animations */
.OptimizedAnimation {
	transition: transform 0.2s ease;
}
```

## Debugging CSS

Effective debugging techniques for UI styling issues.

### Using the Inspector

The in-game UI inspector (F12) allows you to:
- View the DOM structure
- See applied CSS rules
- Modify styles in real-time
- Check for CSS errors

### Troubleshooting CSS Issues

Common issues and solutions:

1. **Styles not applying**: Check selector specificity and rule order
2. **Layout problems**: Validate container dimensions and overflow settings
3. **Animation issues**: Check for conflicting transforms or transitions
4. **Performance problems**: Look for excessive selectors or animations

### Debug Helpers

Add temporary debug styles to troubleshoot layout issues:

```css
/* Outline elements to see their boundaries */
.debug * {
	outline: 1px solid red !important;
}

/* Add background colors to see element boxes */
.debug .Container { background-color: rgba(255, 0, 0, 0.2) !important; }
.debug .Item { background-color: rgba(0, 255, 0, 0.2) !important; }

/* Show element dimensions */
.debug .LayoutElement::after {
	content: attr(id) " - " attr(Width) "x" attr(Height);
	position: absolute;
	bottom: 0;
	right: 0;
	background: black;
	color: white;
	font-size: 10px;
	padding: 2px;
}
```

## Common Patterns

Reusable CSS patterns for common UI elements.

### Panel Styling

```css
.StandardPanel {
	background-color: rgba(0, 0, 0, 0.8);
	border: 1px solid #c2ab78;
	border-radius: 5px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	padding: 10px;
}

.PanelHeader {
	background-color: rgba(50, 40, 20, 0.9);
	border-bottom: 1px solid #c2ab78;
	padding: 8px 10px;
	margin: -10px -10px 10px -10px;
	border-radius: 5px 5px 0 0;
}

.PanelTitle {
	font-size: 18px;
	font-weight: bold;
	color: #f0e0a0;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
}

.PanelContent {
	padding: 5px;
}

.PanelFooter {
	border-top: 1px solid #5a4a2a;
	margin: 10px -10px -10px -10px;
	padding: 8px 10px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}
```

### Button Styling

```css
.StandardButton {
	background-color: rgba(40, 35, 25, 0.9);
	border: 1px solid #c2ab78;
	border-radius: 4px;
	color: #f0e0a0;
	padding: 8px 15px;
	font-size: 14px;
	text-align: center;
	cursor: pointer;
	transition: all 0.2s ease;
}

.StandardButton:hover {
	background-color: rgba(60, 50, 30, 0.9);
	border-color: #f0e0a0;
	transform: translateY(-1px);
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.StandardButton:active {
	background-color: rgba(30, 25, 15, 0.9);
	transform: translateY(1px);
	box-shadow: none;
}

.StandardButton:disabled {
	background-color: rgba(30, 30, 30, 0.9);
	border-color: #666;
	color: #888;
	cursor: not-allowed;
}

.PrimaryButton {
	background-color: rgba(70, 60, 20, 0.9);
	font-weight: bold;
}

.DangerButton {
	background-color: rgba(100, 30, 30, 0.9);
}
```

### Progress Bar Styling

```css
.ProgressBar {
	width: 100%;
	height: 20px;
	background-color: rgba(20, 20, 20, 0.8);
	border: 1px solid #5a4a2a;
	border-radius: 3px;
	overflow: hidden;
	position: relative;
}

.ProgressBar-fill {
	height: 100%;
	background-color: #c2ab78;
	width: 0%; /* Set dynamically with JavaScript */
	transition: width 0.3s ease;
}

.ProgressBar-text {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	text-align: center;
	line-height: 20px;
	font-size: 12px;
	color: white;
	text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.7);
}

/* Variations */
.ProgressBar--science .ProgressBar-fill { background-color: #00BFFF; }
.ProgressBar--culture .ProgressBar-fill { background-color: #FF69B4; }
.ProgressBar--production .ProgressBar-fill { background-color: #CD5C5C; }
```

### Tooltip Styling

```css
.Tooltip {
	position: absolute;
	background-color: rgba(10, 10, 10, 0.95);
	border: 1px solid #c2ab78;
	border-radius: 3px;
	padding: 8px 12px;
	max-width: 300px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.5);
	z-index: 1000;
	pointer-events: none;
}

.TooltipTitle {
	font-weight: bold;
	color: #f0e0a0;
	font-size: 14px;
	margin-bottom: 5px;
	border-bottom: 1px solid #5a4a2a;
	padding-bottom: 3px;
}

.TooltipDescription {
	font-size: 13px;
	color: #e0e0e0;
	line-height: 1.4;
}

.TooltipStats {
	margin-top: 5px;
	font-size: 12px;
	color: #c0c0c0;
}
```

## Examples

Here are complete examples of CSS styling for common UI components.

### Resource Bar Styling

```css
/* Resource bar at the top of the screen */
.ResourceBar {
	display: flex;
	justify-content: flex-start;
	align-items: center;
	gap: 15px;
	padding: 8px 15px;
	background-color: rgba(0, 0, 0, 0.8);
	border-bottom: 1px solid #c2ab78;
}

.ResourceItem {
	display: flex;
	align-items: center;
	gap: 5px;
}

.ResourceIcon {
	width: 24px;
	height: 24px;
}

.ResourceAmount {
	font-size: 16px;
	font-weight: bold;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
}

/* Resource-specific colors */
.Resource--gold .ResourceAmount { color: #FFD700; }
.Resource--science .ResourceAmount { color: #00BFFF; }
.Resource--culture .ResourceAmount { color: #FF69B4; }
.Resource--faith .ResourceAmount { color: #E066FF; }
.Resource--production .ResourceAmount { color: #CD5C5C; }
.Resource--food .ResourceAmount { color: #32CD32; }

/* Growth/decline indicators */
.ResourceDelta {
	font-size: 12px;
	margin-left: 3px;
}

.ResourceDelta--positive { color: #32CD32; }
.ResourceDelta--negative { color: #FF6347; }
```

### Unit Panel Styling

```css
.UnitPanel {
	width: 300px;
	background-color: rgba(0, 0, 0, 0.85);
	border: 1px solid #c2ab78;
	border-radius: 5px;
}

.UnitHeader {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 8px 12px;
	background-color: rgba(50, 40, 20, 0.9);
	border-bottom: 1px solid #c2ab78;
	border-radius: 5px 5px 0 0;
}

.UnitIcon {
	width: 40px;
	height: 40px;
}

.UnitName {
	font-size: 18px;
	font-weight: bold;
	color: #f0e0a0;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
}

.UnitContent {
	padding: 10px;
}

.UnitStats {
	display: grid;
	grid-template-columns: auto 1fr;
	gap: 5px 10px;
	margin-bottom: 10px;
}

.UnitStatLabel {
	font-size: 14px;
	color: #c0c0c0;
}

.UnitStatValue {
	font-size: 14px;
	font-weight: bold;
	color: #f0f0f0;
}

.UnitHealth {
	margin: 10px 0;
}

.UnitHealthBar {
	height: 10px;
	background-color: #300;
	border: 1px solid #c2ab78;
	border-radius: 2px;
	overflow: hidden;
}

.UnitHealthFill {
	height: 100%;
	background-color: #c00;
	width: 75%; /* Set dynamically */
}

.UnitPromotions {
	margin-top: 10px;
}

.UnitPromotionTitle {
	font-size: 15px;
	font-weight: bold;
	color: #f0e0a0;
	margin-bottom: 5px;
}

.UnitPromotionList {
	display: flex;
	flex-wrap: wrap;
	gap: 5px;
}

.UnitPromotionIcon {
	width: 32px;
	height: 32px;
	border: 1px solid #c2ab78;
	border-radius: 50%;
}

.UnitActions {
	display: flex;
	justify-content: space-between;
	margin-top: 15px;
	padding-top: 10px;
	border-top: 1px solid #5a4a2a;
}

.UnitActionButton {
	flex: 1;
	padding: 5px;
	margin: 0 3px;
	background-color: rgba(40, 35, 25, 0.9);
	border: 1px solid #c2ab78;
	border-radius: 3px;
	color: #f0e0a0;
	font-size: 13px;
	text-align: center;
	transition: all 0.2s ease;
}

.UnitActionButton:hover {
	background-color: rgba(60, 50, 30, 0.9);
}
```

## Related Documentation

For more information about UI styling in Civilization VII, refer to these resources:

- [UI Modding Guide](./ui-modding.md) - Comprehensive guide to UI modding
- [UI Component Reference](./ui-component-reference.md) - Reference for available UI components
- [Coherent UI Readme](./coherent-ui-readme.md) - Introduction to Coherent UI
- [Game Event Reference](./game-event-reference.md) - Reference for game events used with UI

---

*This styling guide is based on Civilization VII's UI system as of the current game version. CSS capabilities may change with game updates.* 