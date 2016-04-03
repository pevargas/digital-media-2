///////////////////////////////////////////////////////////////////////////////
// File:   video.pde                  Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Makes some sort of video application hopefully reminciant of arcylic.
// Built upon:
//   Learning Processing
//   Daniel Shiffman
//   http://www.learningprocessing.com
//   Example 16-7: Video pixelation
// Movies from:
//   BBC Motion Gallery
//   http://www.bbcmotiongallery.com/
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
import processing.video.*;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Variable to hold onto Capture object
Capture video;

color[] arcylic = {
  #F207B4,
  #0F88F2,
  #FF9906,
  #07F242,
  #EBF20F
};

int cycle = 0;
int mov   = 0;
float timer;
boolean addImage = true;

PImage current, edgeImg;
ArrayList<PImage> album;

// Step 1. Declare Movie object list
ArrayList<Movie> movies; 
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup() {
  size(640*2,480*2);
  
  // Step 2. Initialize Movie object
  movies = new ArrayList<Movie>( );
  // Movie files should be in data folder
  movies.add(new Movie( this, "balloons.mov" ) ); 
  movies.add(new Movie( this, "business.mov" ) ); 
  movies.add(new Movie( this, "cat.mov" ) ); 
  movies.add(new Movie( this, "chess.mov" ) ); 
  movies.add(new Movie( this, "fish.mov" ) ); 
  movies.add(new Movie( this, "graph.mov" ) ); 
  movies.add(new Movie( this, "ipad.mov" ) ); 
  movies.add(new Movie( this, "squirrel.mov" ) ); 
  movies.add(new Movie( this, "street.mov" ) ); 

  album = new ArrayList<PImage>( );
  
  // Step 3. Start movie playing
  for ( Movie m : movies )
    m.loop();
  
  timer = millis( );
  video = new Capture( this, width, height );
  video.start( );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Step 4. Read new frames from movie
void movieEvent( Movie movie ) {
  movie.read();
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw() {
  background( 0 );
  
  // Each cycle lasts for 5 seconds  
  if ( millis( ) - timer > 5000 ) {
    cycle++;
    timer = millis( );
    addImage = true;
    if ( cycle % 2 == 1 ) {
      movies.get( mov++ % movies.size( ) ).pause( );
      movies.get( mov % movies.size( ) ).play( );
    }
  }

  // Halfway through the cycle, add the image to the album stack.  
  if ( (millis( ) - timer > 2400) && addImage ) {
    album.add( edgeImg );
    addImage = false;
    if ( album.size( ) > 5 )
      album.remove( 0 );
  }
  
  // At exactly half, switch to the photo album
  if ( millis( ) - timer < 2500 ) {    
    // Every other cycle get image from the built-in camera
    if ( cycle % 2 == 0 ) {
      // Read image from the camera
      if ( video.available( ) ) video.read();
  
      video.loadPixels( );
      current = createImage( video.width, video.height, ARGB );
      current.copy( video, 0, 0, video.width, video.height, 0, 0, current.width, current.height );
    }
    // And on the other cycle, get image from loaded video clips.
    else {
      // Step 5. Display movie.
      Movie m = movies.get( mov % movies.size( ) );
      current = createImage( m.width, m.height, ARGB );
      current.copy( m, 0, 0, m.width, m.height, 0, 0, current.width, current.height );
    }

    edgeImg = createImage( current.width, current.height, ARGB );
      
    for ( int y = 0; y < current.height; ++y ) {
      for ( int x = 0; x < current.width; ++x ) {
        int pos = y*current.width + x;
        float val = red(current.pixels[pos]) + green(current.pixels[pos]) + blue(current.pixels[pos]);
        val /= 3;
        
        color c;
        if ( val > 250 ) {
          c = color(
            red(arcylic[cycle % 5]), 
            green(arcylic[cycle % 5]), 
            blue(arcylic[cycle % 5]), 
            250
          );
        }
        else if ( val > 200 ) {
          c = color(
            red(arcylic[cycle % 5]), 
            green(arcylic[cycle % 5]), 
            blue(arcylic[cycle % 5]), 
            200
          );
        }
        else if ( val > 150 ) {
          c = color(
            red(arcylic[cycle % 5]), 
            green(arcylic[cycle % 5]), 
            blue(arcylic[cycle % 5]), 
            150
          );
        }
        else { 
          c = color( 
           red(arcylic[cycle % 5]), 
           green(arcylic[cycle % 5]), 
           blue(arcylic[cycle % 5]), 
           0
          ); 
        }
        edgeImg.pixels[y*current.width + x] = c;
      }
    }
  
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels( );
    image(edgeImg, 0, 0, width, height ); // Draw the new image
  }
  else {
    if ( album.size() > 0 ) {
      int count = (album.size( )-1) * 5;
      int i;
      for ( PImage p : album ) {
        pushMatrix( );
        translate( count, count );
//        rotate( radians( count ) );
        if ( p != null ) image( p, 0, 0, width, height );
        translate( count+5, count+5 );
        if ( p != null ) image( p, 0, 0, width, height );
        count -= 5; 
        popMatrix( );
      }
    }
  }
}
///////////////////////////////////////////////////////////////////////////////


