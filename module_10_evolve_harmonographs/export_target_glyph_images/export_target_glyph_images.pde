// This program export images of glyphs to be used as target images.

String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String path_output_dir = sketchPath("output/" + System.currentTimeMillis());
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
  pg.text(characters.charAt(i), pg.width / 2, pg.height * 0.35);
  //pg.filter(BLUR, int(pg.height * 0.05));
  pg.endDraw();
  pg.save(path_output_dir + "/" + characters.charAt(i) + ".png");
}
exit();
