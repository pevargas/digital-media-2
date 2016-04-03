///////////////////////////////////////////////////////////////////////////////
// File: planets.pde                  Fall 2013
// Authors: Andy Davis                andy.davis@colorado.edu
//          Patrick Vargas            patrick.vargas@colorado.edu
//          Dan Swigert               daniel.swigert@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   In groups of two, create a solar system from a distant galaxy. Your solar
//   system should have at least five planets that orbit a sun, and each planet 
//   should have at least one orbiting moon. Do your best to make it pretty! 
//   Add a stars, asteroids, comets, spaceships, blackholes, etc.
// References:
//   http://en.wikipedia.org/wiki/Kepler's_laws_of_planetary_motion
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
Star sun;
System cluster;
Comet haley;
Twinkle galaxy;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  size( displayWidth/2, displayHeight/2, P3D );
  rectMode( CENTER );
  noStroke();
  sun = new Star( width/2, height/2, 0, 50/2, color( #FFFFFF ) );  
  
  cluster = new System( );  
  
  galaxy = new Twinkle( );
  haley = new Comet( 10/2, color( 255, 255, 170 ) );
}
///////////////////////////////////////////////////////////////////////////////

int x = 0;

///////////////////////////////////////////////////////////////////////////////
void draw() {
  if ( x < 300 ) {
    background( 0 ); 
    camera( 100, 360, 200, width/2, height/2, 0, 0, 0,-1 );
    hint( ENABLE_DEPTH_TEST );
    
    ambientLight( red( sun.c ), green( sun.c ), blue( sun.c ), sun.x, sun.y, sun.z );
  
    haley.draw();
  
    sun.draw();
    pointLight( red( sun.c ), green( sun.c ), blue( sun.c ), sun.x, sun.y, sun.z );
    
    cluster.draw( sun );
  
    camera( );
    hint( DISABLE_DEPTH_TEST );
    galaxy.draw();
    x++;
  }
  else {
    noLoop( );
  }

   saveFrame("gif/planets-###.png"); 
}
///////////////////////////////////////////////////////////////////////////////

