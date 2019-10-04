class Duolingo {
  Drops d[] = new Drops[300];
  int tick = 0;
  PImage charge;
  PImage blast;
  PImage finalForm;
  float xvel = 2, yvel = 2, w = 150, h = 150, x = 1280/2 - w/2, y = 720/8 - h/2, radius = 1;
  int health = 160, frame, image, phase = 0, timer, timer2 = 60, bulletType, trans = 450, volume = 1;
  float easing = 0.15;//Nick, when do we ever use easing?? why is it here??
  int rX;
  boolean a = true, c = true;
  int [] prevX = new int[1240];
  int [] nodalsX = {(int)random(40, 1240)};
  String [] threat = new String[5]; 
  PVector vel;
  int threatTimer = 300, words = (int)random(5);

  //sorting algorithm, binary and linear searching, how to explain recursion, software dev steps




  void startup() {
    PFont f = createFont("Georgia", 32);   
    textFont(f);
    textSize(32);
    blast = loadImage("burst.png");
    charge = loadImage("charge.png");
    finalForm = loadImage("Final.PNG");
    for (int i = 0; i < 120; i++) {
      prevX[i] = 0;
    }
  }

  void run() {
    if (health > 0) { 
      threat();
      threatTimer--;
    }

    drawBoss();
    if (phase == 0 && health > 0) {
      move1();
      attackOne();
    } else if (phase != 0 && health > 0) {
      attackTwo();
      move2();
    }

    if (pause == 0 && health > 0)collisions();
    healthBar();



    for (int i = 0; i < fp.size(); i++)fp.get(i).run();
    if (a == true) {
      rX = (int) random(40, 1240);
      a = false;
    }

    if (health < 100 && health > 0) {
      if (tick == 0) for (int i = 0; i < 300; i++) d[i] = new Drops();
      for (int i = 0; i < 300; i++) {
        d[i].display();
        if (d[i].y>height) d[i] = new Drops();
      }
      tick++;
      phase++;
    }

    if (health <= 0) {
      die();
    }
  }

  void threat() {//I('m sorry Nick, but I'm using an array. Your method was totally broken and had too manny if statements
    if (threatTimer == 0 && health > 0) {
      words = (int) random(0, 5);
      threatTimer = 300;
    }
    threat[0] = "SPANISH OR VANISH!!";
    threat[1] = "BEG FOR MERCY IN ITALIAN!!";
    threat[2] = "STUDY THE FRENCH, OR YOUR KNEES GET THE WRENCH";
    threat[3] = "";
    threat[4] = "";

    textAlign(CENTER);
    fill(0);//Nick, you can't put yellow yext on a yellow background. I changed it to black
    text(threat[words], 1280/2, 70);
  }



  void collisions() {
    for (int i = 0; i < b.size(); i++) {
      if (b.get(i).x >= x - 3 && b.get(i).x <= x + w -3 && b.get(i).y >= y - 3 && b.get(i).y <= y + h + 3) {
        if (shakeFrame == 0) shakeSetup();
        for (int  j= 0; j < 10; j++) particles.add(new Particle(b.get(i).x, b.get(i).y, 1));
        b.remove(i);
        health --;
      }
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

  void reset() { //reset entire game screen
    p.x = 1280/2;
    p.y = 720*3/4;
    p.velx = 0;
    p.vely = 0;
    p.health = 5;
    x = 1280/2 - w/2;
    y = 720/4 - h/2;
    health = 160; // = 500; btw, the boss health is now 160, not 500
    sunx = 10; // Nick, you forgot to reset the arena too...
    suny = 10;
    Rgb = 135;
    rGb = 206;
    rgB = 255;
    phase = 0; 
    tick = 0;
    noTint();
    timer2 = 60;
    for (int i = 0; i < fp.size(); i++) fp.remove(i); //reset projectiles
    for (int i = 0; i < b.size(); i++) b.remove(i); //remove bullets
  }

  void attackOne() { //first attack
    if (timer2 == 0) { //reset timer to make decisions
      timer = (int) random(1, 11);
      timer2 = 60;
      c = true;
    }
    if (timer % 2 == 0 && timer2 == 30) { //shooting 
      c = false; 
      bulletType = (int) random (0, 3);
      vel = new PVector(0, 1);
      vel.normalize();
      vel.mult(8);
      fp.add(new FastProjectile(x + 60, y + 45, vel, 2));
      fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(radians(15)), 2));
      fp.add(new FastProjectile(x + 60, y + 45, vel.copy().rotate(-radians(15)), 2));
    }
    timer2--;// Nick, I still don't understand why there are multiple timers
  }

  void attackTwo() { //second attack
    if (timer2 == 0) { //reset timer to make decisions
      timer = (int) random(1, 11);
      timer2 = 60;
    }
    if (timer % 2 == 0 && timer2 <= 40) { //shooting 
      bulletType = (int) random (0, 3);
      vel = new PVector(0, 1);
      vel.normalize();
      vel.mult(13);
      fp.add(new FastProjectile(duo.x + 60, duo.y + 45, vel, 4));
    }
    timer2--;
  }

  void die() { //this plays the death animation when you beat the boss and spawns in the teleporter
    noTint();
    //Megalovania.amp(volume);
    if(volume > 0 )volume -= 0.01;
    image(finalForm, x, y+40, w, h);
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

      if (trans == 0){
        tp.add(new Teleporter(x, 580));//Nick, you're actually a dumbass. You were spawning a new teleporter every frame. You're only supposed to spawn one
        //Megalovania.stop();
      }
      tp.get(0).run();// do you have any idea how long I spent trying to fix this? I thought it was a teleporter issue. turns out I was trying to enter 200+ teleporters at the end of every fight
    }
  }

  void healthBar() {
    stroke(74, 150, 0);
    strokeWeight(2.5);
    noFill();
    rect(770 + 340, 688, 160, 20);
    noStroke();
    fill(74, 150, 0);
    rect(770 + 340 - (health-160), 688, health, 20);
  }

  void drawBoss() {
    if (health > 99) noTint();
    else tint(255, 0, 0);
    if (c == true && phase == 0) {
      image(charge, x, y+40, w, h);
    } else if (c == false && phase == 0) {
      image(blast, x, y+40, w, h);
    } else if (phase != 0 && health > 0) {
      image(finalForm, x, y+40, w, h);
    }
  }

  void move1() {
    for (int i = 0; i < 1200; i++) {
      if (i == 0) prevX[i] = (int)x;
      else {
        prevX[i] = prevX[i-1];
      }
    }

    if (x != (int) rX) {
      if (abs(x-rX) < 50) {
        float targetX = rX;
        float dx = targetX - x;
        x += dx * easing;
      } else {
        if (rX > x) x += 5;
        if (rX < x) x -= 5;
      }

      if ( x > (int) rX - 1 && x < (int) rX + 1 ) a = true;
    }
  }

  void move2() {
    if (x+w/2 < p.x && x + w < 1240) x += p.max-0.1;
    if (x+w/2 > p.x && x > 40) x -= p.max-0.1;
  }


  class Drops {// lmao, bird droppings
    float x, y, speed;
    Drops() {
      x = random (width);
      y = random (-300, 0);
      speed = random (5, 10);
    } 

    void update() {
      y+=speed;
    }

    void display() { 
      fill(161, 198, 204);
      noStroke();
      rect(x, y, 2, 15);
      update();
    }
  }
}
