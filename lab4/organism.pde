///////////////////////////////////////////////////////////////////////////////
// File: organism.pde                 Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Create a colony of cellular organisms that interact with the mouse
//   * Use Classes and Objects
//   * Use an array to organize your Objects
//   * Your Class should have at least three methods in addition to the Constructor
//   * Set at least one property of the Object through the Constructor
//   * Be creative!
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
int WIDTH = 500;
int HEIGHT = 500;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
class FatCat {
  float x, y, s;
  float posx, posy, eye, sx, sy;

  FatCat ( float px, float py, float ps, float r ) {
    x = px; 
    y = py; 
    s = ps; 
    posx = poxy = r;
    eye = -s*0.5;
    sx = random(-5, 5);
    sy = random(-5, 5); 
  }

  void draw ( ) {
    if ( pow(x - WIDTH/2, 2) + pow(y - HEIGHT/2, 2) < pow(WIDTH/2, 2) ) {
      fill( 0 );
      rect( x, y, s, s );
      rect( x, y + s*0.6, s*1.4, s*0.2 ); 
      fill( 250 );
      rect( x, y + s*0.4, s, s*0.2 ); 
      fill( 250, 200, 0 );
      rect( x + eye, y + s*0.4, s*0.2, s*0.2 );
    }
  }

  void move ( Wallet wa ) {
    posx += 0.001;
    posy += 0.001;
    
    if ( wa.size( ) > 0 ) {
      Money temp;
      float di, step = 2;

      di = distance( temp = closest( wa ) );

      if ( di < s/2 ) { 
        eat( wa, temp );
      }
      else {
        if ( di < WIDTH/2 ) {
          x += (temp.x > x ? step : -step);
          y += (temp.y > y ? step : -step);
        }
      }
    }
    x += cos( radians( millis( )/noise( posx ) )/10 ) + sx;
    y += sin( radians( millis( )/noise( posy ) )/10 ) + sy;
    
    if ( x > WIDTH )  { sx *= -1; x -= s; }
    if ( y > HEIGHT ) { sy *= -1; y -= s; }
    if ( x < 0 )      { sx *= -1; x += s; }
    if ( y < 0 )      { sy *= -1; y += s; }
    
    if ( millis() % 50 == 0 && s > 10 ) s -= 1;
  }

  Money closest ( Wallet wa ) {
    float d = WIDTH*HEIGHT;
    float index = wa.size( );
    Money c = new Money( WIDTH, HEIGHT, 5, millis( ) % 2 == 0 );

    for ( Money m : wa.cash ) {
      if ( d > distance( m ) ) d = distance( c = m );
    }
    return c;
  }

  float distance ( Money m ) { 
    return sqrt( pow( x - m.x, 2 ) + pow( y - m.y, 2 ) );
  }

  void eat ( Wallet wa, Money mo ) {
    wa.spend( mo ); 
    s += 1;
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
class Money {
  int x, y, s;
  boolean isCoin;

  Money ( int px, int py, int ps, boolean coin ) {
    x = px; 
    y = py; 
    s = ps; 
    isCoin = coin;
  }

  void draw ( ) {
    if ( isCoin ) {
      fill( 250, 250, 0 );
      ellipse( x, y, s, s );
    }
    else {
      fill( 0, 250, 0 );
      rect( x, y, s*1.5, s );
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
class Wallet {
  ArrayList<Money> cash;

  Wallet( ) { 
    cash = new ArrayList<Money>( );
  }

  void draw( ) { for ( Money m : cash ) m.draw( ); }

  void push ( ) {
    if ( pow(mouseX - WIDTH/2, 2) + pow(mouseY - HEIGHT/2, 2) < pow(width/2, 2) )
      cash.add( new Money( mouseX, mouseY, 5, millis( ) % 2 == 0 ) );
  }

  void spend( Money m ) { 
    cash.remove( m );
  }
  int size( ) { 
    return cash.size();
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
ArrayList<FatCat> fc;
Wallet w;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  size( 500, 500 ); 

  fc = new ArrayList<FatCat>( );
  
  for ( int i = 0; i < 10; ++i )
    fc.add( new FatCat( random( 0, width ), random( 0, height ), 10, i ) );

  w = new Wallet( );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw ( ) {
  noStroke( );
  rectMode( CENTER );
  background( 0 );

  fill( 150, 150, 150 );
  ellipse( WIDTH/2, HEIGHT/2, WIDTH, HEIGHT );

  w.draw( );
  for ( FatCat c : fc ) {
    c.draw( );
    c.move( w );
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void mouseDragged() { 
 if ( millis( ) % 5 == 0 ) w.push( );
}
void mousePressed( ) { 
  w.push( );
}
///////////////////////////////////////////////////////////////////////////////


