///////////////////////////////////////////////////////////////////////////////
// File:   game.pde                   Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// @pjs preload must be used to preload media if the program is 
// running with Processing.js
@pjs preload = "scott_idle_healty_00.gif, scott_idle_healty_01.gif, scott_idle_healty_02.gif, scott_idle_healty_03.gif, scott_idle_healty_04.gif, scott_idle_healty_05.gif, scott_idle_healty_06.gif, scott_idle_healty_07.gif";

int numFrames = 8;  // The number of frames in the animation
int frame = 0;
PImage[] images = new PImage[numFrames];
///////////////////////////////////////////////////////////////////////////////
    
///////////////////////////////////////////////////////////////////////////////
void setup() {
  size(640, 360);
  frameRate(24);
  
  images[0]  = loadImage( "scott_idle_healty_00.gif" );
  images[1]  = loadImage( "scott_idle_healty_01.gif" ); 
  images[2]  = loadImage( "scott_idle_healty_02.gif" );
  images[3]  = loadImage( "scott_idle_healty_03.gif" ); 
  images[4]  = loadImage( "scott_idle_healty_04.gif" );
  images[5]  = loadImage( "scott_idle_healty_05.gif" ); 
  images[6]  = loadImage( "scott_idle_healty_06.gif" );
  images[7]  = loadImage( "scott_idle_healty_07.gif" ); 
} 
///////////////////////////////////////////////////////////////////////////////
 
///////////////////////////////////////////////////////////////////////////////
void draw() { 
  background( 0 );
  frame = ( frame + 1 ) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for ( int x = -100; x < width; x += images[0].width ) { 
    image( images[( frame + offset ) % numFrames], x, -20);
    offset+=2;
    image( images[( frame + offset ) % numFrames], x, height/2);
    offset+=2;
  }
}
///////////////////////////////////////////////////////////////////////////////

