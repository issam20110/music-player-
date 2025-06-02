String[] board = {"", "", "", "", "", "", "", "", ""}; // Empty board
int currentPlayer = 1; // 1 = X, 2 = O
boolean gameOver = false;

// Score variables
int scoreX = 0;
int scoreO = 0;
int tieCount = 0;

// AI mode flag
boolean playAgainstAI = false; // Flag to toggle AI mode
String aiDifficulty = "Normal"; // Default AI difficulty
boolean showDifficultyMenu = false; // Flag to show the difficulty dropdown menu

void setup() {
  fullScreen(); // Opens the sketch in full-screen mode
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(0, 0, 255); // Blue background for the main game

  // Draw the scoreboard box
  fill(128, 0, 128); // Purple color for the scoreboard
  rect(0, 0, width, displayHeight / 10); // Scoreboard area at the top
  fill(255); // White text color for the scores
  textSize(40); // Larger text size for the scoreboard
  text("Player X: " + scoreX, width / 4, displayHeight / 20);
  text("Ties: " + tieCount, width / 2, displayHeight / 20);
  text("Player O: " + scoreO, 3 * width / 4, displayHeight / 20);

  // Draw the grid
  stroke(255); // White grid lines
  for (int i = 1; i < 3; i++) {
    line(i * width / 3, displayHeight / 10, i * width / 3, height - displayHeight / 10); // Vertical lines
    line(0, i * (height - displayHeight / 10) / 3 + displayHeight / 10, width, i * (height - displayHeight / 10) / 3 + displayHeight / 10); // Horizontal lines
  }

  // Draw the board
  fill(255); // White color for X and O
  textSize((height - displayHeight / 10) / 6); // Increase text size for X and O
  for (int i = 0; i < 9; i++) {
    float x = (i % 3) * width / 3 + width / 6;
    float y = (i / 3) * (height - displayHeight / 10) / 3 + displayHeight / 10 + (height - displayHeight / 10) / 6;
    if (board[i].equals("X")) {
      text("X", x, y);
    } else if (board[i].equals("O")) {
      text("O", x, y);
    }
  }

  // Draw the reset button
  fill(180);
  rect(width / 4 - 75, height - displayHeight / 10, 150, displayHeight / 20); // Button rectangle
  fill(0);
  textSize(30); // Larger text size for button text
  text("Reset", width / 4, height - displayHeight / 10 + displayHeight / 40); // Center text vertically

  // Draw the AI toggle button
  fill(180);
  rect(3 * width / 4 - 75, height - displayHeight / 10, 150, displayHeight / 20); // Button rectangle
  fill(0);
  textSize(30);
  text(playAgainstAI ? "AI: ON" : "AI: OFF", 3 * width / 4, height - displayHeight / 10 + displayHeight / 40); // Toggle AI mode text

  // Draw the dropdown arrow
  fill(180);
  triangle(3 * width / 4 + 80, height - displayHeight / 10 + 10, 3 * width / 4 + 100, height - displayHeight / 10 + 10, 3 * width / 4 + 90, height - displayHeight / 10 + 30); // Arrow shape

  // Draw the dropdown menu if active
  if (showDifficultyMenu) {
    fill(180);
    rect(3 * width / 4 - 75, height - displayHeight / 10 - 60, 150, 60); // Dropdown menu background
    fill(255);
    textSize(20);
    text("Easy", 3 * width / 4, height - displayHeight / 10 - 45);
    text("Normal", 3 * width / 4, height - displayHeight / 10 - 25);
    text("Hard", 3 * width / 4, height - displayHeight / 10 - 5);
  }

  // Draw the exit button
  fill(255, 0, 0); // Red color for the exit button
  ellipse(width - 50, 25, 40, 40); // Circular button
  fill(255); // White text color for "X"
  textSize(20);
  text("X", width - 50, 25);

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
    textSize(50); // Larger text size for winner announcement
    text("Player " + winner + " Wins!", width / 2, height - displayHeight / 5);
    return;
  } else if (isBoardFull()) {
    if (!gameOver) {
      tieCount++;
      gameOver = true;
    }
    fill(255);
    textSize(50); // Larger text size for tie announcement
    text("It's a Draw!", width / 2, height - displayHeight / 5);
    return;
  }

  // AI move
  if (playAgainstAI && currentPlayer == 2 && !gameOver) {
    makeAIMove();
  }
}

