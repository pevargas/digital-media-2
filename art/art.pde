///////////////////////////////////////////////////////////////////////////////
// File: art.pde                      Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Using Processing only, create a piece of interactive generative art
//   * There must be at least three clear ways that the user interacts with
//     the artwork
//   * Structure your code using functions
//   * You may not import any images. All graphics must be created from within
//     Processing.
//   * Conceptually, this project should explore how generative art changes how 
//     we understand the relationships between the artist, the computer, and
//     the user.
//
// README:
//   After five seconds of inactivity, the program will recite Lewis Carroll's
//   "Alice's Adventures in Wonderland". 
//     * Pressing the up and down key's will change the speed of the recitation.
//     * Pressing enter or return will clear both the text and boxes
//     * Pressing any other key will pause the recitation and allow the user
//       to tell thier own story. But only five seconds after the last key
//       stroke.
// 
// Resources:
//   Lewis Carrol's "Alice's Adventures in Wonrderland" provided by Project 
//   Gutenberg. <http://www.gutenberg.org/ebooks/11>
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Global Variables
int step = 25, fade = 250, time = 250, speed = 1000, index = 0;
float timer, pressed = 0;
String dir, filler;
String [] hold;
Rubik norlin;
Book story;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Class to make square
class Square {
  //
  // Member variables
  //
  int x, y, s; // Position and size
  color c;     // Color
 
  //  
  // Constructor
  //
  Square( int px, int py, int ps, color pc ) {
    x = px; y = py; s = ps; c = pc;
  }
  // Copy Constructor
  Square( Square o ) { // other
    x = o.x; y = o.y; s = o.s; c = o.c; 
  }

  //
  // Member Methods
  //

  // A draw funciton to draw a square with a color
  void draw( ) {
    fill( c );
    rect( x, y, s, s );
  }
  
  // Process the typed input
  void process( char acter ) {
    move( acter );
    change( acter );
  } // process( )
  
  // Color the square based on input
  void change( char acter ) {
    // Variables
    float r = red( c ), g = green( c ), b = blue( c );
    
    
    // When I don't use random color, it tends toward only the blue sector.
    // Using random generates a more colorful pattern. Just an interesting note.
    switch( (int) acter % 3 ) {
      case 0: 
        r += step*random(-1, 1);
//        if ( (int) acter % 2 == 0 ) r += step;
//        else r -= step;
        break;
      case 1: 
        g += step*random(-1, 1);
//        if ( (int) acter % 2 == 0 ) g += step;
//        else g -= step;
        break;
      case 2:
        b += step*random(-1, 1); 
//        if ( (int) acter % 2 == 0 ) b += step;
//        else b -= step;
        break;      
    }
    
    // Check overflow or underflow
    if ( r > 255 ) r = 250;
    if ( g > 255 ) g = 250;
    if ( b > 255 ) b = 250;
    if ( r <   0 ) r = 0;
    if ( g <   0 ) g = 0;
    if ( b <   0 ) b = 0;
  
    // Put the new color back
    c = color( r, g, b );
  } // change( )
  
  // Move the square based on the typed input
  void move( char acter ) {
    // Variables
    int px = x, py = y;
    
    // Letter frequency: e it san hurdm wgvlfbk opjxcz yq
    switch( acter ) {
      case 'e': case 'a': 
      case 'r': px += step; break;
      case 'i': case 'n': 
      case 'd': px -= step; break;
      case 't': case 'h': 
      case 'm': py += step; break;
      case 's': case 'u': 
      case 'w': py -= step; break;
    }
    
    // Check overflow or underflow
    if ( px > width ) px = 0;
    if ( px < 0 ) px = width-step;
    if ( py > height ) py = 0;
    if ( py < 0 ) py = height-step;
    
    x = px; y = py; 
  } // move( )

}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Class full of squares
class Rubik {
  //
  // Memeber Variables
  //
  ArrayList<Square> boxes;  

