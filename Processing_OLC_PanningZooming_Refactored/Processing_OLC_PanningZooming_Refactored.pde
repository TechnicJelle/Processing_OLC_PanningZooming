//https://github.com/OneLoneCoder/videos/blob/master/OneLoneCoder_PanAndZoom.cpp

fVector offset;

fVector startPan = new fVector(0.0f, 0.0f);

float scale = 1.0;

fVector selectedCell = new fVector(0.0f, 0.0f);

nVector WorldToScreen (float fWorldX, float fWorldY) {
  int nScreenX = (int)((fWorldX - offset.x) * scale);
  int nScreenY = (int)((fWorldY - offset.y) * scale);
  return new nVector(nScreenX, nScreenY);
}

fVector ScreenToWorld (int nScreenX, int nScreenY) {
  float fWorldX = (float)(nScreenX) / scale + offset.x;
  float fWorldY = (float)(nScreenY) / scale + offset.y;
  return new fVector(fWorldX, fWorldY);
}

void setup() {
  size(160, 100);
  offset = new fVector(-width / 2.0f, -height / 2.0f);
}

void mousePressed() {
  if (mouseButton == CENTER)
    startPan = new fVector(mouseX, mouseY);

  fMouseWorld_AfterZoom = ScreenToWorld(mouseX, mouseY);
}

void mouseDragged() {
  if (mouseButton == CENTER) { 
    offset.x -= (mouseX - startPan.x) / scale;
    offset.y -= (mouseY - startPan.y) / scale;

    startPan = new fVector(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT)
    selectedCell = new fVector(int(fMouseWorld_AfterZoom.x), int(fMouseWorld_AfterZoom.y));
}


fVector fMouseWorld_AfterZoom;
void mouseWheel(MouseEvent event) {
  fVector fMouseWorld_BeforeZoom = ScreenToWorld(mouseX, mouseY);

  scale *= 1 - event.getCount() / 10.0f;

  fMouseWorld_AfterZoom = ScreenToWorld(mouseX, mouseY);

  offset.x += (fMouseWorld_BeforeZoom.x - fMouseWorld_AfterZoom.x);
  offset.y += (fMouseWorld_BeforeZoom.y - fMouseWorld_AfterZoom.y);
}

void draw() {
  background(0);

  for (float y = 0.0f; y <= 10.0f; y++) {
    float sx = 0.0f, sy = y;
    float ex = 10.0f, ey = y;

    nVector pixel_s = WorldToScreen(sx, sy);
    nVector pixel_e = WorldToScreen(ex, ey);

    noFill();
    stroke(255);
    strokeWeight(1);
    line(pixel_s.x, pixel_s.y, pixel_e.x, pixel_e.y);
  }

  for (float x = 0.0f; x <= 10.0f; x++) {
    float sx = x, sy = 0.0f;
    float ex = x, ey = 10.0f;

    nVector pixel_s = WorldToScreen(sx, sy);
    nVector pixel_e = WorldToScreen(ex, ey);

    noFill();
    stroke(255);
    strokeWeight(1);
    line(pixel_s.x, pixel_s.y, pixel_e.x, pixel_e.y);
  }

  nVector c = WorldToScreen(selectedCell.x + 0.5f, selectedCell.y + 0.5f);
  int cr = int(0.3f * scale);
  fill(255, 0, 0);
  noStroke();
  circle(c.x, c.y, cr);
}

class nVector {
  int x;
  int y;

  nVector(int _x, int _y) {
    x = _x;
    y = _y;
  }
}

class fVector {
  float x;
  float y;

  fVector(float _x, float _y) {
    x = _x;
    y = _y;
  }
}
