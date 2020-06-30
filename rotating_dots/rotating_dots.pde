float diameter = 40;
float margin = 300;
float canvas = 1200;
int n = 6;
float angle = 0;

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably      
float shutterAngle = 2;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;
boolean done = false;

void setup() {
  size(1200,1200);
  result = new int[width*height][3];
//  pixelDensity(2);
  frameRate(30);
  blendMode(SUBTRACT);
  colorMode(RGB);
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
  
  saveFrame("images/f##.png");
  if (done)
    exit();
}

void sample() {
  background(#ffffff);
  noStroke();
  
  float t_rotate = 9*PI;
  float speed = 15;
  
  if (angle >= t_rotate) {
    done = true;
    angle -= t_rotate;
  }
  
  float moduloAngle = angle%(PI);
  if (moduloAngle <= PI/2) {
    float c = 0.03;
    if (angle <= PI/2) {
      c = 0.0005;
    }
    angle += ((moduloAngle / speed) + c) / (samplesPerFrame / 2);
  } else if (moduloAngle > PI/2) {
    float c = 0.03;
    if (angle >= t_rotate - PI/2) {
      c = 0.0005;
    }
    angle += ((((PI) - moduloAngle) / speed) + c) / (samplesPerFrame / 2);
  }
  
  float spacing = (canvas-(margin*2))/(n-1);
  
  for (int col = 0; col < n; col++) {
    for (int row = 0; row < n; row++) {
      float x = margin + (spacing * col) - canvas/2;
      float y = margin + (spacing * row) - canvas/2;
      
      int section = max(abs(int(col-float(n-1)/2)), abs(int(row-float(n-1)/2))) + 1;
      
      pushMatrix();
      translate(canvas/2,canvas/2);
      rotate(angle/section);
      fill(0,0,255);
      circle(x,y,diameter);
      popMatrix();
      
      pushMatrix();
      translate(canvas/2,canvas/2);
      rotate((angle/section)*(2.0/3));
      fill(0,255,0);
      circle(x,y,diameter);
      popMatrix();
      
      pushMatrix();
      translate(canvas/2,canvas/2);
      rotate((angle/section)*(1.0/3));
      fill(255,0,0);
      circle(x,y,diameter);
      popMatrix();
    }
  }
}
