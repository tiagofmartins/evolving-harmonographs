int population_size = 6;
float mutation_rate = 0.05;

Population pop;
Harmonograph[] mutated;
boolean show_genes = false;

void settings() {
  size(int(displayWidth * 0.8), int(min(((displayWidth * 0.8) / population_size) * 2, displayHeight * 0.8)));
  smooth(8);
}

void setup() {
  pop = new Population();
  mutated = new Harmonograph[pop.getSize()];
  mutateIndividuals();
  textSize(12);
  textLeading(15);
}

void draw() {
  mutation_rate = map(mouseY, 0, height, 0, 1);
  
  background(255);
  noFill();
  strokeWeight(1);
  stroke(0);
  float dim = width / pop.getSize();
  for (int i = 0; i < pop.getSize(); i++) {
    pop.getIndiv(i).render(getGraphics(), (i + 0.5) * dim, height * 0.3, dim, dim);
  }
  stroke(100, 200, 50);
  for (int i = 0; i < mutated.length; i++) {
    mutated[i].render(getGraphics(), (i + 0.5) * dim, height * 0.7, dim, dim);
  }
  
  if (show_genes) {
    noStroke();
    fill(255, 220);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(0);
    for (int i = 0; i < pop.getSize(); i++) {
      String[] text = new String[pop.getIndiv(i).genes.length];
      for (int g = 0; g < pop.getIndiv(i).genes.length; g++) {
        text[g] = nf(pop.getIndiv(i).genes[g], 0, 4);
      }
      text(join(text, "\n"), (i + 0.35) * dim, height * 0.5);
    }
    fill(70, 180, 30);
    for (int i = 0; i < mutated.length; i++) {
      String[] text = new String[mutated[i].genes.length];
      for (int g = 0; g < mutated[i].genes.length; g++) {
        text[g] = nf(mutated[i].genes[g], 0, 4);
        if (mutated[i].genes[g] != pop.getIndiv(i).genes[g]) {
          text[g] = "> " + text[g] + " <";
        }
      }
      text(join(text, "\n"), (i + 0.65) * dim, height * 0.5);
    }
  }
  
  textAlign(LEFT, TOP);
  fill(0);
  text("Mutation rate: " + nf(mutation_rate, 0, 3), 20, 20);
}

void mutateIndividuals() {
  for (int i = 0; i < pop.getSize(); i++) {
    mutated[i] = pop.getIndiv(i).getCopy();
    mutated[i].mutate();
  }
}

void mouseReleased() {
  mutateIndividuals();
}

void keyReleased() {
  show_genes = !show_genes;
}
