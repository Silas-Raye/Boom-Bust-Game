class Piece {
  PShape p = createShape(GROUP);
  PVector min = new PVector(0,0);
  int seed = 0;
  int gaussian_center = 6;
  int x = 0;
  int y = 0;
  int bomb_x = 0;
  int bomb_y = 0;
  int deg = 0;
  PVector mins;
  
  Piece(int seed_in, int gaussian_center_in) {
    // Set the seed
    if (seed_in == 0) {
      seed = round(random(1,1000));
    }
    else {
      seed = seed_in;
    }
    randomSeed(seed);
    
    // Sets the average piece size
    gaussian_center = gaussian_center_in;
    
    // Picks a random square on the grid to be the "snake head"
    int rx = 721;
    while (rx > 720) {
      rx = round(random(0,10))*72 + 72/2;
    }
    int ry = 721;
    while (ry > 720) {
      ry = round(random(0,10))*72 + 72/2;
    }
    style_piece();
    p.addChild(createShape());
    p.getChild(0).beginShape();
    p.getChild(0).vertex(rx-36,ry-36);
    p.getChild(0).vertex(rx+36,ry-36);
    p.getChild(0).vertex(rx+36,ry+36);
    p.getChild(0).vertex(rx-36,ry+36);
    p.getChild(0).endShape(CLOSE);
    
    // Picks a random square adjacent to "the head" and moves "the head" there
    // Repeat n times. So a larger n means a larger piece
    int n = round(randomGaussian() + gaussian_center);
    int nesw;
    boolean skip;
    for (int i = 0; i < n; i++) {
      nesw = round(random(0,3));
      skip = false;
      switch(nesw) {
        case 0: // Go north
          if (ry - 72 < 0) {
            i--;
            skip = true;
            break;
          }
          else {
            ry -= 72;
            break;
          }
        case 1: // Go east
          if (rx + 72 > 720) {
            i--;
            skip = true;
            break;
          }
          else {
            rx += 72;
            break;
          }
        case 2: // Go south
          if (ry + 72 > 720) {
            i--;
            skip = true;
            break;
          }
          else {
            ry += 72;
            break;
          }
        case 3: // Go west
          if (rx - 72 > 720) {
            i--;
            skip = true;
            break;
          }
          else {
            rx -= 72;
            break;
          }
        default:
          print("Error default case called");
          break;
      }
      p.addChild(createShape());
      if (!skip) {
        if (i == n/2) {
          bomb_x = rx;
          bomb_y = ry;
        }
        p.getChild(i+1).beginShape();
        p.getChild(i+1).vertex(rx-36,ry-36);
        p.getChild(i+1).vertex(rx+36,ry-36);
        p.getChild(i+1).vertex(rx+36,ry+36);
        p.getChild(i+1).vertex(rx-36,ry+36);
        p.getChild(i+1).endShape(CLOSE);
      }
    }
    
    int bomb_i = p.getChildCount();
    p.addChild(createShape());
    p.getChild(bomb_i).beginShape();
    p.getChild(bomb_i).vertex(bomb_x-4,bomb_y-4);
    p.getChild(bomb_i).vertex(bomb_x+4,bomb_y-4);
    p.getChild(bomb_i).vertex(bomb_x+4,bomb_y+4);
    p.getChild(bomb_i).vertex(bomb_x-4,bomb_y+4);
    p.getChild(bomb_i).endShape(CLOSE);
    
    // Translates the shape to 0, 0
    min = get_mins(p);
    p.translate(-min.x,-min.y);
    
    // Saves bomb x and bomb y
    PVector bomb_vertex = p.getChild(p.getChildCount()-1).getVertex(0);
    bomb_x = round(bomb_vertex.x - min.x + 2);
    bomb_y = round(bomb_vertex.y - min.y + 2);
    
    // Remove duplicate children
    // Running it once doesn't always catch them all
    remove_duplicate_children(p);
    remove_duplicate_children(p);
    
    // Same here. I have to run remove_null_children a ton if I want to get them all. IDK why
    for (int ci = 0; ci < p.getChildCount(); ci++) {
      remove_null_children(p);
    }
  }
  
  private void style_piece() {
    noStroke();
    fill(219,85,34,180);
  }
  
  private PVector get_mins(PShape p) {
    // Makes a list of the vertices
    ArrayList<PVector> vertices = new ArrayList<PVector>();
    for (int ci = 0; ci < p.getChildCount(); ci++) {
      for (int vi = 0; vi < p.getChild(ci).getVertexCount(); vi++) {
        vertices.add(p.getChild(ci).getVertex(vi));
      }
    }
    
    // Finds the upper left corner of the piece
    int[] xs = new int[vertices.size()];
    int[] ys = new int[vertices.size()];
    for (int i = 0; i < vertices.size(); i++) {
      xs[i] = (int)vertices.get(i).x;
      ys[i] = (int)vertices.get(i).y;
    }
    
    mins = new PVector(min(xs), min(ys));
    return mins;
  }
  
  private void remove_duplicate_children(PShape p) {
    for (int ci = 0; ci < p.getChildCount(); ci++) {
      for (int cj = ci + 1; cj < p.getChildCount(); cj++) {
        if (p.getChild(ci).getVertexCount() != p.getChild(cj).getVertexCount()) {
          continue;
        }
        int count = 0;
        for (int vi = 0; vi < p.getChild(ci).getVertexCount(); vi++) {
          PVector vertex_i = p.getChild(ci).getVertex(vi);
          for (int vj = 0; vj < p.getChild(cj).getVertexCount(); vj++) {
            PVector vertex_j = p.getChild(cj).getVertex(vj);
            if (vertex_i.equals(vertex_j)) {
              count++;
            }
          }
        }
        if (count == 4) {
          p.removeChild(cj);
        }
      }
    }
  }
  
  private void remove_null_children(PShape p) {
    for (int ci = 0; ci < p.getChildCount(); ci++) {
      if (p.getChild(ci).getVertexCount() == 0) {
        p.removeChild(ci);
      }
    }
  }
  
  void move(int x_in, int y_in) {
    p.translate(x_in, y_in);
  }
  
  void rotate_piece() {
    if (gaussian_center != 9) { // Fragile bombs have a gaussian_center of 9, and they can't be rotated
      style_piece();
      
      deg += 90;
      if (deg == 360) {
        deg = 0;
      }
      
      PShape rotated_piece = createShape(GROUP);
  
      // Copy the original shape into the rotated piece
      for (int ci = 0; ci < p.getChildCount(); ci++) {
        rotated_piece.addChild(createShape());
        rotated_piece.getChild(ci).beginShape();
        for (int vi = 0; vi < p.getChild(ci).getVertexCount(); vi++) {
          PVector original_vertex = p.getChild(ci).getVertex(vi);
          rotated_piece.getChild(ci).vertex(-original_vertex.y, original_vertex.x);
        }
        rotated_piece.getChild(ci).endShape(CLOSE);
      }
      
      min = get_mins(rotated_piece);
      rotated_piece.translate(-min.x,-min.y);
      
      // Saves bomb x and bomb y
      if (deg == 0) {
        PVector bomb_vertex = rotated_piece.getChild(rotated_piece.getChildCount()-1).getVertex(0);
        bomb_x = round(bomb_vertex.x - min.x + 2);
        bomb_y = round(bomb_vertex.y - min.y + 2);
      }
      if (deg == 90) {
        PVector bomb_vertex = rotated_piece.getChild(rotated_piece.getChildCount()-1).getVertex(0);
        bomb_x = round(bomb_vertex.x - min.x - 4);
        bomb_y = round(bomb_vertex.y - min.y + 2);
      }
      if (deg == 180) {
        PVector bomb_vertex = rotated_piece.getChild(rotated_piece.getChildCount()-1).getVertex(0);
        bomb_x = round(bomb_vertex.x - min.x - 4);
        bomb_y = round(bomb_vertex.y - min.y - 4);
      }
      if (deg == 270) {
        PVector bomb_vertex = rotated_piece.getChild(rotated_piece.getChildCount()-1).getVertex(0);
        bomb_x = round(bomb_vertex.x - min.x + 2);
        bomb_y = round(bomb_vertex.y - min.y - 4);
      }
      
      p = rotated_piece;
    }
  }
  
  void light(ArrayList<Piece> pieces, int[][] arr_index, int this_index, int depth) {
    // Maximum depth allowed before stopping the recursion
    int maxDepth = 1000; // You can adjust this value as needed

    if (depth > maxDepth) {
        System.err.println("Error: Maximum recursion depth exceeded.");
        return;
    }
    
    for (int ci = 0; ci < p.getChildCount() - 1; ci++) {
      // Gets the top left vertex
      int smallest_cx = 9999;
      int smallest_cy = 9999;
      int cx = 0;
      int cy = 0;
      for (int vi = 0; vi < 4; vi++) {
        cx = (int)((p.getChild(ci).getVertex(vi).x - min.x + x) / 72);
        cy = (int)((p.getChild(ci).getVertex(vi).y - min.y + y) / 72);
        if (cx < smallest_cx) {
          smallest_cx = cx;
        }
        if (cy < smallest_cy) {
          smallest_cy = cy;
        }
      }
      cx = smallest_cx;
      cy = smallest_cy;
      if (cx < 0 || cx > 9 || cy < 0 || cy > 9) { // Stops out of bounds exception from being thrown when pieces go off the board
        continue;
      }
      if (arr_index[cx][cy] == -2) {
        continue;
      }
      else if ((arr_index[cx][cy] == -1) || (arr_index[cx][cy] == this_index)) {
        arr_index[cx][cy] = -2;
      }
      else if (arr_index[cx][cy] >= 0) {
        pieces.get(arr_index[cx][cy]).light(pieces, arr_index, arr_index[cx][cy], depth + 1);
      }
    }
  }
  
  void draw() {
    shape(p);
    if (gaussian_center == 6) {
      noTint();
    }
    else if (gaussian_center == 3) {
      tint(0, 255, 0);
    }
    else if (gaussian_center == 9) {
      tint(255, 0, 0);
    }
    imageMode(CENTER);
    image(bomb, x + bomb_x + 1, y + bomb_y + 1);
    imageMode(CORNER);
    noTint();
  }
  
  // Setters
  void set_x(int x_in) {
    x = x_in;
  }
  
  void set_y(int y_in) {
    y = y_in;
  }
  
  // Getters
  int get_min_x() {
    return (int)min.x;
  }
  
  int get_min_y() {
    return (int)min.y;
  }
  
  int get_seed() {
    return seed;
  }
  
  int get_gaussian_center() {
    return gaussian_center;
  }
  
  int get_x() {
    return x;
  }
  
  int get_y() {
    return y;
  }
  
  int get_bomb_x() {
    return bomb_x;
  }
  
  int get_bomb_y() {
    return bomb_y;
  }
  
  int get_deg() {
    return deg;
  }
}
