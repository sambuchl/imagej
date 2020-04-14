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

/* Set measurements */
run("Set Measurements...", "integrated display redirect=None decimal=3");

/* Run batch process */
processOpenImages();

/*
 * Processes all open images. 
 */
function processOpenImages() {
	n = nImages;
	setBatchMode(false);
	for (i=1; i<=n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
	setBatchMode(false);
}

/*
 * Processes the currently active image. 
 * Splits the image into channels, closes the unneeded channels,
 * Takes measurements on the green-channel image before closing it.
 *   
 * Use imageTitle parameter
 * to re-select the input image during processing.
 */
function processImage(imageTitle) {
	selectWindow(imageTitle);
	run("Split Channels");
	selectWindow(imageTitle + " (red)");
	close();
	selectWindow(imageTitle + " (green)");
	close();
	selectWindow(imageTitle + " (blue)");
	run("Convert to Mask");
	run("Threshold...");
	run("Analyze Particles...", "size=1000-Infinity pixel display summarize");
	//close();
}
