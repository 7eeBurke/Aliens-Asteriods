/*Asteroids & Aliens
  Lee Burke
  17/12/2020*/
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioPlayer player2;
Aliens a;
Player p;
Laser l;
Asteroids r;

PImage img;
PImage [] aliens = new PImage [10];
PImage [] aliens2 = new PImage [10];
PImage [] aliens3 = new PImage [10];

int state = 0;
final int menu = 0;
final int game = 1;
final int end = 2;
int  px = 450;
int  py = 700;
int  lx = px + 35;
int  ly = py + 50;
int space = 80;           //Space between aliens
int alienX = 0;
int alienY = 200;
int dist1 = 50;       //width of aliens
int dist2 = 36;      //length of aliens
int count = 0;       //Score
int lives = 3;

boolean draw1 = true;    //Draw aliens
boolean draw2 = true;
boolean draw3 = true;
boolean draw4 = true;
boolean draw5 = true;

void setup()
{
  size(1000,800);
  noStroke();
  img = loadImage("Space1.jpg");
  
  minim = new Minim(this);
  player = minim.loadFile("EVA.wav.wav");
  player2 = minim.loadFile("Over.wav.wav");
  
  a = new Aliens();
  p = new Player();
  l = new Laser();
  r = new Asteroids();
  
  p.load();
  a.load();
  player.play();
           
}

void draw()
{
  switch(state){
    case menu: image(img, 0,0);
    textSize(100);
    fill(0,255,100);
    text("Aliens & Asteroids", 100, 200);
    textSize(20);
    text("By Lee Burke", 200, 220);
    textSize(50);
    fill(0,255,0);
    text("Press 'e' to start", 300, 400);
    textSize(32);
    fill(255);
    text("Move Left = Left Arrow",50,570);
    text("Move Right = Right Arrow",50,600);
    text("Shoot = Space",50,630);
    text("Hit a row of aliens 5 times to destroy it",50,690);
    text("Watch out for asteroids!",50,720);
    break;
    
    case game:
    image(img, 0,0);
  
    p.display(px,py);
    p.boundaries();
    p.move();
  
    r.display();
    r.move();
    r.collision();
  
    a.display();
    a.move();
    a.collision();
  
    l.display(lx,ly);
    l.move();
    l.boundaries();
    l.collision();
    l.score();
    break;
    
    case end:
    image(img, 0,0);
    textSize(100);
    fill(255,0,0);
    text("GAME OVER", 200, 400);
    textSize(32);
    text("Score: " + count, 400,425);
    player.close();
    player2.play();
    break;
  }
  if(key == 'e' || key == 'E'){
    state = game;
  }
}

//-------------Player--------------
class Player{
  PImage player;

  void load(){
    player = loadImage("Player.png");              //Ship img 
  }

  void display(int x, int y){
   image(player, x, y); 
  }

  void boundaries(){
    if(px < 0)     px = px + 10;
    if(px > 925)   px = px - 10;
  }
  
  void move(){
     if(keyPressed == true && key == CODED)
    {
      if(keyCode==LEFT) px -= 5;                    //Move left
      if(keyCode==RIGHT) px += 5;                  //Move right
    }  
  }
}
//------------Aliens-------------------
class Aliens{

  int ax = 1;

  void load(){
     for(int i = 0; i < aliens.length; i++)
    {
      aliens[i] = loadImage("Alien.png");        //Green aliens
      aliens2[i] = loadImage("Alien2.png");        //Red aliens
      aliens3[i] = loadImage("Alien3.png");        //White aliens
    }
    
  }

  void display(){
    for(int i = 0; i < 10; i++)
    {
      if(draw1 == true){
        image(aliens[i], alienX + space * i, alienY);     //Green aliens
      }
      if(draw2 == true){
        image(aliens[i], alienX + space * i, alienY - 50);     //Green aliens row 2
      }
      if(draw3 == true){
        image(aliens2[i], alienX + space * i, alienY - 100);     //Red aliens
      }
      if(draw4 == true){
        image(aliens2[i], alienX + space * i, alienY - 150);     //Red aliens row 2
      }
      if(draw5 == true){
        image(aliens3[i], alienX + space * i, alienY - 200);     //White aliens
      }
    }
  }
  
  void move(){
    alienX += ax;
    
    if(alienX <= 10){
      ax = 1;
      alienY = alienY + 10;
      if(draw1 == false){
        ax = 2;
      }
      if(draw2 == false){
        ax = 3;
        alienY = alienY + 15;
      }
      if(draw3 == false){
        ax = 4;
      }
      if(draw4 == false){
        ax = 5;
        alienY = alienY + 20;
      }
    }
    if(alienX+space*10 >= width){
      ax = -1;
      alienY = alienY + 10;
      if(draw1 == false){
        ax = -2;
      }
      if(draw2 == false){
        ax = -3;
        alienY = alienY + 15;
      }
      if(draw3 == false){
        ax = -4;
      }
      if(draw4 == false){
        ax = -5;
        alienY = alienY + 20;
      }
    }
  }
  void collision(){
    if(draw1 == true && alienY >= py+10){
      lives = 0;
    }
    if(draw2 == true && draw1 == false && alienY-50 >= py+10){
      lives = 0;
    }
    if(draw3 == true && draw2 == false && draw1 == false && alienY-100 >= py+10){
      lives = 0;
    }
    if(draw4 == true && draw3 == false && draw2 == false && draw1 == false && alienY-150 >= py+10){
      lives = 0;
    }
    if(draw5 == true && draw4 == false && draw3 == false && draw2 == false && draw1 == false && alienY-200 >= py){
      lives = 0;
    }
  }
  
}
//----------------Laser--------------
class Laser{
  boolean up = false;
  boolean draw = false;
  boolean left = false;
  boolean right = false;
  boolean hit = false;
  
