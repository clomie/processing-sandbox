
private static final int MAX_POS = 400;

PShape square;
Square[] squares = new Square[500];

void setup() {
  size(960, 540, P3D);
  blendMode(ADD);
  shapeMode(CENTER);

  square = createShape(RECT, 0, 0, 20, 20);
  square.setFill(color(255));
  square.setStroke(false);

  for (int i = 0; i < squares.length; i++) {
    squares[i] = new Square();
  }
}

void draw() {
  background(0);
  colorMode(HSB, 360, 100, 100, 256);

  translate(width/2, height/2, 0);

  float angle = (frameCount * 0.5) % 360;
  rotateZ(radians(angle));

  for (Square s : squares) {
    s.update(angle);
    s.render();
  }
}

class Square {
  private float vx, vz;

  private float x, z;
  private color rectColor;

  Square() {
    vx = random(-2, 5);
    vz = random(3, 10);
    init(0);
  }

  void init(float hue) {
    x = 200;
    z = 0;
    rectColor = color(hue, 80, 100);
  }

  void update(float hue) {
    x -= vx;
    z += vz;

    if (z > 400) {
      init(hue);
    }
  }

  void render() {
    pushMatrix();
    translate(x, -100, z);
    rotateX(HALF_PI);
    square.setFill(rectColor);
    shape(square, 0, 0);
    popMatrix();
  }
}

