float n = 30;
int d = 5;

float t = 0;
int numFrames = 300;
int samplesPerFrame = 16;  // more is better but slower. 32 is enough probably
float shutterAngle = 8;
int[][] result;

void setup() {
  size(1000, 1000);
  result = new int[width*height][3];
//  pixelDensity(2);
  colorMode(RGB);
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
  fill(0);
  noStroke();
  ellipseMode(CENTER);
  
  float s = (float)width / n;
  for (int row = -1*(int)n; row < n*2; row++) {
    for (int col = -1*(int)n; col < n*2; col++) {
      float x = row*s + s/2;
      float y = col*s + s/2;

      for (int i = 0; i < 2; i++) {
        float c = (float)width / 2;
        float mag = sqrt(pow(x-c,2) + pow(y-c,2));
        float angle = atan2(y-c,x-c) * 180. / PI * 2 * PI / 360.;
      
        float iMod = (float)i*5;
        float frame = t*numFrames;
        float mod = sin(((2*PI*(frame+iMod)) / (float)numFrames) - ((float)mag/100) - angle) * sqrt(mag)*3;
        mag += mod;
      
        float nX = mag * cos(angle) + c;
        float nY = mag * sin(angle) + c;
        float nD = d + mod/15 + 3;
        float nD2 = d - mod/15 + 1;
      
//      fill(160+mod/1.2, 160, 255);

        if (i==0) {
          fill(255,255,0);
        } else if (i==1) {
          fill(0,0,255);
        } else {
          fill(0,0,255);
        }
        ellipse(nX, nY, nD, nD);
      }
    }
  }
  
  //if (frameCount <= 200) {
  //  saveFrame("images/###.png");
  //} else {
  //  exit();
  //}
}
