import processing.serial.*;

Serial myPort;
PrintWriter output;

int rquad=40;
int xquad=200;
int yquad=200;
boolean overRect = false;

//Colores del boton
int red=100;
int green=100;
int blue=100;

boolean status=false;
String texto="LED OFF";

int xlogo=400;
int ylogo=400;

int valor;

float rojo;
float verde;
float azul;
byte[] clip = new byte[32];

color redColor = color(250, 0, 0);
color greenColor = color(0, 75, 00);
color yellowColor = color(255, 255, 0);
color lilColor = color(19, 149, 240);
color blackColor = color(0, 0, 0);


long last_time=0;
int duration=3000;
long last_timeStar=0;
int durationStar=30;
byte blinker=100;
int angle;
byte nup=0;


PImage img;

void setup() {
  println(Serial.list());
  //  myPort = new Serial(this, Serial.list()[0], 115200);
  //output = createWriter("temp.txt");
  noStroke();



  size(800, 600);
  background(19, 149, 240); //Azul puerto
  PFont f = loadFont("Arial-BoldMT-48.vlw"); //Tipo de fuente. Si no existe, se crea desde TOOLS
  textFont(f, 38);
  textAlign(CENTER);
  fill (237, 240, 252);
  text("EVD Click", 400, 35);
  textFont(f, 20);
  text("Modelo de prueba para simulación de complementos en señalización", 400, 65);
  fill (0);
  textFont(f, 18);
  textAlign(LEFT);
  text("Habilitado", 30, 120);
  text("Activado", 140, 120);
  text("Sensor", 240, 120);
  text("Estados de alarma y operación", 500, 120);
  text("S1", 260, 160);
  text("Pulso operativo", 600, 160);
  text("S2", 260, 200);
  text("Bypass temporal", 600, 200);
  text("S3", 260, 240);
  text("Alarma acústica", 600, 240);
  text("S4", 260, 280);
  text("Interlock detención", 600, 280);
  text("S5", 260, 320);
  text("Relay #4", 600, 320);
  text("Llave switch bypass", 600, 360);
  text("Indicadores de traslación", 30, 370);
  text("Equipo en movimiento", 180, 410);
  text("Ubicación intermedia", 180, 450);
  text("En extremo norte", 180, 490);
  text("En extremo sur", 180, 530);

  //Firs check if image logo file exists
  File fImg=dataFile("logpnsacolor.png");
  boolean exist=fImg.isFile();
  //In case of that put it on the left top corner
  //Dejo la lógica invertida en este condicional para poner la imagen a voluntad
  if (!exist) {
    img = loadImage("logpnsacolor.png");
    image(img, 5, 5, width/5, height/7);
  }
}


void draw() {
  // if (myPort.available()>31) {
  //   clip=myPort.readBytes();
  // }
  long current_time=millis();

  if ((current_time - last_time)> duration) {
    last_time=millis();
    if (blinker==byte(200)) {
      blinker=byte(100);
    } else {
      blinker=byte(200);
    }
  }

  for (byte tex=0; tex<=31; tex++) {
    clip[tex]=byte(200);
  }

  clip[8]=blinker;

  float[] xpos = {560, 560, 560, 560, 560, 70, 70, 70, 70, 70, 180, 180, 180, 180, 180, 100, 100, 100, 560, 850, 100};
  float[] ypos = {270, 230, 190, 310, 150, 150, 190, 230, 270, 310, 150, 190, 230, 270, 310, 480, 520, 400, 350, 650, 440};
  float d1p=28;
  for (byte i=0; i<21; i++) {
    statusIndicator(clip[i], xpos[i], ypos[i], d1p, d1p);
  }

//INICIA LA SECCIÓN DE INTERES
//Blinker es la condición o status lógico que se toma como referencia para activar la animación de la
//estrella giratoria
  if (blinker==byte(200)) {
    if ((current_time - last_timeStar)>durationStar) {
      last_timeStar=millis();
      nup+=1;
      if (nup%2==0 || nup==0) {
        pushMatrix();
        translate(390, 322);
        fill(lilColor); //Colores para rojo
        ellipseMode(CENTER);
        ellipse(0, 0, 120, 120);
        popMatrix();
        estria(true);
      } //Es para generar la estrella rotante
    }
  } else if (blinker==byte(100)) {
    if ((current_time - last_timeStar)>durationStar) {
      last_timeStar=millis();
      nup+=1;
      if (nup%2==0 || nup==0) {
        pushMatrix();
        translate(390, 322);
        fill(lilColor); //Colores para rojo
        ellipseMode(CENTER);
        ellipse(0, 0, 120, 120);
        popMatrix();
        estria(false);
      } //Es para generar la estrella rotante
    }
  } else {
    pushMatrix();
    translate(390, 322);
    fill(lilColor); //Colores para rojo
    ellipseMode(CENTER);
    ellipse(0, 0, 120, 120);
    popMatrix();
  }
}


