class Widget {
  int x, y, width, height;
  String label; 
  int event;
  color widgetColor, labelColor, lineColor;
  PFont widgetFont;

  Widget(int x,int y, int width, int height, String label,
    color widgetColor, PFont widgetFont, int event){
    this.x = x; this.y = y;
    this.width = width; this.height = height;
    this.label = label; this.event = event; 
    this.widgetColor = widgetColor; 
    this.widgetFont = widgetFont;
    lineColor = labelColor;
  }

  void draw(){
    fill(widgetColor);
    stroke(lineColor,150);
    strokeWeight(5);
    rect(x,y,width,height);
    fill(labelColor);
    textFont(widgetFont);
    text(label, x+10, y+height-10);
  }
  
int getEvent(int mX, int mY){
  if(mX>x && mX < x+width && mY >y && mY <y+height){ 
    return event;
    } 
  return EVENT_NULL; }
  
void mouseOver() {
  lineColor = color(255);
  }

void mouseNotOver() {
  lineColor = color(0); 
  }
}
