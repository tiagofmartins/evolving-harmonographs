import java.util.*; // Needed to sort arrays

// This class stores and manages a population of individuals (harmonographs).
class Population {
  
  Harmonograph[] individuals; // Array to store the individuals in the population
  Evaluator evaluator; // Object to calculate fitness of individuals
  
  Population() {
    individuals = new Harmonograph[population_size];
    evaluator = new Evaluator(loadImage(path_target_image), resolution);
    initialize();
  }
  
  // Create the initial individuals
  void initialize() {
    // Fill population with random individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new Harmonograph();
    }
    
    // Evaluate individuals
    for (int i = 0; i < individuals.length; i++) {
      float fitness = evaluator.calculateFitness(individuals[i]);
      individuals[i].setFitness(fitness);
    }
    
    // Sort individuals in the population by fitness (fittest first)
    sortIndividualsByFitness();
  }
  
  // Fill population with new individuals
  void createNewIndividuals() {
    // Create a new a array to store the new individuals
    Harmonograph[] new_individuals = new Harmonograph[individuals.length];
    
    // Copy the elite individuals (we assume that the individuals are already sorted by fitness)
    for (int i = 0; i < elite_size; i++) {
      new_individuals[i] = individuals[i].getCopy();
    }
    
    // Fill the rest of the population with random individuals
    for (int i = elite_size; i < new_individuals.length; i++) {
      new_individuals[i] = new Harmonograph();
    }
    
    // Evaluate new individuals
    for (int i = elite_size; i < new_individuals.length; i++) {
      float fitness = evaluator.calculateFitness(new_individuals[i]);
      new_individuals[i].setFitness(fitness);
    }
    
    // Replace the individuals in the population with the new ones
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new_individuals[i];
    }
    
    // Sort individuals in the population by fitness
    sortIndividualsByFitness();
  }
  
  // Select one individual using a tournament selection 
  Harmonograph tournamentSelection() {
    // Select a random set of individuals from the population
    Harmonograph[] tournament = new Harmonograph[tournament_size];
    for (int i = 0; i < tournament.length; i++) {
      int random_index = int(random(0, individuals.length));
      tournament[i] = individuals[random_index];
    }
    // Get the fittest individual from the selected individuals
    Harmonograph fittest = tournament[0];
    for (int i = 1; i < tournament.length; i++) {
      if (tournament[i].getFitness() > fittest.getFitness()) {
        fittest = tournament[i];
      }
    }
    return fittest;
  }
  
  // Sort individuals in the population by fitness in descending order (fittest first)
  void sortIndividualsByFitness() {
    Arrays.sort(individuals, new Comparator<Harmonograph>() {
      public int compare(Harmonograph indiv1, Harmonograph indiv2) {
        return Float.compare(indiv2.getFitness(), indiv1.getFitness());
      }
    });
  }
  
  // Get an individual from the popultioon located at the given index
  Harmonograph getIndiv(int index) {
    return individuals[index];
  }
  
  // Get the number of individuals in the population
  int getSize() {
    return individuals.length;
  }
}
