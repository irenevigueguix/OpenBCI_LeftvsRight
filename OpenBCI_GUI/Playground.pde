//////////////////////////////////////////////////////////////////////////
//
//		Playground Class
//		Created: 11/22/14 by Conor Russomanno
//		An extra interface pane for additional GUI features
//
//////////////////////////////////////////////////////////////////////////


class Playground {

  //Button for opening and closing
  float x, y, w, h;
  color boxBG;
  color strokeColor;
  color green;
  color red;
  color softgray;
  color darkgray;
  color eggshell;
  PFont myFont;
  float topMargin, bottomMargin;

  boolean isOpen;
  boolean collapsing;

  boolean OBCI_inited= false;
  OpenBCI_ADS1299 OBCI;
  public String but_txt;

  // Buttons
  Button collapser;
  Button StartTrial;
  Button StopTrial;
  Button Right;
  Button Left;
  Button Random;
  Button bpm30;
  Button bpm45;
  Button bpm60;
  Button bpm120; 
  boolean StartTrialButtonPressed = false;
  boolean StopTrialButtonPressed = false;
  boolean RightButtonPressed = false;
  boolean LeftButtonPressed = false;
  boolean RandomButtonPressed = false;
  boolean bpm30ButtonPressed = false;
  boolean bpm45ButtonPressed = false;
  boolean bpm60ButtonPressed = false;
  boolean bpm120ButtonPressed = false;
  boolean audiobpm30;
  boolean audiobpm45;
  boolean audiobpm60;
  boolean audiobpm120;

  //Radio[] hand = new Radio [3];
  //Radio[] bpm = new Radio [4];

  // Timing
  boolean TestRunning = false;
  int startingTime;
  int seconds;
  int minutes;
  int onlysecs; 
  int ThisTime;
  int bonusTime = 0;
  int sec;
  int min;
  int countdown;
  int count = 1;

  // Audio Files
  Minim minim;
  AudioPlayer player30bpm;
  AudioPlayer player45bpm;
  AudioPlayer player60bpm;
  AudioPlayer player120bpm;

  // *********************************************** void SETUP *********************************************** 

  Playground(int _topMargin) {

    // Colors
    strokeColor = color(138, 146, 153);
    green = color(115, 220, 120);
    red = color(230, 120, 140);
    softgray =  color(240, 240, 240);
    darkgray = color(200, 200, 200);
    eggshell = color(255);

    // Buttons
    collapser = new Button(0, 0, 20, 60, "<", 14);
    Right = new Button (int(x+30), int(y+140), 60, 20, "Right", 10);
    Left = new Button (int(x+30), int(y+165), 60, 20, "Left", 10);
    Random = new Button (int(x+30), int(y+190), 60, 20, "Random", 10);
    bpm30 = new Button (int(x+180), int(y+140), 60, 20, "30 bpm", 10);
    bpm45 = new Button (int(x+180), int(y+165), 60, 20, "45 bpm", 10);
    bpm60 = new Button (int(x+180), int(y+190), 60, 20, "60 bpm", 10);
    bpm120 = new Button (int(x+180), int(y+215), 60, 20, "120 bpm", 10);
    StartTrial = new Button(int(x+30), int(y+275), 120, 20, "Start Expriment", 12);
    StopTrial = new Button(int(x+180), int(y+275), 120, 20, "Stop Experiment", 12);

    StartTrial.setColorPressed(darkgray);
    StartTrial.setColorNotPressed(green);
    StopTrial.setColorPressed(darkgray);
    StopTrial.setColorNotPressed(red);
    Right.setColorPressed(darkgray);
    Right.setColorNotPressed(softgray);
    Left.setColorPressed(darkgray);
    Left.setColorNotPressed(softgray);
    Random.setColorPressed(darkgray);
    Random.setColorNotPressed(softgray);
    bpm30.setColorPressed(darkgray);
    bpm30.setColorNotPressed(softgray);
    bpm45.setColorPressed(darkgray);
    bpm45.setColorNotPressed(softgray);
    bpm60.setColorPressed(darkgray);
    bpm60.setColorNotPressed(softgray);
    bpm120.setColorPressed(darkgray);
    bpm120.setColorNotPressed(softgray);

    // Load Audio Files
    minim = new Minim(this); // we pass this to Minim so that it can load files from the data directory
    //// loadFile will look in all the same places as loadImage does. This means that you can find files that are in the data folder and the sketch folder. You can also pass an absolute path, or a URL.
    //player30bpm = minim.loadFile("/data/30BPM.mp3");
    //player45bpm = minim.loadFile("/data/45BPM.mp3");
    //player60bpm = minim.loadFile("/data/60BPM.mp3");
    //player120bpm = minim.loadFile("/data/120BPM.mp3");

    //audiobpm30 = false;
    //audiobpm45 = false;
    //audiobpm60 = false;
    //audiobpm120 = false;

    topMargin = _topMargin;
    bottomMargin = helpWidget.h;

    isOpen = false;
    collapsing = true;

    boxBG = color(255);
    strokeColor = color(138, 146, 153);
    collapser = new Button(0, 0, 20, 60, "<", 14);

    x = width;
    y = topMargin;
    w = 0;
    h = height - (topMargin+bottomMargin);
  }

