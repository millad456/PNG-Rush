class Ball {
  PVector pos;
  PVector vel;
  int timer;

  Ball(float x, float y, int timer, PVector vel) {
    this.vel = vel;
    pos = new PVector(x, y);
    this.timer = timer;
    vel.mult(5);
  }

  void run() {
    image(beachball, pos.x-50, pos.y-50, 100, 100);
    if (pause == 0)bounce();
  }
  void bounce() {
    //bouncing
    for (int i = 0; i < wall.size(); i ++) {// bounce on all walls
      if (pos.x + 50 > wall.get(i).x && pos.y > wall.get(i).y && pos.y < wall.get(i).y + wall.get(i).size) vel.x *= -1;
      if (pos.x - 50 < wall.get(i).x + wall.get(i).size && pos.y > wall.get(i).y && pos.y < wall.get(i).y + wall.get(i).size) vel.x *= -1;
      if (pos.y + 50 > wall.get(i).y && pos.x > wall.get(i).x && pos.x < wall.get(i).x + wall.get(i).size) vel.y *= -1;
      if (pos.y - 50 < wall.get(i).y + wall.get(i).size && pos.x > wall.get(i).x && pos.x < wall.get(i).x + wall.get(i).size) vel.y *= -1;
    }
    //bullet collisions
    for (int i = 0; i < b.size(); i++) {
      if (abs(b.get(i).x - pos.x) < 50 && abs(b.get(i).y -pos.y) < 50) {
        for (int k = 0; k < 10; k++) particles.add(new Particle(b.get(i).x, b.get(i).y, 4));
        b.remove(i);
        timer -= 30;
        if (shakeFrame == 0)shakeSetup();
      }
    }
    //melee collisions
    if (abs(m.x - pos.x) < 50 && abs(m.y -pos.y) < 50) {
      for (int k = 0; k < 10; k++) particles.add(new Particle(m.x, m.y, 4));
      timer = 0;
      if (shakeFrame == 0)shakeSetup();
    }
    //player collisions
    if (abs(p.x - pos.x) < 50 && abs(p.y -pos.y) < 50 && p.iframe == 0) {
      if (shakeFrame == 0)shakeSetup();
      p.health--;
      p.iframe = 120;
    }
    pos.add(vel);
    timer--;
  }
}
