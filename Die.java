// Die Class
// 4/21/22
// Zachary Strickler

import java.util.Random;

/**
   The Die class simulates a six-sided die.
*/

public class Die
{
   private int sides;   // Number of sides
   private int value;   // The die's value
   
   /**
      The constructor performs an initial
      roll of the die.
      @param numSides The number of sides for this die.
   */
   
   public Die(int numSides)
   {
      sides = numSides;
      roll();
   }
   
   /**
      The roll method simlates the rolling of
      the die.
   */
   
   public void roll()
   {
      // Create a Random object.
      Random rand = new Random();
      
      // Get a random value for the die.
      value = rand.nextInt(sides) + 1;
   }
   
   /**
      getSides method
      @return The number of sides for this die.
   */
   
   public int getSides()
   {
      return sides;
   }
   
   /**
      getValue method
      @return The value of the die.
   */
   
   public int getValue()
   {
      return value;
   }
   
   public int setValue(int setValue)
   {
   value = setValue;
   return value;
   }
   
   @Override // overriding equals for arrays.equals comparisons, two dice are equal if they have the same side value.
   public boolean equals (Object o)
   {
      Die d = (Die) o;
      if (value == d.getValue())
         return true;
         
      return false;
   }
}