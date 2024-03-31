String[] lines;
PFont stdFont;
Widget widget1, widget2, widget3, widget4, widget5;
Screen currentScreen,screen1, screen2, screen3;
Render currentRender;
Flights[] flights;                  // Array containing all our Flights.

String[] cancelledStates;                  // Handles Query 2
float[]  cancellationCount;
aBarChart  cancellationChart;


void settings(){
size(SCREENX, SCREENY);
}


void setup() {                                    // reads data and converts to bytes, to string, then printData method is initialised.
  lines = loadStrings("flights2k.csv"); // Load data from file into an array of strings
  flights = new Flights[lines.length]; //// Create an array of Flights objects
  for (int i = 1; i < lines.length; i++) {
    String[] data = lines[i].split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    flights[i] = new Flights(data);
  }
  stdFont = loadFont("Candara-Italic-30.vlw");
  textFont(stdFont);
  
   widget1 = new Widget(30, 270, 400, 40, "Leading States in cancellations.", color(125, 150, 200),
          stdFont, EVENT_BUTTON1);

  widget2 = new Widget(110, 330, 220, 40, "Shortest flights", color(125, 150, 200),        //Has no use. Can be repurposed as Query button!
         stdFont, EVENT_BUTTON2); 
  widget3 = new Widget(110, 390, 220, 40, "Busiest Airports", color(125, 150, 200),
          stdFont, EVENT_FORWARD); 
  widget4 = new Widget(40, 630, 200, 40, "Return", color(100, 155, 150),
          stdFont, EVENT_BACKWARD);
  widget5 =  new Widget(40, 630, 100, 40, "About", color(125, 150, 200),
          stdFont, EVENT_BUTTON3);
  
  screen1 = new Screen(color(200,204,225), new ArrayList<Widget>(), 1);
  screen2 = new Screen(color(24,162,154), new ArrayList<Widget>(), 2);
  screen3 = new Screen(color(24,162,154), new ArrayList<Widget>(), 3);
  screen1.addWidget(widget1, widget2);
  screen1.addWidget(widget3, widget5);
  screen2.addWidget(widget4);
  screen3.addWidget(widget4);
  currentScreen = screen1;
  currentRender = new Render (QUERY_NULL, null);    //Setting up a render object 

  

  
  // This is for the screens class
  backgroundImage = loadImage("background.jpg");
  backgroundImage.resize(width, height);
  logo = loadImage("logo.png");
  
  //for (Flights flight : flights) { // could be removed, print out all flight objects and its info
   // if (flight != null) {
  //    flight.printFlight();
 //   }
 // }
 
  cancelledStates = topCancelledOriginStates(flights);                    // Find the data then create the chart for Query 2
  cancellationCount =  getAmountCancelled(flights,cancelledStates);
  BarChart barChart = new BarChart(this);                               
  cancellationChart = new aBarChart(barChart, cancellationCount, cancelledStates, "State", "No. of flights cancelled",
  "Top 5 States for flight Cancellations.");      //Parameters (barChart, Data Array, LabelArray, xLabel, yLabel, Title)

         
}

void draw() {  
  currentScreen.draw(); //<>//
  currentRender.draw();
  }


void mousePressed(){
  switch(currentScreen.getEvent(mouseX, mouseY)) {
   case EVENT_BUTTON1:              //Button for Query 2 
     println("button 1!");
     currentRender.query= QUERY_2;
     currentScreen = screen2;
     break;
   case EVENT_BUTTON2:        //Button for Query 3
     println("button 2!");
     currentRender.query= QUERY_3;
     currentScreen = screen2;
     currentRender.data= lines;
     break;
     case EVENT_BUTTON3:        //Button for About
     println("button 3!");
     currentScreen = screen3;
     break;
    case EVENT_FORWARD:              //Button for Query 1
      println("Query One");
      currentScreen = screen2;
      currentRender.query= QUERY_1;
      currentRender.data = lines;
      break;
   case EVENT_BACKWARD:                  // Home Button. Brings us back to screen 1 and resets query!
     println("backward"); currentScreen = screen1;
     currentRender.query= QUERY_NULL;
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