  void display(int x, int y){
   if(keyPressed == true && key == CODED){
      if(keyCode==LEFT) lx -= 5;                    //Move left
      if(keyCode==RIGHT) lx += 5;                  //Move right
    }
    if(key == ' '){                             //Draw laser
      draw = true;
    }
    if(draw == true){
      fill(50, 244, 244);
      ellipse(x, y, 5, 30);
    }
    if(y < 0){
      ly = py+50;
      draw = false;
      up = false;
    }
   }
  
  void move(){
    if(keyPressed && key == ' '){              //Shoot laser
      up = true;
    }
    if(up == true){
      ly = ly - 15;
    } 
  }
  
  void boundaries(){
    if(lx < 35)     lx = lx + 10;
    if(lx > 960)   lx = lx - 10;
  }
  
  void collision(){
    if(draw1 == true){
      for(int i = 0; i < 10; i++){
        if(lx >= alienX+space*i && lx < alienX+space*i+dist1 && ly >= alienY && ly < alienY+dist2){
          ly = py+50;
          draw = false;
          up = false;
          hit = true;
        }
      }
    }
    if(draw2 == true && draw1 == false){
      for(int i = 0; i < 10; i++){
        if(lx >= alienX+space*i && lx < alienX+space*i+dist1 && ly >= alienY-50 && ly < alienY-50+dist2){
          ly = py+50;
          draw = false;
          up = false;
          hit = true;
        }
      }
    }
    if(draw3 == true && draw2 == false && draw1 == false){
      for(int i = 0; i < 10; i++){
        if(lx >= alienX+space*i && lx < alienX+space*i+dist1 && ly >= alienY-100 && ly < alienY-100+dist2){
          ly = py+50;
          draw = false;
          up = false;
          hit = true;
        }
      }
    }
    if(draw4 == true && draw3 == false && draw2 == false && draw1 == false){
      for(int i = 0; i < 10; i++){
        if(lx >= alienX+space*i && lx < alienX+space*i+dist1 && ly >= alienY-150 && ly < alienY-150+dist2){
          ly = py+50;
          draw = false;
          up = false;
          hit = true;
        }
      }
    }
    if(draw5 == true && draw4 == false && draw3 == false && draw2 == false && draw1 == false){
      for(int i = 0; i < 10; i++){
        if(lx >= alienX+space*i && lx < alienX+space*i+dist1 && ly >= alienY-200 && ly < alienY-200+dist2){
          ly = py+50;
          draw = false;
          up = false;
          hit = true;
        }
      }
    }
  }
  void score(){
    fill(0);
    rect(0,0,1000,100);
    fill(255);
    textSize(32);
    text("Score: " + count, 800, 50);
    text("Lives: " + lives, 800, 80);
    fill((int)random(0,255),(int)random(0,255),(int)random(0,255));
    text("Asteroids & Aliens",20,75);
    if(hit == true){
      count++;
      hit = false;
    }
    if(count == 5){
      draw1 = false;
    }
    if(count == 10){
      draw2 = false;
    }
    if(count == 15){
      draw3 = false;
    }
    if(count == 20){
      draw4 = false;
    }
    if(count == 25){
      draw5 = false;
    }
    if(lives == 0){
      state = end;
    }
    if(draw5 == false){
      textSize(100);
      fill(230,230,0);
      text("YOU WIN!", 300, 350);
      textSize(32);
      text("Score: " + count, 400,385);
      noLoop();
    }
  }
}
//-------------Asteroids-----------------------------------
class Asteroids{
  int x1 = (int)random(20, 980);
  int x2 = (int)random(20, 980);
  int x3 = (int)random(20, 980);
  int x4 = (int)random(20, 980);
  int x5 = (int)random(20, 980);
  int y1 = 100;
  int y2 = 100;
  int y3 = 100;
  int y4 = 100;
  int y5 = 100;
   
  void display(){
    fill(179);
    ellipse(x1,y1,30,30);
    ellipse(x2,y2,40,40);
    ellipse(x3,y3,50,50);
    ellipse(x4,y4,40,40);
    ellipse(x5,y5,70,70);
  }
  void move(){
    y1 += 8;
    y2 += 7;
    y3 += 5;
    y4 += 6;
    y5 += 3;
    if(y1 >= 800){
      y1 = 100;
      x1 = (int)random(20, 980);
    }
    if(y2 >= 800){
      y2 = 100;
      x2 = (int)random(100, 400);
    }
    if(y3 >= 800){
      y3 = 100;
      x3 = (int)random(100, 800);
    }
    if(y4 >= 800){
      y4 = 100;
      x4 = (int)random(500, 900);
    }
    if(y5 >= 800){
      y5 = 100;
      x5 = (int)random(400, 600);
    }
  }
  void collision(){
    if(dist(x1,y1,px+35,py+35)<40){
      y1 = 100;
      x1 = (int)random(20, 980);
      lives--;
    }
    if(dist(x2,y2,px+35,py+35)<50){
      y2 = 100;
      x2 = (int)random(100, 400);
      lives--;
    }
    if(dist(x3,y3,px+35,py+35)<60){
      y3 = 100;
      x3 = (int)random(300, 800);
      lives--;
    }
    if(dist(x4,y4,px+35,py+35)<50){
      y4 = 100;
      x4 = (int)random(500, 900);
      lives--;
    }
    if(dist(x5,y5,px+35,py+35)<70){
      y5 = 100;
      x5 = (int)random(400, 600);
      lives--;
    }
  }
}
