// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

// Adapted March 12, 2025 by Calico Rose.
// Use color tracking with the Kinect V2.

import java.awt.AWTException;
import java.awt.Robot;
Robot robby;

import KinectPV2.*;
KinectPV2 kinect;
PImage color_img;

color trackColor; 
float threshold = 25;

void setup() {
  // sized to match the "game" image in Unity
  size(325, 410);
  //noCursor();

  // Tracking white as default.
  trackColor = color(255, 255, 255);
  
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.init();
  
  try {
    robby = new Robot();
  }
  catch(AWTException e) {
    println("Robot class not supported.");
    exit();
  }
}

void draw() {
  color_img = kinect.getColorImage();
  image(color_img, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 15;

  float avgX = 0;
  float avgY = 0;

  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < color_img.width; x++ ) {
    for (int y = 0; y < color_img.height; y++ ) {
      int loc = x + y * color_img.width;
      // What is current color
      color currentColor = color_img.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(255);
    strokeWeight(4.0);     
    stroke(0);
    ellipse(avgX, avgY, 24, 24);
    float pointerX = map(avgX, 339, 632, 150, width);
    float pointerY = map(avgY, 632, 1428, 450, 950);
    if(mousePressed) {
      robby.mouseMove((int)pointerY, (int)pointerX); 
    }
    //println("X: ", avgX);
    //println("Y: ", avgY);
    //delay(500);
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//void mousePressed() {
//  // Save color where the mouse is clicked in trackColor variable
//  int loc = mouseX + mouseY*color_img.width;
//  trackColor = color_img.pixels[loc];
//}
