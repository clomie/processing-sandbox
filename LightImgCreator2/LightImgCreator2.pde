void setup() {
  size(500, 500);
  background(0);

  for (Colors c : Colors.values ()) {
    create(c);
    // save("../images/light2-" + c.name().toLowerCase() + ".png");
  }

  printImageSize();  
  // exit();
}

void create(Colors colors) {
  int cx = width / 2;
  int cy = height / 2;

  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float distance = (sq(cx - x) + sq(cy - y)) / 300;
      int c = colors.calculate(distance);
      pixels[x + y * width] = c;
    }
  }
  updatePixels();
}

void printImageSize() {

  int[] xy = {
    width, 0, height, 0
  };

  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      color c = pixels[x + y * width];
      if (c != 0xff000000) {
        xy[0] = min(xy[0], x);
        xy[1] = max(xy[1], x);
        xy[2] = min(xy[2], y);
        xy[3] = max(xy[3], y);
      }
    }
  }
  updatePixels();

  printArray(xy);
}

