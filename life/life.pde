///////////////////////////////////////////////////////////////////////////////
// File: life.pde                     Fall 2013
// Authors: Patrick Vargas            patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description: 
//   Employ the mathematical concepts from this week's lecture to create a 
//   newly discovered alien species. To receive full credit, your code must
//   include at least four of the following features:
//     * An implementation of the Modulus % operator
//     * An implementation of the Perlin Noise function: noise();
//     * An implementation of probability
//     * An implementation of a Trigonometric function to draw polar coordinates
//     * An implementation of the sin() or cos() function to create oscillation
//     * An implementation of recursion
//     * An implementation of a 2­dimensional array
//   extra credit: structure your life-form as a class so you can create multiple 
//   instances with different parameters
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Extra Credit: Class definition
class Derp {
  float x, y, s, ox, oy, dx, dy, wiggle;
  int[] m;
  color col;
 
  Derp( float px, float py, float ps, color pc ) {
    x = px; y = py; s = ps; col = pc; ox = oy = dx = dy = 0;
    m = new int[6];
    wiggle = random(-6, 5);
  } 
  
  void draw( ) {
    pushMatrix();
    translate( x, y );
    rotate(wiggle*360);
    // Legs
    color l = col - 100;
    float ls = s*0.4;
    float off = sin( radians( millis( ) ) )/2 * wiggle;
    
    fill( l );
    ellipse( + s/2 - ls/3, + s/2 + off - ls/3, ls, ls );    
    ellipse( + s/2 - ls/3, - s/2 + -off + ls/3, ls, ls );    
    ellipse( - s/2 + ls/3, + s/2 + -off - ls/3, ls, ls );    
    ellipse( - s/2 + ls/3, - s/2 + off + ls/3, ls, ls );
    
    // Body
    fill( col );
    ellipse( 0, 0, s, s );
    
    // Spots
    color p = col + 100;
    float ps = s*0.2;
    fill( p );
    ellipse( + ps*0.2,  - ps, ps, ps );
    ellipse( - ps,  - ps*0.2, ps*1.5, ps*1.5 );
    ellipse( + ps*0.5, + ps*0.5, ps*1.3, ps*1.3 );
    popMatrix();
  }
  
  void params( int a, int b, int c, int d, int i, int j ) {
    m[0] = a; m[1] = b; m[2] = c; m[3] = d; m[4] = i; m[5] = j;
  }
  
  void move( ) {
    ox += 0.001*wiggle;
    oy += 0.001*wiggle;
    // Point 1: sin and cos
    // Fun Fact: Using parametric equation for route. See
    //   http://en.wikipedia.org/wiki/Parametric_equation
    dx = cos(m[0] * ox) - pow( cos(m[1] * ox), m[4] );
    dy = sin(m[2] * oy) - pow( sin(m[3] * oy), m[5] );
    // Point 2: Perlin noise
    x = 100*dx + width*noise(ox);
    y = 100*dy + height*noise(oy);
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Point 3: 2 dimensional array
Derp[][] herp;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup ( ) {
  size( 500, 500 );
  noStroke();
  rectMode( CENTER );
  
  herp = new Derp[3][10];
  color[] ca = {
    color( 0, 170, 255 ), color( 0, 255, 170 ),
    color( 170, 255, 0 ), color( 255, 170, 0 ),
    color( 170, 0, 255 ), color( 255, 0, 170 )
  };

  for ( int i = 0; i < 10; ++i ) {
    // Point 4: Modulous
    herp[0][i] = new Derp( width/2, height/2, 50, ca[i%6] );
    herp[1][i] = new Derp( width/2, height/2, 50, ca[(10-i)%6] );
    herp[2][i] = new Derp( width/2, height/2, 50, ca[i%6] );
    
    herp[0][i].params( i+1, 6-i, i+1, 6-i, 3, 3 );
    herp[1][i].params( 6-i, 6-i, i+1, i+1, 3, 3 );
    herp[2][i].params( i+1, 6-i, i+1, 6-i, i+1, i+1 );
  }
}
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
void draw ( ) {
  
  background( 0 );
  for ( int i = 0; i < 10; ++i ) {
    herp[0][i].draw( );
    herp[1][i].draw( );
    herp[2][i].draw( );
    herp[0][i].move();
    herp[1][i].move();
    herp[2][i].move();
  }
}
///////////////////////////////////////////////////////////////////////////////


