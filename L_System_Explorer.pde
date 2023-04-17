
// First, defining some variables for the appearance of the main window
int BH; // The height of the productions box
int RW = 120; // The width of the right box
int RH = 80; // The height of the right box
int sep = 5; // The seperation of the boxes
int edge = 10; // The distance from the edge of the screen to the boxes
int d = 15; // diameter of the nodes

float CSize = 40; // Size of the central/mousetracking cursor

int w, h; // Variables to keep track of the width and height of the window for resizing purposes

boolean firstMousePress = false; // True if a mouse button has just been pressed while no other button was.

Triangle LGen, RGen, LAng, RAng; // The different arrow buttons for changing values
Slider AngleSlider, OffsetSlider;


ArrayList<Rectangle> windowButtons = new ArrayList<Rectangle>(); // The buttons that can add or remove windows/production rules
int buttonSize = 16;

PFont myFont;

int iters = 1;
float angle = 0;
float offset = 0;

// The bounds for where new nodes can be placed or dragged to
int xmin, xmax, ymin, ymax;
IntList lims;
IntList windowBounds;

String Productions; // A list of the productions that have a replacement rule
StringList Replacements; // A list of the replacement rules

ArrayList<Window> subWindows = new ArrayList<Window>(); // The windows that control the different production rules
int maxSubWindows = 4;
int initialWindows = 2;

String startVar;

//IntList wIandPN; // Initializing a short intlist that keeps track of some values for the main window's production display
int minProdNum;


ArrayList<Node> nodes = new ArrayList<Node>();


String[] L = {"A", "B", "C", "D", "E", "F"};
//ArrayList<String> M = new ArrayList<String>();
//M = {"A", "B", "C", "D", "E", "F"};

//Triangle StartTriangle;
//float startX, startY;
//int stW = 40; // The width of the start triangle
//int stH = 20; // The height of the start triangle


ArrayList<String> OGWindowProds = new ArrayList<String>(); // OG WindowProds
ArrayList<String> WindowProds = new ArrayList<String>(); // WindowProds

String LSystem;


int SliderBounds = 185;


boolean animatingA = false;
boolean animatingO = false;
float Arate = 0.3; // anywhere between -0.5 and 0.5 or so is good
float Orate = 0.2;

float startWidth = 10;
float decrease = 0.8; // fraction by which it changes (0.8 is good)


void settings() {
  size(displayWidth/2, displayHeight);
  windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "+", this));
  for (int i = 0; i < initialWindows; i++) {
    OGWindowProds.add(L[i]);
    windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
  }
  
  
  
  WindowProds = OGWindowProds;
  
  
  registerMethod("pre", this);
  
  w = width;
  h = height;
  
  xmin = 0;
  xmax = w;
  ymin = 0;
  ymax = h - BH - edge;
  
  lims = new IntList();
  lims.append(xmin);
  lims.append(xmax);
  lims.append(ymin);
  lims.append(ymax);
  
  windowBounds = new IntList();
  windowBounds.append(0);
  windowBounds.append(w);
  windowBounds.append(0);
  windowBounds.append(h);
  
  LGen = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
  RGen = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
  LAng = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
  RAng = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
            
  //startX = w/2;
  //startY = h/2;
  //StartTriangle = new Triangle(startX, startY, startX + stW/2, startY + stH, startX - stW/2, startY + stH, this, lims, OGWindowProds);
  //StartTriangle.setMovable(true);
  //StartTriangle.setWindowProds(WindowProds);
  
  Replacements = new StringList();
  
}

void setup() { 
  //surface.hideCursor();
  surface.setResizable(true);
  surface.setTitle("Main Window");
  surface.setLocation(0, 0);
  //for (Window w : subWindows) {
  //  w.setup();
  //}
  
  //myFont = createFont("Monospaced", 10);
  //textFont(myFont);
  //print(PFont.list());
  
  for (int i = 0; i < initialWindows; i++) {
    subWindows.add(new Window(this, L[i], i, OGWindowProds));
    subWindows.get(i).setWindowProds(WindowProds);
  }
  
}

