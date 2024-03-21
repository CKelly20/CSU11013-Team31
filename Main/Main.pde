
String[] lines;
PFont stdFont;
Widget widget1, widget2, widget3, widget4;
Screen currentScreen,screen1, screen2;

void settings(){
size(SCREENX, SCREENY);
}

Render currentRender;

void setup() {                                    // reads data and converts to bytes, to string, then printData method is initialised.
  byte[] fileBytes = loadBytes("flights2k.csv");    
  String fileContent = new String(fileBytes);
  lines = split(fileContent, "\n");
  printData();
  
  stdFont = loadFont("Candara-Italic-30.vlw");
  textFont(stdFont);
  
  widget1 = new Widget(380, 280, 200, 40, "Button 1", color(125, 150, 200),
          stdFont, EVENT_BUTTON1);
  widget2 = new Widget(380, 280, 200, 40, "Button 2", color(100, 155, 150),
          stdFont, EVENT_BUTTON2); 
  widget3 = new Widget(380, 380, 200, 40, "Busiest Airports", color(125, 150, 200),
          stdFont, EVENT_FORWARD); 
  widget4 = new Widget(50, 610, 200, 40, "Return", color(100, 155, 150),
          stdFont, EVENT_BACKWARD);
  
  screen1 = new Screen(color(200,204,225), new ArrayList<Widget>());
  screen2 = new Screen(color(200,225,204), new ArrayList<Widget>());
  screen1.addWidget(widget1, widget3);
  screen2.addWidget(widget2, widget4);
  currentScreen = screen1;

  currentRender = new Render (QUERY_NULL, null);    //Setting up a render object 

  
  // This is for the screens class
  backgroundImage = loadImage("background.jpg");
  backgroundImage.resize(width, height);

}

void draw() {  
  currentScreen.draw();
  if(currentScreen==screen2){
    currentRender.drawBusiestAirports();
  }
}

void printData() {
  // This loops through every line and prints it until last one is read.
  for (String line : lines) {
    println(line);
  }
}

void mousePressed(){
  switch(currentScreen.getEvent(mouseX, mouseY)) {
   case EVENT_BUTTON1:
     println("button 1!");
     break;
   case EVENT_BUTTON2:
     println("button 2!");
     break;

     case EVENT_FORWARD:
    println("Query One");
    currentScreen = screen2;
    currentRender.data = lines;
    break;

   case EVENT_BACKWARD:
     println("backward"); currentScreen = screen1;
     break;
     } 
  }

void mouseMoved(){      //Changes Colour of widgets outline when mouse hovers them
  int event;
  ArrayList widgetList = currentScreen.getWidgets();
  for(int i = 0; i<widgetList.size(); i++){
  Widget aWidget = (Widget) widgetList.get(i);
  event = aWidget.getEvent(mouseX,mouseY);
  if(event != EVENT_NULL){
    aWidget.mouseOver();
  }
  else
    aWidget.mouseNotOver();  
}
}
