PImage backgroundImage;
PImage wordsImage;
float bannerX; 
boolean scrolling = true; 
int timer = 0; 

color buttonColor = color(173, 216, 230); 
color hoverColor = color(255);
color optionColor = color(255); 
color optionHoverColor = color(173, 216, 230); 
color optionBorderColor = color(0); 
color optionTextColor = color(0); 
color optionTextHoverColor = color(0, 0, 255); 

boolean allFlightHovered = false; 
boolean flightFilterHovered = false; 
boolean flightFilterClicked = false;

void setup() {
  size(2142, 1200);  
  backgroundImage = loadImage("images (2).jpg"); 
  wordsImage = loadImage("words.png");
  bannerX = width;
}

void draw() {
  background(255); 
  image(backgroundImage, 0, 0);
  
 
  image(wordsImage, bannerX, 100);
  
 
  if (scrolling && bannerX > (width - wordsImage.width) / 2) {
    bannerX -= 4; 
  } else {
    scrolling = false;
    
    
    timer++;
    
   
    if (timer >= 200) {
      drawButtons();
    }
  }
  
 
  if (flightFilterClicked) {
    drawOptions();
  }
}

void drawButtons() {
 
  if (allFlightHovered) {
    stroke(hoverColor); 
  } else {
    stroke(0); 
  }
  fill(buttonColor); 
  strokeWeight(2); 
  rect(250, 250, 300, 50); 
  fill(0); 
  textAlign(CENTER, CENTER);
  textSize(20); 
  text("All flight information", 400, 275); 
  
 
  if (flightFilterHovered) {
    stroke(hoverColor);
  } else {
    stroke(0); 
  }
  fill(buttonColor);
  strokeWeight(2);
  rect(250, 450, 300, 50);
  fill(0); 
  text("Flight filter", 400, 475); 
}

void drawOptions() {

  stroke(optionBorderColor);
  fill(optionColor); 
  rect(250, 500, 300, 200);
  
 
  fill(0); 
  textAlign(CENTER, CENTER); 
  textSize(20); 
  
  
  float optionSpacing = 150 / 4;
  
  
  for (int i = 0; i < 4; i++) {
   
    float optionY = 500 + i * optionSpacing + optionSpacing / 2;
    
    
    if (mouseX > 250 && mouseX < 550 && mouseY > optionY - optionSpacing / 2 && mouseY < optionY + optionSpacing / 2) {
      fill(optionTextHoverColor);
    } else {
      fill(optionTextColor);
    }
    
   
    if (i == 0) {
      text("Filter by origin", 400, optionY); 
    } else if (i == 1) {
      text("Filter by flight date", 400, optionY);
    } else if (i == 2) {
      text("Filter by departure airport", 400, optionY);
    } else if (i == 3) {
      text("View canceled flights", 400, optionY); 
    }
  }
}

void mouseMoved() {
  
  if (mouseX > 250 && mouseX < 550 && mouseY > 250 && mouseY < 300) {
   
    allFlightHovered = true;
    flightFilterHovered = false;
  } else if (mouseX > 250 && mouseX < 550 && mouseY > 450 && mouseY < 500) {
   
    flightFilterHovered = true;
    allFlightHovered = false;
  } else {
    
    allFlightHovered = false;
    flightFilterHovered = false;
  }
}

void mousePressed() {
  
  if (mouseX > 250 && mouseX < 550 && mouseY > 450 && mouseY < 500) {
    flightFilterClicked = !flightFilterClicked;
  }
}
