///////////////////////////////////////////////////////////////////////////////
// This is our character, in which the player controls. 
class Ship { 
  float x, y, a, s;  // Position X and Y, angle and size
  float av, v, e, g; // angle-velocity, velocity
  float alpha;

  Ship ( float px, float py ) {
    x = px; y = py;
    a = 0;  av = 0; v = 0;
    s = 1;  alpha = 200;
  }

  ///////////////////////////////////////

  void draw ( Enemies e ) {
    if ( av != 0 ) {
      a += av;
      av += ( av > 0 ) ? -1 : 1;
    }
    if ( v != 0 ) {
      x += cos( radians( a ) )*v;
      y += sin( radians( a ) )*v;
      v += ( v > 0 ) ? -1 : 1;
    }
    
    if ( x > width ) x = 0;
    if ( y > height ) y = 0;
    if ( 0 > x ) x = width;
    if ( 0 > y ) y = height;

    for ( Enemy i : e.horde ) {
      if ( isAbsorb( i ) ) {
        i.isDead = true;
      }
    }
    
    switch ( e.neut ) {
      case  50: s = 1.5; break;
      case  40: s = 2;   break;
      case  30: s = 2.5; break;
      case  20: s = 3;   break;
      case  10: s = 3.5; break;
      case   0: s = 4;   break;
      case 160: s = 0.8; break;
      case 170: s = 0.6; break;
      case 180: s = 0.5; break;
      case 190: s = 0.4; break;
      case 200: s = 0.3; break;
    }
    
    if ( e.neut < 60 ) a += noise( 5 );
    
    pushMatrix( );
    translate( x, y );
    rotate( radians( a + 45 ) );
    
    color good = color( 170, 250, 170 );
    color evil = color( 250, 170, 170 );
    color c = lerpColor( evil, good, e.neut/200.0 );
    
    if ( e.neut > 150 ) {
      fill( red(c), green(c), blue(c), alpha -= 10 );
      if ( alpha < 20 ) alpha = 200;
      stroke( c );
      ellipse( 0, 0, 200*(1-s), 200*(1-s) );
      noStroke( );
    }

    fill ( c );
    quad( 5*s, 10*s, 0, 0, -10*s, -5*s, 20*s, -20*s );
    
    popMatrix( );
  }

  ///////////////////////////////////////

  boolean isAbsorb ( Enemy e ) {
    return dist( x, y, e.x, e.y ) < e.s;
  }

  ///////////////////////////////////////

  void move( Enemies e ) {
    switch ( keyCode ) {
      case UP:    v += 15; break;
      case DOWN:  a += 180; v += 15; break;
      case LEFT:  av -= 10; break;
      case RIGHT: av += 10; break;
    }
    switch ( key ) {
    case ' ': 
      e.fire( x, y, a, v ); 
      break;
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

