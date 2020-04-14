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
//processImages();


 
function processImages() {
	setBatchMode(true);
	// for drag-to-open images (e.g., a CZI with multiple images), use next line & comment out 30-33:
	n = nImages; 
		
	for (i=0; i<n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
	

	/* for a directory full of images, use next 3 lines & for loop: 
	input = "Z:/SHARED/Sam/programs/imagej-FIJI/fiji-win64/Fiji.app/images/input/";
	list = getFileList(input);
	n = list.length;
	
	for (i=0; i<n; i++) {
		processImage(input+list[i]);
	}
	*/
	
	setBatchMode(false);
}

function threshold(image){
	selectWindow(image);
	run("8-bit");
	run("8-bit");
	run("Auto Threshold", "method=MaxEntropy white");
	run("Convert to Mask");
	run("Convert to Mask");
}

function closeWindow(window){
	selectWindow(window);
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
	//blue channel manual threshold: setThreshold(1325, 65535);
	//green channel manual threshold: setThreshold(7138, 65535);
	//red channel manual threshold:	setThreshold(5768, 65535);

	selectWindow(imageTitle);
	blueImage = "C1-" + imageTitle;
	greenImage = "C2-" + imageTitle;
	redImage = "C3-" + imageTitle;
	run("Split Channels");
	
	/* AUTO-THRESHOLD apply noise-reducing thresholds to all channels (Auto Threshold)
	threshold(blueImage);
	threshold(greenImage);
	threshold(redImage);
	*/


	
	// count cells (blue channel)
	selectWindow(blueImage);
	setThreshold(1325, 65535);
	run("Convert to Mask");
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=75-Infinity outline display summarize");
	
	// measure green channel integrated density
	selectWindow(greenImage);
	run("Duplicate...", "title=duplicate");
	selectWindow(greenImage);
	setThreshold(1325, 65535);
	run("Convert to Mask");
	run("Convert to Mask");
	//run("Measure");
	selectWindow("duplicate");
	threshold("duplicate");

	/* set red channel threshold
	selectWindow(redImage);
	setThreshold(5768, 65535);
	run("Convert to Mask");
	run("Convert to Mask");
	
	// measure signal colocalization for green & red channels
	jacopString = "imga=[" + greenImage + "] imgb=[" + redImage + "] pearson";
	run("JACoP ", jacopString);
	*/
	
	// close image windows
	closeWindow(blueImage);
	//closeWindow(greenImage);
	closeWindow(redImage);	
}

imageTitle = getTitle();
processImage(imageTitle);
