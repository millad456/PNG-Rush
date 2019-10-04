class Teleporter {
  float x, y, size = 40;
  int radius1 = 40, radius2 = 20;
  boolean active = true;
  Teleporter(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void run() {
    display();
    teleport();
  }
  void display() {
    fill(255, 0, 255);
    strokeWeight(1);
    stroke(0);
    circle(x+20, y+20, 40);
    circle(x+20, y+20, radius1);
    circle(x+20, y+20, radius2);
    if (pause == 0) {
      if (radius1 > 0) radius1--;
      else radius1 = 40;
      if (radius2 > 0) radius2--;
      else radius2 = 40;
    }
  }
  void teleport() {
    if (p.x > x && p.y > y && p.x < x + 40 && p.y < y + 40 && active) {
      gameState++;

      active = false;
    }
  }
}
