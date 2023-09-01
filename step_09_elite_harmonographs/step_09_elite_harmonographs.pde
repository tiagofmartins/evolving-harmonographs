int population_size = 83;
int elite_size = 3;
int tournament_size = 5;
float mutation_rate = 0.05;
int resolution = 128;
String path_target_image = "moon.png";

Population pop;
PVector[][] cells;

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8));
  smooth(8);
}

void setup() {
  pop = new Population();
  cells = calculateGrid(population_size + 1, 0, 0, width, height, 30, 10, 30, true);
  textSize(constrain(cells[0][0].z * 0.15, 11, 14));
  textAlign(CENTER, TOP);
  fill(0);
}

void draw() {
  background(235);
  float cell_dim = cells[0][0].z;
  int row = 0, col = 0;
  image(pop.evaluator.target_image, cells[row][col].x, cells[row][col].y, cell_dim, cell_dim);
  text("target", cells[row][col].x + cell_dim / 2, cells[row][col].y + cell_dim + 5);
  col += 1;
  for (int i = 0; i < pop.getSize(); i++) {
    image(pop.getIndiv(i).getPhenotype(resolution), cells[row][col].x, cells[row][col].y, cell_dim, cell_dim);
    if (i < elite_size) {
      pushStyle();
      noFill();
      strokeWeight(2);
      stroke(50, 100, 200);
      rect(cells[row][col].x, cells[row][col].y, cell_dim, cell_dim);
      popStyle();
    }
    text(nf(pop.getIndiv(i).getFitness(), 0, 4), cells[row][col].x + cell_dim / 2, cells[row][col].y + cell_dim + 5);
    col += 1;
    if (col >= cells[row].length) {
      row += 1;
      col = 0;
    }
  }
  noLoop();
}

void mouseReleased() {
  pop.createNewIndividuals();
  loop();
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
