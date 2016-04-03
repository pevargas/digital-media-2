///////////////////////////////////////////////////////////////////////////////
// File:   game.pde                   Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Create a simple game that explores, or comments on, a social or political 
//   issue that is of personal interest to you.
//   * The game doesn't need to be complex (Don't freak out about making a game. 
//     Just start thinking about what you want your game to do).
//   * The game MUST be interactive.
//   * The game must explore or make a commentary on a social or political issue 
//     that is important to you.
//   * We have checkpoint where we discuss ideas prior to the presentation date.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
Ship enterprise;
Enemies klingons;
Twinkle background;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  size( displayWidth, displayHeight );
  noStroke( );
  rectMode( CENTER );

  enterprise = new Ship( width/2, height/2 );
  klingons = new Enemies( 0 );
  background = new Twinkle( );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  background( 0 );
  background.draw( );
  enterprise.draw( klingons );
  klingons.draw( );
  
  if ( klingons.size( ) == 0 ) {
    int temp = klingons.neut;
    klingons = new Enemies( klingons.level + 1 );
    klingons.neut = temp;
  }
  
  color good = color( 170, 250, 170 );
  color evil = color( 250, 170, 170 );
  color c = lerpColor( evil, good, klingons.neut/200.0 );
  fill( c );
  ellipse( width*( klingons.neut/200.0 ), 20+5*sin(radians(millis()/10)), 40, 40 );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void keyPressed( ) {
  enterprise.move( klingons );
}
///////////////////////////////////////////////////////////////////////////////

