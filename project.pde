//Benny Sakiewicz, Etash Kalra, Sai Maddhi

float angle = 0; // angle to be rotated by
PVector[] points = new PVector[8]; // point array to store the vertices

PVector X; // the yz plane projected points
PVector Y; // the xz plane projected points
PVector Z; // the xy plane projected points

//projection matrices
float[][] projectionZ = {
  {1, 0, 0},
  {0, 1, 0},
  {0, 0, 0}
};

float[][] projectionX = {
  {0, 0, 0},
  {0, 1, 0},
  {0, 0, 1} 
};

float[][] projectionY = {
  {1, 0, 0},
  {0, 0, 0},
  {0, 0, 1}
};


void setup() {
  //canvas size
  fullScreen(P3D);
  
  // setting the vertices
  points[0] = new PVector(1, 0, 1);
  points[1] = new PVector(2, 0, 1);
  points[2] = new PVector(2, -1, 1);
  points[3] = new PVector(1, -1, 1);
  points[4] = new PVector(1, 0, 2);
  points[5] = new PVector(2, 0, 2);
  points[6] = new PVector(2, -1, 2);
  points[7] = new PVector(1, -1, 2);
}

void draw() {
  //saveFrame("frame-######.png"); // saving the frames
  background(255);
  translate(width/4, height/2); // move to the center of the canvas
  
  drawGraphs(); // draw the axes
  
  // rotation matrices
  float[][] rotationZ = {
    { cos(angle), -sin(angle), 0},
    { sin(angle), cos(angle), 0},
    { 0, 0, 1}
  };

  float[][] rotationX = {
    { 1, 0, 0},
    { 0, cos(angle), -sin(angle)},
    { 0, sin(angle), cos(angle)}
  };

  float[][] rotationY = {
    { cos(angle), 0, sin(angle)},
    { 0, 1, 0},
    { -sin(angle), 0, cos(angle)}
  };
  
  
  // new projected points
  PVector[] projectedZ = new PVector[8];
  PVector[] projectedX = new PVector[8];
  PVector[] projectedY = new PVector[8];
  PVector[] nPoints = new PVector[8];
  
  for (int i = 0; i < 8; i++) {
    nPoints[i] = points[i];
    //rotate the point by multiplying by rotation matrices
    nPoints[i] = matmul(rotationY, nPoints[i]);
    nPoints[i] = matmul(rotationX, nPoints[i]);
    nPoints[i] = matmul(rotationZ, nPoints[i]);
    PVector projected2d = matmul( projectionZ, nPoints[i]); // xy projection
    projected2d.mult(60);
    projectedZ[i] = projected2d;
    projected2d = matmul( projectionX, nPoints[i]); // yz projection
    projected2d.mult(60);
    projectedX[i] = projected2d;
    projected2d = matmul( projectionY, nPoints[i]); // xz projection
    projected2d.mult(60);
    projectedY[i] = projected2d;
    //point(projected2d.x, projected2d.y);
  }
  
  //display the rotated cube vertices
  for(int i = 0; i < 8; i++){
    PVector v = nPoints[i];
    stroke(0, 100, (i * 32) % 255);
    strokeWeight(20);
    noFill();
    point(60 * v.x, 60 * v.y, 60 * v.z);
  }
  
  // print yz projection
  for(int i = 0; i < 8; i++){
    PVector v = projectedX[i];
    stroke(0, 100, (i * 32) % 255);
    strokeWeight(20);
    noFill();
    point(v.z + width / 4, v.y - height / 3);
  }
  
  //print xz projection
  for(int i = 0; i < 8; i++){
    PVector v = projectedY[i];
    stroke(0, 100, (i * 32) % 255);
    strokeWeight(20);
    noFill();
    point(v.x + width / 4, v.z + height / 3);
  }
  
  //print yz projection
  for(int i = 0; i < 8; i++){
    PVector v = projectedZ[i];
    stroke(0, 100, (i * 32) % 255);
    strokeWeight(20);
    noFill();
    point(v.x + width / 2, v.y);
  }

  // Connecting all the vertices that make the cube
  for (int i = 0; i < 4; i++) {
    connect(i, (i+1) % 4, nPoints);
    connect(i+4, ((i+1) % 4)+4, nPoints);
    connect(i, i+4, nPoints);
  }
  // keep rotating
  angle += 0.01;
  if(key == ' ') // pause if spacebar is pressed
    noLoop();
} 

//connect all the points of the cube that need to be connected
void connect(int i, int j, PVector[] points) {
  PVector a = points[i];
  PVector b = points[j];
  strokeWeight(1);
  stroke(0);
  line(60 * a.x, 60 * a.y, 60 * a.z, 60 * b.x, 60 * b.y, 60 * b.z);
}

// multiply matrices
PVector matmul(float[][] a, PVector b) {
  float[][] m = {
                {b.x},
                {b.y},
                {b.z}};
  m = matmul(a, m);
  return new PVector(m[0][0], m[1][0], m[2][0]);
}

//multiply matrices
float[][] matmul(float[][] a, float[][] b) {
  int colsA = a[0].length;
  int rowsA = a.length;
  int colsB = b[0].length;
  int rowsB = b.length;

  if (colsA != rowsB) {
    println("Columns of A must match rows of B");
    return null;
  }

  float result[][] = new float[rowsA][colsB];

  for (int i = 0; i < rowsA; i++) {
    for (int j = 0; j < colsB; j++) {
      float sum = 0;
      for (int k = 0; k < colsA; k++) {
        sum += a[i][k] * b[k][j];
      }
      result[i][j] = sum;
    }
  }
  return result;
}

// draw the graphs
void drawGraphs(){
  stroke(255,0,0);
  line(width / 4 + 150, height / 3, 0, width / 4 - 150, height / 3, 0);
  line(-250, 0, 0, 250, 0, 0); 
  stroke(0, 255, 0);
  line(width / 4 + 150, -height / 3, 0, width / 4 - 150, -height / 3, 0);
  line(0, 250, -20, 0, -250, 20);
  stroke(0, 0, 255);
  line(width / 4, -height / 3 + 150, 0, width / 4, -height / 3 - 150, 0);
  line(width / 4, height / 3 + 150, 0, width / 4, height / 3 - 150, 0);
  line(0, -20, -250, 0, 20, 250);
  stroke(255, 0, 0);
  line(width / 2 - 150, 0, 0, 150 + width / 2, 0, 0);
  stroke(0,255,0);
  line(width / 2, 150, 0, width / 2, -150, 0);
    
}
