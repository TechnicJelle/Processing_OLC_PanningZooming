//https://github.com/OneLoneCoder/videos/blob/master/OneLoneCoder_PanAndZoom.cpp

float fOffsetX = 0.0f;
float fOffsetY = 0.0f;

float fStartPanX = 0.0f;
float fStartPanY = 0.0f;

float fScaleX = 1.0f;
float fScaleY = 1.0f;

float fSelectedCellX = 0.0f;
float fSelectedCellY = 0.0f;

IVector WorldToScreen (float fWorldX, float fWorldY) {
  int nScreenX = (int)((fWorldX - fOffsetX) * fScaleX);
  int nScreenY = (int)((fWorldY - fOffsetY) * fScaleY);
  return new IVector(nScreenX, nScreenY);
}

PVector ScreenToWorld (int nScreenX, int nScreenY) {
  float fWorldX = (float)(nScreenX) / fScaleX + fOffsetX;
  float fWorldY = (float)(nScreenY) / fScaleY + fOffsetY;
  return new PVector(fWorldX, fWorldY);
}

void setup() {
  size(160, 100);
  fOffsetX = -width / 2;
  fOffsetY = -height / 2;
}

void mousePressed() {
  if (mouseButton == CENTER) { 
    fStartPanX = mouseX;
    fStartPanY = mouseY;
  }
  fMouseWorld_AfterZoom = ScreenToWorld(mouseX, mouseY);
}

void mouseDragged() {
  if (mouseButton == CENTER) { 
    fOffsetX -= (mouseX - fStartPanX) / fScaleX;
    fOffsetY -= (mouseY - fStartPanY) / fScaleY;

    fStartPanX = mouseX;
    fStartPanY = mouseY;
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    fSelectedCellX = int(fMouseWorld_AfterZoom.x);
    fSelectedCellY = int(fMouseWorld_AfterZoom.y);
  }
}


PVector fMouseWorld_AfterZoom;
void mouseWheel(MouseEvent event) {
  PVector fMouseWorld_BeforeZoom = ScreenToWorld(mouseX, mouseY);

  fScaleX *= 1 - event.getCount() / 10.0f;
  fScaleY *= 1 - event.getCount() / 10.0f;

  fMouseWorld_AfterZoom = ScreenToWorld(mouseX, mouseY);

  fOffsetX += (fMouseWorld_BeforeZoom.x - fMouseWorld_AfterZoom.x);
  fOffsetY += (fMouseWorld_BeforeZoom.y - fMouseWorld_AfterZoom.y);
}

void draw() {
  background(0);

  for (float y = 0.0f; y <= 10.0f; y++) {
    float sx = 0.0f, sy = y;
    float ex = 10.0f, ey = y;

    IVector pixel_s = WorldToScreen(sx, sy);
    IVector pixel_e = WorldToScreen(ex, ey);

    noFill();
    stroke(255);
    strokeWeight(1);
    line(pixel_s.x, pixel_s.y, pixel_e.x, pixel_e.y);
  }

  for (float x = 0.0f; x <= 10.0f; x++) {
    float sx = x, sy = 0.0f;
    float ex = x, ey = 10.0f;

    IVector pixel_s = WorldToScreen(sx, sy);
    IVector pixel_e = WorldToScreen(ex, ey);

    noFill();
    stroke(255);
    strokeWeight(1);
    line(pixel_s.x, pixel_s.y, pixel_e.x, pixel_e.y);
  }

  IVector c = WorldToScreen(fSelectedCellX + 0.5f, fSelectedCellY + 0.5f);
  int cr = int(0.3f * fScaleX);
  fill(255, 0, 0);
  noStroke();
  circle(c.x, c.y, cr);
}

class IVector {
  int x;
  int y;

  IVector(int _x, int _y) {
    x = _x;
    y = _y;
  }
}
