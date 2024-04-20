// Stuck in the mud dice game, 2 players will roll 5 dice each, and the person with the highest total wins, if one player rolls a 2
// they are stuck in the mud and unable to continue rolling for the rest of the game
// 4/21/22
// Zachary Strickler
import java.util.*;
public class StuckInTheMud
{
   public static void main (String[]args)
   {
      String answer = "Y";
      while (answer.equalsIgnoreCase("Y") || (answer.equalsIgnoreCase("Yes")))
      {
         Scanner keyboard = new Scanner(System.in);
         playStuckInTheMud();
         System.out.println("Would you like to play again? (Yes or Y / No or N)");
         answer = keyboard.nextLine();
      }
   }
   public static void pressEnterKeyToContinue(String playerName) // using a continue method so the game doesn't contine on its own
   { 
      System.out.println("\n" + playerName + ", press Enter key when you are ready to roll!");
      Scanner nextTurn = new Scanner(System.in);
      nextTurn.nextLine();
   }


   public static void playStuckInTheMud()
   {
      Scanner keyboard = new Scanner(System.in);
      System.out.println("What is player ones name?");
      String firstPlayer = keyboard.nextLine();
      System.out.println("What is player twos name?");
      String secondPlayer = keyboard.nextLine();
      Player playerOne = new Player(firstPlayer);
      Player playerTwo = new Player(secondPlayer);
      boolean endTheGame;
      endTheGame = false;
      while (!endTheGame)
      {
         if (!Arrays.equals (playerOne.getDice(),playerOne.endGame()))
         {
            pressEnterKeyToContinue(firstPlayer);
            playerOne.playerTurn(firstPlayer);
         }
         if (!Arrays.equals (playerTwo.getDice(),playerTwo.endGame()))
         {
            pressEnterKeyToContinue(secondPlayer);
            playerTwo.playerTurn(secondPlayer);
         }
         // Exclusive Or Operator to check if only one player can still play.
         if (Arrays.equals(playerOne.getDice(),playerOne.endGame()) ^ Arrays.equals (playerTwo.getDice(),playerTwo.endGame())) 
         {
            if (playerOne.getTotalScore() > playerTwo.getTotalScore() && Arrays.equals (playerTwo.getDice(),playerTwo.endGame()))
            {
               System.out.println("\n" + firstPlayer + " wins with a total score of " + playerOne.getTotalScore() + ".");
               endTheGame = true;
            }
            else if (playerOne.getTotalScore() < playerTwo.getTotalScore() && Arrays.equals (playerOne.getDice(),playerTwo.endGame()))
            {
               System.out.println("\n" + secondPlayer + " wins with a total score of " + playerTwo.getTotalScore() + ".");
               endTheGame = true;
            }    
            
         }
         else if (Arrays.equals(playerOne.getDice(),playerOne.endGame() ) && Arrays.equals (playerTwo.getDice(),playerTwo.endGame()) )
         {
            if (playerOne.getTotalScore() > playerTwo.getTotalScore())
            {
               System.out.println("\n" + firstPlayer + " wins with a total score of " + playerOne.getTotalScore() + ".");
            }
            else if (playerOne.getTotalScore() < playerTwo.getTotalScore())
            {
               System.out.println("\n" + secondPlayer + " wins with a total score of " + playerTwo.getTotalScore() + ".");
            }
            else if (playerOne.getTotalScore() == playerTwo.getTotalScore())
            {
               System.out.println("\n Tie game,  you tied with a total score of " + playerTwo.getTotalScore() + ".");
            }
            
            endTheGame = true;
         }
      }
   }
}