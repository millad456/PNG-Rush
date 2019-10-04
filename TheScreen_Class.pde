class theScreen {
  //ArrayList <Integer> timer = new ArrayList();
  float xvel = 2, yvel = 2, w = 120, h = 90, x = 1280/2 - w/2, y = 720/4 - h/2, radius = 1;
  int health = 500, frame, image, timer = 120, action = 1, trans = 450, startTimer = 120;
  PVector vel;//for the bullet being shot
  boolean shield = false;


  void run() {

    if (health > 0 && pause == 0)collisions();
    if (health > 0)drawBoss();
    if (health >= 350 && pause == 0 && startTimer == 0) move();            //phase 1, only follows player
    if (health < 350 && health > 200 && pause == 0) {   //phase 2
      if (timer == 0) {
        action = (int) random(0, 4);      //at the end of every action, it chooses a new one
      }
      if (action == 1) {                  //follow player for 3 seconds
        if (timer == 0)timer = 160;
        move2();
      } else if (action == 2) {           //shoot player for 30 frames
        if (timer == 0)timer = 45;
        shoot1();
      } else if (action == 3) {           //shield and move slowly
        if (timer == 0)timer = 1200;
        shield();
        move3();
      }
    }
    if (health <= 200 && health > 0 && pause == 0) { 
      shield = false;//phase 3              
      if (timer == 0) {
        action = (int) random(0, 3);
      }
      if (action == 1) {                  //moves very little
        if (timer == 0)timer = 120;
        move3();
      } else if (action == 2) {           //bulley hell for 420 frame
        if (timer == 0)timer = 420;
        shoot2();
      } else if (action == 3) {           //shoot player for 30 frames
        timer = 0;
      }
    }
    if (health <= 0) {
      die();
    }

    if (startTimer > 0) startTimer--;
    for (int i = 0; i < fp.size(); i++) fp.get(i).run();
  }

  void reset() { //reset entire game screen
    p.x = 1280/2;
    p.y = 720*3/4;
    p.velx = 0;
    p.vely = 0;
    p.health = 5;
    x = 1280/2 - w/2;
    y = 720/4 - h/2;
    health = 500;
    action = 1; 
    timer = 120;
    fp.removeAll(fp); //reset projectiles
    b.removeAll(b); //remove bullets
    startTimer = 120;
  }

  void die() { //this plays the death animation when you beat the boss and spawns in the teleporter
    stroke(255);
    strokeWeight(2.5);
    rect(x, y, w, h, 3);
    image(sad, x, y + 5,w,h-10);

    if (w > 0) x += 0.5;
    if (h > 0) y += 0.5;
    if (w > 0) w -= 1;
    if (h > 0) h -= 1;
    if (w <= 1 && h <= 1) {
      fill(255, 255, 255, trans);
      circle(x, y, radius);
      if (radius < 2000)radius = radius*1.25;
      else trans--;
    }
    if (trans <= 0) {
      if (trans == 0) {
        tp.add(new Teleporter(x, y));
      }
      tp.get(0).run();
    }
  }
  void shoot1() {
    if (timer % 10 == 0 && timer < 40) {
      vel = new PVector(p.x - (x+60), p.y - (y+ 45) );
      vel.normalize();
      vel.mult(10);
      fp.add(new FastProjectile(x + 60, y + 45, vel, 1));
      fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(radians(15)), 1));
      fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(-radians(15)), 1));
    }
    image(bullet, x + 20, y + 20, w - 40, h - 40);
    timer --;
  }
  void shoot2() {
    if (timer % 35 == 0) {
      vel = new PVector(p.x - (x+60), p.y - (y+ 45) );
      vel.normalize();
      vel.mult(2);
      fp.add(new FastProjectile(x + 60, y + 45, vel, 1));
      for (int i = 1; i < 8; i++) {
        fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(radians(25*i)), 1));
        fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(-radians(25*i)), 1));
      }
    }
    image(skull, x + 20, y + 5, 80, 80);
    timer --;
  }
  void shield() {
    if (timer > 1) {
      shield = true;
      image(whiteShield, x + w/2 - 40, y + 5);
    } else shield = false;
    timer--;
  }

  void move() {
    image(angry, x, y + 5);
    if (x+w/2 < p.x && x + w < 1240) x += xvel;
    if (x+w/2 > p.x && x > 40) x -= xvel;
    if (y+h/2 < p.y && y + h < 640) y += yvel;
    if (y+h/2 > p.y && y > 40) y -= yvel;
    if (health < 350) timer--;
  }
  void move2() {
    image(angry, x, y + 5);
    if (x+w/2 < p.x && x + w < 1240) x += xvel*1.25;
    if (x+w/2 > p.x && x > 40) x -= xvel*1.25;
    if (y+h/2 < p.y && y + h < 640) y += yvel*1.25;
    if (y+h/2 > p.y && y > 40) y -= yvel*1.25;
    timer--;
  }
  void move3() {
    if (!shield) image(angry, x, y + 5);
    if (x+w/2 < p.x && x + w < 1240) x += xvel*2/3;
    if (x+w/2 > p.x && x > 40) x -= xvel*2/3;
    if (y+h/2 < p.y && y + h < 640) y += yvel*2/3;
    if (y+h/2 > p.y && y > 40) y -= yvel*2/3;
    timer--;
  }

  void collisions() {
    for (int i = 0; i < b.size(); i++) {//bullet collisions
      if (b.get(i).x >= x - 3 && b.get(i).x <= x + w -3 && b.get(i).y >= y - 3 && b.get(i).y <= y + h + 3) {
        if (caFrame == 0)abSetup();
        for (int  j= 0; j < 10; j++) particles.add(new Particle(b.get(i).x, b.get(i).y, 1));
        b.remove(i);
        if (shield) health -= 0.1;
        else health -= 1;
      }
    }//melee collisions
    if (m.x + 10 >= x - 3 && m.x - 10<= x + w -3 && m.y + 10 >= y - 3 && m.y - 10<= y + h + 3 && m.frame  != 0) {
      if (caFrame == 0)abSetup();
      for (int  j= 0; j < 10; j++) particles.add(new Particle(m.x, m.y, 1));

      if (shield) health -= 0.4;
      else health -= 4;
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

  void healthBar() {
    stroke(255);
    strokeWeight(2.5);
    noFill();
    rect(770, 688, 500, 20);
    noStroke();
    fill(255);
    rect(770 - (health-500), 688, health, 20);
    fill(0);
    rect(770 + 150, 688, 1, 22);//phase 1
    rect(770 + 300, 688, 1, 22);
  }

  void drawBoss() {
    if (startTimer > 0) {
      textAlign(LEFT);
      textSize(40);
      fill(255);
      if (startTimer < 90) text (" D", x, y+60);
      if (startTimer < 60) text (" D I", x, y+60);
      if (startTimer < 30) text (" D I E", x, y+60);
    }


    noFill();
    strokeWeight(6);

    stroke(255, 0, 0);
    rect(x + abbx*2, y + abby*2, w, h, 3);
    stroke(0, 0, 255);
    rect(x, y, w, h, 3);
    stroke(255);
    rect(x + abbx, y + abby, w, h, 3);
    tint(255);
  }
  void scanlines() {
    noStroke();
    fill(0, 0, 0, 64);
    //for(int i = 3; i < h-6; i += 4) rect(x+3,y+i,w-6,2);
    for (int i = 0; i < 720; i += 4) rect(0, i, 1280, 2);
  }
}
