// LecturesInGraphics: 
// Points-base source for project 05
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  ??? ???

//**************************** global variables ****************************
pts P = new pts(); // Guide points
pts S = new pts(); // points of stroke
int[] lineLengths = { 5, 4, 5, 4 };
float t=0, f=0;
boolean animate=false, showStrokes=true, showPoints = true;
//STUFF I ADDED
//pt s; //ADDED
//pt t; //ADDED
float animator; //ADDED
boolean jarekLines;
boolean sToggle, tToggle;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pleaseRes.png");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare().resetOnCircle(14);
  S.declare();
  
  jarekLines = true; //ADDED
  sToggle = true; //ADDED
  tToggle = true; //ADDED

  
  pt TL = P(width/5, height/5);
  pt BR = P(4*width/5, 4*height/5);

  for (int i = 0; i < 5; i++) {
     linePoint(P, 0, i).setTo(P(TL.x, L(TL.y, BR.y, i/4f)));
     linePoint(P, 2, i).setTo(P(BR.x, L(TL.y, BR.y, i/4f)));
  }
  for (int i = 0; i < 4; i++) {
     linePoint(P, 1, i).setTo(P(L(TL.x, BR.x, i/3f), TL.y));
     linePoint(P, 3, i).setTo(P(L(TL.x, BR.x, i/3f), BR.y));
  }
}

/**
 * Draws the line with the given index (0-3).
 * @param P - storage pts object
 * @param index - point index value 0-4
 * */
void drawPolyline(pts P, int line) {
  for (int i = 0; i < lineLengths[line]-1; i++) {
    edge(linePoint(P, line, i), linePoint(P, line, i+1));
  }
}

float L(float a, float b, float s) { return a*(1-s) + b*s; }

/**
 * Returns the point on line (line) at index (index).
 * @param P - storage pts object
 * @param line - line index value 0-4
 * @param index - point index value 0-4 or 0-5
 * */
