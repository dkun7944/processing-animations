color color1 = #3da4ab;
color color2 = #ffe277;
color color3 = #fe8a71;
color bg = #ffffff;
color stroke = 0;

int cols = 5;
int rows = 6;
float[][] anim = new float[6][5];
int[][] state = new int[6][5];

int samplesPerFrame = 32;  // more is better but slower. 32 is enough probably      
float shutterAngle = 4;  // this should be between 0 and 1 realistically. exaggerated for effect here
int[][] result;
boolean done = false;
int iter = 0;

void setup() {
  size(1200, 1200, P3D);
  result = new int[width*height][3];
  ortho(-width/2, width/2, -height/2, height/2, -10000, 10000);
  colorMode(HSB);
  stroke(stroke);
  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      anim[r][c] = ((float)(c+1) / (float)(cols+1));
      print(anim[r][c]);
    }
  }
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
  background(bg);
  updateAnim();
  
  float size1 = width/(cols-1)/sqrt(2);
  float size2 = size1*0.7;
  
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r < rows; r++) {
      if (state[r][c] == 0) {
          // ROTATE BIG CUBE
          float cX = size1*c*sqrt(2) + size1/sqrt(2);
          if (r % 2 == 0) {
            cX -= size1*sqrt(2)/2;
          }
          float cY = size1*r*sqrt(1.5) - size1/4;
          drawCutoutCube(cX,cY,size1,size2,anim[r][c]);
      } else {
          // ROTATE SMALL CUBE
          float ccX = size1*c*sqrt(2) + size1/sqrt(2);
          if (r % 2 == 0) {
            ccX -= size1*sqrt(2)/2;
          }
          float ccY = size1*r*sqrt(1.5) - size1/4;
          drawFullCube(ccX,ccY,size1);
          drawSmallCube(ccX,ccY,size2,anim[r][c]);
      }
    }
  }
}

void updateAnim() {
  boolean incIter = true;
  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (anim[r][c] >= 1) {
        anim[r][c] -= 1;
        state[r][c] = state[r][c] == 1 ? 0 : 1;
      } else {
        incIter = false;
      }
  
      if (anim[r][c] <= 0.5) {
        anim[r][c] += (anim[r][c] / 20 + 0.0001) / float(samplesPerFrame / 2);
      } else if (anim[r][c] > 0.5) {
        anim[r][c] += ((1 - anim[r][c]) / 20 + 0.0001) / float(samplesPerFrame / 2);
      }
    }
  }
  
  if (incIter) {
    iter += 1;
    print("iter\n");
  }
  
  if (iter >= 2) {
    done = true;
  }
}

void drawCutoutCube(float cX, float cY, float size, float innerSize, float anim) {
  pushMatrix();
  translate(cX,cY,0);
  rotateX(-1*atan(1/sqrt(2)));
  rotateY(PI/4 + TWO_PI*anim);
  
  float size_2 = size/2;
  float isize_2 = size_2 - (size - innerSize);
  
  fill(bg);
  strokeWeight(0.9);
  
  beginShape();
  fill(color1);
  vertex(isize_2, -size_2, size_2);
  vertex(isize_2, isize_2, size_2);
  vertex(-size_2, isize_2, size_2);
  vertex(-size_2, size_2, size_2); 
  vertex( size_2, size_2, size_2); 
  vertex( size_2, -size_2, size_2); 
  endShape();
  
  beginShape();
  fill(bg);
  vertex( size_2, size_2, size_2); 
  vertex( size_2, size_2, -size_2); 
  vertex( size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, size_2);
  endShape();
  
  beginShape();
  vertex( size_2, size_2, -size_2); 
  vertex(-size_2, size_2, -size_2); 
  vertex(-size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, -size_2);
  endShape();
  
  beginShape();
  fill(color2);
  vertex(-size_2, size_2, -size_2); 
  vertex(-size_2, size_2, size_2); 
  vertex(-size_2, isize_2, size_2);
  vertex(-size_2, isize_2, -isize_2);
  vertex(-size_2, -size_2, -isize_2);
  vertex(-size_2, -size_2, -size_2);
  endShape();
  
  beginShape();
  fill(bg);
  vertex(-size_2, size_2, -size_2); 
  vertex( size_2, size_2, -size_2); 
  vertex( size_2, size_2, size_2); 
  vertex(-size_2, size_2, size_2);
  endShape();
  
  beginShape();
  fill(color3);
  vertex(-size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, size_2); 
  vertex(isize_2, -size_2, size_2);
  vertex(isize_2, -size_2, -isize_2);
  vertex(-size_2, -size_2, -isize_2);
  endShape();
  
  popMatrix();
}

void drawFullCube(float cX, float cY, float size) {
  pushMatrix();
  translate(cX,cY,0);
  rotateX(-1*atan(1/sqrt(2)));
  rotateY(PI/4);
  
  float size_2 = size/2;
  
  fill(bg);
  strokeWeight(0.9);
  
  beginShape();
  fill(color1);
  vertex(-size_2, -size_2, size_2);
  vertex(-size_2, size_2, size_2); 
  vertex( size_2, size_2, size_2); 
  vertex( size_2, -size_2, size_2); 
  endShape();
  
  beginShape();
  fill(bg);
  vertex( size_2, size_2, size_2); 
  vertex( size_2, size_2, -size_2); 
  vertex( size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, size_2);
  endShape();
  
  beginShape();
  vertex( size_2, size_2, -size_2); 
  vertex(-size_2, size_2, -size_2); 
  vertex(-size_2, -size_2, -size_2); 
  vertex( size_2, -size_2, -size_2);
  endShape();
  
  beginShape();
  fill(color2);
  vertex(-size_2, size_2, -size_2); 
  vertex(-size_2, size_2, size_2); 
  vertex(-size_2, -size_2, size_2);
  vertex(-size_2, -size_2, -size_2);
  endShape();
  
  beginShape();
  fill(bg);
  vertex(-size_2, size_2, -size_2); 
  vertex( size_2, size_2, -size_2); 
  vertex( size_2, size_2, size_2); 
  vertex(-size_2, size_2, size_2);
  endShape();
  
  beginShape();
  fill(color3);
  vertex(-size_2, -size_2, -size_2); 
  vertex(size_2, -size_2, -size_2); 
  vertex(size_2, -size_2, size_2); 
  vertex(-size_2, -size_2, size_2);
  endShape();
  
  popMatrix();
}

void drawSmallCube(float cX, float cY, float size, float anim) {
  pushMatrix();
  translate(cX, cY, 200);
  rotateX(atan(1/sqrt(2)) + PI*anim);
  rotateY(PI/4);
  fill(bg);
  strokeWeight(1.05);
  box(size);
  popMatrix();
}
