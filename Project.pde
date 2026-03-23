import processing.sound.*;//sound

int gameState = 0; // 0 = memu, 1 = Space Invaders, 2 = Breakout, 3 = Pong Game
boolean moveLeft = false;
boolean moveRight = false;
boolean gameOver = false;

PImage bgmenu, bgspace, bgbreakout, bgpong;

SoundFile spaceInvadersMusic, breakoutMusic, pongMusic;

void setup() {
  size(700,500);
  frameRate(60);
  //background
  bgmenu = loadImage("01.png"); 
  bgspace = loadImage("02.png"); 
  bgbreakout = loadImage("03.png");
  bgpong = loadImage("04.png");
  //sound
  spaceInvadersMusic = new SoundFile(this, "About You.mp3");
  breakoutMusic = new SoundFile(this, "BIRDS OF A FEATHER.mp3");
  pongMusic = new SoundFile(this, "Thats So True.mp3");

  initGames();
}

void draw() {
  background(0);
  if (gameState == 0) {
    drawMenu();
  } else if (gameState == 1) {
    playSpaceInvaders();
  } else if (gameState == 2) {
    playBreakout();
  } else if (gameState == 3) {
    playPong();
  }
}

void keyPressed() {
  if (gameState == 0) {
    if (key == '1') {
      gameState = 1;
      spaceInvadersMusic.loop();
    }
    if (key == '2') {
      gameState = 2;
      breakoutMusic.loop();
    }
    if (key == '3') {
      gameState = 3;
      pongMusic.loop(); 
    }
  } else if (key == 'm' || key == 'M') {
    gameState = 0;
    initGames();
    spaceInvadersMusic.stop(); 
    breakoutMusic.stop(); 
    pongMusic.stop(); 
  }

  if (gameState == 1 || gameState == 2) {
    if (keyCode == LEFT) moveLeft = true;
    if (keyCode == RIGHT) moveRight = true;
  }

  if (gameState == 1 && key == ' ') {
    bullets.add(new PVector(playerPos.x, playerPos.y - 20));
  }

  if (gameState == 3) {
    if (key == 'w') paddleLeftVel = -7;
    if (key == 's') paddleLeftVel = 7;
    if (key == 'i') paddleRightVel = -7;
    if (key == 'k') paddleRightVel = 7;
  }
}


void keyReleased() {
  if (gameState == 1 || gameState == 2) {
    if (keyCode == LEFT) moveLeft = false;
    if (keyCode == RIGHT) moveRight = false;
  }

  if (gameState == 3) {
    if (key == 'w' || key == 's') paddleLeftVel = 0;
    if (key == 'i' || key == 'k') paddleRightVel = 0;
  }
}


void drawMenu() {
  if (bgmenu != null) {
    image(bgmenu, 0, 0, width, height); 
  } else {
    background(30); 
  }

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("Select a Game", width / 2, 150);
  textSize(25);
  text("1. Space Invaders", width / 2, 210);
  text("2. Breakout", width / 2, 260);
  text("3. Ping Pong Game", width / 2, 310);
}

void initGames() {
  initSpaceInvaders();
  initBreakout();
  initPong();
}

//-------------------------------------------------------------------------------------

// === 1.Space Invaders ===
PVector playerPos;
ArrayList<PVector> bullets = new ArrayList<PVector>(); 
ArrayList<ArrayList<PVector>> enemyGroups = new ArrayList<ArrayList<PVector>>(); 
ArrayList<Float> groupY = new ArrayList<Float>(); 
float enemySpeedY = 0.2;  

void initSpaceInvaders() {
  playerPos = new PVector(width / 2, height - 40);
  bullets.clear();
  enemyGroups.clear();
  groupY.clear();  
  enemySpeedY = 0.2;

  int groupCount = 2; 
  int horizontalSpacing = 115;
  int verticalSpacing = 40;
  
  for (int g = 0; g < groupCount; g++) {
    ArrayList<PVector> group = new ArrayList<PVector>();
    float offsetY = 0 + g * 150;  //start pink ball
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 3; j++) {
        group.add(new PVector(60 + i * horizontalSpacing, offsetY + j * verticalSpacing));
      }
    }
    enemyGroups.add(group);
    groupY.add(offsetY);  
  }
}

