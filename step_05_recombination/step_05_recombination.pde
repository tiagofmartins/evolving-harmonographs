int population_size = 5;

Population pop;
Harmonograph[] offspring;
boolean show_genes = false;

void settings() {
  size(int(displayWidth * 0.8), int(min(((displayWidth * 0.8) / population_size) * 2, displayHeight * 0.8)));
  smooth(8);
}

void setup() {
  pop = new Population();
  offspring = new Harmonograph[pop.getSize() - 1];
  recombinePairsOfIndividuals();
  
  textSize(14);
  textLeading(g.textSize * 1.4);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);

  // Draw individuals (parents at the top and offspring at the bottom)
  noFill();
  strokeWeight(0.5);
  stroke(100, 120, 200);
  float dim = width / pop.getSize();
  for (int i = 0; i < pop.getSize(); i++) {
    pop.getIndiv(i).render(getGraphics(), (i + 0.5) * dim, height * 0.3, dim, dim);
  }
  stroke(120, 200, 100);
  for (int i = 0; i < offspring.length; i++) {
    offspring[i].render(getGraphics(), (i + 1) * dim, height * 0.7, dim, dim);
  }

  // Draw genes of each individual
  if (show_genes) {
    noStroke();
    fill(255, 175);
    rect(0, 0, width, height);
    noStroke();
    fill(100, 120, 200);
    for (int i = 0; i < pop.getSize(); i++) {
      String[] text = new String[pop.getIndiv(i).genes.length];
      for (int g = 0; g < pop.getIndiv(i).genes.length; g++) {
        text[g] = nf(pop.getIndiv(i).genes[g], 0, 4);
      }
      text(join(text, "\n"), (i + 0.5) * dim, height * 0.5);
    }
    fill(120, 200, 100);
    for (int i = 0; i < offspring.length; i++) {
      String[] text = new String[offspring[i].genes.length];
      for (int g = 0; g < offspring[i].genes.length; g++) {
        text[g] = nf(offspring[i].genes[g], 0, 4);
        if (offspring[i].genes[g] == pop.getIndiv(i).genes[g]) {
          text[g] = text[g] + "     ";
        } else {
          text[g] = "     " + text[g];
        }
      }
      text(join(text, "\n"), (i + 1) * dim, height * 0.5);
    }
  }
  noLoop();
}

void recombinePairsOfIndividuals() {
  for (int i = 0; i < offspring.length; i++) {
    Harmonograph parent1 = pop.getIndiv(i);
    Harmonograph parent2 = pop.getIndiv(i + 1);
    //offspring[i] = parent1.onePointCrossover(parent2);
    offspring[i] = parent1.uniformCrossover(parent2);
  }
}

void mouseReleased() {
  recombinePairsOfIndividuals();
  loop();
}

void keyReleased() {
  show_genes = !show_genes;
  loop();
}
