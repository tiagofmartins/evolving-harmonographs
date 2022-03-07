import processing.pdf.*; // Needed to export PDFs

// This class represents and encodes a harmonograph.
class Harmonograph {
  
  float[] genes = new float[20]; // Array of genes that store the values of the harmonograph parameters
  float fitness = 0; // Fitness value
  float time_max = 100;
  float time_step = 0.05;
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  // Create a random harmonograph
  Harmonograph() {
    randomize();
  }
  
  // Create a harmonograph with the given genes
  Harmonograph(float[] genes_init) {
    for (int i = 0; i < genes_init.length; i++) {
      genes[i] = genes_init[i];
    }
  }
  
  // Set all genes to random values 
  void randomize() {
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0, 1);
    }
  }
  
  // One-point crossover operator
  Harmonograph onePointCrossover(Harmonograph partner) {
    Harmonograph child = new Harmonograph();
    int crossover_point = int(random(1, genes.length - 1));
    for (int i = 0; i < genes.length; i++) {
      if (i < crossover_point) {
        child.genes[i] = genes[i];
      } else {
        child.genes[i] = partner.genes[i];
      }
    }
    return child;
  }
  
  // Mutation operator
  void mutate() {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) <= mutation_rate) {
        //genes[i] = random(1); // Replace gene with a random one
        genes[i] = constrain(genes[i] + random(-0.1, 0.1), 0, 1); // Adjust the value of the gene
      }
    }
  }
  
  // Set the fitness value
  void setFitness(float fitness) {
    this.fitness = fitness;
  }
  
  // Get the fitness value
  float getFitness() {
    return fitness;
  }
  
  // Get a clean copy
  Harmonograph getCopy() {
    Harmonograph copy = new Harmonograph(genes);
    copy.fitness = fitness;
    return copy;
  }
  
  // Get the phenotype (image)
  PImage getPhenotype(int resolution) {
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    canvas.background(255);
    canvas.noFill();
    canvas.stroke(0);
    canvas.strokeWeight(canvas.height * 0.002);
    render(canvas, canvas.width / 2, canvas.height / 2, canvas.width, canvas.height);
    canvas.endDraw();
    return canvas;
  }
  
  // Draw the harmonograph line on a given canvas, at a given position and with a given size
  void render(PGraphics canvas, float x, float y, float w, float h) {
    calculatePoints(w, h);
    canvas.pushMatrix();
    canvas.translate(x, y);
    canvas.beginShape();
    for (int i = 0; i < points.size(); i++) {
      canvas.vertex(points.get(i).x, points.get(i).y);
    }
    canvas.endShape();
    canvas.popMatrix();
  }
  
  // Draw the harmonograph points on a given canvas, at a given position and with a given size
  void renderPoints(PGraphics canvas, float x, float y, float w, float h) {
    calculatePoints(w, h);
    canvas.pushMatrix();
    canvas.translate(x, y);
    for (int i = 0; i < points.size(); i++) {
      canvas.point(points.get(i).x, points.get(i).y);
    }
    canvas.popMatrix();
  }
  
  // Calculate the points of this harmonograph
  void calculatePoints(float w, float h) {
    float a1 = w * (0.15 + 0.1 * genes[0]);
    float a2 = w * (0.15 + 0.1 * genes[1]);
    float a3 = h * (0.15 + 0.1 * genes[2]);
    float a4 = h * (0.15 + 0.1 * genes[3]);
    float v1 = -0.02 + 0.04 * genes[4];
    float v2 = -0.02 + 0.04 * genes[5];
    float v3 = -0.02 + 0.04 * genes[6];
    float v4 = -0.02 + 0.04 * genes[7];
    float f1 = v1 + 1 + int(5 * genes[8]);
    float f2 = v2 + 1 + int(5 * genes[9]);
    float f3 = v3 + 1 + int(5 * genes[10]);
    float f4 = v4 + 1 + int(5 * genes[11]);
    float p1 = TWO_PI * genes[12];
    float p2 = TWO_PI * genes[13];
    float p3 = TWO_PI * genes[14];
    float p4 = TWO_PI * genes[15];
    float d1 = 0.01 * genes[16];
    float d2 = 0.01 * genes[17];
    float d3 = 0.01 * genes[18];
    float d4 = 0.01 * genes[19];
    points.clear();
    for (float t = 0; t < time_max; t += time_step) {
      float point_x = a1 * sin(t * f1 + p1) * exp(-d1 * t) + a2 * sin(t * f2 + p2) * exp(-d2 * t);
      float point_y = a3 * sin(t * f3 + p3) * exp(-d3 * t) + a4 * sin(t * f4 + p4) * exp(-d4 * t);
      PVector point = new PVector(point_x, point_y);
      points.add(point);
    }
  }
  
  // Export image (png), vector (pdf) and genes (txt) of this harmonograph
  void export() {
    String output_filename = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "-" +
                             nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
    String output_path = sketchPath("outputs/" + output_filename);
    println("Exporting harmonograph to: " + output_path);
    
    getPhenotype(2000).save(output_path + ".png");
    
    PGraphics pdf = createGraphics(500, 500, PDF, output_path + ".pdf");
    pdf.beginDraw();
    pdf.noFill();
    pdf.strokeWeight(pdf.height * 0.001);
    pdf.stroke(0);
    render(pdf, pdf.width / 2, pdf.height / 2, pdf.width, pdf.height);
    pdf.dispose();
    pdf.endDraw();
    
    String[] output_text_lines = new String[genes.length];
    for (int i = 0; i < genes.length; i++) {
      output_text_lines[i] = str(genes[i]);
    }
    saveStrings(output_path + ".txt", output_text_lines);
  }
}
