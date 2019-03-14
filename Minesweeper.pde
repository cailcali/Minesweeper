

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public int numBombs = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup (){
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here

  buttons = new MSButton [NUM_ROWS] [NUM_COLS];
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++)
      buttons[i][j] = new MSButton(i, j);
  }

  for (int i=0; i<numBombs; i++)
    setBombs();
}

public void setBombs(){
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (!bombs.contains(buttons[row][col]))
    bombs.add(buttons[row][col]);
}

public void draw (){
  background( 0 );
  if (isWon())
    displayWinningMessage();  
}
  
public boolean isWon(){
  for (int i=0; i<NUM_ROWS; i++)
    for (int j=0; j<NUM_COLS; j++)
      if (!buttons[i][j].isMarked()&&!buttons[i][j].isClicked())
        return false;
  return true;
}

public void displayLosingMessage(){
  String message = "You Lose, Try Again.";
  for (int i=0; i<20; i++)
    buttons[8][i].setLabel(message.substring(i,i+1));
}

public void displayWinningMessage(){
  String message = "      You Won!";
  for (int i=0; i<20; i++)
    buttons[8][i].setLabel(message.substring(i,i+1));
}

public class MSButton{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc ){
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  
  public boolean isMarked(){
    return marked;
  }
  
  public boolean isClicked(){
    return clicked;
  }
  // called by manager

  public void mousePressed () {
    clicked = true;

    if(mouseButton == RIGHT) {
      marked = !marked;
      if(marked == false)
        clicked = false;
    } else if(bombs.contains(this))
      displayLosingMessage();
    else if(countBombs(r, c) > 0)
      label = "" + countBombs(r,c);
    else {
      if(isValid(r-1, c) && buttons[r-1][c].isClicked() == false)
        buttons[r-1][c].mousePressed();
      if(isValid(r-1, c-1) && buttons[r-1][c-1].isClicked() == false)
        buttons[r-1][c-1].mousePressed(); 
      if(isValid(r, c-1) && buttons[r][c-1].isClicked() == false)
        buttons[r][c-1].mousePressed();
      if(isValid(r+1, c-1) && buttons[r+1][c-1].isClicked() == false)
        buttons[r+1][c-1].mousePressed();
      if(isValid(r+1, c) && buttons[r+1][c].isClicked() == false)
        buttons[r+1][c].mousePressed();
      if(isValid(r+1, c+1) && buttons[r+1][c+1].isClicked() == false)
        buttons[r+1][c+1].mousePressed();
      if(isValid(r, c+1) && buttons[r][c+1].isClicked() == false)
        buttons[r][c+1].mousePressed();
      if(isValid(r-1, c+1) && buttons[r-1][c+1].isClicked() == false)
        buttons[r-1][c+1].mousePressed();
    }
  }

  public void draw () {   
    //clicked = true;  //for testing
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  
  public void setLabel(String newLabel){
    label = newLabel;
  }
  
  public boolean isValid(int r, int c){
    if(r >= 0 && r<NUM_ROWS && c >= 0 && c<NUM_COLS)
      return true;
    else
      return false;
  }
  
  public int countBombs(int row, int col){
    int numBombs = 0;
    for(int i=row-1; i<row+2; i++)
      for(int j=col-1; j<col+2; j++)
        if(isValid(i, j) && bombs.contains(buttons[i][j]))
            numBombs++;
    return numBombs;
  }
}
