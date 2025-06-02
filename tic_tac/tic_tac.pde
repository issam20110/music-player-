String[] board = {"", "", "", "", "", "", "", "", ""}; // Empty board
int currentPlayer = 1; // 1 = X, 2 = O
boolean gameOver = false;

// Score variables
int scoreX = 0;
int scoreO = 0;
int tieCount = 0;

void setup() {
  size(400, 500); // Increase height to make room for the reset button
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(0, 0, 255); // Blue background for the main game

  // Draw the scoreboard box
  fill(128, 0, 128); // Purple color for the scoreboard
  rect(0, 0, width, 50); // Scoreboard area at the top
  fill(255); // White text color for the scores
  textSize(20);
  text("Player X: " + scoreX, width / 4, 25);
  text("Ties: " + tieCount, width / 2, 25);
  text("Player O: " + scoreO, 3 * width / 4, 25);

  // Draw the grid
  stroke(255); // White grid lines
  for (int i = 1; i < 3; i++) {
    line(i * width / 3, 50, i * width / 3, height - 100); // Vertical lines
    line(0, i * (height - 150) / 3 + 50, width, i * (height - 150) / 3 + 50); // Horizontal lines
  }

  // Draw the board
  fill(255); // White color for X and O
  for (int i = 0; i < 9; i++) {
    float x = (i % 3) * width / 3 + width / 6;
    float y = (i / 3) * (height - 150) / 3 + 50 + (height - 150) / 6;
    if (board[i].equals("X")) {
      text("X", x, y);
    } else if (board[i].equals("O")) {
      text("O", x, y);
    }
  }

  // Draw the reset button
  fill(180);
  rect(width / 2 - 75, height - 75, 150, 50); // Button rectangle
  fill(0);
  textSize(20);
  text("Reset", width / 2, height - 50);

  // Check for a winner
  String winner = checkWinner();
  if (!winner.equals("")) {
    if (!gameOver) {
      if (winner.equals("X")) {
        scoreX++;
      } else if (winner.equals("O")) {
        scoreO++;
      }
      gameOver = true;
    }
    fill(255);
    textSize(24);
    text("Player " + winner + " Wins!", width / 2, height - 150);
    return;
  } else if (isBoardFull()) {
    if (!gameOver) {
      tieCount++;
      gameOver = true;
    }
    fill(255);
    textSize(24);
    text("It's a Draw!", width / 2, height - 150);
    return;
  }
}

void mousePressed() {
  // Check if the reset button is clicked
  if (mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height - 75 && mouseY < height - 25) {
    resetGame();
    return;
  }

  if (gameOver) return;

  int col = mouseX / (width / 3);
  int row = (mouseY - 50) / ((height - 150) / 3);
  int index = row * 3 + col;

  if (index >= 0 && index < 9 && board[index].equals("")) {
    board[index] = currentPlayer == 1 ? "X" : "O";
    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    resetGame();
  }
}

void resetGame() {
  for (int i = 0; i < 9; i++) {
    board[i] = "";
  }
  currentPlayer = 1;
  gameOver = false;
}

String checkWinner() {
  // Check rows
  for (int i = 0; i < 3; i++) {
    if (!board[i * 3].equals("") && board[i * 3].equals(board[i * 3 + 1]) && board[i * 3 + 1].equals(board[i * 3 + 2])) {
      return board[i * 3];
    }
  }

  // Check columns
  for (int i = 0; i < 3; i++) {
    if (!board[i].equals("") && board[i].equals(board[i + 3]) && board[i + 3].equals(board[i + 6])) {
      return board[i];
    }
  }

  // Check diagonals
  if (!board[0].equals("") && board[0].equals(board[4]) && board[4].equals(board[8])) {
    return board[0];
  }
  if (!board[2].equals("") && board[2].equals(board[4]) && board[4].equals(board[6])) {
    return board[2];
  }

  return ""; // No winner
}

boolean isBoardFull() {
  for (int i = 0; i < 9; i++) {
    if (board[i].equals("")) {
      return false;
    }
  }
  return true;
}
