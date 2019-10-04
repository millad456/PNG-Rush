class Kahoot {
  float xvel = 2, yvel = 2, w = 200, h = 84, x = 1280/2 - w/2, y = 720/4 - h/2, radius = 1, easing = 0.04;
  int health = 300, frame, image, timer = 120, action = 1, trans = 450;
  PVector vel;//for the bullet being shot
  PVector node = new PVector((int)random(1, 3)*1280/3, (int)random(1, 3)*720/3);//generate random node
  PVector ve; // for the balls

  void run() {
    image(Title, 1280/2-Title.width/2, 720/2-Title.height/2);
    //calculate collisions
    if (health > 100 && pause == 0) {   //phase 1
      easing = 0.04;
      collisions();
      if (timer == 0) {
        action = (int) random(0, 4);      //at the end of every action, it chooses a new one
      }
      if (action == 1) {                  //follow player for 3 seconds
        if (timer == 0)timer = 160;
        move();
      } else if (action == 2) {           //shoot player for 30 frames
        if (timer == 0)timer = 30;
        shoot1();
      } else if (action == 3) {           //shoot ball randomly
        if (timer == 0)timer = 30;
        shoot2();
      }
    }
    if (health <= 100 && health > 0 && pause == 0) {   //phase 2
      easing = 0.08;
      collisions();
      if (timer == 0) {
        action = (int) random(0, 4);      //at the end of every action, it chooses a new one
      }
      if (action == 1) {                  //follow player for 3 seconds
        if (timer == 0)timer = 160;
        move();
      } else if (action == 2) {           //shoot lots of bullets at player for 30 frames
        if (timer == 0)timer = 30;
        shoot3();
      } else if (action == 3) {           //shoot ball at player
        if (timer == 0)timer = 30;
        shoot4();
      }
    } 


    //draw boss/die
    if (health > 0) {
      drawBoss();
    } else {
      die();
    }
    for (int i = 0; i < fp.size(); i++) fp.get(i).run();
  }

  void move() { //movement method
    if (x + w/2 >= node.x - 3 && x + w/2 <= node.x + 3 && y + h/2 >= node.y - 3 && y + h/2 <= node.y + 3) {
      node = new PVector((int)random(1, 3)*1280/3, (int)random(1, 3)*720/3);//generate random node when it is in the right place
    } else {

      //easing equation to move
      float targetX = node.x;
      float dx = targetX - (x + w/2);
      x += dx * easing;

      float targetY = node.y;
      float dy = targetY - (y + h/2);
      y += dy * easing;

      //old movement
      //if (x + w/2 > node.x) x -= 3;
      //if (x + w/2 < node.x) x += 3;
      //if (y + h/2 > node.y) y -= 3;
      //if (y + h/2 < node.y) y += 3;
    }
    timer--;
  }
  void reset() { //reset entire game screen
    p.x = 1280/2;
    p.y = 720*3/4;
    p.velx = 0;
    p.vely = 0;
    p.health = 5;
    x = 1280/2 - w/2;
    y = 720/4 - h/2;
    health = 300;
    action = 1; 
    timer = 120;
    fp.removeAll(fp); //reset projectiles
    b.removeAll(b); //remove bullets
    bb.removeAll(bb); //remove beach balls of death
  }
  void die() { //this plays the death animation when you beat the boss and spawns in the teleporter
    stroke(255);
    strokeWeight(2.5);
    image(kahootImage, x, y, w, h);

    if (w > 0) x += 1;
    if (h > 0) y += 0.5;
    if (w > 0) w -= 2;
    if (h > 0) h -= 1;
    if (w <= 1 && h <= 1) {
      fill(255, 255, 255, trans);
      circle(x, y, radius);
      if (radius < 2000)radius = radius*1.25;
      else trans--;
    }
    if (trans <= 0) {
      if (trans == 0)tp.add(new Teleporter(x, y));

      tp.get(0).run();
    }
  }
  void collisions() {
    for (int i = 0; i < b.size(); i++) {//bullet collisions
      if (b.get(i).x >= x - 3 && b.get(i).x <= x + w -3 && b.get(i).y >= y - 3 && b.get(i).y <= y + h + 3) {
        if (shakeFrame == 0) shakeSetup();
        for (int  j= 0; j < 10; j++) particles.add(new Particle(b.get(i).x, b.get(i).y, 1));
        b.remove(i);
        health -= 1;
      }
    }
    if (m.x + 10 >= x - 3 && m.x - 10<= x + w -3 && m.y + 10 >= y - 3 && m.y - 10<= y + h + 3 && m.frame  != 0) {
      if (shakeFrame == 0)shakeSetup();
      for (int  j= 0; j < 10; j++) particles.add(new Particle(m.x, m.y, 1));
      health -= 4;
    }
    //player collisions
    if (p.x + 20 >= x && p.x - 20 <= x + w && p.y + 20>= y && p.y -20 <= y + h && p.iframe == 0) {
      p.health--;
      p.iframe = 120;
    }
    for (int i = 0; i < fp.size(); i++) {//for the fast projectiles
      if (p.x + 20 >= fp.get(i).pos.x - 7 && p.x - 20 <= fp.get(i).pos.x + 7 && p.y + 20>= fp.get(i).pos.y - 7&& p.y -20 <= fp.get(i).pos.y + 7 && p.iframe == 0) {
        p.health--;
        p.iframe = 120;
        for (int k = 0; k < 10; k++) particles.add(new Particle(fp.get(i).pos.x, fp.get(i).pos.y, 2));
        fp.remove(i);
      }
    }
  }

  void drawBoss() {
    image(kahootImage, x, y);
    //noFill();
    //stroke(0);
    //rect(x,y,w,h);
    //hitbox stuff
  }

  void shoot1() {//shoot projectiles 
    if (timer == 10) {
      vel = new PVector(1, 0);
      vel.normalize();
      vel.mult(8);
      fp.add(new FastProjectile(x + w/2, y + h/2, vel, 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(90)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(-radians(90)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(180)), 1));
    }
    timer --;
  }
  void shoot2() {//shoot beach ball
    if (timer == 10) {
      vel = PVector.random2D();
      bb.add(new Ball(x + w/2, y + h/2, 360, vel));
    }
    timer --;
  }
  void shoot3() {//shoot projectiles 
    if (timer == 10) {
      vel = new PVector(1, 0);
      vel.normalize();
      vel.mult(8);
      fp.add(new FastProjectile(x + w/2, y + h/2, vel, 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(45)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(-radians(45)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(90)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(-radians(90)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(135)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(-radians(135)), 1));
      fp.add(new FastProjectile(x + w/2, y + h/2, vel.copy().rotate(radians(180)), 1));
    }
    timer --;
  }
  void shoot4() {//shoot beach ball at player 
    if (timer == 10) {
      vel = new PVector(p.x - (x+ w/2), p.y - (y+ h/2) );
      vel.normalize();
      bb.add(new Ball(x + w/2, y + w/2, 360, vel));
    }
    timer --;
  }
  void healthBar() {
    colorMode(HSB, 200); //colour changer
    stroke(colour%200, 200, 200);
    strokeWeight(2.5);
    noFill();
    rect(970, 688, 300, 20);
    noStroke();
    fill(colour%200, 200, 200);
    rect(970 - ((health)-300), 688, (health), 20);
    colorMode(RGB, 255);

    fill(0);
    rect(970 + 200, 688, 1, 22);//last phase
  }

  void setUp() {
    noTint();
    easing = 0.04;
  }
}
