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

///////////////////////////////////////////////////////////////////////////////
// Class to make penguin-bot
class Bot {
  // Member variables
  int x, y, s; // Position and size
  
  // Constructor
  Bot( int px, int py, int ps ) {
    x = px; y = py; s = ps;
  }

  // Member Methods
  void draw ( ) {
    translate(x, y);
    roll( );
    fill( 0 );
    ellipse( 0, 0, s, s ); // Body
    fill( 255 );
    ellipse( 0, s*0.1, s*0.8, s*0.8 ); // Tux
    
    fill( 255, 150, 0 );
    arc( 0, -s*0.24, s*0.15, s*0.15, PI*1.25, PI*1.75); // Beak
    eye( );
  }
  
  void eye ( ) {
    float [] eye = new float[4];
    float [] a   = new float[2];
    eye[0] = -s*0.1;  // LX
    eye[1] = -s*0.35; // LY
    eye[2] = s*0.1;   // RX
    eye[3] = -s*0.35; // RY
    a[0] = atan2(mouseY-y-eye[1], mouseX-x-eye[0]);
    a[1] = atan2(mouseY-y-eye[3], mouseX-x-eye[2]);
    
    fill( 255 );
    ellipse( eye[0], eye[1], s*0.1, s*0.1 ); // Eye-L
    ellipse( eye[2], eye[3], s*0.1, s*0.1 ); // Eye-R

    fill( 0 );
    ellipse( eye[0]+cos(a[0])*s*0.01, eye[1]+sin(a[0])*s*0.01, s*0.05, s*0.05 ); // Pupil-L
    ellipse( eye[2]+cos(a[1])*s*0.01, eye[3]+sin(a[1])*s*0.01, s*0.05, s*0.05 ); // Pupil-R
  }
  void roll ( ) {
    float a = sin(mouseX/width - width/2);
    translate( ( a/TWO_PI )*s, 0 );
    rotate(a);
  }
  void scale( float amt ){
    if ( amt != 0 ) s *= amt;
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Global Variables
Bot penguin;
ArrayList<penguin> flock;
float init;
float time;
boolean isMoving = true;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  // Set up window
  size( 1000, 500 );
  
  // Initalize variables
  init = width*0.25;
  flock = new ArrayList<penguin>( );
  flock.add( new Bot( width/2, height/2, init ) );
  time = second();
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  
  background( color( 0, 140, 255, 200 ) );
  noStroke();
 
  // Draw the penguins
  for ( Bot p : flock ) {
    if ( p.s < 1 ) flock.remove(p); 
    pushMatrix();
    p.draw( );
    popMatrix();
  }
  
  // Make more penguins 
  if ( isMoving ) {
    if ( second() - time > (mouseY/height) ) {
      newPenguin();
      time = second(); 
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void newPenguin() {
  Bot temp = flock.get( flock.size( ) - 1 );
  flock.add( new Bot( mouseX, temp.y, temp.s ) );

  for ( int i = flock.size() - 2; i >= 0; --i ) {
    temp = flock.get( i );
    temp.scale( 0.8 );
    flock.set( i, temp );
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void mouseClicked() {
  if ( isMoving ) isMoving = false;
  else            isMoving = true;
}
///////////////////////////////////////////////////////////////////////////////


