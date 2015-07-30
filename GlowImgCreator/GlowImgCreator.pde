import java.util.*;

void setup() {
  size(150, 150);
  background(0);

  create();
  save("../images/glow.png");

  exit();
}

void create() {
  float power = 2;// glow core decay power
  float supp = 6;

  int cx = width / 2;
  int cy = height / 2;

  int[] xy = {150, 0, 150, 0};

  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // radial symmetric decreasing function
      float bri = 256 * width / (width + pow(dist(x, y, cx, cy), power)) - supp;
      color c = color(bri);
      pixels[x + y * width] = c;
      if (c != 0xff000000) {
        xy[0] = min(xy[0], x);
        xy[1] = max(xy[1], x);
        xy[2] = min(xy[2], y);
        xy[3] = max(xy[3], y);
      }
    }
  }
  updatePixels();

  println(Arrays.toString(xy));
}