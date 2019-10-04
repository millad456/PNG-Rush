class Wall {
  float x, y, size = 40;
  PImage wallSprite;
  int image;
  Wall(float x, float y, int image) {
    this.x = x;
    this.y = y;
    this.image = image;
    if (image == 1) wallSprite = loadImage("wall.png");
    if (image == 9) wallSprite = loadImage ("pine tree.png");
    if (image == 11) wallSprite = loadImage("KCircle.png");
    if (image == 13) wallSprite = loadImage("KTriangle.png");
    if (image == 15) wallSprite = loadImage("KSquare.png");
    if (image == 17) wallSprite = loadImage("KDiamond.png");
  }
  void run() {
    display();
  }
  void display() {
    if (image == 3) {
      noFill();
      strokeWeight(6);
      stroke(0, 0, 255);//red
      rect(x + abbx*2,y + abby*2, size, size, 8);
      stroke(255, 0, 0);//blue
      rect(x, y, size, size, 8);
      stroke(255);
      rect(x + abbx, y + abby, size, size, 8);
    } else if (image == 5){
      noFill();
      noStroke();
      rect(x,y,size,size);
    }
    else if (image == 7){
      noFill();
      noStroke();
      rect(x,y,size,size);
    }else if (image == 9){
      image(wallSprite, x + 9, y);
    }else image(wallSprite, x, y, size, size);
  }
}