void pre() {
  if (w != width || h != height) {
    // Sketch window has resized
    w = width;
    h = height;
    //while (lims.size() > 0) {
    //  lims.remove(0);
    //}
    lims.clear();
    xmin = 0;
    xmax = w;
    ymin = 0;
    ymax = h - BH - edge;
    
    lims.append(xmin);
    lims.append(xmax);
    lims.append(ymin);
    lims.append(ymax);
    
    windowBounds.clear();
    windowBounds.append(0);
    windowBounds.append(w);
    windowBounds.append(0);
    windowBounds.append(h);
    
    adjustSystem(nodes, lims);
    
    LGen.move(w - edge - RW/2 - 15, h - edge - RH/2 - 5,
            w - edge - RW/2 - 15, h - edge - RH/2 + 25,
            w - edge - RW/2 - 40, h - edge - RH/2 + 10);
            
    RGen.move(w - edge - RW/2 + 15, h - edge - RH/2 - 5,
            w - edge - RW/2 + 40, h - edge - RH/2 + 10,
            w - edge - RW/2 + 15, h - edge - RH/2 + 25);
            
    LAng.move(w - edge - RW/2 - 15, h - edge - RH/2 - 5 - RH - edge,
            w - edge - RW/2 - 15, h - edge - RH/2 + 25 - RH - edge,
            w - edge - RW/2 - 40, h - edge - RH/2 + 10 - RH - edge);
            
    RAng.move(w - edge - RW/2 + 15, h - edge - RH/2 - 5 - RH - edge,
            w - edge - RW/2 + 40, h - edge - RH/2 + 10 - RH - edge,
            w - edge - RW/2 + 15, h - edge - RH/2 + 25 - RH - edge);
            
    //AngleSlider = new Slider(w - edge - RW/2 - SliderBounds, w - edge - RW/2 + SliderBounds, 
    //(int) (h - 2*edge - 1.5*RH), (int) (h - 2*edge - 1.5*RH), 10, 25, this);
    AngleSlider = new Slider(w - edge - RW/4, w - edge - RW/4, 
    (int) (h - edge - 1.5*RH - 2*SliderBounds+3), (int) (h - edge - 1.5*RH+3), 25, 10, this);
    
    OffsetSlider = new Slider(w - edge - 3*RW/4, w - edge - 3*RW/4, 
    (int) (h - edge - 1.5*RH - 2*SliderBounds+3), (int) (h - edge - 1.5*RH+3), 25, 10, this);
    
    
    // (w - edge - RW/2 - SliderBounds, w - edge - RW/2 + SliderBounds, 
    // (int) (h - 2*edge - 1.5*RH), (int) (h - 2*edge - 1.5*RH), 10, 25, this);
    //AngleSlider.move(w - edge - RW/2 - SliderBounds, w - edge - RW/2 + SliderBounds, (int) (h - 2*edge - 1.5*RH));
            
    //StartTriangle.adjust(lims);
    
  }
}


