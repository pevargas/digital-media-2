///////////////////////////////////////////////////////////////////////////////
// Out basic bullet class
class Missile {
  float x, y, vx, vy, a, t;
  
  Missile ( float px, float py, float pa, float pv ) {
    x = px; y = py; a = pa;
    t = millis();
    vx = cos( radians( pa ) )*abs( pv == 0 ? 4 : 4 + pv);
    vy = sin( radians( pa ) )*abs( pv == 0 ? 4 : 4 + pv);
  }
  
  ///////////////////////////////////////

  void draw( ) {
    x += vx;
    y += vy;
 
    if ( x > width ) x = 0;
    if ( y > height ) y = 0;
    if ( 0 > x ) x = width;
    if ( 0 > y ) y = height;
 
    pushMatrix( );
    translate( x, y );
    rotate( radians( a ) );
    fill ( 250 );
    rect( 0, 0, 10, 5 );
    popMatrix( );
  }
}
///////////////////////////////////////////////////////////////////////////////

