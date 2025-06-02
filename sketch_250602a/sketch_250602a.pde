import ddf.minim.*;

Minim minim;
AudioPlayer player;
boolean isPaused = false;

void setup() {
  size(400, 300);
  minim = new Minim(this);
  
  // Load the audio file (replace "audio.mp3" with your file path)
  player = minim.loadFile("audio.mp3");
  
  // Draw the buttons
  drawButtons();
}

void draw() {
  background(0, 0, 255); // Blue background
  fill(255); // White text
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Music Player", width / 2, 50);
}

void drawButtons() {
  fill(180); // Button color
  rect(50, 150, 100, 50); // Play button
  rect(150, 150, 100, 50); // Pause button
  rect(250, 150, 100, 50); // Stop button
  
  fill(0); // Button text color
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Play", 100, 175);
  text("Pause", 200, 175);
  text("Stop", 300, 175);
}

void mousePressed() {
  // Check if Play button is clicked
  if (mouseX > 50 && mouseX < 150 && mouseY > 150 && mouseY < 200) {
    playMusic();
  }
  
  // Check if Pause button is clicked
  if (mouseX > 150 && mouseX < 250 && mouseY > 150 && mouseY < 200) {
    pauseMusic();
  }
  
  // Check if Stop button is clicked
  if (mouseX > 250 && mouseX < 350 && mouseY > 150 && mouseY < 200) {
    stopMusic();
  }
}

void playMusic() {
  if (isPaused) {
    player.play(player.position()); // Resume from paused position
    isPaused = false;
  } else {
    player.play(); // Start from the beginning
  }
}

void pauseMusic() {
  if (player.isPlaying()) {
    player.pause();
    isPaused = true;
  }
}

void stopMusic() {
  player.pause();
  player.rewind(); // Reset to the beginning
  isPaused = false;
}
