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
  size( displayWidth, displayHeight, P3D );
  rectMode( CENTER );
  noStroke();
  sun = new Star( width/2, height/2, 0, 50/2, color( #FFFFFF ) );  
  
  cluster = new System( );  
  
  galaxy = new Twinkle( );
  haley = new Comet( 10/2, color( 255, 255, 170 ) );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
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

}
///////////////////////////////////////////////////////////////////////////////

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


