/*
 * This script was developed on ImageJ Fiji 1.52p. 

 * Before starting:
 * Open all desired images in ImageJ (drag from Finder to ImageJ bar)
 * 
 * Click 'Run' or Ctrl + 'r' to run script. 
 * 
 * Last updated by Sam Buchl
 * 2020-05-14
 */

// select the directory/directories of pictures to use

function processOpenPics(){
	n = nImages;
	for (i=1; i<=n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
}

function pickDirectory() {
	dir = getDirectory("Choose a Directory");
	list = getFileList(dir);
	print("Directory is ", dir, " with ", list.length, "files.");
	processFiles(dir);
}

// evaluate whether a given item in a directory is of the desired type to process
// directories are opened
// xmls are ignored (MODIFY THIS WITH OTHER FILETYPES TO IGNORE)
// all other file types are processed (make sure the target directory only contains images)
function processFiles(dir) {
  list = getFileList(dir);
  for (i=0; i<list.length; i++) {
  	  // copy this if to add other filetypes... this should check a list to be easier to edit TODO
      if (endsWith(list[i], "xlsx")){
      	  print(list[i] + " skip!");
      	  continue;
          //if you wish to recursively process files, comment out two lines above, uncomment next line:
          //processFiles(""+dir+list[i]);
      } else if (endsWith(list[i], "/")){
      	  print("opening directory " + list[i]);
      	  processFiles(dir+list[i]);
      } else {
          print("processing file " + list[i]);
          path = dir+list[i];
          open(path);
          processImage(path);
      }
  }
}

function threshold(image, thresholdType){
	selectWindow(image);
	run("8-bit");
	run("8-bit");
	thresholdMethod = "method=" + thresholdType;
	run("Auto Threshold", thresholdMethod);
	run("Convert to Mask");
	run("Convert to Mask");
	run("Measure");
	saveAs("tif", output+image+"-PROCESSED-MASK");
	close();
}


function processImage(path) {
	image = getTitle();

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

	run("Split Channels");
	
	// count cells via blue channel
	// good filter options: "Default white", "MaxEntropy white")
	// for images with lots of cells, use "Default white"
	
	threshold(greenImage, "MaxEntropy white");
	close(redImage);
	close(blueImage);
	close(greenImage);
}


function main(){
	output = getDirectory("Output directory");
	
	/* Set measurements to collect image display label*/
	run("Set Measurements...", "mean integrated display redirect=None decimal=3");

	// Turn on batch mode, so processing windows stay closed; turn off while testing.
	setBatchMode(true);

	// TO PROCESS ALL OPEN IMAGES:
	processOpenPics();
	
	// TO OPEN DIRECTORY OF FILES & PROCESS ALL IMAGES: 
	//pickDirectory();

	// Turn off batch mode, so you can see windows opened during manual processing
	setBatchMode(false);
}

main();
