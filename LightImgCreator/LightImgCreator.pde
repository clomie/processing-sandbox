
private static final float SOURCE_RED   = 256 * 8;
private static final float SOURCE_GREEN = 256 * 4;
private static final float SOURCE_BLUE  = 256 * 4;

void setup() {
  size(60, 60);
  background(0);

  for (Colors c : Colors.values ()) {
    create(c);
  }

  exit();
}

void create(Colors colors) {
  int cx = width / 2;
  int cy = height / 2;

  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float distance = (sq(cx - x) + sq(cy - y)) / 10;
      pixels[x + y * width] = colors.calculate(distance);
    }
  }
  updatePixels();

  save("../images/light-" + colors.name().toLowerCase() + ".png");
}

