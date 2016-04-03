///////////////////////////////////////////////////////////////////////////////
// File: animation.pde                 Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Explore the use of time as a medium, creating time varying changes to 
//   the visuals.
//     Create an animated pattern
//     * Use nested "for" loops to create the pattern.
//     * Do not load any external imagery. All imagery should be made inside 
//       Processing.
//     -or-
//     Create an animated, and unconventional representation of time
//     * Use at least one for loop in your code.
//     * Avoid conventional representations of time (clocks, hour-glasses, 
//       sun and moon, seasons, etc.)
//     * You may not use any numbers.
//     * Do not load any external imagery. All imagery should be made
//       inside Processing.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Class to make Dots
class Dot {
  // Member variables
  int x, y, r;
  color c;
 
  // Constructor
  Dot( int px, int py, int pr, color pc ) {
    x = px; y = py; r = pr; c = pc;
  }

  // Member Methods
  void draw ( ) {
    fill( c );
    ellipse( x, y, r, r );
  }
  
  // Function to calculate distance between two points
  int distance ( int a, int b ) {
    return (int) sqrt( pow(x - a, 2) + pow(y - b, 2) ); 
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Global Variables
boolean forward;
int time, angle;
Dot pupil, blink;
ArrayList<Dot> dots;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {  
  // Variables
  color temp;
  
  // Set up window
  size( 1000, 500 ); 
  
  // Instantiate dot array
  dots = new ArrayList<Dot>( );
  
  // Fill dot array
  for ( int i = 0; i < 36; ++i )
    dots.add( new Dot( 0, 0, 45, color( 255, 255, 255, 100 ) ) );

  // Initialize other parts
  pupil = new Dot(0, 0, 150, color( 0, 0, 0, 255 ) );
  blink = new Dot(width/2, -height*2, width*2, color( 0, 0, 0, 255 ) );

  // Initialize Constants
  time = 0;
  forward = true; 
  angle = 360 / dots.size( );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  // Variables
  Dot tempa, tempb;

  // Move time forward
  time++;
  
  // Color ALL the things
  background( color( 0, 140, 255, 200 ) );
  noStroke();

  // Draw white part  
  for ( int i = 0; i < dots.size( ); i += 2 ) {
    tempa = dots.get( i );
    tempa.x = ( width/2 ) + cos( radians ( time*2 + i*angle ) )*(450);
    tempa.y = ( height/2 ) + sin( radians ( time*2 + i*angle ) )*(450);
    tempa.r = height/2;
    tempa.draw( );
    dots.set( i, tempa );

    tempb = dots.get ( i + 1 );
    tempb.x = ( width/2 ) + cos( radians ( -time + i*angle ) )*(450);
    tempb.y = ( height/2 ) + sin( radians ( -time + i*angle ) )*(450);
    tempb.r = width/2;
    tempb.draw( );
    dots.set( i + 1, tempb );
  }

  // Draw pupil
  pupil.x = ( width*0.5 ) + cos( radians ( time ) ) * 90;
  pupil.y = height/2 + 50;
  pupil.draw( );
  
  // Draw blink
  if ( forward ) blink.y += 100;
  else blink.y -= 100;

  if ( blink.y < -height*40 ) forward = true;
  else if ( blink.y > height ) forward = false;

  blink.draw( );
}
///////////////////////////////////////////////////////////////////////////////


