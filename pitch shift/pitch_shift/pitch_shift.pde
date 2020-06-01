int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float period = 150.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float resampleRate = 1.0; // resampling rate for playhead
float resampleDx = 0;
int resampleHoldCounter = 0;
float playheadOffset = 75;
float rightMargin = 200;
float[] topWaveYvalues;  // Using an array to store height values for the top wave
float[] bottomWaveYvalues; // Using an array to store height values for the bottom resamples wave

void setup() {
  size(640, 640);
  w = width-(int)rightMargin;
  dx = TWO_PI/period;
  topWaveYvalues = new float[w];
  bottomWaveYvalues = new float[w];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
  
  //if (frameCount<=3000) {
  //  saveFrame("../images/line-######.png");
  //} else if (frameCount==3001) {
  //  print("done!");
  //}
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.04;
  resampleRate += resampleDx;
  if (resampleRate>=2 || resampleRate<=0.5) {
    resampleDx = 0;
  }
  resampleRate = constrain(resampleRate, 0.5, 2);
  
  if (resampleDx==0) {
    resampleHoldCounter++;
  }
  
  if (resampleHoldCounter>400) {
    resampleDx = resampleRate>0.9 ? -0.0025 : 0.0025;
    resampleHoldCounter = 0;
  }
  
  // Increment playhead progress
  playheadOffset += resampleRate-1;
  if (playheadOffset > period) {
    playheadOffset -= period;
  } else if (playheadOffset < 0) {
    playheadOffset += period;
  }
  
  // For every x value, calculate a y value with sine function
  float x = theta;
  float amp = amplitude / 3;
  for (int i = 0; i < topWaveYvalues.length; i++) {
    topWaveYvalues[i] = waveFunction(x, amp);
    x+=dx;
  }
  
  for (int i = 0; i < bottomWaveYvalues.length-1; i++) {
    bottomWaveYvalues[i] = bottomWaveYvalues[i+1];
  }
  
  float playheadIdx = width-rightMargin-period+playheadOffset;
  int idxBefore = floor(playheadIdx);
  int idxAfter = ceil(playheadIdx);
  float r = playheadIdx - (float)idxBefore;
  if (idxBefore >= topWaveYvalues.length) {
    idxBefore -= (int)period;
  }
  if (idxAfter >= topWaveYvalues.length) {
    idxAfter -= (int)period;
  }
  bottomWaveYvalues[bottomWaveYvalues.length-1] = topWaveYvalues[idxAfter]*r + topWaveYvalues[idxBefore]*(1-r);
}

float waveFunction(float x, float amp) {
  return sin(x)*amp + sin(2*x)*amp + sin(3*x)*amp;
}

void renderWave() {
  strokeWeight(2);
  stroke(255,255,255);
  
  // Draw the input boundary line
  line(width-rightMargin, 0, width-rightMargin, height);
  
  // Draw the top wave
  float topWaveCenterY = height / 4;
  for (int x = 1; x < topWaveYvalues.length; x++) {
    float x1 = (x-1);
    float y1 = topWaveCenterY+topWaveYvalues[x-1];
    float x2 = x;
    float y2 = topWaveCenterY+topWaveYvalues[x];
    line(x1, y1, x2, y2);
  }
  
  //// Draw the top wave x axis
  //line(0, topWaveCenterY, width-rightMargin, topWaveCenterY);
  
  // Draw the top wave window box
  stroke(125,192,255);
  line(width-rightMargin-period, topWaveCenterY-100, width-rightMargin, topWaveCenterY-100);
  line(width-rightMargin-period, topWaveCenterY-100, width-rightMargin-period, topWaveCenterY+100);
  line(width-rightMargin-period, topWaveCenterY+100, width-rightMargin, topWaveCenterY+100);
  line(width-rightMargin, topWaveCenterY-100, width-rightMargin, topWaveCenterY+100);
  
  // Draw the top wave resampling playhead
  stroke(80,227,194);
  float playheadX = width-rightMargin-period + playheadOffset;
  line(playheadX, topWaveCenterY-99, playheadX, topWaveCenterY+99);
  
  // Draw the bottom wave
  float bottomWaveCenterY = 3 * height / 4;
  for (int x = 1; x < bottomWaveYvalues.length; x++) {
    if (bottomWaveYvalues[x-1] == 0) {
      continue;
    }
    float x1 = (x-1);
    float y1 = bottomWaveCenterY+bottomWaveYvalues[x-1];
    float x2 = x;
    float y2 = bottomWaveCenterY+bottomWaveYvalues[x];
    line(x1, y1, x2, y2);
  }
  
  // Draw the connecting line
  stroke(80,227,194);
  fill(80,227,194);
  int playheadIdx = (int)(width-rightMargin-period+playheadOffset);
  line(playheadX,topWaveCenterY+topWaveYvalues[playheadIdx],width-rightMargin,bottomWaveCenterY+bottomWaveYvalues[bottomWaveYvalues.length-1]);
  
  ellipseMode(CENTER);
  ellipse(playheadX,topWaveCenterY+topWaveYvalues[playheadIdx],10,10);
  ellipse(width-rightMargin,bottomWaveCenterY+bottomWaveYvalues[bottomWaveYvalues.length-1],10,10);
  
  // Draw text.
  fill(255,255,255);
  stroke(255,255,255);
  textSize(18);
  text("rate = " + round2Places(resampleRate), width-rightMargin+20, height/2);
  text("original signal\n" + "440.0 Hz", width-rightMargin+20, topWaveCenterY);
  text("pitch-shifted\nsignal" + "\n" + round2Places(440*resampleRate) + " Hz", width-rightMargin+20, bottomWaveCenterY);
  
  textSize(14);
  fill(125,192,255);
  text("window = 1 period", width-rightMargin-period+10, topWaveCenterY-110);
}

float round2Places(float x) {
  return (float)round(x*100.0)/100.0;
}