  public void initPlayground(OpenBCI_ADS1299 _OBCI) {
    OBCI = _OBCI;
    OBCI_inited = true;
  }

  public void update() {
    // verbosePrint("uh huh");
    if (collapsing) {
      collapse();
    } else {
      expand();
    }

    if (x > width) {
      x = width;
    }
  }

  // *********************************************** void DRAW *********************************************** 


  public void draw() {
    // verbosePrint("yeaaa");

    pushStyle();
    fill(boxBG);
    stroke(strokeColor);
    rect(width - w, topMargin, w, height - (topMargin + bottomMargin));
    textFont(f1);
    textAlign(LEFT, TOP);
    fill(bgColor);
    text("LEFT-HAND VS. RIGHT-HAND", x + 10, y + 10);
    text("TAPPING EXPERIMENT", x + 10, y + 30);
    fill(255, 0, 0);
    collapser.draw(int(x - collapser.but_dx), int(topMargin + (h-collapser.but_dy)/2));
    popStyle();

    textFont(f3, 12);
    text("A rhythm will be presented and you will have to tap to it", x+170, y+70);
    text("accordingly to the selected hand and BPM.", x+135, y+90);

    textFont(f1);
    textAlign(LEFT, TOP);
    fill(bgColor);
    text("Select Hand", x+30, y+120);

    textFont(f1);
    textAlign(LEFT, TOP);
    fill(bgColor);
    text("Select BPM ", x+180, y+120);

    textFont(f1);
    textAlign(LEFT, TOP);
    fill(bgColor);
    text("Are you ready?", x+30, y+250);

    ////////////////////////////////////////////////////////////////////////////////// TRIAL STUFF 

    // Timing
    ThisTime = (millis() - startingTime)+ bonusTime;
    seconds = ThisTime / 1000;
    minutes = seconds / 60;
    onlysecs = seconds - 60*minutes;
    sec = 60 - onlysecs;
    min = (countdown - minutes);
    countdown = 2;

    // TEST RUNNING
    if (TestRunning) {            

      fill(255);
      textFont(f3, 40);
      textAlign(LEFT, TOP);

      if (onlysecs < 10) {
        text("Time " + " " + ((minutes) + ":" + "0" + (onlysecs)), x+30, y+315);
      } else {
        text("Time " + " " + ((minutes) + ":" + (onlysecs)), x+30, y+340);
      }

      if (count < 10) {
        text("Trial" + " " + "0" + (count) + "/" + "10", x+30, y+315);
      } else {
        text("Trial" + " " + (count) + "/" + "10", x+30, y+340);
      }

      if (bpm30ButtonPressed) {
        link("https://www.dropbox.com/s/2f3l4vph5mnbkmc/30BPM.mp3.mp3?dl=0");
        bpm30ButtonPressed = false;
      }

      if (bpm45ButtonPressed) {
        link("https://www.dropbox.com/s/kjwrd6017r9dc31/45BPM.mp3?dl=0");
        bpm45ButtonPressed = false;
      }

      if (bpm60ButtonPressed) {
        link("https://www.dropbox.com/s/egc04c5no4541e5/60BPM.mp3?dl=0");
        bpm60ButtonPressed = false;
      }

      if (bpm120ButtonPressed) {
        link("https://www.dropbox.com/s/sjqsptglnayx675/120BPM.mp3?dl=0");
        bpm120ButtonPressed = false;
      }
    }

    fill(255, 0, 0);
    Right.draw(int(x+30), int(y+140));

    fill(255, 0, 0);
    Left.draw(int(x+30), int(y+165));

    fill(255, 0, 0);
    Random.draw(int(x+30), int(y+190));

    fill(255, 0, 0);
    bpm30.draw(int(x+180), int(y+140));

    fill(255, 0, 0);
    bpm45.draw(int(x+180), int(y+165));

    fill(255, 0, 0);
    bpm60.draw(int(x+180), int(y+190));

    fill(255, 0, 0);
    bpm120.draw(int(x+180), int(y+215));

    fill(255, 0, 0);
    StartTrial.draw(int(x+30), int(y+275));

    fill(255, 0, 0);
    StopTrial.draw(int(x+180), int(y+275));
  }

