class Melee {
  int frame = 0, maxFrame = 10; 
  float r, r1, x, y, easing = 0.5;

  float [] prevX = new float [maxFrame];
  float [] prevY = new float [maxFrame];

  //runs once when the method is called
  void meleeSetup() {

    frame = maxFrame;
  }

  //this is always running 
  void run() {
    if (frame == maxFrame) {//resets all things to starting position
      if (p.dir == 0) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x - 40;
          prevY[i] = p.y - 40;
        }
      }
      if (p.dir == 1) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x - 40;
          prevY[i] = p.y - sqrt(3200);
        }
      }
      if (p.dir == 2) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x + 40;
          prevY[i] = p.y - 40;
        }
      }
      if (p.dir == 3) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x + sqrt(3200);
          prevY[i] = p.y;
        }
      }
      if (p.dir == 4) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x + 40;
          prevY[i] = p.y + 40;
        }
      }
      if (p.dir == 5) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x;
          prevY[i] = p.y + sqrt(3200);
        }
      }
      if (p.dir == 6) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x - 40;
          prevY[i] = p.y + 40;
        }
      }
      if (p.dir == 7) {
        for (int i = prevX.length - 1; i >= 0; i--) {
          prevX[i] = p.x + sqrt(3200);
          prevY[i] = p.y;
        }
      }
    }
    if(pause == 0)swipe();
    drawSwipe();
    parry();
    if (frame > 0) frame--;
  }
  
  void parry(){ // parry fast projectiles
    for (int i = 0; i < fp.size(); i++){
      if(abs(sqrt(sq(fp.get(i).pos.x - x) + sq(fp.get(i).pos.y-y))) <= 25){
        for (int k = 0; k < 10; k++) particles.add(new Particle(fp.get(i).pos.x, fp.get(i).pos.y,1));
        fp.remove(i);
        pause = 10;
      }
    }
  }

  //controls the position of the swipe
  void swipe() {
    if (p.dir == 0) {
      if (frame == maxFrame) {
        x = p.x - 40;
        y = p.y - 40;
      } else if (frame > 0) {
        float targetX = p.x + 40;
        float dx = targetX - x;
        x += dx * easing;
      }
    }
    if (p.dir == 1) {
      if (frame == maxFrame) {
        x = p.x;
        y = p.y - sqrt(3200);
      } else if (frame > 0) {
        float targetX = p.x + sqrt(3200);
        float dx = targetX - x;
        x += dx * easing;

        float targetY = p.y;
        float dy = targetY - y;
        y += dy * easing;
      }
    }
    if (p.dir == 2) {
      if (frame == maxFrame) {
        x = p.x + 40;
        y = p.y - 40;
      } else if (frame > 0) {
        float targetY = p.y + 40;
        float dy = targetY - y;
        y += dy * easing;
      }
    }
    if (p.dir == 3) {
      if (frame == maxFrame) {
        x = p.x + sqrt(3200);
        y = p.y;
      } else if (frame > 0) {
        float targetX = p.x;
        float dx = targetX - x;
        x += dx * easing;

        float targetY = p.y + sqrt(3200);
        float dy = targetY - y;
        y += dy * easing;
      }
    }
    if (p.dir == 4) {
      if (frame == maxFrame) {
        x = p.x + 40;
        y = p.y + 40;
      } else if (frame > 0) {

        float targetX = p.x - 40;
        float dx = targetX - x;
        x += dx * easing;
      }
    }
    if (p.dir == 5) {
      if (frame == maxFrame) {
        x = p.x;
        y = p.y + sqrt(3200);
      } else if (frame > 0) {
        float targetX = p.x - sqrt(3200);
        float dx = targetX - x;
        x += dx * easing;

        float targetY = p.y;
        float dy = targetY - y;
        y += dy * easing;
      }
    }
    if (p.dir == 6) {
      if (frame == maxFrame) {
        x = p.x - 40;
        y = p.y + 40;
      } else if (frame > 0) {

        float targetY = p.y - 40;
        float dy = targetY - y;
        y += dy * easing;
      }
    }
    if (p.dir == 7) {
      if (frame == maxFrame) {
        x = p.x - sqrt(3200);
        y = p.y;
      } else if (frame > 0) {
        float targetX = p.x;
        float dx = targetX - x;
        x += dx * easing;

        float targetY = p.y - sqrt(3200);
        float dy = targetY - y;
        y += dy * easing;
      }
    }
  }


  //draws swipe animation
  void drawSwipe() {
    noStroke();
    fill(255, 0, 0, 255);
    //draws the trai'
    for (int i = prevX.length - 1; i >= 0; i--) if (i != prevX.length - 1  && (p.dir == 0 || p.dir == 4)) {
      fill(255, 0, 0, 255/(i+1));
      quad(prevX[i], prevY[i] + (frame), prevX[i], prevY[i] - frame, prevX[i + 1], prevY[i + 1] - (frame), prevX[i + 1], prevY[i + 1] + (frame));
    } else if (i != prevX.length - 1  && p.dir != 0 && p.dir != 4) {
      fill(255, 0, 0, 255/(i+1));
      quad(prevX[i] + (frame), prevY[i], prevX[i] - frame, prevY[i], prevX[i + 1] - (frame), prevY[i + 1], prevX[i + 1] + (frame), prevY[i + 1]);
    }
    circle(x, y, 10);
    for (int i = prevX.length - 1; i >= 0; i--) {
      if (i == 0) {
        prevX[i] = x;
        prevY[i] = y;
      } else {
        prevX[i] = prevX[i-1];
        prevY[i] = prevY[i-1];
      }
    }
  }
}
