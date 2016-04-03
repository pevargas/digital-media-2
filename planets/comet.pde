///////////////////////////////////////////////////////////////////////////////
// Class for a Comet
class Comet {
  float x, y, z, s, dx, dy;
  color c;
  ArrayList<Star> tail;
  
  Comet( float ps, color pc ) {
    s = ps; c = pc;
    
    tail = new ArrayList<Star>( );
    dx = random( 1 ); dy = random( 1 );
    x = random( width ); y = random( height );
    z = 0;
    
    for ( int i = 0; i < s; ++i ) {
      tail.add( new Star( x -= dx*i, y -= dy*i, z, s - i, 
                color( red(c), green(c), blue(c), 250-i*10 ) ) ); 
    }
  }
  
  void update( ) {
    if ( ( x += dx ) > width )  x = 0; 
    if ( ( y += dy ) > height ) y = 0;
    
    tail.get( 0 ).x = x; tail.get( 0 ).y = y;
    
    for ( int i = (int)s; i < 0; --i ) {
      tail.get( i ).x = tail.get( i - 1 ).x;
      tail.get( i ).y = tail.get( i - 1 ).y;
    }
  }
  
  void draw( ) {
//    for( Star s : tail )
//      s.draw( );
    tail.get( 0 ).draw( );
    pointLight( red( c ), green( c ), blue( c ), x, y, z );
    update( );
  }
}
///////////////////////////////////////////////////////////////////////////////

