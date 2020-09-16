float theta = 0.0;
int n_harmonics = 5;
float p = 0;
float sp;
boolean inc;

void setup() {
  size(600,600);
  pixelDensity(2);
  colorMode(RGB);
  blendMode(SUBTRACT);
}

void draw() {
  background(#ffffff);
  stroke(0);
  strokeWeight(4);
  
  if (p <= 0.0) {
    inc = true;
  } else if (p >= 1) {
    inc = false;
  }
  
  p += inc ? 0.01 : -0.01;
  sp = cubic_ease(p,0,1,0,1);
  
  color[] colors = { color(0,0,255),color(0,255,0),color(255,0,0) };
  
  theta += 0.05;
  float period = width/2;
  float dx = TWO_PI/period;
  for (int i = 0; i < width; i++) {
    float hann = hann(i, width);
    float x1 = i;
    float y1t = sinHarmonicTotal(x1*dx+theta, n_harmonics, height/8) +height/2;
    float x2 = i+1;
    float y2t = sinHarmonicTotal(x2*dx+theta, n_harmonics, height/8) +height/2;
    
    for (int h = 2; h <= n_harmonics; h++) {
      stroke(colors[h%colors.length]);
      float y1h = sinHarmonic(x1*dx+(theta/h), h, height/8) +height/2;
      float y2h = sinHarmonic(x2*dx+(theta/h), h, height/8) +height/2;
      float y1 = (y1t * sp) + (y1h*(1-sp));
      float y2 = (y2t * sp) + (y2h*(1-sp));
      line(x1,y1,x2,y2);
    }
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
