
private PImage img;
private boolean selected;

private Particle[] particles = new Particle[500];

private boolean record = false;

void setup() {
  size(960, 540, P2D);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  selectInput("select image", "fileSelected");

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
  translate(width/2, height/2);

  // image(img, 0, 0, 400, 400);
  for (Particle p : particles) {
    p.update();
    p.render();
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
  float x, y;
  float size;

  Particle() {
    float angle = radians(random(360));
    dx = cos(angle);
    dy = sin(angle);
    init(random(960));
  }

  void init(float r) {
    radius = r;
    x = 0;
    y = 0;
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

  void render() {
    image(img, x, y, size, size);
  }
}