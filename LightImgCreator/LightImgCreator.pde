void setup() {
  size(60, 60);
  background(0);

  for (Colors c : Colors.values()) {
    create(c);
    save("../images/light-" + c.name().toLowerCase() + ".png");
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
}