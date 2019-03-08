import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public int numBombs = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup (){
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r, c);
    
    for(int i=0; i<numBombs; i++)
      setBombs();
}

public void setBombs(){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[r][c])){
        bombs.add(buttons[r][c]);
    }
}

public void draw (){
    background( 0 );
    if(isWon())
        displayWinningMessage();
}

public boolean isWon(){
    for(int r=0; r<NUM_ROWS; r++)
      for(int c=0; c<NUM_COLS; c++)
        if(!buttons[r][c].isMarked() && !buttons[r][c].isClicked())
          return false;
    return true;
}

public void displayLosingMessage(){
    String message = "You Lose - Try Again.";
    for(int i=0; i<20; i++)
      buttons[9][i].setLabel(message.substring(i,i+1));
}

public void displayWinningMessage(){
    String message = "You won!";
    for(int i=0; i<8; i++)
      buttons[9][i].setLabel(message.substring(i,i+1));
}

public class MSButton{
    private int r, c;
    private float x,y, width, height;
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
        
        if(mouseButton == RIGHT){
          marked = !marked;
          if(marked == true)
            clicked = true;
          else
            clicked = false;
        }
        else if(bombs.contains(this))
          displayLosingMessage();
        else if(countBombs(r, c) > 0)
          label = "" + countBombs(r,c);
        else{
          if (isValid(r-1, c) && buttons[r-1][c].isClicked() == false)
            buttons[r-1][c].mousePressed();
          if (isValid(r-1, c-1) && buttons[r-1][c-1].isClicked() == false)
            buttons[r-1][c-1].mousePressed(); 
          if (isValid(r, c-1) && buttons[r][c-1].isClicked() == false)
            buttons[r][c-1].mousePressed();
          if (isValid(r+1, c-1) && buttons[r+1][c-1].isClicked() == false)
            buttons[r+1][c-1].mousePressed();
          if (isValid(r+1, c) && buttons[r+1][c].isClicked() == false)
            buttons[r+1][c].mousePressed();
          if (isValid(r+1, c+1) && buttons[r+1][c+1].isClicked() == false)
            buttons[r+1][c+1].mousePressed();
          if (isValid(r, c+1) && buttons[r][c+1].isClicked() == false)
            buttons[r][c+1].mousePressed();
          if (isValid(r-1, c+1) && buttons[r-1][c+1].isClicked() == false)
            buttons[r-1][c+1].mousePressed();
        }
    }

    public void draw () {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    
    public void setLabel(String newLabel){
        label = newLabel;
    }
    
    public boolean isValid(int r, int c){
      if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
        return true;
      else
        return false;
    }
    
    public int countBombs(int row, int col){
      int numBombs = 0;
      for(int y=row-1; y<row+2; y++)
        for(int x=col-1; x<col+2; x++)
          if(isValid(y,x) == true && bombs.contains(buttons[r][c]))
              numBombs++;
      return numBombs;
    }
}
