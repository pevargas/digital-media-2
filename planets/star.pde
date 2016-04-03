///////////////////////////////////////////////////////////////////////////////
// Class for our Planetary Objects
class Star {
  float x, y, s, z;
  color c;
 
  Star( float px, float py,float pz,float ps, color pc ) {
    x = px; y = py; s = ps; c = pc; z = pz;
  }
  
  void draw() {
    pushMatrix( );
    translate( x, y, z );
    rotateX( frameCount * 0.05 );
    fill( c );
    sphere( s );
    popMatrix( ); 
  }
}

class Planet extends Star {
  float p, d; // Speed, Distance
  float angle;
  float mx, my, mz;
  float ax, ay, az;
  
  Planet( float px, float py, float pz, float ps, color pc, float pp, float pd ) {
    super( px, py, pz, ps, pc );
    angle = 0; p = pp; d = pd;
    ax = random( 0.1, 1 ); ay = random( 0.1, 1 ); az = random( 0.1, 1 );
  }
  
  void getMaster( Star s ) {
    mx = s.x;
    my = s.y;
    mz = s.z;
  }
  
  void update( ) {
    x = cos( radians( angle ) )*d*ax + mx;
    y = sin( radians( angle ) )*d*ay + my;
    z = sin( radians( angle += p ) )*d*az + mz;
  }
}

class SpaceShip extends Star {
  SpaceShip( float px, float py, float pz, float ps, color pc ) {
    super( px, py, pz, ps, pc );
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// This class holds all of our celestial bodies. The even numbers are the planets
//   and the odd are the moons corresponding to those planets.
class System {
  ArrayList<Planet> system;
  
  System( ) {
    system = new ArrayList<Planet>( );
    Planet temp;
    for ( int i = 0; i < 8; ++i ) {
                      // x                y                 z  size              color             speed        distance
      temp = new Planet( random(width/2), random(height/2), 0, random( 10, 20 ), color( #00AAFF ), random( 4 ), random( 40, width ) );       
      system.add( temp );
                             //x                y                 z  size       color             speed                 distance
      system.add( new Planet(  random(width/2), random(height/2), 0, temp.s/2,  color( #FFAA00 ), random( temp.p, 10 ), temp.s*2 ) );
    }  
  }
  
  void draw( Star s ) {
    Planet p, m; // Planet and Moon
    for ( int i = 0; i < system.size( ); i += 2 ) {
      p = system.get( i ); m = system.get( i + 1 );
      p.getMaster( s );    m.getMaster( p );
      p.draw( );           m.draw( );      
      p.update( );         m.update( );
      system.set( i, p );  system.set( i + 1, m );
    }
  }

}
///////////////////////////////////////////////////////////////////////////////

