// Player Class
// Zachary Strickler
// 4/21/22

import java.util.*;

public class Player
{
   private int score;
   private Die[] dice = new Die[6];
   private String playerName;
   private int roundScore;
   private int totalScore;
   
   
   
   public Player(String playerAlias)
   {
      playerAlias = playerName;
      score = 0;
      for (int i = 0; i < dice.length; i++)
      {
         dice[i] = new Die(6);
         dice[i].setValue(1);
      }
   }
   
   
   
   public void playerTurn(String playerName)
   {
      roundScore = 0;
      int twoRoll = 0;
      System.out.print(playerName + " it is your turn, here come the dice.\n");
      for (int i = 0; i < dice.length; i++) // This for loop will add random dice roll integers into the players array
      {  
         if (dice[i].getValue() != 2)
         {
            dice[i].roll();
            if (dice[i].getValue() != 2)
            {
               System.out.println("For roll number " + (i+1) + " you got a " + dice[i].getValue()+ "!");
               roundScore(dice[i].getValue());
            }
            else
            {
               System.out.println("For roll number " + (i+1) + ", you got a 2! Die " + (i+1) + " is now stuck in the mud!");
               twoRoll = 1;
            }
         }
         else
         {
            System.out.println("Die " + (i+1) + " is stuck in the mud since you rolled a 2, it cannot be used for the rest of the game!");
         }
         }
         if (twoRoll == 0)
         {
         System.out.println("\nYour total score this round was " + getRoundScore() + ".");
         totalScore(roundScore);
         System.out.println(playerName + ", your total score for the game is " + getTotalScore() + "!");
         }
         else
         {
         System.out.println("\nSince you rolled a 2, the score for this round is 0");
         roundScore = 0;
         totalScore(roundScore);
         System.out.println(playerName + ", your total score for the game is " + getTotalScore() + "!");
         }
   }
   
   
   
   public void roundScore(int singleRoll)
   {
      roundScore += singleRoll;
   }
   
   public int getRoundScore()
   {
      return roundScore;
   }
      
      
      
      
      
   public void totalScore(int roundScore)
   {
      totalScore += roundScore;
   }
   public int getTotalScore()
   {
   return totalScore;
   }
   
   
   public Die[] getDice()
   {
   return dice;
   }
   
     public Die[] endGame()
     {
     Die[] endGame = new Die[6];
      for (int i = 0; i < endGame.length; i++)
      {
         endGame[i] = new Die(6);
         endGame[i].roll();
         endGame[i].setValue(2);
      }
      return endGame;
      }
}