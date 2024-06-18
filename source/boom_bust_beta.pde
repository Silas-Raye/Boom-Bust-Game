import processing.sound.*;
SoundFile sound;
SoundFile song;

ArrayList<StringDict> dialogue_tree;
StringDict lvl1_dialogue;
StringDict lvl2_dialogue;
StringDict lvl3_dialogue;
StringDict lvl4_dialogue;
StringDict lvl5_dialogue;

int screen = 0;
int num_lvls = 5;
boolean muted = false;

PFont expo;
PFont arial;
PImage title_sign;
PImage bomb;
PImage belt;
PImage matchless_belt;
PImage match;
PImage cityscape;
PImage mobster;
PImage tutorial;
PImage red_arrow;
PImage title_screen_buttons;
PImage[] explosion = new PImage[9];
PImage[] door = new PImage[num_lvls];
PImage[] behind_door = new PImage[num_lvls];

IntList empty_list;
IntList lvl1_l1;
IntList lvl2_l1;
IntList lvl3_l1;
IntList lvl3_l2;
IntList lvl4_l1;
IntList lvl4_l2;
IntList lvl4_l3;
IntList lvl5_l1;
IntList lvl5_l2;
IntList lvl5_l3;

TitleScreen title_screen;
Level lvl1;
Level lvl2;
Level lvl3;
Level lvl4;
Level lvl5;

void setup() {
  size(1080, 720);
  
  sound = new SoundFile(this, "assets/explosion.mp3");
  song  = new SoundFile(this, "assets/saint-motel-benny-goodman.mp3");
  
  expo = createFont("assets/explosion_book_bold.ttf", 128);
  arial = createFont("assets/arial.ttf", 128);
  title_sign = loadImage("assets/title_sign.png");
  bomb = loadImage("assets/bomb.png");
  belt = loadImage("assets/belt.png");
  matchless_belt = loadImage("assets/matchless_belt.png");
  match = loadImage("assets/match.png");
  cityscape = loadImage("assets/cityscape.png");
  mobster = loadImage("assets/mobster.png");
  tutorial = loadImage("assets/tutorial.png");
  red_arrow = loadImage("assets/red_arrow.png");
  title_screen_buttons = loadImage("assets/title_screen_buttons.png");
  for (int i = 0; i < explosion.length; i++) {
    explosion[i] = loadImage("assets/explosion/explode" + i + ".png");
  }
  for (int i = 0; i < num_lvls; i++) {
    door[i] = loadImage("assets/doors/door" + (i + 1) + ".png");
  }
  for (int i = 0; i < num_lvls; i++) {
    behind_door[i] = loadImage("assets/behind_doors/behind_door" + (i + 1) + ".png");
  }
  
  empty_list  = new IntList();
  
  lvl1_l1 = new IntList();
  for (int i = 1; i < 6; i++) {
    lvl1_l1.append(i);
  }
  lvl2_l1 = new IntList();
  for (int i = 6; i < 36; i++) {
    lvl2_l1.append(i);
  }
  lvl3_l1 = new IntList();
  for (int i = 36; i < 46; i++) {
    lvl3_l1.append(i);
  }
  lvl4_l1 = new IntList();
  for (int i = 46; i < 51; i++) {
    lvl4_l1.append(i);
  }
  
  lvl3_l2 = new IntList();
  for (int i = 1; i < 21; i++) {
    lvl3_l2.append(i);
  }
  lvl4_l2 = new IntList();
  for (int i = 21; i < 26; i++) {
    lvl4_l2.append(i);
  }
  
  lvl4_l3 = new IntList();
  for (int i = 1; i < 16; i++) {
    lvl4_l3.append(i);
  }
  
  lvl5_l1 = new IntList();
  for (int i = 1; i < 11; i++) {
    lvl5_l1.append(0);
  }
  lvl5_l2 = new IntList();
  for (int i = 1; i < 11; i++) {
    lvl5_l2.append(0);
  }
  lvl5_l3 = new IntList();
  for (int i = 1; i < 11; i++) {
    lvl5_l3.append(0);
  }
  
  title_screen = new TitleScreen();
  lvl1 = new Level(lvl1_l1, empty_list, empty_list, 1);
  lvl2 = new Level(lvl2_l1, empty_list, empty_list, 2);
  lvl3 = new Level(lvl3_l1, lvl3_l2, empty_list, 3);
  lvl4 = new Level(lvl4_l1, lvl4_l2, lvl4_l3, 4);
  lvl5 = new Level(lvl5_l1, lvl5_l2, lvl5_l3, 5);
  
  dialogue_tree = new ArrayList<StringDict>();
  lvl1_dialogue = new StringDict();
  lvl2_dialogue = new StringDict();
  lvl3_dialogue = new StringDict();
  lvl4_dialogue = new StringDict();
  lvl5_dialogue = new StringDict();
  load_dialogue();
  
  song.loop();
}

void draw() {
  switch(screen) {
    case 0:
      title_screen.draw();
      break;
    case 1:
      lvl1.draw();
      break;
    case 2:
      lvl2.draw();
      break;
    case 3:
      lvl3.draw();
      break;
    case 4:
      lvl4.draw();
      break;
    case 5:
      lvl5.draw();
      break;
    case 6:
      image(tutorial, 0, 0);
      break;
  }
}

void mousePressed() {
  switch(screen) {
    case 0:
      title_screen.mousePressed();
      break;
    case 1:
      lvl1.mousePressed();
      break;
    case 2:
      lvl2.mousePressed();
      break;
    case 3:
      lvl3.mousePressed();
      break;
    case 4:
      lvl4.mousePressed();
      break;
    case 5:
      lvl5.mousePressed();
      break;
    case 6:
      screen = 0;
      break;
  }
}

void keyReleased() {
  switch(screen) {
    case 1:
      lvl1.keyReleased();
      break;
    case 2:
      lvl2.keyReleased();
      break;
    case 3:
      lvl3.keyReleased();
      break;
    case 4:
      lvl4.keyReleased();
      break;
    case 5:
      lvl5.keyReleased();
      break;
    case 6:
      screen = 0;
      break;
  }
}

void debug_screen(String text) {
  textFont(arial);
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER); 
  text(text, width/2, height/2);
}
