///////////////////////////////////////////////////////////////////////////////
// Class for background
class FlatStar extends Star { 
  FlatStar( float px, float py, float ps, color pc ) {
    super( px, py, 0, ps, pc );
  }
  
  void draw() {
    pushMatrix( );
    translate( x, y );
//    rotateX( frameCount * 0.05 );
    fill( c );
    ellipse( x, y, s, s );
    popMatrix( ); 
  }
}

class Twinkle {
  ArrayList<FlatStar> galaxy;
  
  Twinkle () {
    galaxy = new ArrayList<FlatStar>( );
    for ( int i = 0; i < 500; ++i ) {
       galaxy.add( new FlatStar( random( width), random( height), random(10), color( 255, 255, 255, random(10, 255) ) ) );
    }
  }
  
  void draw( ) {
    float t; 
    for( FlatStar s : galaxy ) {
      s.draw( );
      
      t = alpha( s.c ) - 1;
      if ( t < 10 ) t = 250;
      s.c = color( 255, 255, 255, t );
     
      if ( s.x++ > width )  s.x = 0; 
      if ( s.y++ > height ) s.y = 0; 
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

