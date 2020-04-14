//playground
title = getTitle();
c2 = "C2-" + title;
c3 = "C3-" + title;
run("Split Channels");

selectWindow(c2);
close();
selectWindow(c3);
close();

setThreshold(1901, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");

run("Watershed");
run("Analyze Particles...", "size=25-Infinity show=Outlines exclude summarize");
