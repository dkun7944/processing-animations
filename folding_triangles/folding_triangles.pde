float margin = 100;

float f1 = 0;
float f2 = 20;
float f3 = 40;
float f4 = 60;
boolean tL = false;
boolean tR = false;
boolean bL = false;
boolean bR = false;

PGraphics g;
int gSize = 0;

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably
float shutterAngle = 2;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

void setup() {
  size(600,600);
  result = new int[width*height][3];
//  pixelDensity(2);
  colorMode(RGB);
  noStroke();
  
  gSize = width/2;
  g = createGraphics(gSize,gSize);
}

void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;

  for (int sa=0; sa<samplesPerFrame; sa++) {
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
  
  if (frameCount < 160) {
    saveFrame("images/f##.png");
  } else {
    exit();
  }
}

void sample() {
  background(0);
  
  // top left
  f1 += shutterAngle/samplesPerFrame;
  if (f1 > 80) {
    f1 -= 80;
    tL = !tL;
  }
  
  g.beginDraw();
  g.blendMode(tL ? SUBTRACT : ADD);
  g.background(tL ? #ffffff : 0);
  
  float p1 = cubic_ease(f1,0,40,0,1);
  float p2 = cubic_ease(f1,2,42,0,1);
  float p3 = cubic_ease(f1,4,44,0,1);
  
  g.fill(255,0,0);
  g.triangle(p3*gSize,p3*gSize,gSize,0,0,gSize);
  
  g.fill(0,255,0);
  g.triangle(p2*gSize,p2*gSize,gSize,0,0,gSize);
  
  g.fill(0,0,255);
  g.triangle(p1*gSize,p1*gSize,gSize,0,0,gSize);
  
  g.endDraw();
  image(g,0,0,gSize,gSize);
  
  // top right
  f2 += shutterAngle/samplesPerFrame;
  if (f2 > 80) {
    f2 -= 80;
    tR = !tR;
  }
  
  g.beginDraw();
  g.blendMode(tR ? SUBTRACT : ADD);
  g.background(tR ? #ffffff : 0);
  
  p1 = cubic_ease(f2,0,40,0,1);
  p2 = cubic_ease(f2,2,42,0,1);
  p3 = cubic_ease(f2,4,44,0,1);
  
  g.fill(255,0,0);
  g.triangle((1-p3)*gSize,p3*gSize,gSize,gSize,0,0);
  
  g.fill(0,255,0);
  g.triangle((1-p2)*gSize,p2*gSize,gSize,gSize,0,0);
  
  g.fill(0,0,255);
  g.triangle((1-p1)*gSize,p1*gSize,gSize,gSize,0,0);
  
  g.endDraw();
  image(g,gSize,0,gSize,gSize);
  
  // bottom left
  f3 += shutterAngle/samplesPerFrame;
  if (f3 > 80) {
    f3 -= 80;
    bL = !bL;
  }
  
  g.beginDraw();
  g.blendMode(bL ? SUBTRACT : ADD);
  g.background(bL ? #ffffff : 0);
  
  p1 = cubic_ease(f3,0,40,0,1);
  p2 = cubic_ease(f3,2,42,0,1);
  p3 = cubic_ease(f3,4,44,0,1);
  
  g.fill(255,0,0);
  g.triangle(p3*gSize,(1-p3)*gSize,0,0,gSize,gSize);
  
  g.fill(0,255,0);
  g.triangle(p2*gSize,(1-p2)*gSize,0,0,gSize,gSize);
  
  g.fill(0,0,255);
  g.triangle(p1*gSize,(1-p1)*gSize,0,0,gSize,gSize);
  
  g.endDraw();
  image(g,0,gSize,gSize,gSize);
  
  // bottom right
  f4 += shutterAngle/samplesPerFrame;
  if (f4 > 80) {
    f4 -= 80;
    bR = !bR;
  }
  
  g.beginDraw();
  g.blendMode(bR ? SUBTRACT : ADD);
  g.background(bR ? #ffffff : 0);
  
  p1 = cubic_ease(f4,0,40,0,1);
  p2 = cubic_ease(f4,2,42,0,1);
  p3 = cubic_ease(f4,4,44,0,1);
  
  g.fill(255,0,0);
  g.triangle((1-p3)*gSize,(1-p3)*gSize,gSize,0,0,gSize);
  
  g.fill(0,255,0);
  g.triangle((1-p2)*gSize,(1-p2)*gSize,gSize,0,0,gSize);
  
  g.fill(0,0,255);
  g.triangle((1-p1)*gSize,(1-p1)*gSize,gSize,0,0,gSize);
  
  g.endDraw();
  image(g,gSize,gSize,gSize,gSize);
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
