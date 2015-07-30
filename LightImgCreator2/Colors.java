enum Colors {
  RED(8, 4, 4), 
  GREEN(4, 8, 4), 
  BLUE(4, 4, 8), 
  MAGENTA(8, 4, 8), 
  PURPLE(6, 4, 8), 
  ORANGE(8, 6, 4), 
  YELLOW(8, 8, 4), 
  CYAN(4, 8, 8), 
  EMERALD(4, 8, 6);

  private static final float SUPPRESS = 3;
  private float r, g, b;

  private Colors(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  int calculate(float d) {
    return 0xff << 24 | color(r, d) << 16 | color(g, d) << 8 | color(b, d);
  }

  private static int color(float a, float distance) {
    int color = (int)(256 * a / distance - SUPPRESS);
    return Math.max(0, Math.min(color, 255));
  }
}