/*
Rebecca Mier
120578137
Section 0103
I pledge on my honor that I have not given or received any unauthorized assistance on this assignment
*/


//global var declarations
int R = 20;
float ballColor = 255;
int pWidth = 20;
int pHeight = 100;
float xVelocity, yVelocity; //ball velocity
float x,y; //ball position
float padXOne, padXTwo; //paddles' x position
float padYOne, padYTwo; //paddles' y position
int textY = 20; //text Y position
float textSize = 20; //text size
boolean move = false; //ball moving
boolean ballSide; //true=ball hit right side, false=left
//player lives
int oneLives = 3;
int twoLives = 3;
//ball trail arrays
float[] xPos = new float[20];
float[] yPos = new float [20];

void setup(){
  size(800,600);
  x = width/2;
  y = height/2;
  padYOne = height/2;
  padYTwo = height/2;
}

//refer to guide on canvas for keyPressed values
void keyPressed(){
  //game start
  if(key == 't' || key == 'T'){
    move = !move;
    setVelocities();
  }
  
  //game reset
  if(key == 'n' || key == 'N'){
    x = width/2;
    y = height/2;
    move = false;
    padYOne = height/2;
    padYTwo = height/2;
    oneLives = 3;
    twoLives = 3;
    ballColor = 255;
  }
  
  //set ball to be at winning players paddle
  if(key == 'c' || key == 'C'){
    //shoot the ball from the paddle
    move = true;
    setVelocities();
    ballColor = 255;
    
    //set ball position to correct paddle and x velocity
    if(ballSide){
      xVelocity = 4;
      y = padYOne + pHeight/2;
      x = padXOne + pWidth + R;
    }else if(ballSide == false){
      xVelocity = -4;
      y = padYTwo + pHeight/2;
      x = padXTwo - R;
    }
  }
}

void draw(){
  background(0);
  noStroke();
  playerOne();
  playerTwo();
  fill(ballColor);
  ellipse(x,y,R,R);
  ballMove();
  ballTrail();
  
  //top text
  textSize(textSize);
  stroke(255);
  line(0,30,width,30);
  fill(255,0,0);
  text("P1 Lives:" + " " + oneLives, padXOne, textY);
  fill(0,0,255);
  text("P2 Lives:" + " " + twoLives, padXTwo - 70, textY);
  
  
  //win screen
  checkWinner();   

}

//sets random velocities
void setVelocities(){
  xVelocity = random(0,1);
  yVelocity = random(0,1);
    
  if(xVelocity > 0.5){
    xVelocity = 4;
  }else{
    xVelocity = -4;
  }
    
  if(yVelocity > 0.5){
    yVelocity = random(-10,-3);
  }else{
    yVelocity = random(-3,3);
  }
}

//paddle 1 method
void playerOne(){
  padXOne = 0;
  
  if(keyPressed && (key == 'w' || key == 'W')){
    padYOne-=10;
  }
  if(keyPressed && (key == 's' || key == 'S')){
    padYOne+=10;
  }
  
  fill(255,0,0);
  rect(padXOne,padYOne,pWidth,pHeight);
}

//paddle 2 method
void playerTwo(){
  padXTwo = width - pWidth;
  
  if(keyPressed && key == 'i' || key == 'I'){
    padYTwo-=10;
  }
  if(keyPressed && key == 'k' || key == 'I'){
    padYTwo+=10;
  }
  
  fill(0,0,255);
  rect(padXTwo,padYTwo,pWidth,pHeight);
}

//ball move method
void ballMove(){
  if(move){
    x += xVelocity;
    y += yVelocity;
  }
  
  //bouncing off walls
  if((y + R)>=height || (y - R) <= 30){
    yVelocity = -yVelocity;
  }
  
  
  //ball hits left/right side
  if(x > width + 10 || x < -10){
    //stop ball
    move = false;
    //use boolean to check which side was hit and take away life + reset ball position
    if(x > width){
      ballSide = true;
      twoLives -= 1; 
    }else if(x < 0){
      ballSide = false;
      oneLives -= 1; 
    }
    
    x = width/2;
    y = height/2;
    ballColor = 0;
   
  }
  
  //ball hits paddles
  
  //left paddle
    if((x - R) <= padXOne + pWidth/2 && (x - R) >= padXOne && y >= padYOne && y <= padYOne + pHeight){
      xVelocity = -xVelocity;
    }
  
    //right paddle
    if((x + R) >= padXTwo && (x + R) <= padXTwo + pWidth && y >= padYTwo && y <= padYTwo + pHeight){
      xVelocity = -xVelocity;
    }
}

//creates trail following the ball
void ballTrail(){
  //store past 20 ball positions and shift array to the right
  for(int i = xPos.length - 1; i > 0; i--){
    xPos[i] = xPos[i-1];
    yPos[i] = yPos[i-1];
  }
  
  //set new positions
  xPos[0] = x;
  yPos[0] = y;
  
  //transparency
  float t = 255;
  
  //draw trail
  for(int i = 0; i < xPos.length; i++){
    fill(ballColor,ballColor,ballColor,t);
    ellipse(xPos[i], yPos[i], i - 20, i - 20);
    t = t - 10;
  }
}

//creates game over screen
void checkWinner(){
  if(oneLives == 0 || twoLives == 0){
    background(0);
    fill(255);
    textSize(100);
    text("Game Over", width/2 - 230, height/2 - 50);
    textSize(20);
    text("Press N to Restart", width/2 - 80, height/2 + 60);
    textSize(40);
    if(twoLives == 0){
      fill(255,0,0);
      text("Player One is the Winner!", width/2 - 210, height/2 + 15);
    }else if(oneLives == 0){
      fill(0,0,255);
      text("Player Two is the Winner!", width/2 - 210, height/2 + 15);
    }
    
  }
}
