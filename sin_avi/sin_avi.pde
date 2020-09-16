float theta = 0;
float p = 0;
boolean done = false;

void setup() {
  size(600,600);
  pixelDensity(2);
  colorMode(RGB);
  blendMode(SUBTRACT);
}

void draw() {
  background(#ffffff);
//  stroke(#ffffff);
  strokeWeight(24);
  
  p += 0.01;
  
  color[] colors = { color(0,0,255),color(0,255,0),color(255,0,0) };
  
  theta += TWO_PI/32;
  if (theta > TWO_PI) {
    theta -= TWO_PI;
    done = true;
  }
  
  float period1 = width/5;
  float dx1 = TWO_PI/period1;
  
  for (int i = 0; i < width; i++) {
    stroke(255,0,0);
    float x1 = i;
    float y1 = sinHarmonic(x1*dx1+theta, 1, height/3) * hann(x1, width) + height/2;
    float x2 = i+1;
    float y2 = sinHarmonic(x2*dx1+theta, 1, height/3) * hann(x2, width) + height/2;
    line(x1,y1,x2,y2);
    
    stroke(0,255,0);
    y1 = sinHarmonic(x1*dx1+theta+1, 1, height/3) * hann(x1, width) + height/2;
    y2 = sinHarmonic(x2*dx1+theta+1, 1, height/3) * hann(x2, width) + height/2;
    line(x1,y1,x2,y2);
    
    stroke(0,0,255);
    y1 = sinHarmonic(x1*dx1+theta+2, 1, height/3) * hann(x1, width) + height/2;
    y2 = sinHarmonic(x2*dx1+theta+2, 1, height/3) * hann(x2, width) + height/2;
    line(x1,y1,x2,y2);
  }
  
  saveFrame("images/f##.png");
  if (done) {
    exit();
  }
}

float hann(float x, float m) {
  return 0.5 - 0.5*cos((TWO_PI*x)/m);
}

float sinHarmonicTotal(float x, float harmonic, float amp) {
  float out = 0;
  for (int i = 1; i <= harmonic; i++) {
    out += sinHarmonic(x, i, amp);
  }
  return out;
}

float sinHarmonic(float x, float harmonic, float amp) {
  return amp*sin(harmonic*x)/harmonic;
}

float cubic_ease(float value, float start1, float stop1, float start2, float stop2) {
  float b = start2;
  float c = stop2 - start2;
  float t = value - start1;
  float d = stop1 - start1;
  
  t /= d/2;
  if (t < 1) return c/2*t*t*t + b;
  t -= 2;
  return c/2*(t*t*t + 2) + b;
}
