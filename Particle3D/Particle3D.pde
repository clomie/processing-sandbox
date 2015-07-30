import java.util.*;
import peasy.*;

private PeasyCam cam;
private Particle[] particles = new Particle[1000];

private boolean record = false;

void setup() {
  size(960, 540, P3D);

  hint(DISABLE_DEPTH_TEST);
  blendMode(SCREEN);
  imageMode(CENTER);
  frameRate(30);

  cam = new PeasyCam(this, width);
  cam.setMaximumDistance(width * 2);

  List<PImage> images = new ArrayList<PImage>();
  for (Colors c : Colors.values ()) {
    images.add(createLight(c));
  }

  for (int i = 0; i < particles.length; i++) {
    PImage image = images.get(i % images.size());
    particles[i] = new Particle(image);
  }
}

private PImage createLight(Colors colors) {
  int side = 150;
  float center = side / 2.0;
  PImage img = createImage(side, side, RGB);

  for (int y = 0; y < side; y++) {
    for (int x = 0; x < side; x++) {
      float distance = (sq(center - x) + sq(center - y)) / 10;
      int c = colors.calculate(distance);
      img.pixels[x + y * side] = c;
    }
  }

  return img;
}

void draw() {

  background(0);
  translate(width/2, height/2, 0);

  cam.rotateX(radians(0.25));
  cam.rotateY(radians(0.25));

  float[] rotations = cam.getRotations();
  for (Particle p : particles) {
    p.render(rotations);
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

class Particle {

  private final PImage light;
  private final float x, y, z;

  Particle(PImage light) {
    this.light = light;

    float radP = radians(random(360));

    float unitZ = random(-1, 1);
    float sinT = sqrt(1 - sq(unitZ));

    float unitR = pow(random(1), 1.0/3.0);
    float r = width;

    x = r * unitR * sinT * cos(radP);
    y = r * unitR * sinT * sin(radP);
    z = r * unitR * unitZ;
  }

  void render(float[] rotation) {
    pushMatrix();
    translate(x, y, z);
    rotateX(rotation[0]);
    rotateY(rotation[1]);
    rotateZ(rotation[2]);
    image(light, 0, 0);
    popMatrix();
  }
}

