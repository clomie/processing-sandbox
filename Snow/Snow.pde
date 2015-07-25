
private PImage img;
private Particle[] particles = new Particle[500];

void setup() {
  size(960, 540, P2D);
  blendMode(ADD);
  imageMode(CENTER);
  frameRate(30);

  img = loadImage("../images/light-snow.png");

  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  background(0);

  for (Particle p : particles) {
    p.update();
    p.render();
  }
}

class Particle {

  float x, y;
  float size;

  Particle() {
    init(random(height));
  }

  void init(float initY) {
    size = random(40);
    x = random(width);
    y = initY - size / 2;
  }

  void update() {
    if (isDead()) {
      init(0);
    } else {
      y += size / 40;
    }
  }

  boolean isDead() {
    return y > (height + size / 2);
  }

  void render() {
    image(img, x, y, size, size);
  }
}