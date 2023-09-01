int population_size = 55;

Population pop;
color[] colors;
PVector[][] cells;

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8));
  smooth(8);
}

void setup() {
  pop = new Population();
  colors = new color[pop.getSize()];
  for (int i = 0; i < pop.getSize(); i++) {
    colors[i] = color(random(25, 255), random(25, 255), random(25, 255));
  }
  cells = calculateGrid(pop.getSize(), 0, 0, width, height, 30, 5, 5, false);
}

void draw() {
  background(255);
  float cell_dim = cells[0][0].z;
  noFill();
  strokeWeight(cell_dim * 0.0025);
  stroke(0);
  int row = 0, col = 0;
  for (int i = 0; i < pop.getSize(); i++) {
    stroke(colors[i]);
    pop.getIndiv(i).render(getGraphics(), cells[row][col].x + cell_dim / 2, cells[row][col].y + cell_dim / 2, cell_dim, cell_dim);
    col += 1;
    if (col >= cells[row].length) {
      row += 1;
      col = 0;
    }
  }
  noLoop(); // Stop calling the draw() method
}

void mouseReleased() {
  pop.initialize();
  for (int i = 0; i < pop.getSize(); i++) {
    colors[i] = color(random(50, 200), random(50, 200), random(50, 200));
  }
  loop(); // Call draw() method to refresh the window
}

// Calculate grid of square cells
PVector[][] calculateGrid(int cells, float x, float y, float w, float h, float margin_min, float gutter_h, float gutter_v, boolean align_top) {
  int cols = 0, rows = 0;
  float cell_size = 0;
  while (cols * rows < cells) {
    cols += 1;
    cell_size = ((w - margin_min * 2) - (cols - 1) * gutter_h) / cols;
    rows = floor((h - margin_min * 2) / (cell_size + gutter_v));
  }
  if (cols * (rows - 1) >= cells) {
    rows -= 1;
  }
  float margin_hor_adjusted = ((w - cols * cell_size) - (cols - 1) * gutter_h) / 2;
  if (rows == 1 && cols > cells) {
    margin_hor_adjusted = ((w - cells * cell_size) - (cells - 1) * gutter_h) / 2;
  }
  float margin_ver_adjusted = ((h - rows * cell_size) - (rows - 1) * gutter_v) / 2;
  if (align_top) {
    margin_ver_adjusted = min(margin_hor_adjusted, margin_ver_adjusted);
  }
  PVector[][] positions = new PVector[rows][cols];
  for (int row = 0; row < rows; row++) {
    float row_y = y + margin_ver_adjusted + row * (cell_size + gutter_v);
    for (int col = 0; col < cols; col++) {
      float col_x = x + margin_hor_adjusted + col * (cell_size + gutter_h);
      positions[row][col] = new PVector(col_x, row_y, cell_size);
    }
  }
  return positions;
}
