// This class enables the evaluation of individuals (harmonographs).
class Evaluator {

  // These files are used to communicate with the Python script that evaluates the evolved images
  File fileImagesList;
  File fileImagesFitness;

  Evaluator() {
    fileImagesList = new File(sketchPath("images_list.txt"));
    fileImagesFitness = new File(sketchPath("images_fitness.txt"));
    if (fileImagesList.exists()) {
      fileImagesList.delete();
    }
    if (fileImagesFitness.exists()) {
      fileImagesFitness.delete();
    }
  }

  // Calculate the fitness values of a list of individuals using an external Python script
  float[] calculateFitness(Harmonograph[] indivs) {
    // Save images (phenotypes) of the individuals to evaluate
    // as well as a file containing the paths to these images
    PImage[] images = new PImage[indivs.length];
    for (int i = 0; i < indivs.length; i++) {
      images[i] = indivs[i].getPhenotype(resolution);
    }
    Path pathOutputDir = Paths.get(dataPath("images_to_evaluate_" + System.nanoTime()));
    String[] outputImagesPaths = new String[images.length];
    for (int i = 0; i < images.length; i++) {
      Path pathOutputImage = pathOutputDir.resolve(i + ".png");
      outputImagesPaths[i] = pathOutputImage.toString();
      images[i].save(outputImagesPaths[i]);
    }
    saveStrings(fileImagesList.getPath(), outputImagesPaths);

    // Wait until the Python script writes the fitness values to file
    long curr_millis = System.currentTimeMillis();
    boolean print_msg = true;
    while (!fileImagesFitness.exists()) {
      if (print_msg) {
        println("Waiting for fitness");
        print_msg = false;
      }
      delay(100);
    }
    delay(100);
    float secs_waiting = (System.currentTimeMillis() - curr_millis) / 1000f;

    // Load fitness values from the file
    String[] lines = loadStrings(fileImagesFitness.getPath());
    assert lines.length == images.length;
    float[] fitness = new float[images.length];
    for (int i = 0; i < lines.length; i++) {
      fitness[i] = Float.parseFloat(lines[i]);
    }
    fileImagesFitness.delete();
    delay(100);

    // Delete the files saved to disk since they are no longer needed
    String[] files_to_delete = pathOutputDir.toFile().list();
    for (String filename : files_to_delete) {
      File f = new File(pathOutputDir.toString(), filename);
      f.delete();
    }
    pathOutputDir.toFile().delete();

    println("Fitness values loaded (waited " + secs_waiting + " secs)");

    // Return the fitness values
    return fitness;
  }
}