void draw() {
  background(255);
  noStroke();
  
  textAlign(LEFT, TOP);
  //}
  
  stroke(255);
  // Axiom, Productions, and Angle Box
  //fill(100);
  //rect(edge, height-rH-edge, LW, rH);
  
  // Productions Box
  Productions = "";
  Replacements.clear();
  for (Window w : subWindows) {
    Productions += w.getProduction();
    Replacements.append(w.getReplacement());
    //print(" before: " + WindowProds.size());
    //w.setWindowProds(WindowProds);
    //print(" after: " + WindowProds.size());
  }
  //StartTriangle.setWindowProds(WindowProds);
  
  
  if (subWindows.size() != 0) {
    startVar = subWindows.get(0).production;
  } else {
    startVar = "none";
  }
  
  LSystem = combineLSystem(startVar, Productions, Replacements, iters);
  drawLSystem(LSystem, this, w/2, h/2, radians(angle), radians(offset), startWidth, decrease); // w/2, 5*h/6
  fill(220);
  strokeWeight(1);
  stroke(0);
  int comboProdRows = 1;
  if (LSystem.length() > 30) {
    comboProdRows = min(2 + (LSystem.length() - 50) / 70, 1);
  }
  BH = (Replacements.size() + 1 /* this +1 is for the + button */ + comboProdRows /* the other is for the combined production */) * 20;
  rect(sep + edge, height - BH - edge, width - (RW + sep * 2 + edge * 2), BH);
  minProdNum = 0;
  //wIandPN = new IntList();
  
      
  
  
  // This gets the production rules from each of the active windows and puts them into the text box in the main window
  for (int i = 0; i < Replacements.size() + 1 + comboProdRows; i++) {
    float currentW = sep + edge + 4;
    float currentH = height - BH - edge + 20*i - 3;
    fill(0);
    textAlign(LEFT,TOP);
    textSize(20);

    
    if (i == 0) {
      text("Start Variable : " + startVar, currentW, currentH);
    } else if (i < Replacements.size() + 1) {
      text(subWindows.get(i-1).production + " \u2192 " + Replacements.get(i-1), currentW, currentH);
    } else if (i == Replacements.size() + 1) {
      String more = "";
      if (LSystem.length() > 30) {
        more = "...";
      }
      text("Combo Production: " + LSystem.substring(0, min(30, LSystem.length())) + more, currentW, currentH);
    }
    //text(Productions.get(prodNum(minProdNum, maxSubWindows, subWindows)), currentW, currentH);
    if (i < Replacements.size() + 1 && !(Replacements.size() == maxSubWindows && i == 0)) {
      windowButtons.get(i).x = width - RW - sep - 18 - edge;
      windowButtons.get(i).y = currentH + comboProdRows*20 - 15; /*height - edge + step*i - buttonSize - 2 - comboProdRows * 20;*/
      
      // This places buttons that can remove (or add) production rules and their corresponding windows
      windowButtons.get(i).update();
      windowButtons.get(i).display();
    }
  }
  
  // Iterations Box
  fill(220);
  rect(width - RW - edge, height - RH - edge, RW, RH);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Iterations", width - edge - RW/2, height - edge - RH + 12);
  text(str(iters), width - edge - RW/2, height - edge - RH/2 + 6);
  
  fill(200);
  
  
  LGen.update();
  LGen.display();
  LGen.setFirstMousePress(false);
  
  RGen.update();
  RGen.display();
  RGen.setFirstMousePress(false);
  
  
  // Angle Box
  
  fill(220);
  rect(width - RW/2+sep/2 - edge, height - RH - SliderBounds*2 - 1.5*edge - 70, RW/2-sep/2, SliderBounds*2 + 70);
  //(h - edge - 1.5*RH - 2*SliderBounds - 5)
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Angle", width - RW/4+sep/2 - edge, height - 2*SliderBounds - RW*1.5 + 25);
  
  //textSize(20);
  text(nf(angle, 0, 1), width - RW/4+sep/2 - edge, height - edge - 9 - RH - edge);
  
  fill(200);
  
  // Offset Box
  
  fill(220);
  rect(width - RW - edge, height - RH - SliderBounds*2 - 1.5*edge - 70, RW/2-sep/2, SliderBounds*2 + 70);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Offset", width - 3*RW/4 - edge, height - 2*SliderBounds - RW*1.5 + 25);
  
  //textSize(20);
  text(nf(offset, 0, 1), width - 3*RW/4 - edge, height - edge - 9 - RH - edge);
  
  fill(200);
  
  
  //LAng.update();
  //LAng.display();
  //LAng.setFirstMousePress(false);
  
  //RAng.update();
  //RAng.display();
  //RAng.setFirstMousePress(false);
  if (AngleSlider.press) {
    angle = round(360.0 * AngleSlider.slideFraction - 180);
  } else if (animatingA) {
    angle = (angle + Arate + 180) % 360 - 180;
    AngleSlider.setSlideFraction((angle+180.0)/360.0);
    AngleSlider.x = AngleSlider.xmin+AngleSlider.slideFraction*(AngleSlider.xmax-AngleSlider.xmin);
    AngleSlider.y = AngleSlider.ymin+AngleSlider.slideFraction*(AngleSlider.ymax-AngleSlider.ymin);
  }
  
  if (OffsetSlider.press) {
    offset = round(360.0 * OffsetSlider.slideFraction - 180);
  } else if (animatingO) {
    offset = (offset - Orate - 180) % 360 + 180;
    OffsetSlider.setSlideFraction((offset+180.0)/360.0);
    OffsetSlider.x = OffsetSlider.xmin+OffsetSlider.slideFraction*(OffsetSlider.xmax-OffsetSlider.xmin);
    OffsetSlider.y = OffsetSlider.ymin+OffsetSlider.slideFraction*(OffsetSlider.ymax-OffsetSlider.ymin);
  }
  
  
  AngleSlider.update();
  AngleSlider.display();
  AngleSlider.setFirstMousePress(false);
  
  OffsetSlider.update();
  OffsetSlider.display();
  OffsetSlider.setFirstMousePress(false);
  
  for (Window w : subWindows) {
    w.setAngle(angle);
    w.setOffset(offset);
  }
  
  
  //print(angle);
}

