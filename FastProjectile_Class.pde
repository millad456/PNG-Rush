class FastProjectile {
  PVector pos;
  PVector vel;
  int image, atk;
  float amp = 150, freq = 40, tempx;
  PImage french = loadImage("french.png");
  PImage spanish = loadImage("spanish.png");
  PImage italian = loadImage("italian.png");
  
  FastProjectile(float x, float y, PVector vel, int image) {
    pos = new PVector(x, y);
    tempx = x;
    this.vel = vel;
    this.image = image;
  }

  void run() {
    display();
    if (pause == 0)move();
  }

  void display() {
    if (image == 1) {
      noStroke();
      tint(255, 0, 0);
      circle(pos.x + abbx*2, pos.y + abby*2, 15);
      fill(0, 0, 255);
      circle(pos.x, pos.y, 15);
      fill(255);
      circle(pos.x + abbx, pos.y + abby, 15);
    } else if (image == 2){ //bullets for duolingo
      if (duo.bulletType == 0)
      image(french,pos.x-2,pos.y-2,30,30);
      else if (duo.bulletType == 1)
      image(italian,pos.x-2,pos.y-2,30,30);
      else if (duo.bulletType == 2)
      image(spanish,pos.x-2,pos.y-2,30,30);
    }else if (image == 3){
      noStroke();
      fill(255,255,0);
      stroke(0);
      circle(pos.x, pos.y, 15);
    }else if (image == 4){
      noStroke();
      fill(255);
      circle(pos.x, pos.y, 15);
    }
    noTint();
  }

  void move() {
    if (image == 4){
      pos.y += vel.y;
      atk = (int) random(0,2);
      if(atk == 0)
      pos.x = amp*sin(pos.y/freq) + tempx;
      if(atk == 1)
      pos.x = amp*cos(pos.y/freq) + tempx;
    }
    else pos.add(vel);
  }
}
