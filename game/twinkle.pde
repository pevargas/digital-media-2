///////////////////////////////////////////////////////////////////////////////
// Class for background
//   from lab 7
class Star {
  float x, y, s;
  color c;
 
  Star( ) {
    x = random( width ); y = random( height ); s = random(10); 
    c = color( 255, 255, 255, random(10, 255) );
  }
  
  ///////////////////////////////////////

  void draw( ) {
    pushMatrix( );
    translate( x, y );
    fill( c );
    ellipse( x, y, s, s );
    popMatrix( ); 
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
class Twinkle {
  ArrayList<Star> galaxy;
  
  Twinkle () {
    galaxy = new ArrayList<Star>( );
    for ( int i = 0; i < 500; ++i ) {
       galaxy.add( new Star(  ) );
    }
  }
  
  ///////////////////////////////////////

  void draw( ) {
    float t; 
    for( Star s : galaxy ) {
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