void playSpaceInvaders() {
  if (bgspace != null) {
    image(bgspace, 0, 0, width, height); 
  } else {
    background(30);  
  }


  boolean allGroupsEmpty = true;
  for (ArrayList<PVector> group : enemyGroups) {
    if (!group.isEmpty()) {
      allGroupsEmpty = false;
      break;
    }
  }
  if (allGroupsEmpty) {
    fill(0);
    textAlign(CENTER);
    textSize(32);
    text("You Win! Press M to Menu", width / 2, height / 2);
    return;
  }

  for (ArrayList<PVector> group : enemyGroups) {
    for (PVector e : group) {
      if (e.y >= height - 60) {  
        fill(0);
        textAlign(CENTER);
        textSize(32);
        text("Game Over! Press M to Menu", width / 2, height / 2);
        return;
      }
    }
  }


  if (moveLeft) playerPos.x -= 5;
  if (moveRight) playerPos.x += 5;
  playerPos.x = constrain(playerPos.x, 20, width - 20);

  fill(173, 216, 230);  
  rectMode(CENTER);
  rect(playerPos.x, playerPos.y, 60, 20);  // Paddle

  enemySpeedY += 0.0002;
  if (enemySpeedY > 1) enemySpeedY = 0.5;

  fill(255, 182, 193);  
  for (int g = 0; g < enemyGroups.size(); g++) {
    ArrayList<PVector> group = enemyGroups.get(g);
    for (int i = 0; i < group.size(); i++) {
      PVector e = group.get(i);
      e.y += enemySpeedY; 
      ellipse(e.x, e.y, 25, 25);  
    }
  }


  fill(0);
  for (int i = bullets.size() - 1; i >= 0; i--) {
    PVector b = bullets.get(i);
    b.y -= 5;  
    ellipse(b.x, b.y, 15, 15);   //size ball paddle

    for (int g = 0; g < enemyGroups.size(); g++) {
      ArrayList<PVector> group = enemyGroups.get(g);
      for (int j = group.size() - 1; j >= 0; j--) {
        if (dist(b.x, b.y, group.get(j).x, group.get(j).y) < 20) {
          group.remove(j); 
          bullets.remove(i);  
          break;
        }
      }
    }
    if (b.y < 0) {
      bullets.remove(i);
    }
  }
}

//-------------------------------------------------------------------------------------
// === 2.Breakout ===
ArrayList<Brick> bricks = new ArrayList<Brick>();               
PVector ballPos, ballVel;
float paddleX;
int breakoutLives = 3;
color[] rowColors = {
  color(173, 216, 230), // sky
  color(255, 182, 193), // pink
  color(182, 255, 170),  // green
  color(230, 230, 250), // purple
  color(255, 255, 204)  // yellow 
};
class Brick {
  PVector pos;
  int hitsLeft;
  color c;

  Brick(float x, float y, int hits, color col) {
    pos = new PVector(x, y);
    hitsLeft = hits;
    c = col;
    float rand = random(1);
    if (rand < 0.1) {
      hitsLeft = 1;  // 
    } else if (rand < 0.4) {
      hitsLeft = 2;  // 
    } else {
      hitsLeft = 3;  //
    }
  }
 
  void display() {
     if (hitsLeft == 3) {
      fill(c); 
    } else if (hitsLeft == 2) {
      fill(lerpColor(c, color(255), 0.5));  
    } else if (hitsLeft == 1) {
      fill(lerpColor(c, color(255), 0.8));  
    }

    rectMode(CENTER);
    rect(pos.x, pos.y, 70, 30);
  }

  boolean isHit(float ballX, float ballY) {
    return abs(ballX - pos.x) < 40 && abs(ballY - pos.y) < 20;
  }
}
void initBreakout() {
  ballPos = new PVector(width / 2, height / 2);
  ballVel = new PVector(4, -4);
  paddleX = width / 2;
  breakoutLives = 3;
  bricks.clear();

  int horizontalSpacing = 110; 
  int verticalSpacing = 40;

  for (int i = 0; i < 6; i++) {
  for (int j = 0; j < 5; j++) {
    int hits = (int)random(1, 4); 
      color c = rowColors[int(random(rowColors.length))]; 
      bricks.add(new Brick(60 + i * horizontalSpacing, 130 + j * verticalSpacing, hits, c));
    }
  }
}

