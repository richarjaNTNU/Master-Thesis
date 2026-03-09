run("Bio-Formats Macro Extensions");

path = File.openDialog("Select the large .czi movie");
outputDir = getDirectory("Select the Output Folder");

startFrames = newArray(1,    7501,  15001, 22501, 30001, 35001);
endFrames   = newArray(7500, 15000, 22500, 30000, 35000, 40000);

name = File.getName(path);
if (lastIndexOf(name, ".") != -1) nameWithoutExt = substring(name, 0, lastIndexOf(name, "."));
else nameWithoutExt = name;

print("\\Clear");
print("--- Starting Split for " + name + " ---");

for (i = 0; i < startFrames.length; i++) {

    s = startFrames[i];
    e = endFrames[i];

    print("Processing Part " + i + ": Frames " + s + " to " + e);

    run("Bio-Formats Importer", "open=[" + path + "] windowless=true autoscale color_mode=Default view=Hyperstack stack_order=XYCZT specify_range t_begin=" + s + " t_end=" + e + " t_step=1");

    outName = nameWithoutExt + "_" + i + ".ome.tif";
    saveAs("Tiff", outputDir + outName);

    close();
    run("Collect Garbage");
}

print("--- All Done ---");
