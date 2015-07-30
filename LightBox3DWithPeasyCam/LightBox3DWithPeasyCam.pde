import java.util.*; //<>//
import peasy.*;

private PeasyCam cam;

private List<PImage> images = new ArrayList<PImage>();
private Particle[] particles = new Particle[2000];

private boolean record = false;

void setup() {
  size(960, 540, P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(SCREEN);
  imageMode(CENTER);
  frameRate(30);

  for (Colors c : Colors.values()) {
    images.add(createLight(c));
  }

  cam = new PeasyCam(this, width/2);
  cam.setMaximumDistance(width);

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
}

private PImage createLight(Colors colors) {

  int side = 150;
  PImage img = createImage(side, side, RGB);

  int center = side / 2;

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

  if (frameCount % 20 == 0) {
    println(frameRate);
  }

  background(0);
  translate(width/2, height/2, 0);

  cam.rotateX(radians(0.25));
  cam.rotateY(radians(0.25));

  float[] rotations = cam.getRotations();

  for (Particle p : particles) { //<>//
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


  PImage light;
  float x, y, z;

  Particle() {
    light = images.get(floor(random(images.size())));

    float radP = radians(random(360));

    float unitZ = random(-1, 1);
    float sinT = sqrt(1 - sq(unitZ));

    float r = pow(random(1), 1.0/3.0);
    float RAD = width;

    x = RAD * r * sinT * cos(radP);
    y = RAD * r * sinT * sin(radP);
    z = RAD * r * unitZ;
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