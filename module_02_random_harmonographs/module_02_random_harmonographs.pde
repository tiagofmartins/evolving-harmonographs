float[] params = new float[20];
float time_max = 200;
float time_step = 0.05;
ArrayList<PVector> points = new ArrayList<PVector>();

void settings() {
  size(600, 600);
  smooth(8);
}

void setup() {
  randomizeParameters();
}

void draw() {
  if (mouseX != pmouseX) {
    time_max = map(mouseX, 0, width, 0, 250);
    //time_step = map(mouseX, 0, width, 0.1, 0.02);
    calculatePoints();
  }
  
  background(255);
  
  noStroke();
  fill(0);
  textSize(14);
  textLeading(18);
  text(join(nf(params, 0, 3), "\n"), 15, 25);
  
  noFill();
  strokeWeight(1);
  stroke(80, 120, 0);
  translate(width / 2, height / 2);
  beginShape();
  for (int i = 0; i < points.size(); i++) {
    vertex(points.get(i).x, points.get(i).y);
  }
  endShape();
}

void keyReleased() {
  randomizeParameters();
}

void randomizeParameters() {
  for (int i = 0; i < params.length; i++) {
    params[i] = random(0, 1);
  }
  calculatePoints();
}

void calculatePoints() {
  float a1 = width * (0.15 + 0.1 * params[0]);
  float a2 = width * (0.15 + 0.1 * params[1]);
  float a3 = height * (0.15 + 0.1 * params[2]);
  float a4 = height * (0.15 + 0.1 * params[3]);
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
