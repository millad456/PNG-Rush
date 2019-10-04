import processing.sound.*;
Player p = new Player();
Melee m = new Melee();
LevelEditor  le = new LevelEditor();
Star[] stars = new Star[3000];
PFont f;

//bosses
theScreen screen = new theScreen();
Kahoot k = new Kahoot();
Duolingo duo = new Duolingo();

ArrayList <Wall> wall = new ArrayList();
ArrayList <Player> p2 = new ArrayList();
ArrayList <BreakableWall> brWall = new ArrayList();
ArrayList <Bullet> b = new ArrayList();
ArrayList <Particle> particles = new ArrayList();
ArrayList <Teleporter> tp = new ArrayList();
ArrayList <FastProjectile> fp = new ArrayList();
ArrayList <Photon> ph = new ArrayList();
ArrayList <Ball> bb = new ArrayList();

PImage heart;
PImage Title;
PImage beachball;
PImage kahootImage;
PImage bullet;
PImage whiteShield;
PImage skull;
PImage angry;
PImage sad;
/*
SoundFile KahootWaiting;
SoundFile KahootIntense;
SoundFile AxiomVergeTheme;
SoundFile Megalovania;
*///scrapped audio implementation

int []  lineX = new int [16];
int gameState = -1, pause = 0, photonx, photony; //0 is main menu, 1 is gameplay, 2 is scripted sequence, 3 is tutorial, 4 is game over, 5 is win
boolean up, down, left, right, W, A, S, D, P, shift, space, setupLevel = true; //these are for multiple keyboard inputs
int caFrame = 0, abbx, abby, signx, signy, shakeFrame = 0, tutorialTimer1 = 0;//screen shake related int variables
int Rgb = 135, rGb = 206, rgB = 255, sunx = 10, suny = 10;
float colour;
PVector dir;


void setup() {
  size(1280, 720);
  f = createFont("Arial", 80, true);
  textFont(f, 28);
  dir = PVector.random2D();

  //setup Images
  heart = loadImage("heart.png");
  Title = loadImage("KahootTitle2.PNG");
  beachball = loadImage("beachBallTransparent.png");
  kahootImage = loadImage("4ShapesCompressed.png");
  bullet = loadImage("bullet.png");
  whiteShield = loadImage("whiteShield.png");
  skull = loadImage("skull.png");
  angry = loadImage ("angry face clipart.png");
  sad = loadImage ("sad face clipart.png");
/*
  KahootIntense = new SoundFile(this, "Kahoot! 20 Second Countdown.mp3");
  KahootWaiting = new SoundFile(this, "Kahoot Lobby Music.mp3");
  Megalovania = new SoundFile(this, "Undertale- Megalovania.mp3");
  AxiomVergeTheme = new SoundFile(this, "Trace Rising.mp3");
  *///scrapped audio implementation
}



