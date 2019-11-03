PShader MB;

float scrollSpeed = 0.1;
float iterSpeed = 1;

float cameraX = -0.5;
float cameraY = 0.0;
float scale = 3.5;
float iterations = 50;

void setup() {
  size(800, 800, P2D);
  surface.setResizable(true);
  MB = loadShader("Mandelbrot.glsl");
}

void draw() {
  background(255);
  MB.set("iResolution", float(width), float(height));
  
  MB.set("scale", scale);
  MB.set("transl", cameraX, cameraY);
  MB.set("iterations", iterations);
  
  shader(MB);
  rect(0, 0, width, height);
}

void mouseDragged() {
  cameraX += float(pmouseX - mouseX)/width * scale;
  cameraY += float(mouseY - pmouseY)/height * scale;
}

void mouseWheel(MouseEvent event) {
  float count = event.getCount();
  if(keyCode == SHIFT && keyPressed) {
    iterations += round(count * iterSpeed * (iterations/10));
  } else {
    scale += (count * scrollSpeed) * scale;
  }
}
