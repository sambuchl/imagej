/*
 * Macro template to process green-channel measurements for all open images.
 * Ensure that the desired measurements are set (Analyze --> Set Measurements)
 * before running this macro.
 * 
 * Edit the processImage function as needed.
 * 
 * Errors will be thrown when running. Just click on the next image and click
 * ctl + 'R' to re-run the script and continue with the measurements.
 * 
 * Measurements are complete when all image windows are closed.
 * 
 * All measurements will be shown in the Results window.
 */

/* Set measurements to collect image display label*/
run("Set Measurements...", "display redirect=None decimal=3");

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
	redImage = "C3-" + imageTitle;	
	run("Split Channels");
	selectWindow(redImage);
	close();
	selectWindow(greenImage);
	close();
	selectWindow(blueImage);
	setThreshold(771, 65535);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=50-Infinity outline pixel display summarize");
	close();
}
