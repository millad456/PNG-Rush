class Particle {
  PVector pos;
  PVector vel;
  int frame = 60, type;

  Particle(float x, float y, int type) {
    pos = new PVector(x, y);
    vel = PVector.random2D().mult((int)random(1, 4));
    this.type = type;
  }

  void run() {
    if (pause == 0) {
      if (type == 1)fill(255, 255, 0); //these are sparks from the bullets
      else if (type == 2) fill(255);
      else if (type == 3) fill(0);//black particles
      else if (type == 4) fill(random(255),random(255),random(255));//random colour particles
      noStroke();
      circle(pos.x, pos.y, frame/12);
      pos = pos.add(vel);
      frame--;
    }
  }
}
