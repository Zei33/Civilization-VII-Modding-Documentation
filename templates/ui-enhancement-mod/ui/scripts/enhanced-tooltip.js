// Enhanced Tooltip UI Modification
// Author: Your Name

// Wait for the game UI to fully initialize
document.addEventListener("DOMContentLoaded", function() {
	// Find the tooltip container
	const tooltipContainer = document.getElementById("TooltipContainer");
	
	if (!tooltipContainer) {
		console.error("Enhanced Tooltip: Could not find tooltip container");
		return;
	}
	
	// Find or create tooltip controls
	let tooltipControls = tooltipContainer.querySelector(".TooltipControls");
	if (!tooltipControls) {
		tooltipControls = document.createElement("div");
		tooltipControls.className = "TooltipControls";
		tooltipContainer.appendChild(tooltipControls);
	}
	
	// Add a button to the tooltip controls
	const tooltipButton = document.createElement("button");
	tooltipButton.className = "TooltipEnhancementButton";
	tooltipButton.title = Game.Localize("LOC_ENHANCED_TOOLTIP_TOGGLE");
	tooltipButton.innerHTML = `<img src="ui/icons/tooltip_enhancement_icon.png" alt="Enhanced Tooltips" />`;
	tooltipControls.appendChild(tooltipButton);
	
	// Hook into the tooltip display event
	Game.Subscribe("TooltipShown", function(tooltipType, tooltipID) {
		// Only enhance certain types of tooltips
		if (tooltipType === "TOOLTIP_UNIT" || tooltipType === "TOOLTIP_BUILDING") {
			enhanceTooltip(tooltipType, tooltipID);
		}
	});
	
	function enhanceTooltip(tooltipType, tooltipID) {
		// Get the tooltip element
		const tooltip = tooltipContainer.querySelector(".Tooltip");
		
		if (!tooltip) return;
		
		// Example: Add a custom class to style our enhanced tooltips
		tooltip.classList.add("enhanced-tooltip");
		
		// Example: Add additional information to the tooltip
		const infoDiv = document.createElement("div");
		infoDiv.className = "enhanced-tooltip-info";
		
		if (tooltipType === "TOOLTIP_UNIT") {
			// Add unit-specific enhancements
			infoDiv.textContent = Game.Localize("LOC_ENHANCED_TOOLTIP_UNIT_INFO");
			
			// Example: Query additional unit data from the game
			Game.Database.QueryUnitDetails(tooltipID, function(unitDetails) {
				if (unitDetails) {
					const statsDiv = document.createElement("div");
					statsDiv.className = "enhanced-unit-stats";
					statsDiv.innerHTML = `
						<div>${Game.Localize("LOC_ENHANCED_TOOLTIP_MOVEMENT")}: ${unitDetails.Movement}</div>
						<div>${Game.Localize("LOC_ENHANCED_TOOLTIP_COST")}: ${unitDetails.Cost}</div>
					`;
					infoDiv.appendChild(statsDiv);
				}
			});
		} else if (tooltipType === "TOOLTIP_BUILDING") {
			// Add building-specific enhancements
			infoDiv.textContent = Game.Localize("LOC_ENHANCED_TOOLTIP_BUILDING_INFO");
		}
		
		tooltip.appendChild(infoDiv);
	}
});

// Add a custom style element to the document
const styleElement = document.createElement("style");
styleElement.textContent = `
	.enhanced-tooltip {
		border: 2px solid gold !important;
		padding: 10px !important;
	}
	
	.enhanced-tooltip-info {
		margin-top: 10px;
		padding-top: 5px;
		border-top: 1px solid rgba(255, 255, 255, 0.3);
		font-style: italic;
	}
	
	.enhanced-unit-stats {
		margin-top: 5px;
		font-weight: bold;
	}
`;
document.head.appendChild(styleElement);

// Notes:
// 1. Replace "Game.Subscribe" and other API calls with the actual Civilization VII UI API methods
// 2. Localization keys (LOC_*) should be defined in your text XML files
// 3. The Game.Database API calls are placeholders - refer to the UI Modding documentation for actual API 