  //
  // Class Constructor
  //
  Rubik ( ) {
    boxes = new ArrayList<Square>( );
    boxes.add(new Square(width/2 - step, height/2 - step, step, color(150, 150, 150)));
  }
  
  //
  // Memeber methods
  //
  void draw ( ) { for ( Square b : boxes ) b.draw( ); blink( ); }
  void fresh( ) {
    boxes.clear();
    boxes.add(new Square(width/2 - step, height/2 - step, step, color(150, 150, 150)));     
  }
  Square top ( ) { return boxes.get( boxes.size( ) - 1 ); }
  void pop ( ) { 
    if ( boxes.size() != 0 ) boxes.remove( boxes.size( ) - 1 ); 
  }
  void push ( char acter ) {
    Square top, temp; 
  
    top = new Square( boxes.get( boxes.size( ) - 1 ) );
    top.process( acter );
    
    for ( int i = 0; i < boxes.size(); ++i ) {
      temp = boxes.get( i );
      if ( temp.x == top.x && temp.y == top.y ) { 
        boxes.remove( i );
        break;
      }
    } 
    top.c = color(red(top.c), green(top.c), blue(top.c), 255);
    boxes.add( top );
  } // push ( )
  
  void blink ( ) {
    top( ).c = color(red(top( ).c), green(top( ).c), blue(top( ).c), time -= 3 );
    if ( time < 100 ) time = 250;
  }
} // class Rubik
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Class for story telling
class Book {
  //
  // Member Variables
  //
  ArrayList txt;
  
  //
  // Constructor
  //
  Book() {
    txt = new ArrayList( );
    for ( int i = 0; i < 15; ++i ) push( new Character(' ') );
  } 
  
  //
  // Member Methods
  //
  void pop ( ) { if ( txt.size() != 0 ) txt.remove( txt.size( ) - 1 ); }
  void fresh( ) {
    txt.clear( );
    for ( int i = 0; i < 15; ++i ) push( new Character(' ') );    
  }
  void draw ( ) {
    int i;
    int part = 255/20;
    String temp;

    for( i = 0; i < txt.size( ); ++i ) {
      temp = txt.get( i ).toString( );
      fill( 255, part*i ); 
      text(temp, step*i + 100, height-100);
    }
  }
  void push( char acter ) {
    if ( acter == CODED ) {
      if ( keyCode == DELETE || keyCode == BACKSPACE ) pop( );
    }
    else {
      txt.add( acter );
      if ( txt.size( ) > 20 ) txt.remove( 0 );      
    }
  } // push( )
} // class Book 
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {  

  // Set up window
  size( 1000, 600 );

  PFont font = loadFont( "Courier New" );
  textFont(font, step);
  
  dir = "Tell me a story.";
  hold = loadStrings( "alice_in_wonderland.txt" );
  filler = "\0";
  
  for ( int i = 0; i < hold.length; ++i )
    filler += hold[i];
 
  norlin = new Rubik( );
  story  = new Book( );
  
  timer = millis();
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
//  noStroke();
  stroke( 255 );
  background( 0 );
  
  norlin.draw( );
  story.draw( );
    
  fill( 255, fade );
  text( dir, 625, height - 100);

  if ( millis() - pressed > 5000 ) {
    if ( millis() - timer > speed ) {
      if ( index < filler.length() ) {
        Character temp = new Character( filler.charAt( index++ ) );
        norlin.push( temp ); 
        story.push( temp );
      }
      timer = millis();
      if ( speed > 200 ) speed -= 100;
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void keyPressed() {
  char temp;

  if ( keyCode == UP ) speed -= 100;
  else if ( keyCode == DOWN ) speed += 100;
  else if ( keyCode == ENTER || keyCode == RETURN ) {
    norlin.fresh( );
    story.fresh( );
  }
  else {
    pressed = millis();
    speed = 1000;
    norlin.push( key );
    story.push( key );
    if ( fade != 0 ) fade -= 10;
  }
  
  if ( speed < 0 ) speed = 0;
}
///////////////////////////////////////////////////////////////////////////////


