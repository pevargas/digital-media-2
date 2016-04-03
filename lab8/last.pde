///////////////////////////////////////////////////////////////////////////////
// File:   final.pde                  Fall 2013
// Author: Patrick Vargas             patrick.vargas@colorado.edu
// Professor Harriman, Digital Media 2, University of Colorado Boulder
// Description:
//   Maps lightening for the past year.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Class for storing all the data in the table
class Data {
  int event_id;
  int begin_date;
  String display_date;
    int begin_time;
  int deaths_direct, injuries_direct;
  int damage_property_num, damage_crops_num;
  String city;
  float latitude, longitude;

  Data( int a, int b, String c, int d, int e, int f, 
  int g, int h, String i, float j, float k ) {
    event_id            = a;
    begin_date          = b;
    display_date        = c;
    begin_time          = d;
    deaths_direct       = e;
    injuries_direct     = f;
    damage_property_num = g;
    damage_crops_num    = h;
    city                = i;
    latitude            = j;
    longitude           = k;
  }
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
ArrayList<Data> base; 
String[] database;
String[] line;
int index;
PImage img;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void setup( ) {
  // Original Size 1058, 775
  size( 819, 600 );

  base = new ArrayList<Data>( );
  database = loadStrings( "lightening.csv" );
  img = loadImage( "colorado.png" );

  for ( int i = 1; i < database.length; i++ ) {
    line = split( database[i], "," );

    Data temp = new Data( int( line[0] ), int(line[1]), 
    line[2], int( line[3] ), int( line[4] ), 
    int( line[5] ), int( line[6] ), int( line[7] ), line[8], 
    float( line[9] ), float( line[10] ) );

    base.add( temp );
  }  

  index = 0;
  image( img, 0, 0, width, height );
  fill( 255 );
  rect( 0, 0, width, height );
  noStroke( );
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
void draw( ) {
  tint( 255, 20 );
  image( img, 0, 0, width, height );

  Data temp = base.get( index++ );
  if ( index == base.size( ) ) index = 0;

  float x = map( temp.latitude, 37, 41, 0, width );
  float y = map( temp.longitude, -109.05, -102.05, 0, height );
  int size = 5;

  if ( temp.deaths_direct > 0 ) {
    fill( 250, 0, 0 );
    text( temp.deaths_direct, x + size, y + size );
  }
  else if ( temp.injuries_direct > 0 ) {
    fill( 250, 0, 250 );
    text( temp.injuries_direct, x + size, y + size );
  }
  else if ( temp.damage_property_num > 0 ) {
    fill( 0, 200, 100 );
    text( "$"+temp.damage_property_num, x + size, y + size );
  }
  else if ( temp.damage_crops_num > 0 ) {
    fill( 0, 100, 250 );
    text( "$"+temp.damage_crops_num, x + size, y + size );
  }
  else
    fill( 250, 200, 0 );
  ellipse( x, y, size, size );

  fill( 0 );
  rect( 0, height - 20, width, 20 );
  fill( 250 ); 
  text( "Date: " + temp.display_date, 10, height - 5 );

  fill( 250, 0, 0 );
  ellipse( 140, height - 10, size, size );
  text( "Direct Deaths", 150, height - 5 );

  fill( 250, 0, 250 );
  ellipse( 250, height - 10, size, size );
  text( "Direct Injuries", 260, height - 5 );

  fill( 0, 200, 100 );
  ellipse( 360, height - 10, size, size );
  text( "Property Damage", 370, height - 5 );

  fill( 0, 100, 250 );
  ellipse( 490, height - 10, size, size );
  text( "Crop Damage", 500, height - 5 );

  fill( 250, 200, 0 );
  ellipse( 600, height - 10, size, size );
  text( "General Lightning Strike", 610, height - 5 );
}
///////////////////////////////////////////////////////////////////////////////


