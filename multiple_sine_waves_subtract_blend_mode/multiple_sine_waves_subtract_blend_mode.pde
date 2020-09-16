float margin = 100;
int nLines = 20;
float minStrokeWeight = 2;
float maxStrokeWeight = 12;

void setup() {
  size(600,600);
  pixelDensity(2);
  noFill();
  blendMode(SUBTRACT);
  colorMode(RGB);
}

void draw() {
  background(#ffffff);
//  strokeCap(SQUARE);

  float frame = ((float)frameCount/2.);
  
  float x1 = margin;
  float x2 = width-margin;
  for (int i = 1; i <= nLines; i++) {
    float h = map(i, 1, nLines, minStrokeWeight, maxStrokeWeight);
    float yb = margin + ((i-1) * (height-(2*margin)) / nLines);
    strokeWeight(h);
    
    stroke(255,0,0);
    beginShape();
    for (float x = x1; x <= x2; x++) {
      float f = sin(x/13.-frame);
      float y = yb+f*map(x,x1,x2,0,2);
      curveVertex(x,y);
    }
    endShape();
    
    stroke(0,255,0);
    beginShape();
    for (float x = x1; x <= x2; x++) {
      float f = sin(x/14.-frame);
      float y = yb+f*map(x,x1,x2,0,2);
      curveVertex(x,y);
    }
    endShape();
    
    stroke(0,0,255);
    beginShape();
    for (float x = x1; x <= x2; x++) {
      float f = sin(x/15.-frame);
      float y = yb+f*map(x,x1,x2,0,2);
      curveVertex(x,y);
    }
    endShape();
  }
}

float hann(float x, float m) {
  return 0.5 - 0.5*cos((TWO_PI*x)/m);
}
