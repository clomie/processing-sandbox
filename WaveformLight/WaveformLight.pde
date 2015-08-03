import peasy.*;

import java.awt.Color;
import java.util.*;

PImage light;
PeasyCam cam;

private List<Light> lights = new ArrayList<Light>();

void setup() {
  size(960, 540, P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  cam = new PeasyCam(this, width/2, 0, 0, 500);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(2000);

  light = createLight();

  int range = 5000;
  for (int x = -range; x < range; x += 5) {
    lights.add(new Light(x, -120));
    lights.add(new Light(x, 120));
  }
}

private PImage createLight() {
  int side = 400;
  float center = side / 2.0;
  PImage img = createImage(side, side, RGB);

  for (int y = 0; y < side; y++) {
    for (int x = 0; x < side; x++) {
      float d = (sq(center - x) + sq(center - y)) / 300;
      color c = color(calc(8, d), calc(8, d), calc(8, d));
      img.pixels[x + y * side] = c;
    }
  }

  return img;
}

float calc(float a, float distance) {
  return 256 * a / distance - 16;
}

void draw() {
  background(0);

  color col = hsbAsRgb(frameCount % 360, 75, 100);
  for (Light l : lights) {
    l.update();
    l.render(col);
  }
}

// colorMode(HSB, 360, 100, 100)
private color hsbAsRgb(float h, float s, float b) {
  float hue = 1.0 / 360 * h;
  float sat = s / 100;
  float bri = b / 100;
  return Color.HSBtoRGB(hue, sat, bri);
}

class Light {

  private float x, y;

  private float vh;
  private float h;

  Light(float x, float y) {
    this.x = x;
    this.y = y;
    h = random(400);
    vh = random(25, 50);
  }

  void update() {
    h += vh;
    if (h >= 400) {
      vh = random(-50, -25);
    } else if (h <= 0) {
      vh = random(25, 50);
    }
  }

  void render(color tc) {
    pushMatrix();
    translate(x, y);
    tint(tc);
    image(light, 0, 0, 45, h);
    popMatrix();
  }
}

