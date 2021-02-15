PImage img;
float t = 0;
float[] ellipseLocs;

int samplesPerFrame = 16;  // more is better but slower. 32 is enough probably
float shutterAngle = 16;
int numFrames = 240;
int[][] result;

void setup() {
  size(1000, 1300);
  result = new int[width*height][3];
  ellipseLocs = new float[1000*1300];
  img = loadImage("dan.jpg");
  img.loadPixels();
//  pixelDensity(2);
  blendMode(ADD);
  
  for (int x = 1; x < width; x += 4) {
    for (int y = 1; y < height; y += 4) {
      // Pixel location and color
      int loc = x + y*img.width;
      color pix = img.pixels[loc];

      // Pixel to the left location and color
      int leftLoc = (x-1) + y*img.width;
      color leftPix = img.pixels[leftLoc];

      int bottomLoc = x + (y-1)*img.width;
      color bottomPix = img.pixels[bottomLoc];
      //print(x);
      //print("\n");
      //print(y);
      //print("\n\n");

      // New color is difference between pixel and left neighbor
      float diffH = abs(brightness(pix) - brightness(leftPix));
      float diffV = abs(brightness(pix) - brightness(bottomPix));
      float diff = (diffH + diffV) / 2;

      if (diff > 19) {
        ellipseLocs[loc] = diff;
      } else {
        ellipseLocs[loc] = 0;
      }
    }
  }
}

void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;

  for (int sa=0; sa<samplesPerFrame; sa++) {
    t = map(frameCount + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 4 * PI);
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
  
  if (frameCount <= 240) {
    saveFrame("images/f##.png");
  } else {
    exit();
  }
  print(frameCount);
  print("\n");
}

void sample() {
  //  loadPixels();

  background(0);
  ellipseMode(CENTER);
  fill(color(255));
  float s = 4;
  float mult = (2+sin(t*0.5))*0.005;
  
  for (int x = 1; x < width; x += 4) {
    for (int y = 1; y < height; y += 4) {
      int loc = x + y*img.width;
      
      if (ellipseLocs[loc] > 0) {
        float val = 255 - (ellipseLocs[loc] * 4);
        fill(0,0,255);
        ellipse(x + 15*sin(t+(y*mult)), y+15*cos(t+(x*mult)), s, s);
        
        fill(0,255,0);
        ellipse(x + 15*sin(t+1+(y*mult)), y+15*cos(t+1+(x*mult)), s, s);
        
        fill(255,0,0);
        ellipse(x + 15*sin(t+2+(y*mult)), y+15*cos(t+2+(x*mult)), s, s);
      }
    }
    //  updatePixels();
  }
}
