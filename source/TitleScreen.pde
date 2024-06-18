class TitleScreen {
  int sign_y;
  int clock;
  boolean[] light_on;
  boolean lvl_selector;
  color white = color(255);
  color gold = color(213, 177, 115);
  color c0;
  color c1;
  color c2;
  color c3;
  color c4;
  color c5;
  
  TitleScreen() {
    sign_y = -600;
    clock = 0;
    light_on = new boolean [5];
    lvl_selector = false;
  }
  
  private void flash_lights() {
    fill(0);
    noStroke();
    clock += 2;
    if (clock > 350) { // Resets the clock
      clock = 100;
    }
    // If any of the lights are off, cover them with a black rectangle
    // Also, don't draw any rectangles till the sign slides in (at clock == 100)
    if (light_on[0] == false && clock > 100) {
      rect(660,336,60,60);
    }
    if (light_on[1] == false && clock > 100) {
      rect(820,336,60,60);
    }
    if (light_on[2] == false && clock > 100) {
      rect(880,336,60,60);
    }
    if (light_on[3] == false && clock > 100) {
      rect(940,336,60,60);
    }
    if (light_on[4] == false && clock > 100) {
      rect(1000,336,60,60);
    }
    // Flash the lights based on the clock
    if (clock >= 100 && clock < 150) {
      light_on[0] = false;
      light_on[1] = true;
      light_on[2] = true;
      light_on[3] = true;
      light_on[4] = true;
    }
    if (clock > 150 && clock < 200) {
      light_on[0] = true;
      light_on[1] = false;
      light_on[2] = true;
      light_on[3] = true;
      light_on[4] = true;
    }
    if (clock > 200 && clock < 250) {
      light_on[0] = true;
      light_on[1] = true;
      light_on[2] = false;
      light_on[3] = true;
      light_on[4] = true;
    }
    if (clock > 250 && clock < 300) {
      light_on[0] = true;
      light_on[1] = true;
      light_on[2] = true;
      light_on[3] = false;
      light_on[4] = true;
    }
    if (clock > 300) {
      light_on[0] = true;
      light_on[1] = true;
      light_on[2] = true;
      light_on[3] = true;
      light_on[4] = false;
    }
  }
  
  private void draw_lvl_label(int x, int y, int w, String label, color c) {
    fill(0);
    stroke(c);
    strokeWeight(3);
    rectMode(CENTER);
    rect(x, y, w, 50);
    rectMode(CORNER);
    
    textAlign(LEFT);
    textFont(expo);
    fill(c);
    textSize(30);
    text(label, x - (w/2) + 10, y + 10);
  }
  
  void draw() {
    image(cityscape, 0, 0);
    if (!lvl_selector) {
      translate(-510, 0);
      image(title_sign, 0, sign_y);  
      if (sign_y < -10) { // Makes the sign slide in from the top
        sign_y += 15;
      }
      flash_lights();
    }
    else {
      image(title_screen_buttons, 0, 0);
      if (muted) {
        fill(255);
        noStroke();
        rect(29, 626, 15, 30);
      }
      
      // Draws the lvl labels
      if (mouseX > 875 && mouseX < 1015 && mouseY > 505 && mouseY < 555 ){
        c0 = gold;
      }
      else {
        c0 = white;
      }
      if (mouseX > 93 && mouseX < 260 && mouseY > 283 && mouseY < 333 ){
        c1 = gold;
      }
      else {
        c1 = white;
      }
      if (mouseX > 315 && mouseX < 485 && mouseY > 175 && mouseY < 225 ){
        c2 = gold;
      }
      else {
        c2 = white;
      }
      if (mouseX > 545 && mouseX < 730 && mouseY > 115 && mouseY < 170 ){
        c3 = gold;
      }
      else {
        c3 = white;
      }
      if (mouseX > 795 && mouseX < 970 && mouseY > 75 && mouseY < 125 ){
        c4 = gold;
      }
      else {
        c4 = white;
      }
      if (mouseX > 110 && mouseX < 260 && mouseY > 25 && mouseY < 75 ){
        c5 = gold;
      }
      else {
        c5 = white;
      }
      
      draw_lvl_label(945, 530, 140, "TUTORIAL", c0);
      draw_lvl_label(180, 310, 160, "LEVEL ONE", c1);
      draw_lvl_label(400, 200, 165, "LEVEL TWO", c2);
      draw_lvl_label(640, 145, 180, "LEVEL THREE", c3);
      draw_lvl_label(885, 100, 175, "LEVEL FOUR", c4);
      draw_lvl_label(185, 50, 148, "FREEPLAY", c5);
    }
  }
  
  void mousePressed() {
    if (!lvl_selector) {
      lvl_selector = true;
    }
    else {
      if (mouseX > 10 && mouseX < 45 && mouseY > 620 && mouseY < 660 ) {
        if (!muted) {
          song.amp(0);
        }
        else {
          song.amp(1);
        }
        muted = !muted;
      }
      if (mouseX > 10 && mouseX < 45 && mouseY > 665 && mouseY < 705 ) {
        sign_y = -600;
        clock = 0;
        lvl_selector = false;
      }
      if (c0 == gold) {
        screen = 6;
      }
      else if (c1 == gold) {
        screen = 1;
      }
      else if (c2 == gold) {
        screen = 2;
      }
      else if (c3 == gold) {
        screen = 3;
      }
      else if (c4 == gold) {
        screen = 4;
      }
      else if (c5 == gold) {
        screen = 5;
      }
    }
  }
}
