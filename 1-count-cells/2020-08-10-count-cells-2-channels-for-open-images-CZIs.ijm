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
 * 
 * Last updated by Sam Buchl
 * 2020-04-13
 */


// set magnification - the Mayo Clinic - Gugg 16 live-cell scope offers 5x, 10x, 20x, 25x, 63x
// use a whole number (5, 10, 20, 25, 63)
magnification = 10;

// minimum cell size is set for LX-2s/hepatic stellate cells but can be manually updated
// 75 works well as a default
// minCellSize = 75;
minCellSize = (magnification/10)*75;



function countCells(image){
	selectWindow(image);
	run("Watershed");
	analyzeParticlesSettingsString = "size=" + minCellSize +"-Infinity pixel show=Outlines summarize";
	run("Analyze Particles...", analyzeParticlesSettingsString);
	maskImage=getTitle();
	saveAs("tif", output + maskImage+"-COUNT-MASK");
	close();
}

function pickDir() {
	setBatchMode(true);
	/* for drag-to-open images (e.g., a CZI with multiple images), use next line & comment out 30-33:
	n = nImages; 
	*/

	dir = getDirectory("Choose a Directory");
	list = getFileList(dir);
	print("Directory is ", dir, " with ", list.length, "files.");
	processFiles(dir);
	

	setBatchMode(false);
}

function processFiles(dir) {
  list = getFileList(dir);
  for (i=0; i<list.length; i++) {
      if (endsWith(list[i], "xml")){
      	  print(list[i] + " skip!");
      	  continue;
          //if you wish to recursively process files, comment out two lines above, uncomment next line:
          //processFiles(""+dir+list[i]);
      } else if (endsWith(list[i], "xlsx")){
      	  print(list[i] + " skip!");
      	  continue;
          //if you wish to recursively process files, comment out two lines above, uncomment next line:
          //processFiles(""+dir+list[i]);
      } else if (endsWith(list[i], "ijm")){
      	  print(list[i] + " skip!");
      	  continue;
          //if you wish to recursively process files, comment out two lines above, uncomment next line:
          //processFiles(""+dir+list[i]);
      } else if (endsWith(list[i], "/")){
      	  print("opening directory " + list[i]);
      	  processFiles(dir+list[i]);
      } else {
          print("processing file: " + list[i]);
          path = dir+list[i];
          processImage(path);
      }
  }
}





 
function processImages() {
	setBatchMode(true);
	// for drag-to-open images (e.g., a CZI with multiple images), use next line & comment out 30-33:
	n = nImages; 
		
	for (i=0; i<n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}

	setBatchMode(false);
}



function threshold(image, method){
	selectWindow(image);
	chosenMethod = "method=" + method + " white";
	run("Auto Threshold", chosenMethod);
}

/*
 * Processes the currently active image. 
 * Splits the image into channels, closes the unneeded channels,
 * Counts cells with the Analyze --> Analyze particles tool.
 *   
 * Use imageTitle parameter
 * to re-select the input image during processing.
 */
function processImage(path) {
	//open(path);	// uncomment for multiple folders use
	image = getTitle();
	selectWindow(image);
    run("Split Channels");	


	// set filetype here (e.g., "tif" or "czi")
	fileType = "czi";
	

	if (fileType == "tif"){
		blueImage = image + " (blue)";
		greenImage = image + " (green)";
		redImage = image + " (red)";		
	}

	if (fileType == "czi"){
		blueImage = "C1-" + image;
		greenImage = "C2-" + image;
		redImage = "C3-" + image;	
	}

	//close(redImage);
	close(greenImage);
	

	// apply noise-reducing auto thresholds to green & red channels
	threshold(blueImage, "Default");
	countCells(blueImage);

	close(blueImage);


}


function main(){
	output = getDirectory("Output directory");
	
	/* Set measurements to collect image display label*/
	run("Set Measurements...", "mean integrated display redirect=None decimal=3");
	
	/* Run batch process */
	processImages();
}


main();


