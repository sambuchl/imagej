/*
 * Convert CZIs to TIFs with ImageJ
 *  
 *
 * 
 * Before starting:
 * Open all desired images in ImageJ (drag from Finder to ImageJ bar)
 * 
 * Click 'Run' or Ctrl + 'r' to run script. 
 * 
 * Last updated by Sam Buchl
 * 2020-08-05
 */


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



function setFiletype(image, filetype){

}


// opens an image, selects it, processes it
function processImage(path) {
	image = getTitle();
	saveAs("tif", outputDirectory+image);
	close();
}



function main(){
	outputDirectory = getDirectory("Output directory");
	
	/* Set measurements to collect image display label*/
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");

	// Turn on batch mode, so processing windows stay closed; comment out while testing.
	//setBatchMode(true);

	// TO PROCESS ALL OPEN IMAGES:
	processOpenPics();
	
	// TO OPEN DIRECTORY OF FILES & PROCESS ALL IMAGES: 
	//pickDirectory();

	// Turn off batch mode, so you can see windows opened during manual processing
	setBatchMode(false);
}


main();


