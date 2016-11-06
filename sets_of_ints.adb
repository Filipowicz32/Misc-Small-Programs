-- Name: John Filipowicz
-- Date: September 15, 2016
-- Course: ITEC 320 Principles of Procedural Programming

-- Purpose: This program takes integers from an input file as sets and
--   calculates the average and tracks the second largest of the set.
--   Additionally, the program calculates the grand average and displays the
--   largest of the second largest ints. Input is a file of comprised of
--   integers. The first integer is read in as the number of integers following
--   that belong to the set. Therefore, these leading or set description
--   integers must be positive. If a non positive is read in, the program stops
--   reading input from the file.

-- Data is assumed to be valid.
-- Sample data (from nokie/classes/320/p1.html):
--    2
--    6
--    4
--      4   10   40   20   29
--    3 -1 -2 -2
--    1 5
--    0

-- Output Format:
--   Set 1
--      Size: 2
--      Average: 5.00
--      Second largest: 4
--
--   Average of values 10.90
--   Average of averages: 8.27
--   Largest second largest: 29

-- Help recieved: references to nokie/classes/320 as well as the Programming
--   in Ada 2012 Textbook by John Barnes.


WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO; USE Ada.Float_Text_IO;

PROCEDURE sets_of_ints IS

   -- Purpose: Handle per set calculations and update the largest of the
   --    second largest integers.
   -- Parameters: leadInt: the number of ints in the set, setSum: out
   --    parameter for sum of ints in the set, and largeSL: in out
   --    parameter for tracking the largest of the second largest ints
   -- Precondition: leadInt > 0

   PROCEDURE set_calc(leadInt: integer; setSum: OUT integer;
   largeSL: in out Integer) IS

   largest: Integer;   -- Largest int of the set.
   secLargest: Integer := Integer'First;   -- Second largest int of the set.
   setAve: Float;   -- Average of the set.
   currentInt: Integer;   -- Most recently read in integer

   BEGIN
      setSum := 0;
      FOR num IN 1 .. leadInt LOOP
         get(currentInt);
         setSum := setSum + currentInt;

         -- Tracking largest and second largest integers
         IF num = 1 AND leadInt > 1 THEN
            largest := currentInt;
         ELSIF currentInt >= largest THEN
            secLargest := largest;
            largest := currentInt;
         ELSIF currentInt >= secLargest THEN
            secLargest := currentInt;
         END IF;
      END LOOP;

      IF secLargest >= largeSL THEN
         largeSL := secLargest;   -- Tracking largest second largest integer
      END IF;

      setAve := Float(setSum) / Float(leadInt); -- calc average for output

      New_Line;
      Put("   Size: ");
      Put(leadInt,0);
      New_Line;

      Put("   Average: ");
      Put(setAve,4,2,0);
      New_Line;

      IF secLargest > Integer'First THEN
         Put("   Second Largest: ");
         Put(secLargest,0);
         New_Line;
      END IF;
      New_Line;
   END set_calc;

   -- Purpose: Display the final output section.
   -- Parameters: grandAve: average of all values, aveAve: average of all
   --    averages, largestSL: largest of the second largest integers.
   -- Precondition: Parameters are not null.

   PROCEDURE final_output(grandAve, aveAve: Float; largestSL: Integer) IS
   BEGIN

      Put("Average of values: ");
      Put(grandAve,4,2,0);
      New_Line;

      Put("Average of averages: ");
      Put(aveAve,4,2,0);
      New_Line;

      IF largestSL > Integer'First THEN
         Put("Largest second largest: ");
         Put(largestSL,0);
         New_Line;
      END IF;

   END final_output;

   -- Purpose: Control main loop and do non set calculations
   PROCEDURE set_prompt IS

   aveAve: Float := 0.00;   -- Average of the set averages.
   grandAve: Float := 0.00;   -- Average of all values.
   setAve: Float;   -- Average for the individual sets.
   aveSum: Float := 0.00;

   leadInt: Integer;   -- Integer to tell the size of the set.
   totalCount: Integer := 0;   -- Total number of integers from the sets.
   setCounter: Integer := 0;   -- Number of sets.
   grandSum: Integer := 0;   -- Sum of the set sums.
   largestSL: Integer := Integer'First; -- Largest of the sets second largest.
   setSum: Integer; -- Sum per set.

   BEGIN

   -- Read first set count and update appropriate counters
   get(leadInt);
   setCounter := setCounter + 1;
   totalCount := totalCount + leadInt;

   WHILE leadInt > 0 LOOP
      Put("Set ");
      Put(setCounter,0);
      set_Calc(leadInt, setSum, largestSL);

      setAve := Float(setSum) / Float(leadInt); -- calc set average
      aveSum := aveSum + setAve; -- update running sum of averages
      grandSum := grandSum + setSum; -- update sum of all ints

      -- repeat for the loop portion of the 1.5 loop
      get(leadInt);
      setCounter := setCounter + 1;
      totalCount := totalCount + leadInt;
   END LOOP;

   -- Final Calculations
   grandAve := Float(grandSum) / Float(totalCount);
   aveAve := aveSum / Float(setCounter);

   final_output(grandAve, aveAve, largestSL);
   END set_prompt;

BEGIN
   set_prompt;
END sets_of_ints;









