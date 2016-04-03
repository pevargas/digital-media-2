///////////////////////////////////////////////////////////////////////////////
// File: robot.pde                 Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Create a robot that performs at least three functions (that you write)
//   activated by user interaction.
//   * Example Functions: move, jump, talk, blink, spin, explode, grow, shrink, etc.
//   * Each function should be triggered by its own keystroke or mouse interaction
//   * Spend some time working on the aesthetic (make sure the robot looks good!).
//   * Be creative!
///////////////////////////////////////////////////////////////////////////////

// Penguin bot
// flap()
// laser()
// roll()
// talk()
// laser()

///////////////////////////////////////////////////////////////////////////////
// Class to make penguin-bot
class Bot {
  // Member variables
  int x, y, s; // Position and size
  int ox, oy; // Pupil offset
  
  // Constructor
  Bot( int px, int py, int ps ) {
    x = px; y = py; s = ps;
  }

  // Member Methods
  void draw ( ) {
    fill( 0 );
    ellipse( x, y, s, s ); // Body
    fill( 255 );
    ellipse( x, y+s*0.1, s*0.8, s*0.8 ); // Tux
    
    fill( 255, 150, 0 );
    arc(x, y-s*0.24, s*0.15, s*0.15, PI*1.25, PI*1.75); // Beak
    eye( );
  }
  
  void eye ( ) {
    float [] eye = new float[4];
    eye[0] = x-s*0.1;
    eye[1] = y-s*0.35;
    eye[2] = x+s*0.1;
    eye[3] = y-s*0.35;
    fill( 255 );
    ellipse( eye[0], eye[1], s*0.1, s*0.1 );// Eye-L
    ellipse( eye[2], eye[3], s*0.1, s*0.1 );// Eye-R
    fill( 0 );
    ellipse( eye[0]+cos(PI/3+ox)*s*0.01, eye[1]+sin(TWO_PI/4+oy)*s*0.01, s*0.05, s*0.05 );// Pupil-L
    ellipse( eye[2]-cos(PI/3+ox)*s*0.01, eye[3]+sin(TWO_PI/4+oy)*s*0.01, s*0.05, s*0.05 );// Pupil-R
  }
  
  void eye ( int px, int py ) { ox = px; oy = py; }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Global Variables
Bot penguin;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {  
  // Variables
  
  // Set up window
  size( 500, 500 );
  
  penguin = new Bot(0, 0, width*0.5);
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  // Variables

  translate(width/2, height/2);
  float a = atan2(mouseY-height/2, mouseX-width/2);

  // Color ALL the things
  background( color( 0, 140, 255, 200 ) );
  noStroke();

//  penguin.eye( millis() % 360, millis() % 360 );
  penguin.eye( cos(mouseX), sin(mouseY) );
  penguin.draw( );


  rect(-12, -5, 24, 10);
}
///////////////////////////////////////////////////////////////////////////////

float angle ( int x1, int y1, int x2, int y2 ) {
   float dx = x2 - x1, dy = y2 - y1;
   return atan2(dy, d2); 
}
