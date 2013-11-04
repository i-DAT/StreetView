String postcode = "PL11QH"; // Drakes Circus

String lat,lon;
PImage wholeImage;
float rotation;
boolean shifted, rotateLeft, rotateRight;

void setup()
{
  size(1280,1024);
  PGraphics buffer;
  PImage frontImage, leftImage, backImage, rightImage, upImage;
  setLocationByPostcode(postcode);
  buffer = createGraphics(640,640,P2D);
  buffer.beginDraw();
  backImage = loadStreetImage(0,350,10,90);
  leftImage = loadStreetImage(90,350,10,90);
  frontImage = loadStreetImage(180,350,10,90);
  rightImage = loadStreetImage(270,350,10,90); 
  upImage = loadStreetImage(0,640,90,105);
  buffer.image(frontImage,0,0);
  buffer.save("f_output.jpg");
  buffer.image(leftImage,0,0);
  buffer.save("l_output.jpg");
  buffer.image(backImage,0,0);
  buffer.save("b_output.jpg");
  buffer.image(rightImage,0,0);
  buffer.save("r_output.jpg");
  buffer.scale(-1.0,1.0);
  buffer.noStroke();
  buffer.fill(255);
  buffer.rect(-buffer.width,0,buffer.width,buffer.height);
  buffer.tint(255,255,255,230);
  buffer.image(upImage,-buffer.width,0);
  buffer.save("u_output.jpg");
  buffer.endDraw();
  String[] command = new String[1];
  command[0] = sketchPath("stitch.sh");
  try {
    Runtime.getRuntime().exec(command).waitFor();
  } catch (Exception e) {
  }
  wholeImage = loadImage("output.jpg");
}

void draw()
{
  noSmooth();
  background(0);
  imageMode(CENTER);
  translate(width/2,(height/2)-335);
  if(rotateLeft && shifted) rotation-=0.07;
  else if(rotateRight && shifted) rotation+=0.07;
  else if(rotateLeft) rotation-=0.007;
  else if(rotateRight) rotation+=0.007;
  else smooth();
  rotate(rotation);
  image(wholeImage,0,0);
}

void keyPressed()
{
  if(keyCode == SHIFT) shifted = true;
  else if(keyCode == LEFT) rotateLeft = true;
  else if(keyCode == RIGHT) rotateRight = true;
}

void keyReleased()
{
  if(keyCode == SHIFT) shifted = false;
  else if(keyCode == LEFT) rotateLeft = false;
  else if(keyCode == RIGHT) rotateRight = false;
}

PImage loadStreetImage(int heading, int imageHeight, int pitch, int fov)
{
  String url = "http://maps.googleapis.com/maps/api/streetview?sensor=false&size=640x";
  url = url + imageHeight;
  url = url + "&pitch=" + pitch;
  url = url + "&fov=" + fov;
  url = url + "&location=" + lat + "," + lon;
  url = url + "&heading=" + heading;
  return loadImage(url,"jpg");
}

void setLocationByGPS(float latPos, float lonPos)
{
  lat = "" + latPos;
  lon = "" + lonPos;
}

void setLocationByPostcode(String pc)
{
  int start, end;
  String[] lines = loadStrings("https://maps.google.co.uk/maps?q="+pc);
  for(int i=0; i<lines.length ;i++) {
    start = lines[i].indexOf("viewport_center_lat");
    if(start != -1) {
      end = lines[i].indexOf(";",start);
      lat = lines[i].substring(start+20,end);
      start = lines[i].indexOf("viewport_center_lng");
      end = lines[i].indexOf(";",start);
      lon = lines[i].substring(start+20,end);
    }
  }
}
