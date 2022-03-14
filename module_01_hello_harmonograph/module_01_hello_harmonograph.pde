size(600, 600);
smooth(8);
background(255);

// Array with the normalised values of the harmonograph parameters
// All values in this array are in the range [0, 1].
float[] params = {0.417, 0.275, 0.018, 0.113, 0.110, 0.406, 0.555, 0.095, 0.048, 0.512, 0.156, 0.472, 0.080, 0.037, 0.997, 0.448, 0.723, 0.249, 0.598, 0.824};

// Individual variables for the harmonograph parameters.
// The values of the parameters are now in different ranges.
float a1 = width * (0.15 + 0.1 * params[0]); // amplitude 1
float a2 = width * (0.15 + 0.1 * params[1]); // amplitude 2
float a3 = height * (0.15 + 0.1 * params[2]); // amplitude 3
float a4 = height * (0.15 + 0.1 * params[3]); // amplitude 4
float v1 = -0.02 + 0.04 * params[4]; // frequency variation 1
float v2 = -0.02 + 0.04 * params[5]; // frequency variation 2
float v3 = -0.02 + 0.04 * params[6]; // frequency variation 3
float v4 = -0.02 + 0.04 * params[7]; // frequency variation 4
float f1 = v1 + 1 + int(5 * params[8]); // frequency 1
float f2 = v2 + 1 + int(5 * params[9]); // frequency 2
float f3 = v3 + 1 + int(5 * params[10]); // frequency 3
float f4 = v4 + 1 + int(5 * params[11]); // frequency 4
float p1 = TWO_PI * params[12]; // phase 1
float p2 = TWO_PI * params[13]; // phase 2
float p3 = TWO_PI * params[14]; // phase 3
float p4 = TWO_PI * params[15]; // phase 4
float d1 = 0.01 * params[16]; // damping 1
float d2 = 0.01 * params[17]; // damping 2
float d3 = 0.01 * params[18]; // damping 3
float d4 = 0.01 * params[19]; // damping 4

float time_max = 200; // max time (length of the line)
float time_step = 0.05; // time increment (density of the line vertexes)

// Draw the harmonograph at the centre of the window
noFill();
strokeWeight(1);
stroke(255, 90, 10);
translate(width / 2, height / 2);
beginShape(); // start drawing the line
for (float t = 0; t< time_max; t += time_step) {
  float x = a1 * sin(t * f1 + p1) * exp(-d1 * t) + a2 * sin(t * f2 + p2) * exp(-d2 * t);
  float y = a3 * sin(t * f3 + p3) * exp(-d3 * t) + a4 * sin(t * f4 + p4) * exp(-d4 * t);
  vertex(x, y); // add new vertex to the line
}
endShape(); // end drawing the line