void playBreakout() {
  if (bgbreakout != null) {
    image(bgbreakout, 0, 0, width, height); 
  } else {
    background(30); 
  }
  if (bricks.isEmpty()) {
    fill(0);
    textAlign(CENTER);
    textSize(32);
    text("You Win! Press M to Menu", width / 2, height / 2);
    return;
  }
  if (moveLeft) paddleX -= 7;
  if (moveRight) paddleX += 7;
  paddleX = constrain(paddleX, 50, width - 50);

  fill(255, 165, 0);
  rectMode(CENTER);
  rect(paddleX, height - 30, 100, 10);

  ballPos.add(ballVel);
  fill(0);
  ellipse(ballPos.x, ballPos.y, 20, 20);

  if (ballPos.x < 0 || ballPos.x > width) ballVel.x *= -1;
  if (ballPos.y < 60) {
  ballVel.y *= -1;
  ballPos.y = 60; 
}
  if (ballPos.y > height) {
    breakoutLives--;
    if (breakoutLives <= 0) {
      fill(0);
      textAlign(CENTER);
      textSize(32);
      text("Game Over! Press M to Menu", width / 2, height / 2);
      return;
    } else {
      ballPos = new PVector(width / 2, height / 2);
      ballVel = new PVector(4, -4);
    }
  }

  if (ballPos.y > height - 40 && abs(ballPos.x - paddleX) < 50) {
    ballVel.y *= -1;
    ballPos.y = height - 41;
  }
  
  for (int i = bricks.size() - 1; i >= 0; i--) {
  Brick b = bricks.get(i);
  b.display();

  if (b.isHit(ballPos.x, ballPos.y)) {
    ballVel.y *= -1;
    b.hitsLeft--;
    if (b.hitsLeft <= 0) {
      bricks.remove(i);
    }
  }
}
  drawHearts(breakoutLives, 20, 20);
}

//-------------------------------------------------------------------------------------


// === 3. Pong ===
float ballX, ballY, ballSpeedX, ballSpeedY;
float paddleLeftY, paddleRightY;
float paddleHeight = 100, paddleWidth = 20;
int leftScore = 0, rightScore = 0;
float paddleLeftVel = 0, paddleRightVel = 0;
int leftLives = 3, rightLives = 3;

void initPong() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = 4;
  ballSpeedY = 4;
  paddleLeftY = height / 2 - paddleHeight / 2;
  paddleRightY = height / 2 - paddleHeight / 2;
  leftScore = 0;
  rightScore = 0;
  leftLives = 3;
  rightLives = 3;
}

void playPong() {
  if (bgpong != null) {
    image(bgpong, 0, 0, width, height); 
  } else {
    background(30); 
  }
  if (leftLives <= 0 || rightLives <= 0) {
    fill(0);
    textAlign(CENTER);
    textSize(32);
    if (leftLives <= 0) text("Right Wins! Press M to Menu", width / 2, height / 2);
    else text("Left Wins! Press M to Menu", width / 2, height / 2);
    return;
  }
  if (ballY < 70) {  
    ballSpeedY *= -1;  
    ballY = 70; 
  }

  ballX += ballSpeedX;
  ballY += ballSpeedY;

  if (ballY < 0 || ballY > height) ballSpeedY *= -1;

  paddleLeftY += paddleLeftVel ;
  paddleRightY += paddleRightVel ;
  
  paddleLeftY = constrain(paddleLeftY, 0, height - paddleHeight);
  paddleRightY = constrain(paddleRightY, 0, height - paddleHeight);

  if (ballX < paddleWidth + 10 && ballY > paddleLeftY && ballY < paddleLeftY + paddleHeight) {
    ballSpeedX *= -1;
  }
  if (ballX > width - paddleWidth - 10 && ballY > paddleRightY && ballY < paddleRightY + paddleHeight) {
    ballSpeedX *= -1;
  }

  if (ballX < 0) {
    rightScore++;
    leftLives--;
    resetBall();
  } else if (ballX > width) {
    leftScore++;
    rightLives--;
    resetBall();
  }

  fill(255, 182, 193);//color paddle left - pink
  rect(10, paddleLeftY, paddleWidth, paddleHeight);//paddle left
  fill(173, 216, 230);//color paddle right - sky
  rect(width - 10 - paddleWidth, paddleRightY, paddleWidth, paddleHeight);//paddle right
  fill(185, 174, 220);
  ellipse(ballX, ballY, 20, 20);
  
  fill(0);
  textSize(32);
  textAlign(CENTER, TOP);
  text(leftScore, width / 4, 100);
  text(rightScore, width * 3 / 4, 100);

  drawHearts(leftLives, 40, 60);
  drawHearts(rightLives, width - 100, 60);
}

void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = random(1) > 0.5 ? 4 : -4;
  ballSpeedY = random(1) > 0.5 ? 4 : -4;
}

// Draw Hearts 
void drawHearts(int lives, float startX, float startY) {
  fill(255, 0, 0);
  for (int i = 0; i < lives; i++) {
    float x = startX + i * 30;
    float y = startY;
    beginShape();
    vertex(x, y);
    bezierVertex(x - 10, y - 15, x - 20, y + 10, x, y + 20);
    bezierVertex(x + 20, y + 10, x + 10, y - 15, x, y);
    endShape(CLOSE);
  }
}
