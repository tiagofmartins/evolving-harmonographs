// This class manages a group of individuals.
class Population {
  
  Harmonograph[] individuals;
  
  // Create population
  Population() {
    individuals = new Harmonograph[population_size];
    initialize();
  }
  
  // Initialize population with random individuals
  void initialize() {
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new Harmonograph();
    }
  }
  
  Harmonograph getIndiv(int index) {
    return individuals[index];
  }
  
  int getSize() {
    return individuals.length;
  }
}
