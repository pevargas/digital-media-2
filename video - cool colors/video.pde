// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-7: Video pixelation

import processing.video.*;

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

// Step 1. Declare Movie object
ArrayList<Movie> movies; 

void setup() {
  size(640,480);
  
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
  
  // Step 3. Start movie playing
  for ( Movie m : movies )
    m.loop();
  
  timer = millis( );
  video = new Capture( this, width, height );
  video.start( );
}

// Step 4. Read new frames from movie
void movieEvent( Movie movie ) {
  movie.read();
}

void draw() {
  background( arcylic[(cycle + 3) % 5] );
  if ( millis( ) - timer > 2500 ) {
    cycle++;
    timer = millis( );
    if ( cycle % 2 == 1 ) {
      movies.get( mov++ % movies.size( ) ).pause( );
      movies.get( mov % movies.size( ) ).play( );
    }
  } 
  
  if ( cycle % 2 == 0 ) {
    // Read image from the camera
    if ( video.available() ) video.read();

    video.loadPixels( );
    PImage edgeImg = createImage( video.width, video.height, ARGB );
    
    for ( int y = 0; y < video.height; ++y ) {
      for ( int x = 0; x < video.width; ++x ) {
        int pos = y*video.width + x;
        float val = red(video.pixels[pos]) + green(video.pixels[pos]) + blue(video.pixels[pos]);
        val /= 3;
        
        color c;
        if ( val > 200 ) {
          c = color(  
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 0
          );
        }
        else if ( val > 150 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 50
          );
        }
        else if ( val > 100 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 100
          );
        }
        else if ( val > 50 ) {
          c = color( 
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 150
          );
        }
        else { c = color( 0, 0, 0, 250 ); }
        edgeImg.pixels[y*video.width + x] = c;
      }
    }
  
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels();
    image(edgeImg, 0, 0, width, height ); // Draw the new image
  }
  else {
    // Step 5. Display movie.
    Movie current = movies.get( mov % movies.size( ) );
    PImage edgeImg = createImage( current.width, current.height, ARGB );
    
    for ( int y = 0; y < current.height; ++y ) {
      for ( int x = 0; x < current.width; ++x ) {
        int pos = y*current.width + x;
        float val = red(current.pixels[pos]) + green(current.pixels[pos]) + blue(current.pixels[pos]);
        val /= 3;
        
        color c;
        if ( val > 200 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 0
          );
        }
        else if ( val > 150 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 50
          );
        }
        else if ( val > 100 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 100
          );
        }
        else if ( val > 50 ) {
          c = color(
            red(arcylic[cycle % 5]), green(arcylic[cycle % 5]), blue(arcylic[cycle % 5]), 150
          );
        }
        else { c = color( 0, 0, 0, 250 ); }
        edgeImg.pixels[y*current.width + x] = c;
      }
    }
  
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels();
    image(edgeImg, 0, 0, width, height ); // Draw the new image
  }
}


