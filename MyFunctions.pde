//// LERP
//pt L(pt A, pt B, float t) {
//  return P(A.x+t*(B.x-A.x), A.y+t*(B.y-A.y));
//}

pt Bezier3(pt A, pt B, pt C, float t) {
   return L(L(A,B,t),L(B,C,t),t); 
}

pt Bezier4(pt A, pt B, pt C, pt D, float t) {
   return L(Bezier3(A,B,C,t),Bezier3(B,C,D,t),t);  
}

pt Bezier5(pt A, pt B, pt C, pt D, pt E, float t) {  //Use this to draw the points, pass in t as a paramter
  return L(Bezier4(A,B,C,D,t),Bezier4(B,C,D,E,t),t);
}

pt Neville3(pt A, pt B, pt C, float t) {
   return L(L(A,B,2*t),L(B,C,2*t-1),t);  
}

pt Neville4(pt A, pt B, pt C, pt D, float t) {
   return L(Neville3(A,B,C,1.5*t),Neville3(B,C,D,1.5*t-0.5),t);
}

pt BillinearInterp(pt A, pt B, pt C, pt D, float t, float s) {
   return L(L(A,B,t),L(D,C,t),s);  
}

void drawBezierSides(int index0, int index1, int index2, int index3, int index4, pts P) {
  beginShape();
  pen(magenta, 1.5);
  for (float i = 0; i <=1; i+=0.01) {  //ADDED: Trying Bezier curve.
     pt temp = Bezier5(P.G[index0], P.G[index1], P.G[index2], P.G[index3], P.G[index4], i);
     vertex(temp.x,temp.y);
  }
  endShape();
}

//void drawBezierPoint(int index0, int index1, int index2, int index3, int index4, pts P, float t) {
//  pt temp = Bezier5(P.G[index0], P.G[index1], P.G[index2], P.G[index3], P.G[index4], t);
//  pen(black, 0.5);
//  fill(black);
//  ellipse(temp.x, temp.y,5,5);
//}

pt drawBezierPoint(int index0, int index1, int index2, int index3, int index4, pts P, float t) {
  pt temp = Bezier5(P.G[index0], P.G[index1], P.G[index2], P.G[index3], P.G[index4], t);
  pen(black, 0.5);
  fill(magenta);
  ellipse(temp.x, temp.y,5,5);
  noFill();
  return temp;
}

pt returnBezierPoint(int index0, int index1, int index2, int index3, int index4, pts P, float t) {
  return Bezier5(P.G[index0], P.G[index1], P.G[index2], P.G[index3], P.G[index4], t);
}

void drawNevilleSides(int index0, int index1, int index2, int index3, pts P) {
  beginShape();
  pen(cyan,1.5);
  for (float i = 0; i <=1; i+=0.01) {
    pt temp = Neville4(P.G[index0], P.G[index1], P.G[index2], P.G[index3], i);
    vertex(temp.x,temp.y);
  }
  endShape();
}

//void drawNevillePoint(int index0, int index1, int index2, int index3, pts P, float t) {
//  pt temp = Neville4(P.G[index0], P.G[index1], P.G[index2], P.G[index3], t);
//  pen(black, 0.5);
//  fill(black);
//  ellipse(temp.x, temp.y,5,5);
//}

pt drawNevillePoint(int index0, int index1, int index2, int index3, pts P, float t) {
  pt temp = Neville4(P.G[index0], P.G[index1], P.G[index2], P.G[index3], t);
  pen(black, 0.5);
  fill(blue);
  ellipse(temp.x, temp.y,5,5);
  noFill();
  return temp;
}

pt returnNevillePoint(int index0, int index1, int index2, int index3, pts P, float t) {
  return Neville4(P.G[index0], P.G[index1], P.G[index2], P.G[index3], t);
}

//void drawBiLinInterp(int index0, int index1, int index2, int index3, pts P) {
//  beginShape();
//  pen(black,0.5);
//  for (float i = 0; i <=1; i+=0.01) {
//    for (float j = 0; j <=1; j+=0.01) {
//      pt temp = BillinearInterp(P.G[index0], P.G[index1], P.G[index2], P.G[index3], i, j);
//      vertex(temp.x,temp.y);
//    } 
//  }
//  endShape();
//}

//void drawBiLinPoint(int index0, int index1, int index2, int index3, pts P) {  //index 4->7 and index 0->11
// pen(blue,0.5);
// fill(blue);
// pt temp = BillinearInterp(P.G[index0],P.G[index1],P.G[index2],P.G[index3], (float)mouseX/width,(float)mouseY/height); //t and s
// ellipse(temp.x,temp.y,5,5);
//}

pt drawBiLinPoint(int index0, int index1, int index2, int index3, pts P, float t, float s) {  //index 4->7 and index 0->11
 pen(blue,0.5);
 fill(green);
 pt temp = BillinearInterp(P.G[index0],P.G[index1],P.G[index2],P.G[index3], t,s); //t and s
 ellipse(temp.x,temp.y,5,5);
 noFill();
 return temp;
}

pt returnBiLinPoint(int index0, int index1, int index2, int index3, pts P, float t, float s) {  //index 4->7 and index 0->11
 return BillinearInterp(P.G[index0],P.G[index1],P.G[index2],P.G[index3], t, s); //t and s
}

//void drawCoonsPatchLine
