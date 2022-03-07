Harmonograph h;

void settings() {
  size(600, 600);
  smooth(8);
}

void setup() {
  h = new Harmonograph();
}

void draw() {
  background(255);
  noFill();
  strokeWeight(1);
  stroke(0);
  h.render(getGraphics(), mouseX, mouseY, 400, 400);
}

void mouseReleased() {
  h.randomize();
}

void keyReleased() {
  if (key == 'e') {
    h.export();
  }
}
