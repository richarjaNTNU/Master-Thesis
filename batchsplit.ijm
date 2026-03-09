run("Bio-Formats Macro Extensions");
setBatchMode(true); 

inputDir = getDirectory("Select Folder containing your .czi files");
outputMasterDir = getDirectory("Select Master Output Folder");

fileList = getFileList(inputDir);

startFrames = newArray(1,    7501,  15001, 22501, 30001, 35001);
endFrames   = newArray(7500, 15000, 22500, 30000, 35000, 40000);

print("\\Clear");
print("--- Starting Batch Process ---");
print("Input: " + inputDir);

for (f = 0; f < fileList.length; f++) {
    
    fileName = fileList[f];
    
    if (endsWith(fileName, ".czi")) {
        
        rawPath = inputDir + fileName;
        
		fullPath = replace(rawPath, "\\", "/");
        
        if (lastIndexOf(fileName, ".") != -1) {
            nameWithoutExt = substring(fileName, 0, lastIndexOf(fileName, "."));
        } else {
            nameWithoutExt = fileName;
        }

        print("Processing File (" + (f+1) + "/" + fileList.length + "): " + fileName);

        subFolder = outputMasterDir + nameWithoutExt + File.separator;
        
        if (!File.exists(subFolder)) {
            File.makeDirectory(subFolder);
        }

        for (i = 0; i < startFrames.length; i++) {

            s = startFrames[i];
            e = endFrames[i];

            run("Bio-Formats Importer", "open=[" + fullPath + "] windowless=true autoscale color_mode=Default view=Hyperstack stack_order=XYCZT specify_range t_begin=" + s + " t_end=" + e + " t_step=1");

            outName = nameWithoutExt + "_" + i + ".ome.tif";
            saveAs("Tiff", subFolder + outName);

            close();
            run("Collect Garbage");
        }
        print(" > Finished splitting " + fileName);
        print("------------------------------");
    }
}

setBatchMode(false);
print("--- ALL FILES COMPLETED ---");
showMessage("Batch Processing Complete!");
