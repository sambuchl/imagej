/*
 * This script was developed on ImageJ Fiji 1.52p. 
 * Use of this script requires the JACoP plugin. 
 * 
 * Use this script to:
 * - Count cells (DAPI-stained)
 * - Measure red/green colocalization (ER OR Golgi + Collagen marker)
 * - Measure green integrated density (For collagen per cell calculation)
 * 
 * Before starting:
 * Open all desired images in ImageJ (drag from Finder to ImageJ bar)
 * 
 * Click 'Run' or Ctrl + 'r' to run script. 
 */

/* Set measurements to collect image display label*/
run("Set Measurements...", "mean integrated display redirect=None decimal=3");

/* Run batch process */
processOpenImages();

/*
 * Processes all open images. 
 */
function processOpenImages() {
	n = nImages;
	setBatchMode(true);
	for (i=1; i<=n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
	setBatchMode(false);
}

/*
 * Processes the currently active image. 
 * Splits the image into channels, closes the unneeded channels,
 * Counts cells with the Analyze --> Analyze particles tool.
 *   
 * Use imageTitle parameter
 * to re-select the input image during processing.
 */
function processImage(imageTitle) {
	selectWindow(imageTitle);
	blueImage = "C1-" + imageTitle;
	greenImage = "C2-" + imageTitle;
	run("Split Channels");
	
	//1. count cells (blue channel)
	selectWindow(blueImage);
	setThreshold(9000, 65535);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=40-Infinity outline display summarize");
	
	//selectWindow(blueImage);
	close();
	
	//colocalize red/green channels
	
	//apply noise-reducing thresholds
	selectWindow(greenImage);
	setThreshold(2313, 65535);
	run("Convert to Mask");
	run("Convert to Mask");
	
	//measure green integrated density
	run("Measure");
	
	//selectWindow(greenImage);
	close();
}