  boolean isMouseHere() {
    if (mouseX >= x && mouseX <= width && mouseY >= y && mouseY <= height - bottomMargin) {
      return true;
    } else {
      return false;
    }
  }

  boolean isMouseInButton() {
    verbosePrint("Playground: isMouseInButton: attempting");
    if (mouseX >= collapser.but_x && mouseX <= collapser.but_x+collapser.but_dx && mouseY >= collapser.but_y && mouseY <= collapser.but_y + collapser.but_dy) {
      return true;
    } else {
      return false;
    }
  }

  public void toggleWindow() {
    if (isOpen) {//if open
      verbosePrint("close");
      collapsing = true;//collapsing = true;
      isOpen = false;
      collapser.but_txt = "<";
    } else {//if closed
      verbosePrint("open");
      collapsing = false;//expanding = true;
      isOpen = true;
      collapser.but_txt = ">";
    }
  }

  public void mousePressed() {
    verbosePrint("Playground >> mousePressed()");

    if (bpm30.isMouseHere()) {
      //if ((bpm30ButtonPressed) && (!bpm45ButtonPressed) && (!bpm60ButtonPressed) && (!bpm120ButtonPressed)) {
      bpm30.setIsActive(true);
      bpm30ButtonPressed = true;
      audiobpm30 = true;
      bpm45.setIsActive(false);
      bpm45ButtonPressed = false;
      audiobpm45 = false;
      bpm60.setIsActive(false);
      bpm60ButtonPressed = false;
      audiobpm60 = false;
      bpm120.setIsActive(false);
      bpm120ButtonPressed = false;
      audiobpm120 = false;
      //}
    }

    if (bpm45.isMouseHere()) {
      //if ((!bpm30ButtonPressed) && (bpm45ButtonPressed) && (!bpm60ButtonPressed) && (!bpm120ButtonPressed)) {
      bpm30.setIsActive(false);
      bpm30ButtonPressed = false;
      audiobpm30 = false;
      bpm45.setIsActive(true);
      bpm45ButtonPressed = true;
      audiobpm45 = true;
      bpm60.setIsActive(false);
      bpm60ButtonPressed = false;
      audiobpm60 = false;
      bpm120.setIsActive(false);
      bpm120ButtonPressed = false;
      audiobpm120 = false;
      //}
    }

    if (bpm60.isMouseHere()) {
      //if ((!bpm30ButtonPressed) && (!bpm45ButtonPressed) && (bpm60ButtonPressed) && (!bpm120ButtonPressed)) {
      bpm30.setIsActive(false);
      bpm30ButtonPressed = false;
      audiobpm30 = false;
      bpm45.setIsActive(false);
      bpm45ButtonPressed = false;
      audiobpm45 = false;
      bpm60.setIsActive(true);
      bpm60ButtonPressed = true;
      audiobpm60 = true;
      bpm120.setIsActive(false);
      bpm120ButtonPressed = false;
      audiobpm120 = false;
      //}
    }

    if (bpm120.isMouseHere()) {
      //if ((!bpm30ButtonPressed) && (!bpm45ButtonPressed) && (!bpm60ButtonPressed) && (bpm120ButtonPressed)) {
      bpm30.setIsActive(false);
      bpm30ButtonPressed = false;
      audiobpm30 = false;
      bpm45.setIsActive(false);
      bpm45ButtonPressed = false;
      audiobpm45 = false;
      bpm60.setIsActive(false);
      bpm60ButtonPressed = false;
      audiobpm60 = false;
      bpm120.setIsActive(true);
      bpm120ButtonPressed = true;
      audiobpm120 = true;
      //}
    }

    if (Right.isMouseHere()) {
      Right.setIsActive(true);
      RightButtonPressed = true;
      Left.setIsActive(false);
      LeftButtonPressed = false;
      Random.setIsActive(false);
      RandomButtonPressed = false;
    }

    if (Left.isMouseHere()) {
      Right.setIsActive(false);
      RightButtonPressed = false;
      Left.setIsActive(true);
      LeftButtonPressed = true;
      Random.setIsActive(false);
      RandomButtonPressed = false;
    }

    if (Random.isMouseHere()) {
      Right.setIsActive(false);
      RightButtonPressed = false;
      Left.setIsActive(false);
      LeftButtonPressed = false;
      Random.setIsActive(true);
      RandomButtonPressed = true;
    }

    if (StartTrial.isMouseHere()) {
      if (((bpm30ButtonPressed) && (!bpm45ButtonPressed) && (!bpm60ButtonPressed) && (!bpm120ButtonPressed)) || ((!bpm30ButtonPressed) && (bpm45ButtonPressed) && (!bpm60ButtonPressed) && (!bpm120ButtonPressed)) ||
        ((!bpm30ButtonPressed) && (!bpm45ButtonPressed) && (bpm60ButtonPressed) && (!bpm120ButtonPressed)) || ((!bpm30ButtonPressed) && (!bpm45ButtonPressed) && (!bpm60ButtonPressed) && (bpm120ButtonPressed))) {
        StartTrial.setIsActive(true);
        StartTrialButtonPressed = true;
        StopTrial.setIsActive(false);
        Right.setIsActive(false);
        RightButtonPressed = false;
        Left.setIsActive(false);
        LeftButtonPressed = false;
        Random.setIsActive(false);
        RandomButtonPressed = false;
        if (!TestRunning) {
          TestRunning = true;
          startingTime = millis();
        }
      }
    }

    if (StopTrial.isMouseHere()) {
      if ((bpm30ButtonPressed) || (bpm45ButtonPressed) || (bpm60ButtonPressed) || (bpm120ButtonPressed)) {
        StopTrial.setIsActive(true);
        StopTrialButtonPressed = true;
        StartTrial.setIsActive(false);
        StartTrialButtonPressed = false;
        if (TestRunning) {
          TestRunning = false;
          startingTime = millis();
        }
      }
    }
  }

  public void mouseReleased() {
    verbosePrint("Playground >> mouseReleased()");
  }

  public void expand() {
    if (w <= width/3) {
      w = w + 50;
      x = width - w;
    }
  }

  public void collapse() {
    if (w >= 0) {
      w = w - 50;
      x = width - w;
    }
  }
};