import java.util.*;

private List<PImage> images = new ArrayList<PImage>();
private List<Strobe> strobes = new ArrayList<Strobe>();

private int lightIndex = 0;

private boolean record;

void setup() {
  size(960, 540, P2D);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  for (Colors c : Colors.values()) {
    images.add(createLight(c));
  }

  for (int y = 54; y < height; y += 104) {
    for (int x = 56; x < width; x += 106) {
      strobes.add(new Strobe(x, y));
    }
  }
}

private PImage createLight(Colors colors) {
  int side = 400;
  float center = side / 2.0;
  PImage img = createImage(side, side, RGB);

  for (int y = 0; y < side; y++) {
    for (int x = 0; x < side; x++) {
      float distance = (sq(center - x) + sq(center - y)) / 300;
      int c = colors.calculate(distance);
      img.pixels[x + y * side] = c;
    }
  }

  return img;
}

void draw() {

  background(0);

  if (frameCount % 10 == 0) {
    for (Strobe s : strobes) {
      s.flash(lightIndex);
    }
    lightIndex = (lightIndex + 1) % images.size();
  }

  for (Strobe s : strobes) {
    s.update();
    s.render();
  }

  if (record) {
    saveFrame("frame/frame-######.tif");
  }
}

void keyPressed() {
  if (key == 's') {
    record = true;
  }
}

class Strobe {

  private float x, y;
  private float alpha;
  private int index;

  Strobe(float x, float y) {
    this.x = x;
    this.y = y;
    alpha = 0;
    index = 0;
  }

  void update() {
    if (alpha > 0) {
      alpha -= 10;
    }
  }

  void flash(int i) {
    if (alpha <= 0 && random(10) < 1) {
      alpha = 255;
      index = i;
    }
  }

  void render() {
    if (alpha <= 0) {
      return;
    }
    tint(255, alpha);
    image(images.get(index), x, y);
  }
}
