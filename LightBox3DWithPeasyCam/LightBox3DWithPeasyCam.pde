import java.util.*;
import peasy.*;

private String[] colors = {"blue", "cyan", "emerald", "green", "magenta", "orange", "purple", "red", "yellow"};
private PImage[] images = new PImage[colors.length];

private Particle[] particles = new Particle[1000];

private PeasyCam cam;

private boolean record = false;

void setup() {
  size(960, 540, P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(SCREEN);
  imageMode(CENTER);
  frameRate(30);

  for (int i = 0; i < images.length; i++) {
    images[i] = loadImage("../images/light2-" + colors[i] + ".png");
  }

  cam = new PeasyCam(this, width/2);
  cam.setMaximumDistance(width/2);

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
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

  float x, y, z;
  int imageIndex;

  Particle() {
    x = random(-width/2, width/2);
    y = random(-width/2, width/2);
    z = random(-width/2, width/2);
    imageIndex = (int)random(images.length);
  }

  void render(float[] rotation) {
    pushMatrix();
    translate(x, y, z);
    rotateX(rotation[0]);
    rotateY(rotation[1]);
    rotateZ(rotation[2]);
    image(images[imageIndex], 0, 0);
    popMatrix();
  }
}