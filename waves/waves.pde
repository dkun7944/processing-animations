int n_lines = 2000;
int s = 1000;
float cd_min = 3000;
float cd_max = 6000;

float nX = 0;
float nX2 = 100;
float nS = 0.002;

float seedInc = 0.03;
float curSeed = 0;

float seedInc2 = -0.03;
float curSeed2 = 100;

void setup() {
  size(1000, 1000);
  pixelDensity(2);
  colorMode(HSB);
}

void draw() {
  background(0);
  noFill();
  stroke(255, 255, 255, 32);
  strokeWeight(2);
  curveTightness(0.5);
  
  nX = 0;
  nX2 = 100;
  
  float spacing = (float)s / (float)n_lines;
  float cd_diff = cd_max - cd_min;
  
  float p = 2 * 3.141592 * (float)frameCount / 240;
  float r = 1600;
    
  for (float y = -500; y < 1500; y += spacing) {
    
    float pY = p + (y/80);
    float pY2 = p + 3.141592 + (y/80);
    
    stroke(pRand(128, 255), 255, 255, 48);
    
    curve(-1 * pRand(cd_min, cd_max) + r*sin(pY),
          y + pRand(-1 * cd_diff, cd_diff) + r*cos(pY),
          0,
          y,
          s,
          y,
          s + pRand2(cd_min, cd_max) + r*sin(pY2),
          y + pRand2(-1 * cd_diff, cd_diff) + r*cos(pY2));
  }
  
  if (frameCount < 240) {
    saveFrame("images/f##.png");
  }
}

float pRand(float min, float max) {
  nX += nS;
  return (noise(nX) * (max - min)) + min;
}

float pRand2(float min, float max) {
  nX2 += nS;
  return (noise(nX2) * (max - min)) + min;
}
