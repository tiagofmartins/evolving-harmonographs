import java.util.*; // Needed to sort arrays

// This class stores and manages a population of individuals (harmonographs).
class Population {
  
  Harmonograph[] individuals; // Array to store the individuals in the population
  Evaluator evaluator; // Object to calculate fitness of individuals
  int generations; // Integer to keep count of how many generations have been created
  
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
    
    // Reset generations counter
    generations = 0;
  }
  
  // Create the next generation
  void evolve() {
    // Create a new a array to store the individuals that will be in the next generation
    Harmonograph[] new_generation = new Harmonograph[individuals.length];
    
    // Copy the elite to the next generation (we assume that the individuals are already sorted by fitness)
    for (int i = 0; i < elite_size; i++) {
      new_generation[i] = individuals[i].getCopy();
    }
    
    // Create (breed) new individuals with crossover
    for (int i = elite_size; i < new_generation.length; i++) {
      if (random(1) <= crossover_rate) {
        Harmonograph parent1 = tournamentSelection();
        Harmonograph parent2 = tournamentSelection();
        Harmonograph child = parent1.onePointCrossover(parent2);
        new_generation[i] = child;
      } else {
        new_generation[i] = tournamentSelection().getCopy();
      }
    }
    
    // Mutate new individuals
    for (int i = elite_size; i < new_generation.length; i++) {
      new_generation[i].mutate();
    }
    
    // Evaluate new individuals
    for (int i = elite_size; i < individuals.length; i++) {
      float fitness = evaluator.calculateFitness(new_generation[i]);
      new_generation[i].setFitness(fitness);
    }
    
    // Replace the individuals in the population with the new generation individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new_generation[i];
    }
    
    // Sort individuals in the population by fitness
    sortIndividualsByFitness();
    
    // Increment the number of generations
    generations++;
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
  
  // Get the number of generations that have been created so far
  int getGenerations() {
    return generations;
  }
}
