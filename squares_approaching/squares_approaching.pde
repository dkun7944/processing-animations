float x, y;
float[] z;

void setup() {
  size(1000, 1000, P3D);
  pixelDensity(2);
  hint(DISABLE_OPTIMIZED_STROKE);
  smooth(8);
  colorMode(RGB);
  blendMode(ADD);
  x = width/2;
  y = height/2;
  
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, width/height, cameraZ/10.0, cameraZ*100.0);
  
  float maxDistance = -50000;
  int nSquares = 20;
  float stride = (cameraZ - maxDistance) / (float)nSquares;
  z = new float[nSquares];
  for (int i = 0; i < nSquares; i++) {
    z[i] = maxDistance + (i * stride);
  }
}

void draw() {
  background(0);
  
  surface.setLocation(3000, -850);
  
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  println(cameraZ);
  for (int i = 0; i < z.length; i++) {
    pushMatrix();
    translate(x,y,z[i]);
    fill(255, 0, 0);
    dRect(0,0,200,200,20);
    popMatrix();
    
    pushMatrix();
    translate(x,y,z[i] + 30);
    fill(0, 255, 0);
    dRect(0,0,200,200,20);
    popMatrix();
    
    pushMatrix();
    translate(x,y,z[i] + 60);
    fill(0, 0, 255);
    dRect(0,0,200,200,20);
    popMatrix();
    
    z[i] += 50;
    
    if (z[i] > cameraZ) {
      z[i] -= 50000;
    }
  }
  
  if (frameCount < 600) {
    saveFrame("images/f###.png");
  }
}

void dRect(float x, float y, float w, float h, float strokeWeight) {
  noStroke();
  
  rect(x - w/2, y - h/2, strokeWeight, h);
  rect(x - w/2, y + h/2 - strokeWeight, w, strokeWeight);
  rect(x + w/2 - strokeWeight, y - h/2, strokeWeight, h);
  rect(x - w/2, y - h/2, w, strokeWeight);
}
