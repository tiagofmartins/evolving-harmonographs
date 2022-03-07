import processing.pdf.*; // Needed to export PDFs

// This class represents and encodes a harmonograph.
class Harmonograph {
  
  float[] params = new float[20]; // Array that stores the values of the harmonograph parameters
  float time_max = 100;
  float time_step = 0.05;
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  // Create a random harmonograph
  Harmonograph() {
    randomize();
  }
  
  // Create a harmonograph with the given parameters
  Harmonograph(float[] params_init) {
    for (int i = 0; i < params_init.length; i++) {
      params[i] = params_init[i];
    }
  }
  
  // Set all parameters to random values 
  void randomize() {
    for (int i = 0; i < params.length; i++) {
      params[i] = random(0, 1);
    }
  }
  
  // Get the image of the harmonograph
  PImage getImage(int resolution) {
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    canvas.background(255);
    canvas.noFill();
    canvas.stroke(0);
    canvas.strokeWeight(canvas.height * 0.001);
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
  
  // Calculate the points of this harmonograph
  void calculatePoints(float w, float h) {
    float a1 = w * (0.15 + 0.1 * params[0]);
    float a2 = w * (0.15 + 0.1 * params[1]);
    float a3 = h * (0.15 + 0.1 * params[2]);
    float a4 = h * (0.15 + 0.1 * params[3]);
    float v1 = -0.02 + 0.04 * params[4];
    float v2 = -0.02 + 0.04 * params[5];
    float v3 = -0.02 + 0.04 * params[6];
    float v4 = -0.02 + 0.04 * params[7];
    float f1 = v1 + 1 + int(5 * params[8]);
    float f2 = v2 + 1 + int(5 * params[9]);
    float f3 = v3 + 1 + int(5 * params[10]);
    float f4 = v4 + 1 + int(5 * params[11]);
    float p1 = TWO_PI * params[12];
    float p2 = TWO_PI * params[13];
    float p3 = TWO_PI * params[14];
    float p4 = TWO_PI * params[15];
    float d1 = 0.01 * params[16];
    float d2 = 0.01 * params[17];
    float d3 = 0.01 * params[18];
    float d4 = 0.01 * params[19];
    points.clear();
    for (float t = 0; t < time_max; t += time_step) {
      float point_x = a1 * sin(t * f1 + p1) * exp(-d1 * t) + a2 * sin(t * f2 + p2) * exp(-d2 * t);
      float point_y = a3 * sin(t * f3 + p3) * exp(-d3 * t) + a4 * sin(t * f4 + p4) * exp(-d4 * t);
      PVector point = new PVector(point_x, point_y);
      points.add(point);
    }
  }
  
  // Export image (png), vector (pdf) and parameters (txt) of this harmonograph
  void export() {
    String output_filename = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "-" +
                             nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
    String output_path = sketchPath("outputs/" + output_filename);
    println("Exporting harmonograph to: " + output_path);
    
    getImage(2000).save(output_path + ".png");
    
    PGraphics pdf = createGraphics(500, 500, PDF, output_path + ".pdf");
    pdf.beginDraw();
    pdf.noFill();
    pdf.strokeWeight(pdf.height * 0.001);
    pdf.stroke(0);
    render(pdf, pdf.width / 2, pdf.height / 2, pdf.width, pdf.height);
    pdf.dispose();
    pdf.endDraw();
    
    String[] output_text_lines = new String[params.length];
    for (int i = 0; i < params.length; i++) {
      output_text_lines[i] = str(params[i]);
    }
    saveStrings(output_path + ".txt", output_text_lines);
  }
}