//main method
void draw() {
  println(p2.size());
  if (gameState == -1) menuSetup();
  else if (gameState == 0) menu();
  ////////////////////////////////Tutorials////////////////////////////////
  else if (gameState == 1) {//gamestate 1 runs the intro sequence and created the level
    le.run();
    gameState = 2;
  } else if (gameState == 2) {                                          //Tutorial 1
    background(255);
    if (shakeFrame >= 0) shake();
    drawGrid();
    drawWalls();
    tutorial1();
    p.run();
    for (Bullet currentBullet : b) currentBullet.run();
    blockCollisions();
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).run();
      if (particles.get(i).frame == 0) particles.remove(i);
    }
    drawHud();
  } else if (gameState == 3) {//tutorial number 2 setup
    le.run();
    gameState = 4;
  } else if (gameState == 4) {//tutorial 2
    background(255);
    if (shakeFrame >= 0) shake();
    drawGrid();
    drawWalls();
    tutorial2();
    p.run();
    for (Bullet currentBullet : b) currentBullet.run();
    blockCollisions();
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).run();
      if (particles.get(i).frame == 0) particles.remove(i);
    }
    drawHud();
  } 
  ////////////////////////////////kahoot fight////////////////////////////////
  else if (gameState == 5) {//gamestate 1 runs the intro sequence and created the level
    tp.removeAll(tp);
    le.run();
    k.setUp();
    gameState++;
  } else if (gameState == 6) {
    colorMode(HSB, 200); //background colour changer
    background(colour%200, 200, 200);
    colorMode(RGB, 255);
    colour += 0.1;
    if (shakeFrame > 0) shake();
    drawWalls();
    k.run();
    p.run();
    for (Ball currentBall : bb) currentBall.run();
    for (Bullet currentBullet : b) currentBullet.run();
    blockCollisions();
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).run();
      if (particles.get(i).frame == 0) particles.remove(i);
    }
    drawHud();
    k.healthBar();
    if (p.health <= 0 && p.iframe == 0) {
      k.reset();
    }
  }////////////////////////////////duolingo owl fight////////////////////////////////
  else if (gameState == 7) {//gamestate 4 runs the intro sequence and creates the level
    tp.removeAll(tp);
    le.run();
    duo.startup();
    gameState++;
  } else if (gameState == 8) {
    background(255);
    if (shakeFrame > 0) shake();
    fill (Rgb, rGb, rgB);
    rect(0, 0, 1280, 480);
    fill(74, 150, 0);
    rect(0, 480, 1280, 240);
    fill(255, 255, 0);
    if (duo.health < 100) {
      sunx --;
      suny --;
      circle(sunx, suny, 500);
    } else circle(sunx, suny, 500);
    drawWalls();
    duo.run();
    p.run();
    for (Bullet currentBullet : b) currentBullet.run();
    blockCollisions();
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).run();
      if (particles.get(i).frame == 0) particles.remove(i);
      if (duo.health < 100 && Rgb != 87 && rGb != 114 && rgB != 143) {
        Rgb--;
        rGb--;
        rgB--;
      }
    }

    drawHud();
    duo.healthBar();
    if (p.health <= 0 && p.iframe == 0) {
      duo.reset();
    }
  }
  ////////////////////////////////the screen fight////////////////////////////////
  else if (gameState == 9) {//gamestate 5 runs the intro sequence and creates the level
    tp.removeAll(tp);
    le.run();
    for (int i = 0; i < stars.length; i++) stars[i] = new Star((int)random(1, 4));
    gameState++;
  } else if (gameState == 10) {//the screen boss fight
    background(63);
    for (int i = 0; i < stars.length; i++) stars[i].run();
    if (caFrame > 0) aberrate();
    drawWalls();
    screen.run();
    if (screen.startTimer  == 0)p.run();
    else p.drawPlayer();
    for (Bullet currentBullet : b) currentBullet.run();
    blockCollisions();
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).run();
      if (particles.get(i).frame == 0) particles.remove(i);
    }
    screen.scanlines();
    drawHud();
    screen.healthBar();
    if (p.health <= 0 && p.iframe == 0) {
      screen.reset();
    }
  }
  pauseGame();
}
//main method     

void pauseGame() {
  //pause button
  if (P && pause != 100) {
    pause = 100;
    P = false;
  } else if (P && pause == 100) {
    pause = 0;
    P = false;
  }
  if (pause > 0 && pause != 100) pause--;
}

void menuSetup() {
  for (int i = 0; i < 8; i ++) {
    for (int j = 0; j < 13; j++) {
      p2.add(new Player(j*1280/8, i*720/8));
    }
  }
  gameState++;
}

void menu() {                //main menu method. put everything main menu related here
  background(255);
  for (int i = 0; i < p2.size(); i++) {
    p2.get(i).run();
    if (p2.get(i).x > 1280) p2.get(i).x = 0;
    if (p2.get(i).x < 0) p2.get(i).x = 1280;
    if (p2.get(i).y > 720) p2.get(i).y = 0;
    if (p2.get(i).y < 0) p2.get(i).y = 720;
  }
  strokeWeight(4);
  stroke(20);
  textAlign(CENTER);
  textSize(100);

  //title text x3 for the chromatic aberration
  fill(0);
  text("PNG RUSH", 640, 360);

  //borders on the start button
  fill(255);
  stroke(0);
  rect(440, 490, 400, 100);

  for (int i = 0; i < lineX.length; i++) {
    line((i*25 + lineX[i]) % 400 + 440, 500, (i*25 + lineX[i]) % 400 + 440, 510);
    line(840  - (i*25 + lineX[i]) % 400, 570, 840 - (i*25 + lineX[i]) % 400, 580);
  }
  if (mouseX >= 440 && mouseX <= 840 && mouseY >= 490 && mouseY <= 590) {
    for (int i = 0; i < lineX.length; i++)lineX[i] += 3;
    if (mousePressed)gameState = 1;
  } else for (int i = 0; i < lineX.length; i++)lineX[i] += 1;


  //start text
  fill(0);
  textSize(64);
  text("Start", 640, 560);
}

