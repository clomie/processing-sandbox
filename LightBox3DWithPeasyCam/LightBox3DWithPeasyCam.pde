import peasy.*;

private PImage img;
private boolean selected;

private Particle[] particles = new Particle[500];

private PeasyCam cam;

private boolean record = false;

void setup() {
  size(960, 540, P3D);
  hint(DISABLE_DEPTH_TEST);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  File def = new File(sketchPath("../images/light-emerald.png"));
  selectInput("Select image", "fileSelected", def);

  cam = new PeasyCam(this, 100);
  cam.setMaximumDistance(width/2);

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    exit();
  } else {
    img = loadImage(selection.toString());
    selected = true;
  }
}

void draw() {
  if (!selected) {
    return;
  }

  background(0);
  translate(width/2, height/2, 0);

  cam.rotateX(radians(0.25));
  cam.rotateY(radians(0.25));

  float[] rotations = cam.getRotations();

  // image(img, 0, 0, 400, 400);
  for (Particle p : particles) {
    // p.update();
    p.render(rotations);
  }

  if (record) {
    saveFrame("frame/frame-######.tif");
  }
}

void keyPressed() {
  if (key == 's') {
    record = true;
  } else if (key == 'r') {
    selectInput("select image", "fileSelected");
  }
}

class Particle {

  final float dx, dy;

  float radius;
  float x, y, z;
  float size;

  Particle() {
    float angle = radians(random(360));
    dx = cos(angle);
    dy = sin(angle);
    init(random(width));
  }

  void init(float r) {
    radius = r;
    x = random(-height/2, height/2);
    y = random(-height/2, height/2);
    z = random(-height/2, height/2);
    size = random(150);
  }

  void update() {
    if (isDead()) {
      init(0);
    } else {
      radius += 10;
      x = radius * dx;
      y = radius * dy;
      size -= 2;
    }
  }

  boolean isDead() {
    return (size <= 0) ||
      x < -(width+size)  || (width+size) < x ||
      y < -(height+size) || (height+size) < y;
  }

  void render(float[] rotation) {
    pushMatrix();
    translate(x, y, z);
    rotateX(rotation[0]);
    rotateY(rotation[1]);
    rotateZ(rotation[2]);
    image(img, 0, 0);
    popMatrix();
  }
}