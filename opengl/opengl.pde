import processing.opengl.*;
void setup() {
  size(400,400,OPENGL);
  smooth();
  frameRate(30);
}

void draw() {
  background(0);
  translate(200,200);
  rotateX(map(mouseY,0,height,0,PI));
  rotateY(map(mouseX,0,width,0,PI));
  fill(255,0,0);
  box(150);
}
