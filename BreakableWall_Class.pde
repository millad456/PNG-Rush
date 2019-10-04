class BreakableWall {
  float x, y, size = 40;
  int health = 3;
  int type;

  PImage breakableBlock = loadImage("Bblock.png");
  PImage breakableBlock1 = loadImage("BBblock.jpg");
  PImage shield = loadImage("shield.png");
  PImage whiteShield = loadImage("whiteShield.png");

  BreakableWall(float x, float y, int image) {
    this.x = x;
    this.y = y;
    type = image;
  }
  void run() {
    calcHealth();
  }

  void calcHealth() {
    if (type == 2) {
      if (health >= 2) {
        fill(255, 0, 0);
        image(breakableBlock, x, y, size, size);
      } else if (health == 1) {
        fill(0, 255, 0);
        image(breakableBlock1, x, y, size, size);
      } else if (health == 0) {
        fill(0);
        rect(x, y, size, size);
      }
    }
    else if (type == 4 && health > 0){
      noFill();
      strokeWeight(2.5);
      stroke(0);
      rect(x,y,size,size,8);
      image(shield, x + 2, y + 2, size - 4, size - 4);
    }
  }
}
