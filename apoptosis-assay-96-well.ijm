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

/* THRESHOLD IMAGES
 * Keep the useful signal.
 * Determine min/max by visual inspection to eliminate random speckling.
 */
function applyThreshold(image, min, max){
	selectWindow(image);
	setThreshold(min, max);
	run("Convert to Mask");
}

/*
OVERLAYING CHANNELS
note that imageJ thinks of C3 as blue, C2 as green, and C1 as red by default
assign images accordingly
*/
	


function mergeBlueRed(){
	combinedString = c1string + c3string + " keep";
	run("Merge Channels...", combinedString);
}

function mergeBlueGreen(){
	combinedString = c3string + c2string + " keep";
	run("Merge Channels...", combinedString);
}

function mergeBlueGreenRed(){
	combinedString = c3string + c2string + c1string + " keep";
	run("Merge Channels...", combinedString);
}

function processOverlap(minT, maxT, minP, newName){
	selectWindow("RGB");
	run("8-bit");
	applyThreshold("RGB", minT, maxT);
	run("Convert to Mask");
	particlesString2 = "size=" + minP + "-Infinity outline display exclude summarize";
	rename(newName);
	run("Analyze Particles...", particlesString2);
	close();
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
	redImage = "C3-" + imageTitle;	
	
	//to imageJ, ch1 is the RED image
	c1string = "c1=[" + redImage + "] ";
	//to imageJ, ch2 is the GREEN image
	c2string = "c2=[" + greenImage + "] ";
	//to imageJ, ch3 is the BLUE image
	c3string = "c3=[" + blueImage + "] ";
	
	run("Split Channels");
	
	applyThreshold(blueImage, 10000, 65535);
	applyThreshold(greenImage, 2717, 65535);
	applyThreshold(redImage, 2056, 65535);

	mergeBlueGreen();
	newName = "BlueGreen-" + imageTitle;
	processOverlap(130, 255, 25, newName);

	mergeBlueRed();
	newName = "BlueRed-" + imageTitle;
	processOverlap(120, 255, 50, newName);
	
	mergeBlueGreenRed();
	newName = "BlueGreenRed-" + imageTitle;
	processOverlap(200, 255, 50, newName);
	
	//1. count cells (blue channel)
	selectWindow(blueImage);
	run("Watershed");
	run("Analyze Particles...", "size=90-Infinity outline display summarize");
	close();

	selectWindow(redImage);
	close();	
	
	selectWindow(greenImage);
	close();
}
