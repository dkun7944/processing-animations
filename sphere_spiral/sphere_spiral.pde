float r = 180;
float rs = 30;

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably      
float shutterAngle = 4;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;

float f = 0;

void setup() {
  size(512,512,P3D);
  ortho();
//  pixelDensity(2);
  result = new int[width*height][3];
  colorMode(HSB);
  smooth(8);
}

void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;

  for (int sa=0; sa<samplesPerFrame; sa++) {
    f = frameCount + sa*shutterAngle/samplesPerFrame;
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
  
  if (frameCount<=800) {
    saveFrame("images/f##.png");
  } else {
    exit();
  }
}

void sample() {
  background(#05051f);
  lights();
  noFill();
  stroke(#ffffff);
  strokeWeight(8);
  strokeCap(ROUND);
  
//  f += 1. / (float)samplesPerFrame;
  
  pushMatrix();
  translate(width/2,height/2,0);
  rotateX((float)f/800*TWO_PI);
//  rotateY((float)frameCount/800*TWO_PI);
  rotateZ((float)f/800*TWO_PI);
  
  int nLines = 50;
  
  print("%i\n", f);
  
//  beginShape();
  for (int i = 0; i < nLines; i++) {
    float a = i+((float)f/12);
    float cr1 = r + (rs*cos(PI*9*a/nLines));
    float z1 = cr1*sin(PI*1.5*a/nLines);
    float x1 = cr1*cos(PI*1.5*a/nLines);
    float y1 = rs*sin(PI*9*a/nLines);
    strokeWeight(12.0*(float)i/(float)nLines);
    stroke(64+64*i/nLines,128,255);
//    curveVertex(x1,y1,z1);
    
    pushMatrix();
    translate(x1,y1,z1);
    sphere((float)i/(float)nLines/2);
    popMatrix();
  }
//  endShape();
  
  //beginShape();
  for (int i = 0; i < nLines; i++) {
    float a = i+((float)f/12);
    float cr1 = r + (rs*cos(PI*9*a/nLines-PI));
    float z1 = cr1*sin(PI*1.5*a/nLines);
    float x1 = cr1*cos(PI*1.5*a/nLines);
    float y1 = rs*sin(PI*9*a/nLines-PI);
    strokeWeight(12.0*(float)i/(float)nLines);
    stroke(80+64*i/nLines,128,255);
    //curveVertex(x1,y1,z1);
    
    pushMatrix();
    translate(x1,y1,z1);
    sphere((float)i/(float)nLines/2);
    popMatrix();
  }
  //endShape();
  
  //beginShape();
  for (int i = 0; i < nLines; i++) {
    float a = i+((float)f/12);
    float cr1 = r + (rs*cos(PI*9*a/nLines-PI/2));
    float z1 = cr1*sin(PI*1.5*a/nLines);
    float x1 = cr1*cos(PI*1.5*a/nLines);
    float y1 = rs*sin(PI*9*a/nLines-PI/2);
    strokeWeight(12.0*(float)i/(float)nLines);
    stroke(96+64*i/nLines,128,255);
    //curveVertex(x1,y1,z1);
    
    pushMatrix();
    translate(x1,y1,z1);
    sphere((float)i/(float)nLines/2);
    popMatrix();
  }
  //endShape();
  
  //beginShape();
  for (int i = 0; i < nLines; i++) {
    float a = i+((float)f/12);
    float cr1 = r + (rs*cos(PI*9*a/nLines-3*PI/2));
    float z1 = cr1*sin(PI*1.5*a/nLines);
    float x1 = cr1*cos(PI*1.5*a/nLines);
    float y1 = rs*sin(PI*9*a/nLines-3*PI/2);
    strokeWeight(12.0*(float)i/(float)nLines);
    stroke(112+64*i/nLines,128,255);
    //curveVertex(x1,y1,z1);
    
    pushMatrix();
    translate(x1,y1,z1);
    sphere((float)i/(float)nLines/2);
    popMatrix();
  }
  //endShape();
  
  popMatrix();
}
