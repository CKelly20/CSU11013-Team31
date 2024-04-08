PFont boldFont;
PImage backgroundImage;
PImage logo;

class Screen{
  color background;
  ArrayList<Widget> screenWidgets;
  int event;
  int screenTracker;                          // Allows our screen class to know which screen it's on

  Screen(color background, ArrayList<Widget> widgets, int screenTracker){
    this.background = background;
    this.screenWidgets = widgets;
    this.screenTracker=screenTracker;
  }

  void addWidget(Widget widget1, Widget widget2){
    screenWidgets.add(widget1);
    screenWidgets.add(widget2);
  }
  
   void addWidget(Widget widget1){
    screenWidgets.add(widget1);
  }

  int getEvent(int mX, int mY){
    for(int i = 0; i < screenWidgets.size(); i++){
      if(mX > screenWidgets.get(i).x && mX < screenWidgets.get(i).x + screenWidgets.get(i).width && mY > screenWidgets.get(i).y
        && mY < screenWidgets.get(i).y + screenWidgets.get(i).height){
        return screenWidgets.get(i).event;
      }
    }
    return EVENT_NULL;
  }

  void draw(){
   background(background);
   
   if(screenTracker==1){                //If on main screen draw image and our Heading 
   image(backgroundImage, 0, 0);
   boldFont = createFont("Arial Bold", 50);
   textFont(boldFont);
   fill(0);
   text("Flight Tracker", 70, 250);
   logo.resize(100,0);
   image(logo, 170,70);
   }
   
   // the following is for the transition and is incomplete
   //if(screenTracker!=1 || screenTracker != 3){
   //image(backgroundImage, 0, 0);
   //boldFont = createFont("Arial Bold", 50);
   //textFont(boldFont);
   //fill(0);
   //text("Flight Tracker", 70, 250);
   //logo.resize(100,0);
   //image(logo, 170,70);
   //}
   
   // the following is for the about us screen
   if(screenTracker==3){                //If on main screen draw image and our Heading 
   image(backgroundImage, 0, 0);
   boldFont = createFont("Arial Bold", 50);
   textFont(boldFont);
   fill(0);
   text("About Us", 120, 250);
   textFont(stdFont);
   fill(255);
   text("The current program was  built \nand designed by Ahmed, Conor, \nVictor, Ayo, Somto and Ciaran", 50, 280);
   logo.resize(100,0);
   image(logo, 170,70);
   }  
   
   
   for(int i = 0; i < screenWidgets.size(); i++){
     screenWidgets.get(i).draw();
   } 
  }
  
  ArrayList getWidgets()
  {
    return screenWidgets;
  }
  
}
