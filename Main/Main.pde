
String[] lines; //<>//

import controlP5.*;


PFont stdFont;
PFont myFont;
Widget widget1, widget2, widget3, widget4, widget5, widget6; 
Screen currentScreen,screen1, screen2, screen3, screen4, screen5;
Render currentRender;


Flights[] flights;    // Array containing all our Flights.


         

String[] cancelledStates;                  // Handles Query 2
float[]  cancellationCount;
aBarChart  cancellationChart;
ControlP5 cp5;
DropdownList d1;

void settings(){
size(SCREENX, SCREENY);
}


void setup() {  // reads data and converts to bytes, to string, then printData method is initialised.
  frameRate(60);
  americaMap = loadShape("MapOfAmerica.svg"); // Load the map outline from the SVG file
  americaMap.scale(0.9); // Scale the map to fit within the canvas
  americaMap.translate(0, 0);
  stateDots = new HashMap<String, PVector>(); // Initialize the HashMap
  flightsByState = new HashMap<String, ArrayList<Flights>>();
  
  stateDots.put("CA", new PVector(160, 280));
  stateDots.put("TX", new PVector(480, 420));
  stateDots.put("WA", new PVector(200, 80)); // Washington
  stateDots.put("OR", new PVector(180, 140)); // Oregon
  stateDots.put("NV", new PVector(210, 230)); // Nevada
  stateDots.put("ID", new PVector(260, 160)); // Idaho
  stateDots.put("MT", new PVector(330, 100)); // Montana
  stateDots.put("WY", new PVector(370, 200)); // Wyoming
  stateDots.put("UT", new PVector(300, 260)); // Utah
  stateDots.put("CO", new PVector(380, 280)); // Colorado
  stateDots.put("AZ", new PVector(270, 350)); // Arizona
  stateDots.put("NM", new PVector(370, 370)); // New Mexico
  stateDots.put("ND", new PVector(480, 110)); // North Dakota
  stateDots.put("SD", new PVector(480, 180)); // South Dakota
  stateDots.put("NE", new PVector(480, 230)); // Nebraska
  stateDots.put("KS", new PVector(500, 290)); // Kansas
  stateDots.put("OK", new PVector(520, 350)); // Oklahoma
  stateDots.put("MN", new PVector(560, 140)); // Minnesota
  stateDots.put("IA", new PVector(570, 220)); // Iowa
  stateDots.put("MO", new PVector(590, 280)); // Missouri
  stateDots.put("AR", new PVector(590, 370)); // Arkansas
  stateDots.put("LA", new PVector(595, 430)); // Louisiana
  stateDots.put("WI", new PVector(620, 160)); // Wisconsin
  stateDots.put("IL", new PVector(630, 260)); // Illinois
  stateDots.put("IN", new PVector(690, 250)); // Indiana
  stateDots.put("MI", new PVector(700, 170)); // Michigan
  stateDots.put("OH", new PVector(740, 240)); // Ohio
  stateDots.put("KY", new PVector(720, 300)); // Kentucky
  stateDots.put("WV", new PVector(780, 270)); // West Virginia
  stateDots.put("PA", new PVector(810, 220)); // Pennsylvania
  stateDots.put("NY", new PVector(840, 170)); // New York
  stateDots.put("VT", new PVector(870, 140)); // Vermont
  stateDots.put("NH", new PVector(900, 150)); // New Hampshire
  stateDots.put("ME", new PVector(910, 90));  // Maine
  stateDots.put("MA", new PVector(880, 170)); // Massachusetts
  stateDots.put("CT", new PVector(885, 185)); // Connecticut
  stateDots.put("RI", new PVector(900, 185)); // Rhode Island
  stateDots.put("NJ", new PVector(865, 220)); // New Jersey
  stateDots.put("DE", new PVector(860, 250)); // Delaware
  stateDots.put("MD", new PVector(830, 250)); // Maryland
  stateDots.put("VA", new PVector(805, 290)); // Virginia
  stateDots.put("AL", new PVector(570, 440)); // Alabama
  stateDots.put("MS", new PVector(540, 490)); // Mississippi
  stateDots.put("NC", new PVector(810, 330)); // North Carolina
  stateDots.put("SC", new PVector(790, 370)); // South Carolina
  stateDots.put("GA", new PVector(750, 400)); // Georgia
  stateDots.put("FL", new PVector(800, 490)); // Florida
  stateDots.put("AL", new PVector(700, 400)); // Alabama
  stateDots.put("MS", new PVector(650, 400)); // Mississippi
  stateDots.put("TN", new PVector(680, 340)); // Tennessee
  
  lines = loadStrings("flights2k.csv"); // Load data from file into an array of strings
  flights = new Flights[lines.length]; //// Create an array of Flights objects
  
  for (int i = 1; i < lines.length; i++) {
    String[] data = lines[i].split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    flights[i] = new Flights(data);
    Flights flight = flights[i];
    String originState = flight.originState;
    if (!flightsByState.containsKey(originState)) {
      flightsByState.put(originState, new ArrayList<Flights>());
    }
    flightsByState.get(originState).add(flight);
  }
  stdFont = loadFont("Candara-Italic-30.vlw");
  textFont(stdFont);
  
  widget1 = new Widget(30, 450, 400, 40, "Leading States in cancellations.", color(125, 150, 200),
          stdFont, EVENT_BUTTON1);
  widget2 = new Widget(110, 330, 220, 40, "Shortest flights", color(125, 150, 200),        //Has no use. Can be repurposed as Query button!
         stdFont, EVENT_BUTTON2); 
  widget3 = new Widget(110, 390, 220, 40, "Busiest Airports", color(125, 150, 200),
          stdFont, EVENT_FORWARD); 
  widget4 = new Widget(40, 630, 200, 40, "Return", color(100, 155, 150),
          stdFont, EVENT_BACKWARD);
  widget5 =  new Widget(40, 630, 100, 40, "About", color(125, 150, 200),
          stdFont, EVENT_BUTTON3);
  widget6 =  new Widget(110, 270, 220, 40, "Set Date Range", color(125, 150, 200),
          stdFont, EVENT_BUTTON4);
  
  screen1 = new Screen(color(200,204,225), new ArrayList<Widget>(), 1);
  screen2 = new Screen(color(24,162,154), new ArrayList<Widget>(), 2);
  screen3 = new Screen(color(24,162,154), new ArrayList<Widget>(), 3);
  screen4 = new Screen(color(24,162,154), new ArrayList<Widget>(),4);
  screen5 = new Screen(color(24,162,154), new ArrayList<Widget>(),5);
  screen1.addWidget(widget1, widget2);
  screen1.addWidget(widget3, widget5);
  screen1.addWidget(widget6);
  screen2.addWidget(widget4);
  screen3.addWidget(widget4);
  screen4.addWidget(widget4);
  currentScreen = screen1;
  currentRender = new Render (QUERY_NULL, null);    //Setting up a render object 

  
  backgroundImage = loadImage("background.jpg");    // This is for the screens class  
  backgroundImage.resize(width, height);
  logo = loadImage("logo.png");
 
  cancelledStates = topCancelledOriginStates(flights);                    // Find the data then create the chart for Query 2
  cancellationCount =  getAmountCancelled(flights,cancelledStates);
  BarChart barChart = new BarChart(this);                               
  cancellationChart = new aBarChart(barChart, cancellationCount, cancelledStates, "State", "No. of flights cancelled",
  "Top 5 States for flight Cancellations.");      //Parameters (barChart, Data Array, LabelArray, xLabel, yLabel, Title)
  
  cp5 = new ControlP5(this);
  d1 = cp5.addDropdownList("myList-d1").setPosition(60, 100);            // Creating dropDown menu. 
  customize(d1); // customize the first list                            // Hide all the minor details getting assigned.
  cp5.setAutoDraw(false);                                               // We decide when to draw the menu.
  myFont = createFont("Arial", 14);  
  cp5.setFont(myFont);     


 startDate = getDate("Enter start date (DD/MM/YYYY):");
 endDate = getDate("Enter end date (DD/MM/YYYY):");         

}

