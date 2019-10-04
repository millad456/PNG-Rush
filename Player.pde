class Player {
  float x = 1280/2, y = 720*3/4, angle, velx, vely, acc = 0.8, max = 5, fr = 1, tipx, tipy, dashDistance = 250, shrink = 0.95, maxShrink = 0.8;
  int health = 5, frame = 0, dir, dashCooldown, dashCooldownMax = 60, meleeFrame = 80, meleeCooldown, iframe = 0;
  boolean canShoot = true;
  Player(float x, float y){
    this.x = x;
    this.y = y;
  }
  Player(){
  
  }


  void run() {
    if (m.frame == 0 && pause == 0) {
      checkAngle();
      if (health > 0)move();
      shoot();
    }
    drawPlayer();
    if (pause == 0) {
      if (space && m.frame == 0 && meleeCooldown == 0) { //starts melee
        space = false;
        m.meleeSetup();
        meleeCooldown = 60;
      }
      if (m.frame > 0) m.run(); //run melee
      if (dashCooldown > 0) dashCooldown--;
      if (meleeCooldown > 0) meleeCooldown--;
      if (iframe > 0) iframe--;
    }
  }
  //the can move methods. add any new collidable objects to here
  boolean canMoveUp() {
    for (int i = 0; i < wall.size(); i++) {
      if (x >= wall.get(i).x && x <= wall.get(i).x + wall.get(i).size && y <= wall.get(i).y + 50 && y >= wall.get(i).y) {
        vely = 0;
        return false;
      }
    }
    for (int i = 0; i < brWall.size(); i++) {
      if (x >= brWall.get(i).x && x <= brWall.get(i).x + brWall.get(i).size && y <= brWall.get(i).y + 50 && y >= brWall.get(i).y && brWall.get(i).health >= 0) {
        vely = 0;
        return false;
      }
    }
    return true;
  }
  boolean canMoveDown() {
    for (int i = 0; i < wall.size(); i++) {
      if (x >= wall.get(i).x && x <= wall.get(i).x + wall.get(i).size && y >= wall.get(i).y - 10 && y <= wall.get(i).y) {
        vely = 0;
        return false;
      }
    }
    for (int i = 0; i < brWall.size(); i++) {
      if (x >= brWall.get(i).x && x <= brWall.get(i).x + brWall.get(i).size && y >= brWall.get(i).y - 10 && y <= brWall.get(i).y && brWall.get(i).health >= 0) {
        vely = 0;
        return false;
      }
    }
    return true;
  }
  boolean canMoveLeft() {
    for (int i = 0; i < wall.size(); i++) {
      if (y >= wall.get(i).y && y <= wall.get(i).y + wall.get(i).size && x <= wall.get(i).x + 50 && x > wall.get(i).x) {
        velx = 0;
        return false;
      }
    }
    for (int i = 0; i < brWall.size(); i++) {
      if (y >= brWall.get(i).y && y <= brWall.get(i).y + brWall.get(i).size && x <= brWall.get(i).x + 50 && x > brWall.get(i).x && brWall.get(i).health >= 0) {
        velx = 0;
        return false;
      }
    }
    return true;
  }
  boolean canMoveRight() {
    for (int i = 0; i < wall.size(); i++) {
      if (y >= wall.get(i).y && y <= wall.get(i).y + wall.get(i).size && x >= wall.get(i).x - 10 && x < wall.get(i).x) {
        velx = 0;
        return false;
      }
    }
    for (int i = 0; i < brWall.size(); i++) {
      if (y >= brWall.get(i).y && y <= brWall.get(i).y + brWall.get(i).size && x >= brWall.get(i).x - 10 && x < brWall.get(i).x && brWall.get(i).health >= 0) {
        velx = 0;
        return false;
      }
    }
    return true;
  }

  //Shooting inputs
  void shoot() {
    if ((up || down || left || right) && frame == 0 && !shift) {
      b.add(new Bullet(x, y, angle));
      frame++;
    }
  }
  //dashing method
  void dash() {
    dashCooldown = 60;
    shift = false;
    for (int i = 0; i<= dashDistance; i++) {//check block collision only in for loop
      if (dir == 0) {
        if (canMoveUp()) y -= 1;
      } else if (dir == 1) {
        if (canMoveUp()) y -= 0.707;
        if (canMoveRight()) x += 0.707;
      } else if (dir == 2) {
        if (canMoveRight()) x += 1;
      } else if (dir == 3) {
        if (canMoveDown()) y += 0.707;
        if (canMoveRight()) x += 0.707;
      } else if (dir == 4) {
        if (canMoveDown()) y += 1;
      } else if (dir == 5) {
        if (canMoveDown()) y += 0.707;
        if (canMoveLeft()) x -= 0.707;
      } else if (dir == 6) {
        if (canMoveLeft()) x -= 1;
      } else if (dir == 7) {
        if (canMoveUp())y -= 0.707;
        if (canMoveLeft()) x -= 0.707;
      }
    }
  }
  //Movement calculations
  void move() {

    if ((!shift && dashCooldown != 0) || !shift) { // only moves when shift isn't held
      //movement
      if (W && vely >= -max && canMoveUp()) vely -= acc;
      if (D && velx <= max && canMoveRight()) velx += acc;
      if (S && vely <= max && canMoveDown()) vely += acc;
      if (A && velx >= -max && canMoveLeft()) velx -= acc;

      if (!W && !A && !S && !D ) { //calculate friction
        if (velx > fr) velx -= fr;
        if (velx < -fr) velx += fr;
        if (velx <= fr && velx >= -fr) velx = 0;
        if (vely > fr) vely -= fr;
        if (vely < -fr) vely += fr;
        if (vely <= fr && vely >= -fr) vely = 0;
      }
      //add up velocities
      if (velx < 0 && canMoveLeft())x += velx;
      else if (velx > 0 && canMoveRight())x += velx;


      if (vely < 0 && canMoveUp()) {
        y += vely;
      } else if (vely > 0 && canMoveDown()) {
        y += vely;
      }
    }
    
    
  }                                      

  //Looking calculations
  void checkAngle() {
    if (up || down || left || right) {  //if you are shooting in a direction, look there
      if (up && right) angle = PI/4;
      else if (down && right) angle = 3*PI/4;
      else if (down && left) angle = 5*PI/4;
      else if (up && left) angle = 7*PI/4;
      else if (up) angle = 0;
      else if (right) angle = PI/2;
      else if (down) angle = PI;
      else if (left) angle = 3*PI/2;
    } else {                            //if not, just look where you're moving
      if (W && D) angle = PI/4;
      else if (S && D) angle = 3*PI/4;
      else if (S && A) angle = 5*PI/4;
      else if (W && A) angle = 7*PI/4;
      else if (W) angle = 0;
      else if (D) angle = PI/2;
      else if (S) angle = PI;
      else if (A) angle = 3*PI/2;
    }
    dir = (int) (angle/(PI/4));         //converts angle into one of 8 directions
  }



  //draw Player Method
  void drawPlayer() {

    if ((iframe % 16 >= 0 && iframe % 16 <= 8 && iframe > 0)|| iframe == 0) {
      strokeWeight(1);
      if (shift && dashCooldown == 0) { 
        //this draws the transparent player during the dash control
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        noFill();
        quad(-40, 4 - dashDistance, -18, -20 - dashDistance, -28, 4 - dashDistance, -18, 28 - dashDistance);  // left part
        quad(40, 4 - dashDistance, 18, -20 - dashDistance, 28, 4 - dashDistance, 18, 28 - dashDistance);  // right part
        triangle(-12, 16 - dashDistance, 12, 16 - dashDistance, 0, -20 - dashDistance); //triangle
        //original player
        scale(shrink);
        if (shrink >= maxShrink) shrink -= 0.02;
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        if (m.frame != 0) fill(255, 0, 0); //changed colours based on melee frame
        else fill(0, 255, 0);
        triangle(-12, 16, 12, 16, 0, -20); //triangle
        popMatrix();
      } else if (frame == 0) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        if (m.frame != 0) fill(255, 0, 0); //changed colours based on melee frame
        else fill(0, 255, 0);
        triangle(-12, 16, 12, 16, 0, -20); //triangle
        popMatrix();
        shrink = 0.95;
        ;
      } else if (frame >= 1 && frame <=4) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(255, 255, 0);
        triangle(-12, 28, 12, 28, 0, -8); //triangle

        popMatrix();
        frame++;
      } else if (frame == 5) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(255, 255, 0);
        triangle(-12, 24, 12, 24, 0, -12); //triangle
        popMatrix();
        frame++;
      } else if (frame == 6) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(255, 255, 0);
        triangle(-12, 22, 12, 22, 0, -14); //triangle
        popMatrix();
        frame++;
      } else if (frame == 7) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(255, 255, 0);
        triangle(-12, 20, 12, 20, 0, -16); //triangle
        popMatrix();
        frame++;
      } else if (frame == 8) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(255, 255, 0);
        triangle(-12, 18, 12, 18, 0, -18); //triangle
        popMatrix();
        frame++;
      } else if (frame == 9) {
        pushMatrix();
        translate(x, y);
        rotate(angle);
        stroke(0);
        fill(0, 0, 0);
        quad(-40, 4, -18, -20, -28, 4, -18, 28);  // left part
        quad(40, 4, 18, -20, 28, 4, 18, 28);  // right part
        fill(0, 255, 0);
        triangle(-12, 16, 12, 16, 0, -24); //triangle
        popMatrix();
        frame = 0;
      }
    }

    //fill(0);
    //circle(x,y,10);
  }
}
