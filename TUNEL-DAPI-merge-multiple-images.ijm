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

function mergeBlueRed(){
	combinedString = redString + blueString + " keep";
	run("Merge Channels...", combinedString);
}

function mergeBlueGreen(){
	combinedString = blueString + greenString + " keep";
	run("Merge Channels...", combinedString);
}

function mergeBlueGreenRed(){
	combinedString = blueString + greenString + redString + "keep";
	run("Merge Channels...", combinedString);
}

function mergeBlueMaskGreen(){
	//original next line (adds keep original images):
	//combinedString = cellMaskString + yellowString + " keep";
	combinedString = cellMaskString + redString + "keep";
	run("Merge Channels...", combinedString);
}


function processOverlap(minT, maxT, minP){
	selectWindow("RGB");
	run("Duplicate...", " ");
	run("8-bit");
	applyThreshold("RGB-1", minT, maxT);
	run("Convert to Mask");
	particlesString2 = "size=" + minP + "-Infinity show=Outlines display exclude summarize";
	run("Analyze Particles...", particlesString2);
}

function countCells(){
	selectWindow(blueImage);
	run("Watershed");
	//original next line: 	run("Analyze Particles...", "size=100-Infinity show=Outlines display summarize");
	run("Analyze Particles...", "size=100-Infinity show=Masks display summarize");
}

function invertPic(image){
	selectWindow(image);
	run("Invert");
}

function closeWindow(window){
	selectWindow(window);
	close();
}


/*
TUNEL-DAPI overlap script
This script does the following:
- Splits image into 3 constituent channels
- Thresholds each channel to remove noise
- Selects the DAPI channel, watersheds (splits connected cells), and applies a mask
- Merges the DAPI channel with the TUNEL channel, with DAPI as blue, TUNEL as red.
- The resulting display shows (1) the TUNEL-DAPI merge image 
- and (2) a display with a count of the overlapped areas only.
- The resulting image can then be manually counted for TUNEL.
*/

// prevent windows from opening/closing/flickering while processing

function processImage(imageTitle){
	selectWindow(imageTitle);
	blueImage = "C1-" + imageTitle;
	greenImage = "C2-" + imageTitle;
	redImage = "C3-" + imageTitle;	
	run("Split Channels");

	// values for 3/6 apoptosis plate, HSCs:
	applyThreshold(blueImage, 6000, 65535);
	applyThreshold(greenImage, 10000, 65535);
	applyThreshold(redImage, 2056, 65535);

	/*applyThreshold(blueImage, 4500, 65535);
	applyThreshold(greenImage, 2717, 65535);
	applyThreshold(redImage, 2056, 65535);
	*/

	/*
	OVERLAYING CHANNELS
	note that imageJ thinks of C3 as blue, C2 as green, and C1 as red by default
	assign images as needed to maximize contrast
	*/
		
	//to imageJ, ch1 is the RED image
	redString = "c1=[" + greenImage + "] ";
	//to imageJ, ch2 is the GREEN image
	greenString = "c7=[" + greenImage + "] ";
	//to imageJ, ch3 is the BLUE image
	blueString = "c3=[" + blueImage + "] ";
	//c7 is the YELLOW image, in this case, using the TUNEL channel
	yellowString = "c7=[" + greenImage + "] ";
	
	//cell mask string
	cellMaskString = "c3=[" + "Mask of " + blueImage + "] ";

	// count cells
	countCells();
	
	maskString = "Mask of " + blueImage;
	invertPic(maskString);
	mergeBlueMaskGreen();
	processOverlap(120, 255, 50);
	
	//mergeBlueGreen();
	//processOverlap(130, 255, 25);
	
	
	/*
	mergeBlueRed();
	processOverlap(120, 255, 50);
	
	
	mergeBlueGreenRed();
	//processOverlap(200, 255, 50);
	*/

		
	// close windows - comment out for testing
	closeWindow(redImage);
	closeWindow(greenImage);
	closeWindow(blueImage);
    maskWindow = "Mask of " + blueImage;
	closeWindow(maskWindow);
	closeWindow("Drawing of RGB-1");
	closeWindow("RGB-1");
	closeWindow("RGB");

}


