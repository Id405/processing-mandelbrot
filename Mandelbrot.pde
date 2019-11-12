//Drag mouse to pan camera, scrollwheel to zoom, shift + scrollwheel to change iterations

PShader MB;

float scrollSpeed = 0.1; // Speed at which you zoom
float iterSpeed = 1; // Speed at which you change the iterations

float cameraX = -0.5; // Camera information
float cameraY = 0.0;
float scale = 3.5;

float trapX = 0.0;
float trapY = 0.0;
float contrast = 0.02;

float iterations = 50;

void setup() {
  size(800, 800, P2D);
  surface.setResizable(true);
  MB = loadShader("OrbitTrapping.glsl"); // Load glsl shader
  
  MB.set("g1", 0.7, 0.0); // Comment these lines if not using OrbitTrapping.glsl
  MB.set("g2", 0.5, 1.0);
  MB.set("contrast", contrast);
}

void draw() {
  background(255);
  MB.set("iResolution", float(width), float(height));
  
  MB.set("scale", scale);
  MB.set("transl", cameraX, cameraY);
  MB.set("iterations", iterations);
  MB.set("trap", trapX, trapY); // Comment this line too
  
  shader(MB);
  rect(0, 0, width, height); // Draw rectangle over the screen so the glsl shader applies to it
}

void mouseDragged() { // Pan Camera
  if(mouseButton == CENTER) {
    cameraX += float(pmouseX - mouseX)/width * scale;
    cameraY += float(mouseY - pmouseY)/height * scale;
  }
}

void mouseWheel(MouseEvent event) { // Zoom or change iterations
  float count = event.getCount();
  if(keyCode == SHIFT && keyPressed) {
    iterations += round(count * iterSpeed * (iterations/10));
  } else {
    scale += (count * scrollSpeed) * scale;
  }
}
