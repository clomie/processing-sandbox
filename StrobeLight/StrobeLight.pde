import java.util.*;

private List<PImage> images = new ArrayList<PImage>();
private List<Strobe> strobes = new ArrayList<Strobe>();

private int lightIndex = 0;

// 120bpm -> 2.0 beat/sec (30fps : 15frame/beat)
// 150bpm -> 2.5 beat/sec (30fps : 12frame/beat)
// 180bpm -> 3.0 beat/sec (30fps : 10frame/beat)
private int frameParBeat = 10;
private int bpm = floor((30.0 / frameParBeat) * 60.0);

void setup() {
  size(960, 540, P2D);
  blendMode(ADD);
  imageMode(CENTER);

  frameRate(30);

  for (Colors c : Colors.values ()) {
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

  if (frameCount % frameParBeat == 0) {
    for (Strobe s : selectStrobes ()) {
      s.flash(lightIndex);
    }
    lightIndex = (lightIndex + 1) % images.size();
  }

  for (Strobe s : strobes) {
    s.render();
  }

  saveFrame("frame" + bpm + "/frame-######.tif");
}

private List<Strobe> selectStrobes() {
  List<Strobe> list = new ArrayList<Strobe>();
  for (Strobe s : strobes) {
    if (s.isDead()) {
      list.add(s);
    }
  }
  Collections.shuffle(list);

  int remains = list.size();
  if (remains < 2) {
    return Collections.emptyList();
  }

  int size = min(remains, floor(random(2, 8)));
  return list.subList(0, size);
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

  boolean isDead() {
    return alpha < 0;
  }

  void flash(int i) {
    alpha = 300;
    index = i;
  }

  void render() {
    // Apply transparency without changing color
    tint(255, alpha);
    image(images.get(index), x, y);
    alpha -= 12;
  }
}

