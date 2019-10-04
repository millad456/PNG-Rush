  class Star{
    float x = random(-width,width)*1.5, y = random(-height, height)*1.5;
    int dis;//distance
    Star(int dis){
      this.dis = dis;
    }
    
    void run(){
      noStroke();
      fill(255,0,0);
      rect(x+((screen.x-640)/6*dis) + abbx*2,y+((screen.y-360)/6*dis) + abby*2,dis,dis);
      fill(0,0,255);
      rect(x+((screen.x-640)/6*dis),y+((screen.y-360)/6*dis),dis,dis);
      fill(255);
      rect(x+((screen.x-640)/6*dis) + abbx,y+((screen.y-360)/6*dis) + abby,dis,dis);
    }
  }