void mousePressed() {
  // remove window
  //print(" old: " + WindowProds);
  for (int i = 0; i < windowButtons.size(); i++) {
    if (windowButtons.get(i).over) {
      windowButtons.get(i).over = false;
      if (windowButtons.get(i).s == "+") {
        //print("adding");
        addNewWindow();
      } else if (windowButtons.get(i).s == "-") {
        //print("removing");
        windowButtons.remove(windowButtons.get(i));
        subWindows.get(i-1).close();
        subWindows.remove(subWindows.get(i-1));
        WindowProds.remove(WindowProds.get(i-1));
        
        
      }
      //print(WindowProds);
    }
  }
  //print(" new: " + WindowProds);
  
  
  //StartTriangle.setWindowProds(WindowProds);
  
  //StartTriangle.setFirstMousePress(true);
  
  if (LGen.over) {
    iters--;
    if (iters < 0) {
      iters = 0;
    }
  }
  if (RGen.over) {
    iters++;
  }
  LGen.setFirstMousePress(true);
  RGen.setFirstMousePress(true);
  
  
  //if (LAng.over) {
  //  angle -= 10.0;
  //  if (angle < 0.0) {
  //    angle = 360 + angle;
  //  }
  //}
  //if (RAng.over) {
  //  angle = (angle + 15.0) % 360;
  //}
  //LAng.setFirstMousePress(true);
  //RAng.setFirstMousePress(true);
  
  //if (AngleSlider.over) {
  //  print("h");
  //  angle = 360 * AngleSlider.slideFraction;
  //}
  AngleSlider.setFirstMousePress(true);
  OffsetSlider.setFirstMousePress(true);
  //for (Node n : nodes) {
  //  n.setFirstMousePress(true);
  //}
  for (Window w : subWindows) {
    //print("first: " + w.WindowProds);
    w.setWindowProds(WindowProds);
    //print("second: " + w.WindowProds);
  }
}

void mouseDragged() {
  
}

void mouseReleased() {
  //for (Node n : nodes) {
  //  n.releaseEvent();
  //}
  LGen.releaseEvent();
  RGen.releaseEvent();
  LAng.releaseEvent();
  RAng.releaseEvent();
  AngleSlider.releaseEvent();
  OffsetSlider.releaseEvent();
  //StartTriangle.releaseEvent();
}

ArrayList<String> getWindowProds() {
  return WindowProds;
}

void addNewWindow() {
  for (int i = 0; i < maxSubWindows; i++) {
    boolean inList = false;
    for (int j = 0; j < subWindows.size(); j++) {
      if (subWindows.get(j).nth == i) {
        inList = true;
        break;
      }
    }
    if (!inList) {
      subWindows.add(i, new Window(this, L[i], i, OGWindowProds));
      subWindows.get(i).setWindowProds(WindowProds);
      windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
      //print(" old: " + WindowProds);
      WindowProds.add(i, L[i]);
      //print(" new: " + WindowProds);
      break;
    }
  }
}