int population_size = 60;
int elite_size = 1;
int tournament_size = 3;
float mutation_rate = 0.2;
int resolution = 100;
String path_target_image = "1646506902776/V.png";

Population pop;
PVector[][] grid;
boolean show_phenotypes = false;
boolean show_fitness = true;

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8));
  smooth(8);
}

void setup() {
  pop = new Population();
  grid = calculateGrid(population_size, 0, 0, width, height, 30, 10, 30, true);
  textSize(constrain(grid[0][0].z * 0.1, 11, 14));
  textAlign(CENTER, TOP);
  fill(0);
}

void draw() {
  pop.evolve();
  println("Generations: " + pop.getGenerations());
  background(show_phenotypes ? 255 : 0);
  int row = 0, col = 0;
  for (int i = 0; i < pop.getSize(); i++) {
    noFill();
    if (show_phenotypes) {
      image(pop.getIndiv(i).getPhenotype(resolution), grid[row][col].x, grid[row][col].y, grid[row][col].z, grid[row][col].z);
      strokeWeight(1);
      stroke(0);
      rect(grid[row][col].x, grid[row][col].y, grid[row][col].z, grid[row][col].z);
    } else {
      strokeWeight(max(grid[row][col].z * 0.01, 1));
      stroke(255, 80);
      pop.getIndiv(i).renderPoints(getGraphics(), grid[row][col].x + grid[row][col].z / 2, grid[row][col].y + grid[row][col].z / 2, grid[row][col].z, grid[row][col].z);
    }
    if (show_fitness) {
      fill(show_phenotypes ? 80 : 128);
      text(nf(pop.getIndiv(i).getFitness(), 0, 4), grid[row][col].x + grid[row][col].z / 2, grid[row][col].y + grid[row][col].z + 2);
    }
    col += 1;
    if (col >= grid[row].length) {
      row += 1;
      col = 0;
    }
  }
}

void keyReleased() {
  if (key == 'e') {
    pop.getIndiv(0).export();
  } else if (key == 'p') {
    show_phenotypes = !show_phenotypes;
  } else if (key == 'f') {
    show_fitness = !show_fitness;
  }
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
