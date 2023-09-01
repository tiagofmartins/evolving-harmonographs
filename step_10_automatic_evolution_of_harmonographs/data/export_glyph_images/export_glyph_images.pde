import java.nio.file.*;

// This program export images of glyphs to be used as target images.

// ABCDEFGHIJKLMNOPQRSTUVWXYZ
// abcdefghijklmnopqrstuvwxyz
// 0123456789
String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

Path path_output_dir = Paths.get(sketchPath("output"), "glyphs_" + System.currentTimeMillis());
PGraphics pg = createGraphics(300, 300);
PFont font = createFont("RobotoMono-Bold.ttf", pg.height * 0.925);
for (int i = 0; i < characters.length(); i++) {
  pg.smooth(8);
  pg.beginDraw();
  pg.background(255);
  pg.textFont(font);
  pg.textAlign(CENTER, CENTER);
  pg.fill(0);
  pg.noStroke();
  pg.text(characters.charAt(i), pg.width / 2, pg.height * 0.48);
  //pg.filter(BLUR, int(pg.height * 0.05));
  pg.endDraw();
  pg.save(Paths.get(path_output_dir.toString(), characters.charAt(i) + ".png").toString());
}
exit();
