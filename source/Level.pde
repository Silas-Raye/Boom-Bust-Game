class Level {
  Piece p;
  ArrayList<Piece> pieces;
  IntList normal_seed_list;
  IntList sticky_seed_list;
  IntList fragile_seed_list;
  IntList og_normal_seed_list;
  IntList og_sticky_seed_list;
  IntList og_fragile_seed_list;
  int[][] arr_index = new int[10][10];
  boolean piece_in_hand = false;
  boolean match_in_hand = false;
  boolean exploding = false;
  int explosion_index = 0;
  int x_pos;
  int y_pos;
  int lvl_index;
  int final_score = 0;
  int dialogue_index = 1;
  color[] rect_color = {#7f7b3a, #424f47, #6b716c, #262c30, #2e3f3b};
  
  Level(IntList l1, IntList l2, IntList l3, int lvl_index_in) {
    pieces = new ArrayList<Piece>();
    
    normal_seed_list = l1;
    sticky_seed_list = l2;
    fragile_seed_list = l3;
    
    og_normal_seed_list = clone(l1);
    og_sticky_seed_list = clone(l2);
    og_fragile_seed_list = clone(l3);
    
    // Fill arr_index with -1s
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        arr_index[i][j] = -1;
      }
    }
    
    lvl_index = lvl_index_in;
  }
  
  private IntList clone(IntList in) {
    IntList out = new IntList();
    for (int i = in.size() - 1; i >= 0; i--) {
      out.append(in.get(i));
    }
    
    return out;
  }
  
  private void draw_bg() {
    image(door[lvl_index - 1], 0, 0);
    
    // Draws the grid
    for (int i = 0; i < 720; i += 72) {
      for (int j = 0; j < 720; j += 72) {
        strokeWeight(2);
        stroke(20);
        noFill();
        square(i,j,72);
      }
    }
    
    // Draws all the past pieces
    for (int i = 0; i < pieces.size(); i++) {
      pieces.get(i).draw();
    }
    
    // Shows the door_bg image through the door wherever the bombs explode
    PImage maskImage = createImage(720, 720, RGB);
    maskImage.loadPixels();
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (arr_index[j][i] == -2) {
          for (int x = j*72; x < (j+1)*72; x++) {
            for (int y = i*72; y < (i+1)*72; y++) {
              maskImage.pixels[y*720 + x] = color(255, 255, 255);
            }
          }
        }
      }
      maskImage.updatePixels();
      behind_door[lvl_index - 1].mask(maskImage);
      image(behind_door[lvl_index - 1], 0, 0);
    }
    
    // Draws a rectangle next to the grid to cover any pieces that go off the grid to the right
    fill(rect_color[lvl_index - 1]);
    noStroke();
    rect(721,0,360,720);
    stroke(0);
    
    // Draws the belt
    if (match_in_hand) {
      image(matchless_belt,720,0);
    }
    else {
      image(belt,720,0);
    }
    
    // Draws the mobster
    image(mobster, 0, 0);
    
    // Draws nums on the bags
    textFont(arial);
    textSize(40);
    textAlign(CENTER);
    fill(0);
    text(normal_seed_list.size(), 762, 130);
    text(sticky_seed_list.size(), 837, 150);
    text(fragile_seed_list.size(), 972, 142);
    
    // Draws the dialogue
    textSize(22);
    textAlign(LEFT);
    if (exploding) {
      text(dialogue_tree.get(lvl_index - 1).get("lvl" + (lvl_index) + "_pe"), 750, 210);
    }
    else {
      text(dialogue_tree.get(lvl_index - 1).get("lvl" + (lvl_index) + "_d" + (dialogue_index)), 750, 210);
    }
    
    // Hides dialogue buttons when there is no dialogue in that direction
    if (dialogue_index <= 1 || exploding) {
      fill(255);
      noStroke();
      rect(960, 300, 50, 50);
    }
    if (dialogue_index == dialogue_tree.get(lvl_index - 1).size() - 1 || exploding) {
      fill(255);
      noStroke();
      rect(1008, 300, 50, 50);
    }
  }
  
  private int canvas_to_grid(Piece p_in, String xy) {
    if (xy == "x") {
      return ((p_in.get_x() + p_in.get_bomb_x() + 38)/72) - 1;
    }
    else if (xy == "y") {
      return ((p_in.get_y() + p_in.get_bomb_y() + 38)/72) - 1;
    }
    else {
      print("Error in the canvas_to_grid function. Please enter \"x\" or \"y\"");
      return -1;
    }
  }
  
  private int snap(int pos) {
    if (pos % 72 > -70 && pos % 72 < -36) {
      return pos - 72 - (pos % 72);
    }
    else if (pos % 72 > 36) {
      return pos + 72 - (pos % 72);
    }
    else {
      return pos - (pos % 72);
    }
  }
  
  int get_score() {
    return final_score;
  }
  
  void reset_everything() {
    piece_in_hand = false;
    match_in_hand = false;
    exploding = false;
    explosion_index = 0;
    dialogue_index = 1;
    final_score = 0;
    
    // Remove all the saved pieces
    for (int i = pieces.size() - 1; i >= 0; i--) {
      pieces.remove(i);
    }
    
    // Fill arr_index with -1s
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        arr_index[i][j] = -1;
      }
    }
    
    // Refill the bags
    normal_seed_list = clone(og_normal_seed_list);
    sticky_seed_list = clone(og_sticky_seed_list);
    fragile_seed_list = clone(og_fragile_seed_list);
  }
  
  void draw() {
    draw_bg();
  
    if (piece_in_hand) {
      x_pos = mouseX - p.get_bomb_x();
      y_pos = mouseY - p.get_bomb_y();
      translate(x_pos, y_pos);
      p.draw();
    }
    else if (match_in_hand && !exploding) {
      translate(mouseX,mouseY);
      match.resize(30, 0);
      image(match, -20, -60);
    }
    
    // Draws the explosions when the bombs are lit
    if (exploding) {
      for (int i = 0; i < pieces.size(); i++) {
        Piece q = pieces.get(i);
        if (arr_index[canvas_to_grid(q, "x")][canvas_to_grid(q, "y")] == -2) {
          push();
          translate(q.get_x() + q.get_bomb_x(), q.get_y() + q.get_bomb_y());
          image(explosion[explosion_index], -100, -100);
          pop();
        }
      }
      if (frameCount%10 == 0 && explosion_index < explosion.length - 1) {
          explosion_index++;
      }
      
      // Draws the red arrow after bombs are lit
      float red_arrow_y = 0;
      float amplitude = 10; // the maximum displacement of the shape
      float period = 60; // the time it takes for one full oscillation in frames
      red_arrow_y = amplitude * sin(frameCount * TWO_PI / period);
      
      image(red_arrow, 2, red_arrow_y);
    }
  }
  
  void mousePressed() {
    if (mouseX > 962 && mouseX < 1002 && mouseY > 366 && mouseY < 404) {
      reset_everything();
    }
    if (mouseX > 1010 && mouseX < 1050 && mouseY > 366 && mouseY < 404) {
      screen = 0;
    }
    if (!exploding) {
      if (mouseX > 962 && mouseX < 1002 && mouseY >  305 && mouseY < 345) {
        if (dialogue_index > 1) {
          dialogue_index--;
        }
      }
      if (mouseX > 1010 && mouseX < 1050 && mouseY > 305 && mouseY < 345) {
        if (dialogue_index < dialogue_tree.get(lvl_index - 1).size() - 1) {
          dialogue_index++;
        }
      }
      if (mouseX > 0 && mouseX < 720 && mouseY > 0 && mouseY < 720) { // If you're over the grid
        x_pos = snap(x_pos);
        y_pos = snap(y_pos);
        int mx = mouseX / 72;
        int my = mouseY / 72;
        
        // Placeing pieces
        if (piece_in_hand) { // If you have a piece in hand
          p.set_x(x_pos); // Save the location
          p.set_y(y_pos);
          p.move(p.get_x(), p.get_y());
          
          if (arr_index[canvas_to_grid(p, "x")][canvas_to_grid(p, "y")] != -1) { // If the square has a bomb, move the piece back so as to undo the above move action
            p.move(-p.get_x(), -p.get_y());
            p.set_x(0);
            p.set_y(0);
          }
          
          else { // If the square has no bomb, add the piece to the background, and save what piece is in that square to arr_index
            piece_in_hand = false;
            arr_index[canvas_to_grid(p, "x")][canvas_to_grid(p, "y")] = pieces.size();
            pieces.add(p);
          }
        }
        
        // Picking up pieces
        else if (arr_index[mx][my] >= 0) { // If you don't have a piece in hand, the square has a bomb, and...
          if (!match_in_hand && pieces.get(arr_index[mx][my]).get_gaussian_center() != 3) { // ...you don't have a match in hand, and the piece you are trying to pick up isn't sticky
            piece_in_hand = true;
            p = new Piece(pieces.get(arr_index[mx][my]).get_seed(), pieces.get(arr_index[mx][my]).get_gaussian_center()); // Copy the piece into the hand
            for (int i = 0; i < (pieces.get(arr_index[mx][my]).get_deg() / 90); i++) { // Rotate the piece to match its old orientation
              p.rotate_piece();
            }
            pieces.remove(arr_index[mx][my]); // Remove the piece from pieces
            for (int i = 0; i < 10; i++) { // Update all indices in arr_index to reflect the new version of the pieces list
              for (int j = 0; j < 10; j++) {
                if (arr_index[i][j] > arr_index[mx][my]) {
                  arr_index[i][j]--;
                }
              }
            }
            arr_index[mx][my] = -1; // Lastly remove the index from arr_index
          }
          else if (match_in_hand) { // ...you do have a match in hand
            pieces.get(arr_index[mx][my]).light(pieces, arr_index, arr_index[mx][my], 0);
            exploding = true;
            if (!muted) {
              sound.play();
            }
            for (int i = 0; i < 10; i++) {
              for (int j = 0; j < 10; j++) {
                if (arr_index[i][j] == -2) {
                final_score++;
                }
              }
            }
            load_dialogue();
          }
        }
      }
      
      // The get normal bomb button
      if (mouseX > 720 && mouseX < 800 && mouseY > 5 && mouseY < 150 && !match_in_hand) { // If you're over the button, get a new piece
        if (!piece_in_hand && normal_seed_list.size() > 0) {
          piece_in_hand = true;
          p = new Piece(normal_seed_list.get(normal_seed_list.size() - 1), 6);
          normal_seed_list.remove(normal_seed_list.size() - 1);
        }
        else if (piece_in_hand && p.get_gaussian_center() == 6) { // Can only put a piece back in if it's the same type
          piece_in_hand = false;
          normal_seed_list.append(p.get_seed());
        }
      }
      
      // The get sticky bomb button
      if (mouseX > 800 && mouseX < 875 && mouseY > 15 && mouseY < 170 && !match_in_hand) { // If you're over the button, get a new piece
        if (!piece_in_hand && sticky_seed_list.size() > 0) {
          piece_in_hand = true;
          p = new Piece(sticky_seed_list.get(sticky_seed_list.size() - 1), 3);
          sticky_seed_list.remove(sticky_seed_list.size() - 1);
        }
        else if (piece_in_hand && p.get_gaussian_center() == 3) { // Can only put a piece back in if it's the same type
          piece_in_hand = false;
          sticky_seed_list.append(p.get_seed());
        }
      }
      
      // The get fragile bomb button
      if (mouseX > 930 && mouseX < 1010 && mouseY > 25 && mouseY < 165 && !match_in_hand) { // If you're over the button, get a new piece
        if (!piece_in_hand && fragile_seed_list.size() > 0) {
          piece_in_hand = true;
          p = new Piece(fragile_seed_list.get(fragile_seed_list.size() - 1), 9);
          fragile_seed_list.remove(fragile_seed_list.size() - 1);
        }
        else if (piece_in_hand && p.get_gaussian_center() == 9) { // Can only put a piece back in if it's the same type
          piece_in_hand = false;
          fragile_seed_list.append(p.get_seed());
        }
      }
      
      // The get match button
      if (mouseX > 1015 && mouseX < 1080 && mouseY > 15 && mouseY < 155 && !piece_in_hand) { // If you're over the button, get a match
        if (match_in_hand) {
          match_in_hand = false;
        }
        else {
          match_in_hand = true;
        }
      }
    }
  }
  
  void keyReleased() {
    if (key == 'r' && piece_in_hand) {
      p.rotate_piece();
    }
  }
}
