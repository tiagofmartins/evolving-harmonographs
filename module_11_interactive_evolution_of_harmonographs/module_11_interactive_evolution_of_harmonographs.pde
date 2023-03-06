int population_size = 21;
int elite_size = 1;
int tournament_size = 3;
float crossover_rate = 0.7;
float mutation_rate = 0.3;
int resolution = 200;

Population pop;
PVector[][] grid;
Harmonograph hovered_indiv = null;

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8));
  smooth(8);
}

void setup() {
  pop = new Population();
  grid = calculateGrid(population_size, 0, 0, width, height, 30, 10, 30, true);
  textSize(constrain(grid[0][0].z * 0.1, 11, 14));
  textAlign(CENTER, TOP);
}

void draw() {
  background(235);
  hovered_indiv = null; // Temporarily clear selected individual 
  int row = 0, col = 0;
  for (int i = 0; i < pop.getSize(); i++) {
    float x = grid[row][col].x;
    float y = grid[row][col].y;
    float d = grid[row][col].z;
    // Check if current individual is hovered by the cursor
    noFill();
    if (mouseX > x && mouseX < x + d && mouseY > y && mouseY < y + d) {
      hovered_indiv = pop.getIndiv(i);
      stroke(0);
      strokeWeight(3);
      rect(x, y, d, d);
    } else if (pop.getIndiv(i).getFitness() > 0) {
      stroke(100, 255, 100);
      strokeWeight(map(pop.getIndiv(i).getFitness(), 0, 1, 3, 6));
      rect(x, y, d, d);
    }
    // Draw phenotype of current individual
    image(pop.getIndiv(i).getPhenotype(resolution), x, y, d, d);
    // Draw fitness of current individual
    fill(0);
    text(nf(pop.getIndiv(i).getFitness(), 0, 2), x + d / 2, y + d + 2);
    // Go to next grid cell
    col += 1;
    if (col >= grid[row].length) {
      row += 1;
      col = 0;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (hovered_indiv != null) {
      // Change fitness of the selected (hovered) individual
      float fit = hovered_indiv.getFitness();
      if (keyCode == UP) {
        fit = min(fit + 0.1, 1);
      } else if (keyCode == DOWN) {
        fit = max(fit - 0.1, 0);
      } else if (keyCode == RIGHT) {
        fit = 1;
      } else if (keyCode == LEFT) {
        fit = 0;
      }
      hovered_indiv.setFitness(fit);
    }
  } else if (key == ' ') {
    // Evolve (generate new population)
    pop.evolve();
  } else if (key == 'i') {
    // Initialise new population
    pop.initialize();
  } else if (key == 'e') {
    // Export selected individual
    if (hovered_indiv != null) {
      hovered_indiv.export();
    }
  }
}

void mouseReleased() {
  // Set fitness of clicked individual to 1
  if (hovered_indiv != null) {
    if (hovered_indiv.getFitness() < 1) {
      hovered_indiv.setFitness(1);
    } else {
      hovered_indiv.setFitness(0);
    }
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