void mousePressed() {
  // Check if the reset button is clicked
  if (mouseX > width / 4 - 75 && mouseX < width / 4 + 75 && mouseY > height - displayHeight / 10 && mouseY < height - displayHeight / 10 + displayHeight / 20) {
    resetGame();
    return;
  }

  // Check if the AI toggle button is clicked
  if (mouseX > 3 * width / 4 - 75 && mouseX < 3 * width / 4 + 75 && mouseY > height - displayHeight / 10 && mouseY < height - displayHeight / 10 + displayHeight / 20) {
    playAgainstAI = !playAgainstAI; // Toggle AI mode
    return;
  }

  // Check if the dropdown arrow is clicked
  if (mouseX > 3 * width / 4 + 80 && mouseX < 3 * width / 4 + 100 && mouseY > height - displayHeight / 10 + 10 && mouseY < height - displayHeight / 10 + 30) {
    showDifficultyMenu = !showDifficultyMenu; // Toggle dropdown menu
    return;
  }

  // Check if a difficulty option is selected
  if (showDifficultyMenu) {
    if (mouseX > 3 * width / 4 - 75 && mouseX < 3 * width / 4 + 75) {
      if (mouseY > height - displayHeight / 10 - 60 && mouseY < height - displayHeight / 10 - 40) {
        aiDifficulty = "Easy";
        showDifficultyMenu = false;
        return;
      } else if (mouseY > height - displayHeight / 10 - 40 && mouseY < height - displayHeight / 10 - 20) {
        aiDifficulty = "Normal";
        showDifficultyMenu = false;
        return;
      } else if (mouseY > height - displayHeight / 10 - 20 && mouseY < height - displayHeight / 10) {
        aiDifficulty = "Hard";
        showDifficultyMenu = false;
        return;
      }
    }
  }

  // Check if the exit button is clicked
  if (dist(mouseX, mouseY, width - 50, 25) < 20) { // Check if mouse is within the circular button
    exit(); // Exit the game
    return;
  }

  if (gameOver || (playAgainstAI && currentPlayer == 2)) return;

  int col = mouseX / (width / 3);
  int row = (mouseY - displayHeight / 10) / ((height - displayHeight / 10) / 3);
  int index = row * 3 + col;

  if (index >= 0 && index < 9 && board[index].equals("")) {
    board[index] = currentPlayer == 1 ? "X" : "O";
    currentPlayer = currentPlayer == 1 ? 2 : 1;
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

void makeAIMove() {
  int index = -1; // Initialize index to a default value

  if (aiDifficulty.equals("Easy")) {
    do {
      index = int(random(0, 9)); // Randomly select a cell
    } while (!board[index].equals("") && index != -1); // Ensure the cell is empty
  } else if (aiDifficulty.equals("Normal")) {
    index = findBestMoveNormal(); // Implement a basic blocking and winning strategy
  } else if (aiDifficulty.equals("Hard")) {
    index = findBestMoveHard(); // Implement the minimax algorithm for optimal moves
  }

  // Ensure index is valid before making a move
  if (index != -1 && board[index].equals("")) {
    board[index] = "O"; // AI plays as "O"
    currentPlayer = 1; // Switch back to Player X
  }
}

// Normal difficulty: Block opponent's winning moves and prioritize its own winning moves
int findBestMoveNormal() {
  // Check if AI can win
  for (int i = 0; i < 9; i++) {
    if (board[i].equals("")) {
      board[i] = "O"; // Temporarily make the move
      if (!checkWinner().equals("")) {
        board[i] = ""; // Undo the move
        return i; // Return the winning move
      }
      board[i] = ""; // Undo the move
    }
  }

  // Check if AI needs to block opponent's winning move
  for (int i = 0; i < 9; i++) {
    if (board[i].equals("")) {
      board[i] = "X"; // Temporarily make the move for the opponent
      if (!checkWinner().equals("")) {
        board[i] = ""; // Undo the move
        return i; // Return the blocking move
      }
      board[i] = ""; // Undo the move
    }
  }

  // Otherwise, pick the first available cell
  for (int i = 0; i < 9; i++) {
    if (board[i].equals("")) {
      return i;
    }
  }

  return -1; // No valid moves
}

// Hard difficulty: Use minimax algorithm for optimal moves
int findBestMoveHard() {
  int bestScore = Integer.MIN_VALUE;
  int bestMove = -1;

  for (int i = 0; i < 9; i++) {
    if (board[i].equals("")) {
      board[i] = "O"; // AI makes the move
      int score = minimax(false); // Evaluate the move
      board[i] = ""; // Undo the move
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  return bestMove;
}

// Minimax algorithm for Hard difficulty
int minimax(boolean isMaximizing) {
  String winner = checkWinner();
  if (winner.equals("O")) return 1; // AI wins
  if (winner.equals("X")) return -1; // Player wins
  if (isBoardFull()) return 0; // Draw

  if (isMaximizing) {
    int bestScore = Integer.MIN_VALUE;
    for (int i = 0; i < 9; i++) {
      if (board[i].equals("")) {
        board[i] = "O"; // AI makes the move
        int score = minimax(false); // Minimize opponent's score
        board[i] = ""; // Undo the move
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = Integer.MAX_VALUE;
    for (int i = 0; i < 9; i++) {
      if (board[i].equals("")) {
        board[i] = "X"; // Opponent makes the move
        int score = minimax(true); // Maximize AI's score
        board[i] = ""; // Undo the move
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}
