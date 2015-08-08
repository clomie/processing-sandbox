import java.awt.Color;
import java.util.*;
import peasy.*;

private PImage light;
private Camera cam;

private List<Light> lights = new ArrayList<Light>();

private boolean record;

void setup() {
  size(960, 540, P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  light = createLight();
  cam = new Camera(this);

  int rangeX = 10000;
  for (int x = -rangeX; x < rangeX; x += 5) {
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

  if (frameCount % 10 == 0) {
    println(frameRate);
  }

  cam.rotate();
  // cam.printRotations();

  color col = hsbAsRgb(frameCount % 360, 75, 100);
  for (Light l : lights) {
    l.update();
    l.render(col);
  }

  if (record) {
    saveFrame("frame/frame-######.tif");
  }
}

// colorMode(HSB, 360, 100, 100)
private color hsbAsRgb(float h, float s, float b) {
  float hue = 1.0 / 360 * h;
  float sat = s / 100;
  float bri = b / 100;
  return Color.HSBtoRGB(hue, sat, bri);
}

void keyPressed() {
  if (key == 'r') {
    record = true;
  }
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

class Camera {

  private final PeasyCam cam;

  // 120bpm -> 2.0 beat/sec (30fps : 15frame/beat)
  // 150bpm -> 2.5 beat/sec (30fps : 12frame/beat)
  // 180bpm -> 3.0 beat/sec (30fps : 10frame/beat)
  private final float ratio = 1.75;

  private final float rotateSpeed = 2.0;
  private final float zoomSpeed = 12.5;

  private float vx, vy, vz, vd;
  private float x, y, z, d;

  Camera(PApplet p) {
    cam = new PeasyCam(p, 500);
    cam.setMinimumDistance(250);
    cam.setMaximumDistance(1000);

    vx = tiltRandom();
    vy = tiltRandom();
    vz = rotateSpeed * ratio;
    vd = zoomSpeed * ratio;

    d = 500;
  }

  float tiltRandom() {
    return random(1 * ratio, 2 * ratio);
  }

  void rotate() {
    cam.reset();

    x += vx;
    y += vy;
    z += vz;
    d += vd;

    cam.rotateX(radians(x));
    cam.rotateY(radians(y));
    cam.rotateZ(radians(z));
    cam.setDistance(d, 0);

    if (x <= -30) {
      vx = tiltRandom();
    } else if (x >= 30) {
      vx = -tiltRandom();
    }
    if (y <= -30) {
      vy = tiltRandom();
    } else if (y >= 30) {
      vy = -tiltRandom();
    }

    if (d <= 250) {
      vd = zoomSpeed * ratio;
    } else if (d >= 1000) {
      vd = -zoomSpeed * ratio;
    }
  }

  void printRotations() {
    float[] rs = cam.getRotations();
    println("x : " + ceil(degrees(rs[0])) + ", y : " + ceil(degrees(rs[1])) + ", z : " + ceil(degrees(rs[2])));
  }
}