//Hacer girar la estrella e invertirle el giro según sea el caso del condicional en parámetro
void estria(boolean s) {
  pushMatrix();
  translate(390, 322);
  rotate(radians(angle));
  roTria(60, s);
  popMatrix();

  pushMatrix();
  translate(390, 322);
  rotate(radians(angle+30));
  roTriaInv(60, s);
  popMatrix();

  pushMatrix();
  translate(390, 322);
  rotate(radians(angle+60));
  roTria(60, s);
  popMatrix();

  pushMatrix();
  translate(390, 322);
  rotate(radians(angle+90));
  roTriaInv(60, s);
  popMatrix();

  pushMatrix();
  translate(390, 322);
  fill(lilColor); //Colores para rojo
  ellipseMode(CENTER);
  ellipse(0, 0, 90, 90);
  popMatrix();
}



//Dibujar el triángulo y asegurar el ángulo de avance para la siguiente secuencia
void roTria(int le, boolean sense) {
  fill(yellowColor);
  triangle(0, -le, -le*sqrt(3)/2, le/2,
    le*sqrt(3)/2, le/2);
  if (sense) {
    angle+=1;
  } else {
    angle-=1;
  }
}
void roTriaInv(int le, boolean sense) {
  fill(blackColor);
  triangle(0, -le, -le*sqrt(3)/2, le/2,
    le*sqrt(3)/2, le/2);
  if (sense) {
    angle+=1;
  } else {
    angle-=1;
  }
}
//FIN DE LA SECCIÓN DE INTERES
//=======================================================



//To fill color acording to byte value
void stateType(byte value) {
  if (value==byte(200)) {
    fill(greenColor); //Colores para verde
  } else {
    fill(redColor); //Colores para rojo
  }
}

//To scan status byte array and indicate each one of them according to table order from arduino
void statusIndicator(byte stFlag, float xcord, float ycord, float d1, float d2) {
  stateType(stFlag);
  ellipseMode(CENTER);
  ellipse(xcord, ycord, d1, d2);
  //size(400, 400);
}



/*
void draw() {
 
 if (mouseX > xquad-rquad && mouseY < xquad+rquad &&
 mouseY > yquad-rquad && mouseY < yquad+rquad)
 {
 stroke(205, 100, 100);
 overRect=true; //Contorno del rectangulo en un color especifico
 } else
 {
 stroke(0, 0, 0); //Contorno del rectangulo en un color especifico
 overRect=false;
 }
 
 //Dibujar rectangulo
 //  fill(red, green, blue);
 //  rectMode(RADIUS);
 //  rect(xquad, yquad, rquad, rquad);
 
 //Crear texto de color negro con la palabra led
 fill (0, 0, 0);
 //PFont f;
 PFont f = loadFont("Aharoni-Bold-50.vlw"); //Tipo de fuente. Si no existe, se crea desde TOOLS
 textFont(f, 20);
 text(texto, 170, 270);
 
 if (myPort.available()>31) {
 clip=myPort.readBytes();
 }
 
 valor=int(clip[4]);
 text("Temperatura = ", 390, 200);
 rectMode(RADIUS);
 fill(19, 149, 240); //Azul puerto
 stroke(19, 149, 240);
 rect(530, 200, 20, 20);
 fill(0, 0, 0);
 text(valor, 530, 200);
 
 // output.print(hour() + ":");
 // output.print(minute() + ":");
 // output.print(second());
 // output.print("   "+ valor + "°C ");
 //  output.println("");
 
 float temp = map (valor, 10, 42, 0, 255);//Escalamos la temperatura donde maximo sea 32ºC y mínimo 15ºC
 rojo=temp;
 verde=temp*-1 + 255;
 azul=temp*-1 + 255;
 //Dibujamos una esfera para colorear la temperatura
 noStroke();
 //valor
 if (valor==200) {
 fill(0, 75, 00); //Colores para verde
 } else {
 fill(250, 0, 0); //Colores para rojo
 }
 //fill(rojo, verde, azul);
 ellipseMode(CENTER);
 ellipse(590, 193, 40, 40);
 }
 
 void mousePressed()  //Cuando el mouse está apretado
 {
 if (overRect==true) //Si el mouse está dentro de rect
 {
 status=!status; //El estado del color cambia
 //    myPort.write("A"); //Envia una "A" para que el Arduino encienda el led
 if (status==true)
 {
 //Color del botón rojo
 red=255;
 green=0;
 blue=0;
 texto="LED ON";
 }
 if (status==false)
 {
 //Color del botón negro
 red=100;
 green=100;
 blue=100;
 texto="LED OFF";
 }
 }
 }
 */
