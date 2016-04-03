///////////////////////////////////////////////////////////////////////////////
// File: snake.pde                    Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Rework the attached code in an object­oriented fashion and create a 
//   Snake class.
//   * Make multiple objects from the class (Snakes) with slightly different
//     looks (shapes, sizes colors)
//   * Make it pretty by adding some type of background coloring based on the
//     location of the Mouse
// Attached Code Information
//   Learning Processing
//   Daniel Shiffman
//   http://www.learningprocessing.com
//   Example 9-8: A snake following the mouse
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Body Class
class Body {
  int x, y;
  color c;
  
  Body( int px, int py, color pc ) { x = px; y = py; c = pc; }
  void move( Body next ) { x = next.x; y = next.y; }
  void draw( ) {
    fill( c );
    ellipse( x, y, 10, 10 );
  }  
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Snake class
class Snake {
  // Declare two arrays with 50 elements.
  ArrayList<Body> bd;
  int x, y, xdir, ydir, speed, score, r, g, b;
  
  Snake( ) {
    x = width/2; y = height/2;
    xdir = 1;    ydir = 0; 
    speed = 3;   score = 0;
    r = g = b = 0;

    bd = new ArrayList<Body>( );

    // Initialize all elements of each array to zero.
    for ( int i = 0; i < 5; ++i )
      push( new Body( width/2, height/2, color( r, g, b ) ) );

  } 
  
  void move( ) {
    Body current, next;
    for ( int i = size() - 1; i > 0; --i ){
      current = bd.get( i );
      next    = bd.get( i - 1 );
      current.move( next );
      
      bd.set( i, current );
    }

    // Increment based on direction
    if      ( xdir == -1 ) x -= speed;
    else if ( xdir ==  1 ) x += speed;
    if      ( ydir == -1 ) y -= speed;
    else if ( ydir ==  1 ) y += speed;

    // Warp around screen
    if ( x < 0 ) x = width;
    if ( y < 0 ) y = height;
    if ( x > width ) x = 0;
    if ( y > height ) y = 0;

    // Updated
    bd.get( 0 ).x = x;
    bd.get( 0 ).y = y;
  }
  
  void direction( ) {
    if ( key == CODED ) {
      switch( keyCode ) {
        case UP:    xdir =  0; ydir = -1; break;
        case DOWN:  xdir =  0; ydir =  1; break;
        case LEFT:  xdir = -1; ydir =  0; break;
        case RIGHT: xdir =  1; ydir =  0; break;
      }
    }
  }
  
  int size( ) { return bd.size( ); }
  void push( Body b ) { bd.add( b ); }
  void draw( ) { for ( Body b : bd ) b.draw( ); }
  void colornscore( ) {
    timeout -= 2;
    if ( r != 255 )      r++;
    else if ( g != 255 ) g++;
    else if ( b != 255 ) b++;
  }
  void distance( Body b ) { 
    if ( dist(x, y, b.x, b.y ) < 10 ) {
      push( new Body( (int)random( width ), (int)random( height ), color( r, g, b ) ) );
  
      b.x = (int)random( width );
      b.y = (int)random( height );
      b.c = color( (int)random( 255 ), (int)random( 255 ), (int)random( 255 ) );

      colornscore( );
      score += 10;    
      time = 0;
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// SuperSnake class
class SuperSnake extends Snake {
  SuperSnake( ) {
    x = (int) random( width );
    y = (int) random( height );
    r = g = b = 255;
    // Initialize all elements of each array to zero.
    bd.clear();
    for ( int i = 0; i < 5; ++i )
      push( new Body( width/2, height/2, color( r, g, b ) ) );

  }
  
  void colornscore( ) {
    timeout++;
    if ( r != 0 )      r--;
    else if ( b != 0 ) b--;
    else if ( g != 0 ) g--;
  }

  void direction( Body b ) {
    if ( time > timeout ) {
      if ( abs(x - b.x) > 2 ) {
        if      ( x < b.x )    { xdir =  1; ydir = 0; }
        else /* ( x > b.x ) */ { xdir = -1; ydir = 0; }
      }
      else { // ( x - b.x <= y - b.y )
        if      ( y < b.y )    { ydir =  1; xdir = 0; }
        else /* ( y > b.y ) */ { ydir = -1; xdir = 0; }
      }
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
Snake python; SuperSnake cobra;
Body food;
int time, timeout;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  size( 600, 600 );
  
  time = 0;
  timeout = 50;
  textSize( 100 );

  python = new Snake( );
  cobra = new SuperSnake( );
  food = new Body( (int)random( width ), (int)random( height ), 
                   color( (int)random( 255 ), (int)random( 255 ), (int)random( 255 ) ) );  

  ellipseMode(CENTER);
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  noStroke( );
  background( 255 );
  step = 50;
  
  for ( int i = 0; i < width; i += step ) {
    for ( int j = 0; j < height; j += step ) {
      fill( color( red(food.c)-i+cobra.x, 
                   green(food.c)-j+cobra.y, 
                   blue(food.c) - (i+j)/2+(python.x+python.y)/2
                 ) );
      rect( i, j, step, step );
    }
  }

  fill( 0 );
  int diff = python.score - cobra.score;
  text( diff, width/2 - textWidth(diff)/2, height/2 - 100 );
  
  food.draw( );
  python.draw( );
  cobra.draw( );

  python.move( );
  cobra.move( );

  python.distance( food );
  cobra.distance( food );

  cobra.direction( food );

  time++;
  
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void keyPressed( ) { python.direction( ); }
///////////////////////////////////////////////////////////////////////////////


