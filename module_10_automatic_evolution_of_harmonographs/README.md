# Automatic Evolution of Harmonographs

This module demonstrates the automatic evolution of harmonograph drawings using a fitness function that evaluates individuals based on their visual similarity to a preset target image. In the specific case of this module, an image containing a letter is used as the target.

![](../images/automatic-evolution.gif)
*Population of harmonographs being evolved to resemble the letter V*

### Controls

Users can interact with the program using the following controls:

- Press key `p` to toggle the mode that draws the phenotypes' images;
- Press key `f` to toggle the visibility of fitness values;
- Press key `e` to export the best individual to file.

<!--
### TODO

- Implement the body the `evolve()` method of the `Population` class.
-->

### Challenges

- Implement a mechanism that increases the mutation rate based on the lack of diversity in the population.
- Implement a mechanism that exports the best evolved individual after a preset number of generations without any increase in fitness. After exporting the best individual, the evolutionary process should be reset.