//drawHud
void drawHud() {
  noStroke();
  fill(0);
  rect(-10, 680, 1290, 50); 
  for (int i = 1; i <= p.health; i++) {
    image(heart, (i* 25) -20, 690, 20, 20);
  }
  //draw both bars
  fill(255, 247, 0);
  rect(130, 688, 120, 10);
  fill(0, 205, 255);
  rect(130, 700, 120, 10);
  fill(0);
  rect(130 + (120 - p.dashCooldown*2), 688, p.dashCooldown*2, 10);
  rect(130 + (120 - p.meleeCooldown*2), 700, p.meleeCooldown*2, 10);
}



//walls method
void drawWalls() {
  for (int i = 0; i < wall.size(); i++) wall.get(i).run();
  for (int i = 0; i < brWall.size(); i++) brWall.get(i).run();
  for (int i = 0; i < tp.size(); i++) tp.get(i).run();
}


//Input methods
void keyPressed() {
  if (key == 'w' || key == 'W') W = true;
  if (key == 'a' || key == 'A') A = true;
  if (key == 's' || key == 'S') S = true;
  if (key == 'd' || key == 'D') D = true;
  if (key == 'p' || key == 'P') P = true;
  if (key == ' ') space = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (keyCode == SHIFT) shift = true;
}
void keyReleased() {
  if (key == 'w' || key == 'W') W = false;
  if (key == 'a' || key == 'A') A = false;
  if (key == 's' || key == 'S') S = false;
  if (key == 'd' || key == 'D') D = false;
  if (key == 'p' || key == 'P') P = false;
  if (key == ' ') space = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
  if (keyCode == SHIFT) {
    shift = false;
    if (p.dashCooldown == 0)p.dash();
  }
}

void blockCollisions() {
  //breakable wall collisions
  for (int i = 0; i < brWall.size(); i++) {
    for (int j = 0; j < b.size(); j++) {//bullet collision
      if (brWall.get(i).health >= 0 && b.get(j).x >= brWall.get(i).x && b.get(j).x <= brWall.get(i).x + brWall.get(i).size && b.get(j).y >= brWall.get(i).y && b.get(j).y <= brWall.get(i).y + brWall.get(i).size) {
        brWall.get(i).health--;
        for (int k = 0; k < 10; k++) particles.add(new Particle(b.get(j).x, b.get(j).y, 1));
        b.remove(j);
      }
    }//br wall and melee
    if (brWall.get(i).health >= 0 && m.x + 10>= brWall.get(i).x && m.x - 10 <= brWall.get(i).x + brWall.get(i).size && m.y + 10 >= brWall.get(i).y && m.y - 10 <= brWall.get(i).y + brWall.get(i).size) {
      brWall.get(i).health--;
      pause = 3;
      for (int k = 0; k < 10; k++) particles.add(new Particle(m.x, m.y, 1));
    }
    for (int j = 0; j < fp.size(); j++) {//br wall and projectile
      if (brWall.get(i).x + brWall.get(i).size >= fp.get(j).pos.x && brWall.get(i).x <= fp.get(j).pos.x && brWall.get(i).y + brWall.get(i).size >= fp.get(j).pos.y && brWall.get(i).y <= fp.get(j).pos.y) {
        for (int k = 0; k < 4; k++) particles.add(new Particle(fp.get(j).pos.x, fp.get(j).pos.y, 2));
        fp.remove(j);
      }
    }
    if (brWall.get(i).health == 0) {
      for (int k = 0; k < 30; k++) particles.add(new Particle(brWall.get(i).x + brWall.get(i).size/2, brWall.get(i).y + brWall.get(i).size/2, 3));
      brWall.remove(i);
    }
  }
  //normal wall collisions
  for (int i = 0; i < wall.size(); i++) {
    for (int j = 0; j < b.size(); j++) {//bullets
      if (b.get(j).x >= wall.get(i).x && b.get(j).x <= wall.get(i).x + wall.get(i).size && b.get(j).y >= wall.get(i).y && b.get(j).y <= wall.get(i).y + wall.get(i).size && wall.get(i).image != 7) {
        for (int k = 0; k < 10; k++) particles.add(new Particle(b.get(j).x, b.get(j).y, 1));
        b.remove(j);
      }
    }
    for (int j = 0; j < fp.size(); j++) {
      if (wall.get(i).x + wall.get(i).size >= fp.get(j).pos.x && wall.get(i).x <= fp.get(j).pos.x && wall.get(i).y + wall.get(i).size >= fp.get(j).pos.y && wall.get(i).y <= fp.get(j).pos.y && wall.get(i).image !=7) {
        for (int k = 0; k < 4; k++) particles.add(new Particle(fp.get(j).pos.x, fp.get(j).pos.y, 2));
        fp.remove(j);
      }
    }
  }
  //beach ball remover
  for (int i = 0; i < bb.size(); i++) if (bb.get(i).timer < 0) {
    for (int k = 0; k < 50; k++) particles.add(new Particle(bb.get(i).pos.x, bb.get(i).pos.y, 4));
    bb.remove(i);
  }
}


