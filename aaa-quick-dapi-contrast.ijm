imageTitle = getTitle();
//selectWindow(imageTitle);
blueImage = "C1-" + imageTitle;
greenImage = "C2-" + imageTitle;
redImage = "C3-" + imageTitle;	
run("Split Channels");



selectWindow(redImage);
close();
selectWindow(blueImage);
run("Enhance Contrast", "saturated=0.35");
selectWindow(greenImage);
close();

