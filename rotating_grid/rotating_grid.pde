int grid = 10;
float[] d;
float t = 0;

int tR = 8;
int cR = 0;

int numFrames = 800;
int samplesPerFrame = 16;  // more is better but slower. 32 is enough probably
float shutterAngle = 4;
int[][] result;

void setup() {
  size(1000,1000);
  result = new int[width*height][3];
  d = new float[4];
  blendMode(ADD);
}

void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;

  for (int sa=0; sa<samplesPerFrame; sa++) {
    t = map(frameCount + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
    sample();
    loadPixels();
    for (int i=0; i<pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++)
    pixels[i] = (result[i][0]/samplesPerFrame) << 16 | 
      (result[i][1]/samplesPerFrame) << 8 | (result[i][2]/samplesPerFrame);
  updatePixels();
  
  if (frameCount <= numFrames) {
    saveFrame("images/f##.png");
  } else {
    exit();
  }
  print(frameCount);
  print("\n");
}

void sample() {
  background(0);
  noStroke();
  
  float s = width / grid;
  
  fill(#ffffff);
  boolean f = true;
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(-360*t));
  
  for (int y = -5; y < grid+5; y++) {
    f = abs(y) % 2 == 0;
    for (int x = -5; x < grid+5; x++) {
      float halfGrid = (float)(grid-1)/2.;
      float circleNum = max(abs(y-halfGrid), abs(x-halfGrid));
      float tO = t + ((1 - (circleNum / halfGrid)) * 0.04);
      
      cR = (int)(tO * (float)tR);
      float lT = (float)cR * (1 / (float)tR);
      float uT = lT + (1 / ((float)tR * 2));
      float lA = cR % 2 == 0 ? 0 : 45;
      float uA = cR % 2 == 0 ? 45 : 90;
      float rotate = constrain(cubic_ease(tO, lT, uT, lA, uA), lA, uA);
      
      float lTt = lT + (1 / ((float)tR * 2));
      float uTt = uT + (1 / ((float)tR * 2));
      float lTr = cR % 2 == 0 ? 0 : 1;
      float uTr = cR % 2 == 0 ? 1 : 0;
      float translate = constrain(cubic_ease(tO, lTt, uTt, lTr, uTr), 0, 1);
      
      if (f) {
        pushMatrix();
        translate(x * s + s / 2 - width/2, y * s + s / 2 - width/2);
        int diagonal = (x - y + 5) / 2;
        float mult = diagonal % 2 == 0 ? 1 : -1;
        float translateAmt = mult * translate * width / grid;
        float diagSection = diagonal % 3;
        if (diagSection == 0) {
          fill(0, 0, 255);
        } else if (diagSection == 1) {
          fill(0, 255, 0);
        } else {
          fill(255, 0, 0);
        }
        translate(translateAmt, translateAmt);
        rotate(radians(rotate));
        rect(s / -2, s / -2, s, s);
        popMatrix();
        
        pushMatrix();
        translate(x * s + s / 2 - width/2, y * s + s / 2 - width/2);
        mult = diagonal % 2 == 0 ? -1 : 1;
        translateAmt = mult * translate * width / grid;
        if (diagSection == 0) {
          fill(0, 255, 0);
        } else if (diagSection == 1) {
          fill(255, 0, 0);
        } else {
          fill(0, 0, 255);
        }
        translate(translateAmt, translateAmt);
        rotate(radians(rotate));
        rect(s / -2, s / -2, s, s);
        popMatrix();
        
        if (diagSection == 0) {
          fill(255, 0, 0);
        } else if (diagSection == 1) {
          fill(0, 0, 255);
        } else {
          fill(0, 255, 0);
        }
        
        pushMatrix();
        translate(x * s + s / 2 - width/2, y * s + s / 2 - width/2);
        rect(s / -2, s / -2, s, s);
        popMatrix();
      }
      
      f = !f;
    }
  }
  
  popMatrix();
  
  //t += 1.0 / (float)numFrames;
  //if (t >= 1) {
  //  t = 0;
  //}
  
  //if (frameCount < numFrames) {
  //  saveFrame("images/f##.png");
  //} else {
  //  exit();
  //}
}

float cubic_ease(float value, float start1, float stop1, float start2, float stop2) {
  if (value < start1) return start2;
  if (value > stop1) return stop2;
  
  float b = start2;
  float c = stop2 - start2;
  float t = value - start1;
  float d = stop1 - start1;
  
  t /= d/2;
  if (t < 1) return c/2*t*t*t + b;
  t -= 2;
  return c/2*(t*t*t + 2) + b;
}