void abSetup() {                 //sets up the chromatic aberration method
  if ((int)random(2) == 1)signx = 1;
  else signx = -1;
  if ((int)random(2) == 1)signy = 1;
  else signy = -1;
  caFrame = 4;
}
//instead of screenshake, chromatic aberration for the screen boss
void aberrate() {
  if (caFrame == 4) abbx += 3*signx;
  else if (caFrame == 3) abby += 3*signx;
  else if (caFrame == 2) abbx -= 3*signx;
  else if (caFrame == 1) abby -= 3*signx;
  if (caFrame != 0) caFrame--;
}

void shakeSetup() {                 //sets up the shake method
  if ((int)random(2) == 1)signx = 1;
  else signx = -1;
  if ((int)random(2) == 1)signy = 1;
  else signy = -1;
  shakeFrame = 4;
}

void shake() {
  if (shakeFrame == 4) abbx += 3*signx;
  else if (shakeFrame == 3) abby += 3*signx;
  else if (shakeFrame == 2) abbx -= 3*signx;
  else if (shakeFrame == 1) abby -= 3*signx;
  if (shakeFrame != 0) shakeFrame--;
  translate(abbx, abby);
}

//Delete later. This grid is just for reference
void drawGrid() {
  noFill();
  stroke(1);
  strokeWeight(1);
  int w = 40;
  for (int i = 0; i < 1280/w; i++) {
    for (int j = 0; j < 720/w; j++) {
      rect(i*w, j*w, w, w);
    }
  }
}

void tutorial1() {
  //tutorial messages
  textSize(28);
  fill(0);
  if (p.x > 440 && p.x < 800 && p.y > 280)text("Use WASD to move ", 500, 350);
  if (p.x > 300 && p.x < 700 && p.y < 280 )text("Use SHIFT to blink forward ", 500, 110);
}

void tutorial2() {
  //tutorial messages
  textSize(28);
  textAlign(LEFT);
  fill(0);
  if (p.x > 420 && p.x < 800 && p.y > 360)text("Use the Arrow Keys to shoot ", 420, 430);
  if (p.x < 800 && p.x > 280 && p.y < 360)text("You can teleport past projectiles ", 360, 350);
  if (p.x < 280 && p.y < 360)text("Press P to pause at any time ", 360, 350);
  if (p.x > 800 && p.y > 360)text("Use SPACE to melee/parry ", 890, 630);

  //projectile launcher
  fill(0, 0, 255);
  rect(980, 60, 40, 40);
  fill(0);
  rect(996, 76, 8, 40);
  rect(990, 114, 20, 8);
  if (tutorialTimer1 % 60 == 0)fp.add(new FastProjectile(1000, 120, new PVector(0, 8), 3));

  //projectile wave
  if (tutorialTimer1 % 100 == 0) {
    for (int i = 40; i < 400; i += 20) {
      fp.add(new FastProjectile(800, i, new PVector(-8, 0), 3));
    }
  }

  if (p.health == 0) {//reset method
    p.x = 1280/2;
    p.y = 720*3/4;
    p.velx = 0;
    p.vely = 0;
    p.health = 5;
    tutorialTimer1 = 0;
    fp.removeAll(fp); //reset projectiles
    b.removeAll(b); //remove bullets
  }

  //all the projectile stuff
  for (int i = 0; i < fp.size(); i++) {//for the fast projectiles
    if (p.x + 20 >= fp.get(i).pos.x - 7 && p.x - 20 <= fp.get(i).pos.x + 7 && p.y + 20>= fp.get(i).pos.y - 7&& p.y -20 <= fp.get(i).pos.y + 7 && p.iframe == 0) {
      p.health--;
      p.iframe = 120;
      for (int k = 0; k < 10; k++) particles.add(new Particle(fp.get(i).pos.x, fp.get(i).pos.y, 2));
      fp.remove(i);
    }
  }
  for (int i = 0; i < fp.size(); i++)fp.get(i).run();
  tutorialTimer1++;
}

void lazer() {
  //lazer thing

  pushMatrix();
  translate(700, 50);
  dir.rotate(radians(1));
  popMatrix();
  dir.normalize();
  for (int i = 0; i < 100; i++) {
    ph.add(new Photon(photonx, photony));
    photony += dir.y;
    photonx += dir.x;
  }
  for (int i = 0; i < ph.size(); i++) { 
    ph.get(i).run();
  }
  ph.removeAll(ph);

  photonx = 700;
  photony = 50;
}
