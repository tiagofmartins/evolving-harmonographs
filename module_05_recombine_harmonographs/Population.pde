// This class stores and manages a population of individuals (harmonographs).
class Population {
  
  Harmonograph[] individuals; // Array to store the individuals in the population
  
  Population() {
    individuals = new Harmonograph[population_size];
    initialize();
  }
  
  // Create the initial individuals
  void initialize() {
    // Fill population with random individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new Harmonograph();
    }
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