void draw() {  
  currentScreen.draw();
  currentRender.draw();
  }



void mousePressed(){
  switch(currentScreen.getEvent(mouseX, mouseY)) {

   case EVENT_BUTTON1:              //Button for Query 2   ie, Cancelled Flights
     currentRender.query= QUERY_2;
     currentScreen = screen2;
     break;
   case EVENT_BUTTON2:        //Button for Query 3
     currentRender.query= QUERY_3;
     currentScreen = screen2;
     currentRender.data= lines;
     break;
     case EVENT_BUTTON3:        //Button for About
     currentScreen = screen3;
     break;
    case EVENT_BUTTON4:
     boolean dateInputSuccessful = getDate(); // Ask for date only when "Set Date Range" button is pressed
     if (dateInputSuccessful) {
       currentScreen = screen4; // Switch screen only if date input was successful
       currentRender.query= QUERY_4;
       currentRender.data= lines;
     }
     break;
     case FLIGHT_INFO_SCREEN:
     currentScreen = screen5;
    case EVENT_FORWARD:              //Button for Query 1
      currentScreen = screen2;
      currentRender.query= QUERY_1;
      currentRender.data = lines;
      break;
   case EVENT_BACKWARD:                  // Home Button. Brings us back to screen 1 and resets query!
     currentScreen = screen1;
     currentRender.query= QUERY_NULL;
     break;
     } 
     for (String state : stateDots.keySet()) {
       PVector dotPos = stateDots.get(state); // Get the coordinates of the dot for the current state
       // Check if the mouse is over the dot when pressed
       if (dist(dotPos.x, dotPos.y, mouseX, mouseY) < 10) {
         selectedState = state; // Set the selected state
         return;
       }
     }
     if (currentScreen == screen4) {
       handleMapScreenClick();
     } else if (currentScreen == screen5) {
       handleFlightInfoScreenClick();
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

void customize(DropdownList ddl) {     // Author: C.Kelly   Sets the minor details for the provide dropDown menu.
  //ddl.setBackgroundColor(color(255));
  ddl.setItemHeight(40);
  ddl.setBarHeight(30);
  ddl.setCaptionLabel("Select State");
  ddl.setSize(125,200);

  addStatesToDropdown(ddl,flights);
  
  ddl.setColorBackground(color(204,102,0));
  ddl.setColorActive(color(255, 128, 128));
}

void controlEvent(ControlEvent theEvent) {        // Author: C.Kelly    Handles retrieving a value upon pressing an option from a drop down menu.

  if (theEvent.isController()) { 
    String selectedState = theEvent.getController().getLabel();

    int cancelledFlightsCount;
    
    //println(d1.getItem(selectedState));
    
    Map test = d1.getItem(selectedState);
    if (test != null && test.containsKey("value")) {
      cancelledFlightsCount = (int)Float.parseFloat(test.get("value").toString());
      println(selectedState+" had " +cancelledFlightsCount+" cancelled flights!");
    }
  }
}
