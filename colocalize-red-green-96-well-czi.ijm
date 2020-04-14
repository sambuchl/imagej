/*
 * ImageJ Macro for measuring colocalization on red & green channels.
 * 
 * BEFORE STARTING: 
 * Install the JACoP plugin from 
 * https://imagejdocu.tudor.lu/doku.php?id=plugin:analysis:jacop_2.0:just_another_colocalization_plugin:start
 * 
 * Open the JACoP interface to set the desired measurements.
 * 
 * (Edit the processImage function as needed, e.g., if you need other channels)
 * 
 * Open the target images (e.g., click and drag from the file manager into ImageJ)
 * 
 * Measurements are complete when all image windows are closed.
 * 
 * Measurements will be shown in the Log window.
 */

processOpenImages();

function processOpenImages() {
	/*
 	 * Processes all open images. 
 	 */
	n = nImages;
	setBatchMode(true);
	for (i=1; i<=n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
	setBatchMode(false);
}


function processImage(imageTitle) {
	/*
	 * Measures colocalized signal from two image channels
	 */
	
	//split selected image into channels, close un-needed channel
	selectWindow(imageTitle);
	blueImage = "C1-" + imageTitle;
	greenImage = "C2-" + imageTitle;
	redImage = "C3-" + imageTitle;	
	run("Split Channels");
	selectWindow(blueImage);
	close();
	
	//apply noise-reducing thresholds
	selectWindow(greenImage);
	setThreshold(205, 65535);
	run("Convert to Mask");
	run("Convert to Mask");
	selectWindow(redImage);
	setThreshold(520, 65535);
	run("Convert to Mask");
	run("Convert to Mask");

	//run colocalization plugin JACoP
	jacopString = "imga=[" + greenImage + "] imgb=[" + redImage + "] pearson";
	run("JACoP ", jacopString);

	//close windows
	selectWindow(greenImage);
	close();
	selectWindow(redImage);
	close();	
}