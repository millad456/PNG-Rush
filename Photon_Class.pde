class Photon{
float x,y;
  Photon(float x, float y){
    this.x = x;
    this.y = y;
  }
  void run(){
    noStroke();
    fill(255, 0, 0, 10);
    for(int j = 30; j > 0; j = j/2) circle(x, y, j);
  }
}
