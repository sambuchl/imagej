/*
 * Macro template to process blue-channel measurements for all open images.
 * 
 * BEFORE STARTING: 
 * Ensure that the desired measurements are set (Analyze --> Set Measurements)
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
 * Takes measurements on the green-channel image before closing it.
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
	selectWindow(greenImage);
	close();
	selectWindow(redImage);
	close();
	selectWindow(blueImage);
	run("Convert to Mask");
	run("Convert to Mask");
	run("Measure");
	close();
}
