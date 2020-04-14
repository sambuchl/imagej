
processImages();


 
function processImages() {
	setBatchMode(true);
	/* for drag-to-open images (e.g., a CZI with multiple images), use next line & comment out 30-33:
	n = nImages; 
	*/

	/* for a directory full of images, use next 3 lines: */
	input = "Z:/SHARED/Sam/programs/imagej-FIJI/fiji-win64/Fiji.app/images/input/";
	list = getFileList(input);
	n = list.length;
	print(n);
	

	setBatchMode(false);
}

function closeWindow(window){
	selectWindow(window);
	close();
}

function threshold(image){
	selectWindow(image);
	run("8-bit");
	run("8-bit");
	run("Auto Threshold", "method=MaxEntropy white");
	run("Convert to Mask");
	run("Convert to Mask");
}

function aFunction(){
imageTitle = getTitle();
selectWindow(imageTitle);
blueImage = "C1-" + imageTitle;
greenImage = "C2-" + imageTitle;
redImage = "C3-" + imageTitle;
run("Split Channels");

// apply noise-reducing thresholds to all channels (Auto Threshold)
threshold(blueImage);
threshold(greenImage);
threshold(redImage);

// count cells (blue channel)
selectWindow(blueImage);
run("Watershed");
run("Analyze Particles...", "size=75-Infinity outline display summarize");

// measure green channel integrated density
selectWindow(greenImage);
run("Measure");

// measure signal colocalization for green & red channels
jacopString = "imga=[" + greenImage + "] imgb=[" + redImage + "] pearson";
run("JACoP ", jacopString);

// close image windows
closeWindow(blueImage);
closeWindow(greenImage);
closeWindow(redImage);
}
