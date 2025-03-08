// ===========================================================================
// Resource Potential Lens Script
// Highlights tiles based on their potential for resources
// Author: Your Name
// ===========================================================================

(function() {
	// Lens configuration
	const LENS_NAME = "RESOURCE_POTENTIAL_LENS";
	const LENS_LAYER = "RESOURCE_POTENTIAL_LAYER";
	
	// Color configuration for different resource potentials
	const LUXURY_COLOR = "rgb(255, 215, 0)";      // Gold color for luxury resources
	const STRATEGIC_COLOR = "rgb(255, 0, 0)";     // Red color for strategic resources
	const BONUS_COLOR = "rgb(0, 255, 0)";         // Green color for bonus resources
	const HIGH_POTENTIAL_COLOR = "rgba(255, 255, 255, 0.5)";  // White highlight for high potential
	const NO_POTENTIAL_COLOR = "rgba(0, 0, 0, 0)"; // Transparent for no potential
	
	// Register the lens with the game's lens system
	function registerLens() {
		console.log("Registering Resource Potential Lens");
		
		// Add the lens to the lens palette
		if (LensManager && LensManager.AddLens) {
			LensManager.AddLens(
				LENS_NAME,
				Game.Localize("LOC_RESOURCE_POTENTIAL_LENS_NAME"),
				Game.Localize("LOC_RESOURCE_POTENTIAL_LENS_DESCRIPTION"),
				"ICON_RESOURCE_LENS",
				function() { return true; }  // Always available
			);
			
			console.log("Resource Potential Lens registered successfully");
		} else {
			console.error("Could not register Resource Potential Lens - LensManager not available");
			return;
		}
		
		// Subscribe to lens activation event
		Game.Subscribe("LensActivated", function(lensName) {
			if (lensName === LENS_NAME) {
				activateResourceLens();
			}
		});
		
		// Subscribe to lens deactivation event
		Game.Subscribe("LensDeactivated", function(lensName) {
			if (lensName === LENS_NAME) {
				deactivateResourceLens();
			}
		});
	}
	
	// Activate the resource potential lens
	function activateResourceLens() {
		console.log("Activating Resource Potential Lens");
		
		// Create a new layer for the lens
		let hexLayer = LensManager.CreateHexLayer(LENS_LAYER);
		
		// Get plot data from the game
		Game.RequestPlotData(function(plotData) {
			if (!plotData) {
				console.error("Could not get plot data");
				return;
			}
			
			// Process each plot
			for (let i = 0; i < plotData.length; i++) {
				const plot = plotData[i];
				const color = getResourcePotentialColor(plot);
				
				// Apply the color to the hex grid if it has potential
				if (color !== NO_POTENTIAL_COLOR) {
					hexLayer.SetHexColor(plot.x, plot.y, color);
				}
			}
		});
		
		// Show the legend
		showLegend();
	}
	
	// Deactivate the resource potential lens
	function deactivateResourceLens() {
		console.log("Deactivating Resource Potential Lens");
		
		// Clear the lens layer
		LensManager.ClearHexLayer(LENS_LAYER);
		
		// Hide the legend
		hideLegend();
	}
	
	// Show the lens legend
	function showLegend() {
		// Create legend if it doesn't exist
		let legend = document.getElementById("ResourceLensLegend");
		if (!legend) {
			legend = document.createElement("div");
			legend.id = "ResourceLensLegend";
			legend.className = "ResourceLensLegend";
			
			// Add title
			const title = document.createElement("h3");
			title.textContent = Game.Localize("LOC_RESOURCE_LENS_LEGEND_TITLE");
			legend.appendChild(title);
			
			// Add legend items
			addLegendItem(legend, "luxury", Game.Localize("LOC_RESOURCE_LENS_LUXURY_POTENTIAL"));
			addLegendItem(legend, "strategic", Game.Localize("LOC_RESOURCE_LENS_STRATEGIC_POTENTIAL"));
			addLegendItem(legend, "bonus", Game.Localize("LOC_RESOURCE_LENS_BONUS_POTENTIAL"));
			addLegendItem(legend, "high", Game.Localize("LOC_RESOURCE_LENS_HIGH_POTENTIAL"));
			
			document.body.appendChild(legend);
		}
		
		// Show the legend
		legend.classList.add("visible");
	}
	
	// Hide the lens legend
	function hideLegend() {
		const legend = document.getElementById("ResourceLensLegend");
		if (legend) {
			legend.classList.remove("visible");
		}
	}
	
	// Helper function to add a legend item
	function addLegendItem(legend, className, text) {
		const item = document.createElement("div");
		item.className = "LegendItem";
		
		const colorBox = document.createElement("div");
		colorBox.className = "LegendColor " + className;
		
		const label = document.createElement("span");
		label.textContent = text;
		
		item.appendChild(colorBox);
		item.appendChild(label);
		legend.appendChild(item);
	}
	
	// Determine the color for a plot based on its resource potential
	function getResourcePotentialColor(plot) {
		// Skip plots that already have resources
		if (plot.hasResource) {
			return NO_POTENTIAL_COLOR;
		}
		
		// Determine resource potential based on terrain, features, and adjacency
		let potentialType = determineResourcePotential(plot);
		
		switch (potentialType) {
			case "LUXURY":
				return LUXURY_COLOR;
			case "STRATEGIC":
				return STRATEGIC_COLOR;
			case "BONUS":
				return BONUS_COLOR;
			case "HIGH":
				return HIGH_POTENTIAL_COLOR;
			default:
				return NO_POTENTIAL_COLOR;
		}
	}
	
	// Determine resource potential based on plot characteristics
	function determineResourcePotential(plot) {
		// Note: This is a simplified example. In a real mod, you would use
		// more complex logic based on the game's actual resource placement rules.
		
		// Check terrain type
		switch (plot.terrainType) {
			case "TERRAIN_GRASS":
			case "TERRAIN_PLAINS":
				// Grassland and plains have good potential for luxury resources
				if (plot.hasHills) {
					return "LUXURY";
				}
				return "BONUS";
				
			case "TERRAIN_DESERT":
			case "TERRAIN_TUNDRA":
				// Desert and tundra often have strategic resources
				if (plot.hasHills || plot.hasFeature) {
					return "STRATEGIC";
				}
				return "HIGH";
				
			case "TERRAIN_SNOW":
				// Snow rarely has resources
				return "NONE";
				
			case "TERRAIN_COAST":
			case "TERRAIN_OCEAN":
				// Water tiles can have resources
				if (plot.isShallow) {
					return "BONUS";
				}
				return "HIGH";
				
			default:
				return "NONE";
		}
	}
	
	// Initialize the lens when the UI is fully loaded
	document.addEventListener("DOMContentLoaded", function() {
		// Wait for the game to initialize fully
		setTimeout(function() {
			registerLens();
		}, 1000);
	});
	
	// Add a button to the lens bar
	function addLensButton() {
		const lensBar = document.querySelector(".LensBar");
		if (!lensBar) {
			console.error("Could not find LensBar");
			return;
		}
		
		// Create a new button
		const button = document.createElement("button");
		button.className = "LensButton ResourcePotentialLensButton";
		button.title = Game.Localize("LOC_RESOURCE_POTENTIAL_LENS_NAME");
		button.innerHTML = `<img src="UI/Icons/resource_lens_icon.png" alt="Resource Lens" />`;
		
		// Add click event
		button.addEventListener("click", function() {
			LensManager.ToggleLens(LENS_NAME);
		});
		
		// Add button to lens bar
		lensBar.appendChild(button);
	}
	
	// Try to add the button once UI is loaded
	document.addEventListener("UILoaded", function() {
		addLensButton();
	});
})(); 