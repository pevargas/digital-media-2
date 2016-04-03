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

