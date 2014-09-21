PImage theCamera;
PImage titleBanner;
PImage pleaseEnterYourName;
import processing.video.*;
import java.io.InputStreamReader;

boolean readyToStartCam = false;
String instruction = "Please Enter Your Name and press return: ";
String yourName = "";
int videoScale = 10; // Size of each cell in the grid, ratio of window size to video size
int cols = width/videoScale; // Number of columns and rows in our system
int rows = height/videoScale;
Capture video; // Variable to hold onto Capture object
String sourceText[];
String commandArray[] = new String[3];
PFont f;
int threshNumber = 80;

//----------------------------------------------THE SETUP--------------------------------------------
void setup(){
  size(800, 600);
  background(255);
  cols = width/videoScale;
  rows = height/videoScale;
  video = new Capture(this, width, height);
  video.start();
  f = createFont("Menlo", 12);
  textFont(f);
}

//------------------------------------------- THE-DRAW LOOP-------------------------------------------
void draw(){
  background(255);
  if (readyToStartCam == false){
    introScreen();
  } else {
  startCamera();
  displayCamera();}
}

void keyPressed(){
  if (key == ' ') {
      println("Image Saved");
      saveFrame("selfie-###.jpg");}
  if (key == 'w'){
      threshNumber = threshNumber + 15;
      println(threshNumber);}
  if (key == 's'){
      threshNumber = threshNumber - 15;
      println(threshNumber);
  }
}

//------------------------------------------- THE FUNCTIONS -------------------------------------------

void introScreen(){
background(255);
  theCamera = loadImage("theCamera.png");
  titleBanner = loadImage("titleBanner.png");
  pleaseEnterYourName = loadImage("pleaseEnterYourName.png");
  image(theCamera,5,10);
  image(titleBanner,250,10);
  fill(255,0,0);
  text(instruction,250,300);
  yourName = (yourName+(frameCount/10 % 2 == 0 ? "" : ""));
  text(yourName, 250, 315);  
}

void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      yourName = yourName.substring(0,max(0,yourName.length()-1));
      break;
    case ENTER:
    case RETURN:
      commandArray[0] = new String();
      commandArray[1] = new String();
      commandArray[2] = new String();
      getTextDataForName(yourName);
      sourceText = loadStrings("newfile.txt"); //load source Text as strings 
      readyToStartCam = true;
      break;
    case ESC:
    case DELETE:
      break;
    default:
      yourName += key;
    }
  }
}

void getTextDataForName( String name ){
  commandArray[0] = "sh";
  commandArray[1] = "runNameFinder.sh";
  commandArray[2] = name;
  String line;
  try {
    File workingDir = new File("/Users/2sman/Documents/Processing/pixelatedPhotoboothThreshholdWithFileInput/data");   
    Process p = Runtime.getRuntime().exec(commandArray, null, workingDir);
    BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    while ( (line = input.readLine ()) != null) {
      println(line);
    }
    input.close();
  } 
  catch (Exception e) {
    e.printStackTrace();  
  }
}

void startCamera(){
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
}

void displayCamera(){
        //TESTING GETTING IT ALL INTO ONE STRING
      String sourceTextOneStr = "";
      for (int i = 0; i < sourceText.length; i++){
        sourceTextOneStr += sourceText[i] + " ";
  }  

  int charcount = 0;
   for (int j = 0; j < rows; j++) { 
    for (int i = 0; i < cols; i++) {   
      // Where are we within the pixels?
      int x = i*videoScale;
      int y = j*videoScale;
     
      // Looking up the appropriate color in the pixel array
      color c =  video.pixels[x + y*video.width];
      
      float threshholdImage = brightness(video.pixels[x + y*video.width]);
      if (threshholdImage > threshNumber) {
        c = color(255);
        fill(c);
      text(sourceTextOneStr.charAt(charcount), x, y);
      } 
      else {
        c = color(0); 
        fill(c);
        text(sourceTextOneStr.charAt(charcount), x, y);
      }
      charcount = (charcount + 1) % sourceTextOneStr.length();
    }
  }
}