pt linePoint(pts P, int line, int index) {
  if (line == 0) index = 4 - index;
  else if (line == 3) index = 3 - index;
  
  for (int i = 0; i < line; i++) 
    index += lineLengths[i]-1; // -1 because it wraps
  return P.G[index % P.nv];
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  
//*******************************************************************************
//*******************************************************************************
//*******************************************************************************
   
   float s = (float)mouseY/height; //ADDED  
   float t = (float)mouseX/width; //ADDED
  
   //Draw the curves
   drawBezierSides(4,3,2,1,0,P); //ADDED
   drawBezierSides(7,8,9,10,11,P); //ADDED
   drawNevilleSides(4,5,6,7,P); //ADDED
   drawNevilleSides(0,13,12,11,P); //ADDED
//   drawBiLinInterp(0,4,7,11,P); //ADDED

   //Draw the billinear interpolation point
   pt bilin = drawBiLinPoint(4,7,11,0,P,t,s); //ADDED
   
   pt alpha, bravo, charlie, delta; //Points for temporary storage.
   
   //Draw the bezier points
   alpha = drawBezierPoint(4,3,2,1,0,P,s);
   bravo = drawBezierPoint(7,8,9,10,11,P,s);
   line(alpha.x,alpha.y,bravo.x,bravo.y);
   
   //Draw t along the line connecting the s points on either bezier
   charlie = L(alpha, bravo, t);  //Charlie is the bezier point
   fill(yellow);
   ellipse(charlie.x,charlie.y, 5,5);
   noFill();
   
   //Draw the neville points
   alpha = drawNevillePoint(4,5,6,7,P,t);
   bravo = drawNevillePoint(0,13,12,11,P,t);
   line(alpha.x,alpha.y,bravo.x,bravo.y);
   
   //Draw s along the line connecting the t points on either neville
   delta = L(alpha, bravo, s);  //Delta is the neville point
   fill(red);
   ellipse(delta.x,delta.y, 5,5);
   noFill();
   
   //Compute and draw the coon's patch point with respect to mouse position
   pt copa = new pt(charlie.x+delta.x-bilin.x,charlie.y+delta.y-bilin.y);
   fill(cyan);
   ellipse(copa.x, copa.y, 5, 5);
   noFill();
   
   //********Drawing the Coon's Patch interpolations********
   
   pt bezier1, neville1, bilinC;  //More temporary pt variables
   
   //Draw the coon's patch lerp of s for every time t (horizontal coon's patch, with constant s and variable t) ->Compute delta a whole bunch, but keep charlie
   if(sToggle) {
     beginShape();
     stroke(red);
     strokeWeight(2);
     for(float i = 0; i <=1.0; i+=0.01) {
       //Compute the neville points
       alpha = returnNevillePoint(4,5,6,7,P,i);
       bravo = returnNevillePoint(0,13,12,11,P,i);
       neville1 = L(alpha, bravo, s);
       //Compute the bezier points
       alpha = returnBezierPoint(4,3,2,1,0,P,s);
       bravo = returnBezierPoint(7,8,9,10,11,P,s);
       bezier1 = L(alpha, bravo, i);  //Charlie is the bezier point
       //Compute the bilinear point
       bilinC = returnBiLinPoint(4,7,11,0,P,i,s);
       //DO THE COON'S PATCH
       copa = new pt(bezier1.x+neville1.x-bilinC.x,bezier1.y+neville1.y-bilinC.y);
       vertex(copa.x,copa.y);
     }
     endShape();
   }//end of if(sToggle)
   
   //Draw the coon's patch lerp of t for every time s (vertical coon's patch, with constant t and variable s) ->Compute charlie a whole bunch, but keep delta
   if (tToggle) {  
     beginShape();
     stroke(blue);
     strokeWeight(2);
     for(float i = 0; i <=1.0; i+=0.01) {
       //Compute the neville points
       alpha = returnNevillePoint(4,5,6,7,P,t);
       bravo = returnNevillePoint(0,13,12,11,P,t);
       neville1 = L(alpha, bravo, i);
       //Compute the bezier points
       alpha = returnBezierPoint(4,3,2,1,0,P,i);
       bravo = returnBezierPoint(7,8,9,10,11,P,i);
       bezier1 = L(alpha, bravo, t);  //Charlie is the bezier point
       //Compute the bilinear point
       bilinC = returnBiLinPoint(4,7,11,0,P,t,i);
       //DO THE COON'S PATCH
       copa = new pt(bezier1.x+neville1.x-bilinC.x,bezier1.y+neville1.y-bilinC.y);
       vertex(copa.x,copa.y);
     }
     endShape();
   }//end of if(tToggle)
   
   //Animate the above coon's patch lines if A is pressed
   if (animate) {
     //Draw the coon's patch lerp of s for every time t (horizontal coon's patch, with constant s and variable t) ->Compute delta a whole bunch, but keep charlie
     beginShape();
     stroke(red);
     strokeWeight(2);
     for(float i = 0; i <=1.0; i+=0.01) {
       //Compute the neville points
       alpha = returnNevillePoint(4,5,6,7,P,i);
       bravo = returnNevillePoint(0,13,12,11,P,i);
       neville1 = L(alpha, bravo, animator);
       //Compute the bezier points
       alpha = returnBezierPoint(4,3,2,1,0,P,animator);
       bravo = returnBezierPoint(7,8,9,10,11,P,animator);
       bezier1 = L(alpha, bravo, i);  //Charlie is the bezier point
       //Compute the bilinear point
       bilinC = returnBiLinPoint(4,7,11,0,P,i,animator);
       //DO THE COON'S PATCH
       copa = new pt(bezier1.x+neville1.x-bilinC.x,bezier1.y+neville1.y-bilinC.y);
       vertex(copa.x,copa.y);
     }
     endShape();
     
     //Draw the coon's patch lerp of t for every time s (vertical coon's patch, with constant t and variable s) ->Compute charlie a whole bunch, but keep delta
     beginShape();
     stroke(blue);
     strokeWeight(2);
     for(float i = 0; i <=1.0; i+=0.01) {
       //Compute the neville points
       alpha = returnNevillePoint(4,5,6,7,P,animator);
       bravo = returnNevillePoint(0,13,12,11,P,animator);
       neville1 = L(alpha, bravo, i);
       //Compute the bezier points
       alpha = returnBezierPoint(4,3,2,1,0,P,i);
       bravo = returnBezierPoint(7,8,9,10,11,P,i);
       bezier1 = L(alpha, bravo, animator);  //Charlie is the bezier point
       //Compute the bilinear point
       bilinC = returnBiLinPoint(4,7,11,0,P,animator,i);
       //DO THE COON'S PATCH
       copa = new pt(bezier1.x+neville1.x-bilinC.x,bezier1.y+neville1.y-bilinC.y);
       vertex(copa.x,copa.y);
     }
     endShape();
     
     System.out.println(animator);

    if (animator >= 1.0) {
      animator = 0.0;
    }
    else {
      animator+=0.01;
    }    
   }//End of animate

//*******************************************************************************
//*******************************************************************************
//*******************************************************************************   

  // Draw strokes
  int[] colors = { 
    red, black, green, blue
  };
  if (jarekLines) { // ADDED
    for (int i = 0; i < lineLengths.length; i++) {
      pen(colors[i%colors.length], 2);
      drawPolyline(P, i);
    }
  }//end of if(jarekLines)

  // Draw points
  if (showPoints) {
    pen(black, 1);
    int R = 15;
    for (int i = 0; i < P.nv; i++) {
      fill(white);
      show(P.G[i], R);
      fill(black);
      label(P.G[i], String.valueOf((char)('A'+i)));
    }

    // Draw color-coded indices
    vec offset = V(-R*2, 0);
    for (int line = 0; line < 4; line++) {
      fill(colors[(line%colors.length)]);
      pt M = P(0, 0);
      for (int i = 0; i < 4; i++) {
        pt p = linePoint(P, line, i);
        M.add(p);
        label(P(p, offset), String.valueOf(i));
      }
      M.scale(0.25f);
      label(P(M, S(2.5f, offset)), "Line " + line); 
      offset = R(offset);
    }
  }

  if (showStrokes) {
    noFill(); 
    stroke(blue); 
    S.drawCurve();
  } 

  displayHeader();
  if (scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if (filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++, 4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
}  // end of draw()

//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
  // till it is released or another key is pressed or released
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
  if (key=='~') { 
    filming=!filming;
  } // filming on/off capture frames into folder FRAMES
  //if (key=='s') P.savePts("data/pts");   
  if (key=='l') P.loadPts("data/pts"); 
  if (key=='p') showPoints = !showPoints;
  if (key=='S') showStrokes=!showStrokes;   // quit application
  if (key=='Q') exit();  // quit application
  change=true;
  //Below here are ADDED by me
  if (key=='a') {animate = !animate;
                 animator = 0;}
  if (key=='j') {jarekLines = !jarekLines;
  }
  if (key=='s') {sToggle = !sToggle;}
  if (key=='t') {tToggle = !tToggle;}
}

void mousePressed() {  // executed when the mouse is pressed
  if (keyPressed && key==' ') S.empty();
  if (!keyPressed) P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
}

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
    if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
    if (key=='t') {
      P.dragAll();
      S.dragAll();
    } // move all vertices
    if (key=='r') {
      P.rotateAll(ScreenCenter(), Mouse(), Pmouse());
      S.rotateAll(ScreenCenter(), Mouse(), Pmouse());
    } // turn all vertices around their center of mass
    if (key=='z') {
      P.scaleAll(ScreenCenter(), Mouse(), Pmouse()); 
      S.scaleAll(ScreenCenter(), Mouse(), Pmouse());
    } // scale all vertices with respect to their center of mass
    if (key==' ') S.addPt(Mouse());
  }
  change=true;
}  

//**************************** text for name, title and help  ****************************
String title ="Project 5: Coon Patch and Neville Interpolation", 
name ="CS3451 Fall 2014  Ryan Mendes", 
menu="j: toggle border lines | a: animate each coon's patch over time | s and t: toggle individual coon's patch curves", 
guide="drag to edit curve vertices"; // help info


