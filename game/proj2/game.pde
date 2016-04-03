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

///////////////////////////////////////////////////////////////////////////////
// This is our enemy class.
class Enemies {
  ArrayList<Enemy> horde;
  ArrayList<Missile> clip;
  int level, neut;
  
  Enemies( int l ) {
    horde = new ArrayList<Enemy>( );
    clip = new ArrayList<Missile>( );
    neut = 100;
    for( int i = 0; i < (level = l); ++i )
      horde.add( new Enemy( i % 2 == 0 ? true : false ) );
  }

  ///////////////////////////////////////
  
  void draw( ) {
    ArrayList<Missile> temp = new ArrayList<Missile>( );
    
    for ( Enemy e : horde )
      e.draw( ); 
    
    for ( Missile m : clip ) {
      m.draw( );
      if ( millis( ) - m.t > 2500 )
        temp.add( m );
    }
    
    for ( Missile m : temp )
      clip.remove( m );
      
    temp.clear( ); 
    hit();
  }

  ///////////////////////////////////////
  
  void hit( ) {
    ArrayList<Enemy> temp = new ArrayList<Enemy>( );
    
    for ( Enemy e : horde ) {
      if ( clip.remove( isHit( e ) ) ) {
        temp.add( e );
        if ( e.isGood ) neut -= 5;
        else            neut += 5;

      }
        
      if ( e.isDead ) { 
        temp.add( e );
        if ( e.isGood ) neut += 5;
        else            neut -= 5;

      }
    }
    
    if ( neut < 0 )   neut = 0;
    if ( neut > 200 ) neut = 200;

    for ( Enemy e : temp )
      horde.remove( e );
      
    temp.clear( ); 
  }

  ///////////////////////////////////////

  Missile isHit( Enemy e ) {
    for ( Missile m : clip )
      if ( dist( e.x, e.y, m.x, m.y ) < e.s )
        return m;
      
    return new Missile( -1, -1, -1, -1 );
  }

  ///////////////////////////////////////

  void fire( float px, float py, float pa, float pv ) {
    if ( clip.size( ) < 20 ) {
      clip.add( new Missile( px, py, pa, pv ) );
    }
  }
  
  ///////////////////////////////////////
  
  int size( ) { return horde.size( ); }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
class Enemy {
  float x, y, vx, vy, a, s;
  float[] pts; boolean isGood, isDead;
  
  Enemy( boolean bool ) {
    x = random( width ); y = random( height );
    a = random( 360 );
    s = random( 50, 100 );
    vx = cos( radians( a ) );
    vy = sin( radians( a ) );
    isGood = bool;
    isDead = false;
    
    pts = new float[] { random( -s ), random( -s ), random( s ), random( -s ), 
                        random( -s ), random( s ), random( s ), random( s ) };
  } 
  
  ///////////////////////////////////////
  
  void draw ( ) {
    x += vx;
    y += vy;
    
    if ( 0 > x ) x = width;
    if ( x > width ) x = 0;
    if ( 0 > y ) y = height;
    if ( y > height ) y = 0;
    
    pushMatrix( );
    translate( x, y );
    rotate( a += 0.01 );

    if ( isGood ) fill( 170, 250, 170, 200 );
    else          fill( 250, 170, 170, 200 );
    
    quad( pts[0], pts[1], pts[2], pts[3], pts[4], pts[5], pts[6], pts[7] );

    if ( isGood ) {
      fill( 170, 250, 170, 100 );
      ellipse( 0, 0, s, s );
      ellipse( pts[0], pts[1], s*0.25, s*0.25 ); ellipse( pts[2], pts[3], s*0.25, s*0.25 ); 
      ellipse( pts[4], pts[5], s*0.25, s*0.25 ); ellipse( pts[6], pts[7], s*0.25, s*0.25 );
    }
    else {
      fill( 250, 170, 170, 100 );
      rect( 0, 0, s, s );
      rect( pts[0], pts[1], s*0.25, s*0.25 ); rect( pts[2], pts[3], s*0.25, s*0.25 ); 
      rect( pts[4], pts[5], s*0.25, s*0.25 ); rect( pts[6], pts[7], s*0.25, s*0.25 );
    }

    popMatrix( );
  }
}
///////////////////////////////////////////////////////////////////////////////

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


