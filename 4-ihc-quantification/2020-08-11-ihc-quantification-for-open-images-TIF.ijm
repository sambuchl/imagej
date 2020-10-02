/*
 * This script was developed on ImageJ Fiji 1.52p. 
 *  
 *
 * 
 * Before starting:
 * Open all desired images in ImageJ (drag from Finder to ImageJ bar)
 * 
 * Click 'Run' or Ctrl + 'r' to run script. 
 * 
 * Last updated by Sam Buchl
 * 2020-08-11
 */


function processOpenPics(){
	n = nImages;
	for (i=1; i<=n; i++) {
		imageTitle = getTitle();
		processImage(imageTitle);
	}
}

function pickDirectory(input) {
	list = getFileList(input);
	print("Directory is ", input, " with ", list.length, "files.");
	processFiles(input);
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


// applies thresholds to remove noise; UPDATE method=MaxEntropy to modify threshold applied
function threshold(image){
	selectWindow(image);
	run("8-bit");
	run("8-bit");
	run("Auto Threshold", "method=MaxEntropy white");
	run("Convert to Mask");
	run("Convert to Mask");
}


function countCells(image){
	selectWindow(image);
	run("Watershed");
	run("Analyze Particles...", "size=25-Infinity outline summarize");
}

// measure the Sirius red signal for a given image
function quantifyRed(image){
	//run("Colour Deconvolution", "vectors=[User values] [r1]=.14673959 [g1]=.68811435 [b1]=.7106097 [r2]=.20182571 [g2]=.44874462 [b2]=.87057143 [r3]=.403679 [g3]=.34807402 [b3]=.84610146");
	run("Colour Deconvolution", "vectors=[H DAB]");
	selectWindow(image + "-(Colour_3)");
	close();
	selectWindow(image + "-(Colour_1)");
	close();
	selectWindow(image);
	close();
	selectWindow(image + "-(Colour_2)");
	run("Auto Threshold", "method=MaxEntropy");
	setThreshold(255, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Measure");
	saveAs("tif", output+image+"-PROCESSED-MASK");
	print(output+image+" processing complete.");
	close();
	selectWindow("Colour Deconvolution");
	close();
}

function quantifyGreen(image){
	
}

function setFiletype(image, filetype){

}


// opens an image, selects it, processes it
function processImage(image) {
	quantifyRed(image);
	close(image);
}



function main(){
	// output masks of thresholded sirius red
	
	//uncomment next line if reading files from directory
	//input = getDirectory("Input directory of images to process");
	output = getDirectory("Output directory");
	
	/* Set measurements to collect image display label*/
	run("Set Measurements...", "area area_fraction mean integrated display redirect=None decimal=3");

	// Turn on batch mode, so processing windows stay closed; comment out while testing.
	setBatchMode(true);

	// TO PROCESS ALL OPEN IMAGES:
	processOpenPics();
	
	// TO OPEN DIRECTORY OF FILES & PROCESS ALL IMAGES: 
	//pickDirectory(input);

	// Turn off batch mode, so you can see windows opened during manual processing
	setBatchMode(false);
}


main();


