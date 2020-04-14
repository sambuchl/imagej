title = getTitle();
C1 = "C1-" + title;
C2 = "C2-" + title;
C3 = "C3-" + title;
run("Split Channels");
selectWindow(C1);
//setAutoThreshold("Default dark");
setThreshold(4500, 65535);
run("Convert to Mask");
run("Watershed");

function closeWin(window){
	selectWindow(window);
	close();
}

closeWin(C2);
closeWin(C3);