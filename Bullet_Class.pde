class Bullet {
  float x, y, xvel, yvel, angle;  
  float  speed = 10;
  int frame = 0, dir, spread = 0;

  Bullet(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    if (angle == PI/4) {
      xvel = speed*0.707;
      yvel = -speed*0.707;
    } else if (angle == 3*PI/4) {
      xvel = speed*0.707;
      yvel = speed*0.707;
    } else if (angle == 5*PI/4) {
      xvel = -speed*0.707;
      yvel = speed*0.707;
    } else if (angle == 7*PI/4) {
      xvel = -speed*0.707;
      yvel = -speed*0.707;
    } else if (angle == 0) {
      yvel = -speed;
    } else if (angle == PI/2) {
      xvel = speed;
    } else if (angle == PI) {
      yvel = speed;
    } else if (angle == 3*PI/2) {
      xvel = -speed;
    }
    
  }

  void run() {
    if (frame == 0){
      startup();
    }

    display();
    if(pause == 0) {
      move();
      frame++;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    fill(0);
    noStroke();
    ellipse(0, 0, 5, 5);
    popMatrix();
  }

  void move() {
    x+=xvel;
    y+=yvel;
  }
  
  void startup(){
    dir = (int) (angle/(PI/4));
    if (dir == 0)y -= 20;
    else if (dir == 1) {
      x += 14;
      y -= 14;
    } else if (dir == 2) x += 20;
    else if (dir == 3) {
      x += 14;
      y += 14;
    } else if (dir == 4) y += 20;
    else if (dir == 5) {
      x -= 14;
      y += 14;
    } else if (dir == 6) x -= 20;
    else if (dir == 7) {
      x -= 14;
      y -= 14;
    }
    
    x += (int) random(-spread, spread);
    y += (int) random(-spread, spread);
  }
}
