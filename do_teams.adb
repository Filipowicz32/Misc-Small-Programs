-- Name: John Filipowicz
-- Due Date: October 4th, 2016
-- Course: Itec 320 Project 2

-- Purpose: This program tallies wins, ties, and calculates point
--     differential averages of each teams wins in four scenarios. The winner
--     of the first scenario loses their highest score while the loser loses
--     their lowest. The items tracked are then recalculated. Afterwards, the
--     two teams scores are sorted from highest to lowest, thereafter being
--     recalculated. Finally the second teams lowest to highest is compared
--     to the first teams highest to lowest and recalculated one last time.
--
-- Sample input:
-- 6    21
-- 15   15
-- 25   40
-- 9    28
-- 6    24
--
-- Corresponding output:
--  Original pairings:
--  	Wins for A: 0
--  	Wins for B: 4
--  	Ties:       1
--  	Average A win: 0.0
--  	Average B win: 16.8
--
--  Reduced team pairings:
--		Wins for A: 1
--      Wins for B: 3
--      Ties:       0
--      Average A win: 10.0
--      Average B win: 14.3
--
--  Reduced best vs best pairings:
--  	Wins for A: 0
--  	Wins for B: 4
--  	Ties:       0
--  	Average A win: 0.0
--  	Average B win: 8.3
--
--  Reduced best vs worst pairings:
--	  	Wins for A: 1      	
--    	Wins for B: 3
--    	Ties:       0
--    	Average A win: 10.0
--    	Average B win: 14.3

-- Help recieved: ~nokie/classes/320 , Programming in Ada 2012 by John Barnes
--   	Dr. Chase's notes on bubble sort (in java),
--   	stack overflow forum regarding reversing the order of an array in java


with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.float_text_io; use ada.float_text_io;
with ada.exceptions; use ada.exceptions;


--------------------------------------------------------------------------
-- Purpose: Produce four sets of analysis on the score data.
-- Precondition: There exists a set of scores where the number of scores is
--     equal per team and are in the range 1..1000 with 1..100 possible sets.
-- Postcondition: The game score output has been displayed.
--------------------------------------------------------------------------
procedure do_teams is
	subtype scores_possible is integer range 1..1000;
	type sets_range is range 1..100;
	type team_scores is array(sets_range range <>) of scores_possible;
	

    	----------------------------------------------------------------------
	-- Purpose: Display the number of wins per team, the number of ties,
	--     and the average win per team.
	-- Precondition: Both team_scores type parameters are initialized
	-- Postcondition: All values are displayed and are in the ranges
	--     1..100. 0..999 for the averages
	----------------------------------------------------------------------
	function output (team_a, team_b: in team_scores; title: in string)
					return boolean is
		a_is_winner: boolean; -- Whether team_a has won the game
		wins_a: integer := 0; -- Num of wins on team a
		wins_b: integer := 0; -- Num of wins on team b
		ties: integer := 0; -- Num of ties

		-- Total point differential of the respective teams
		point_diff_a: scores_possible := 1;
		point_diff_b: scores_possible := 1;

		-- Average value of the point differential of a win for the
		--     respective teams.
		ave_a_win: float;
		ave_b_win: float;
   	begin
		-- In place for quick testing purposes
		--for i in team_a'range loop
		--	put(team_a(i));
		--	put(team_b(i));
		--	new_line;
		--end loop;


		-- Loop tracking the wins/ties and the point differentials
		for i in team_a'range loop
			if team_a(i) > team_b(i) then
				wins_a := wins_a + 1;
				point_diff_a := point_diff_a + team_a(i) - team_b(i);
			elsif team_a(i) < team_b(i) then
				wins_b := wins_b + 1;
				point_diff_b := point_diff_b + team_b(i) - team_a(i);
			else
				ties := ties + 1;
			end if;
		end loop;

		if wins_a /= 0 then
			ave_a_win := float(point_diff_a - 1) / float(wins_a);
		else
			ave_a_win := 0.0;
		end if;

		if wins_b /= 0 then
			ave_b_win := float(point_diff_b - 1) / float(wins_b);
		else
			ave_b_win := 0.0;
		end if;

		put_line(title);
		put("Wins for A: ");
		put(wins_a,3);
		new_line;

		put("Wins for B: ");
		put(wins_b,3);
		new_line;

		put("Ties: ");
		put(ties,9);
		new_line;

		put("Average A win: ");
		put(ave_a_win,4,1,0);
		new_line;

		put("Average B win: ");
		put(ave_b_win,4,1,0);
		new_line;
		new_line;

		if wins_a > wins_b then
			a_is_winner := true;
		elsif wins_a < wins_b then
			a_is_winner := false;
		elsif ave_a_win > ave_b_win then
			a_is_winner := true;
		else
			a_is_winner := false;
		end if;

		return a_is_winner;
   	end output;


	----------------------------------------------------------------------
	-- Purpose: Read in the data scores and initialize the team arrays
	-- Precondition: There exists a data file with 1..100 complete sets,
	--     each containing a score per team in the range 1..1000.
	-- Postcondition: The arrays are filled with data of type possible_scores
	--     as well as reporting the size of the real data per array.
	----------------------------------------------------------------------
	procedure get_data (team_a, team_b: in out team_scores;
						score_num: out sets_range) is
		odd_num_amount: exception; -- Exception to detect odd num amounts
	begin
		exception_block:
		begin
			score_num := 1;
			while not end_of_file loop
				get(team_a(score_num));

				if end_of_file then
					raise odd_num_amount;
				else
					get(team_b(score_num));
				end if;

				score_num := score_num + 1;
			end loop;
			score_num := score_num - 1;

		exception
			when data_error =>
				put_line("Data error: You must enter a number within range" &
					"1..1000");

			when constraint_error =>
				put_line("Constraint error: The number you have entered is" &
					"not within the range 1..1000");
				put_line("Alternatively, the amount of numbers per team may" &
					"not belong to the range 2..100");

			when e: odd_num_amount =>
				put_line("Odd Number Amount error: You must have an even" &
					"amount of numbers to be valid input");

		end exception_block;
	end get_data;


	----------------------------------------------------------------------
	-- Purpose: Remove the highest score from the winning team and the
	--     lowest score from the losing team.
	-- Precondition: A team has won
	-- Postcondition: Both teams size are reduced by 1 with the correct
	--     item removed.
	----------------------------------------------------------------------
	procedure reduced_output_prep(win_team, lose_team: in out team_scores;
								num_players: in out sets_range) is
		desired_index: sets_range := 1; -- The index of the value in question
	begin
		-- Locating the largest value in the winning teams array
		for i in win_team'range loop
			if win_team(i) > win_team(desired_index) then
				desired_index := i;
			end if;
		end loop;

		-- "Removing" score and adjusting the array
		if desired_index /= win_team'last then
			for i in win_team'range loop
				if i >= desired_index and i < win_team'last then
					win_team(i) := win_team(i + 1);
				end if;
			end loop;
		end if;

		-- Locating the smallest value in the losing teams array
		desired_index := 1;
		for i in lose_team'range loop
			if lose_team(i) < lose_team(desired_index) then
				desired_index := i;
			end if;
		end loop;

		-- "Removing" score and adjusting the array
		if desired_index /= lose_team'last then
			for i in lose_team'range loop
				if i >= desired_index and i < lose_team'last then
					lose_team(i) := lose_team(i + 1);
				end if;
			end loop;
		end if;

		num_players := num_players - 1;
	end reduced_output_prep;


	----------------------------------------------------------------------
	-- Purpose: Sort both arrays to descending order
	-- Preconditions: The arrays have atleast 1 element of type
	--     scores_possible.
	-- Postconditions: the arrays will be in descending order
	-----------------------------------------------------------------------
	procedure best_best_prep (team: in out team_scores) is
		temp_score: scores_possible; -- Temp score used to swap values
		sort_location: sets_range := 1; -- Location of sort start
		swapped: boolean := true; -- whether something was swapped.
	begin
		while swapped loop
			swapped := false;
			for i in team'range loop
				if i < team'last and then team(i) < team(i + 1) then
					temp_score := team(i);
					team(i) := team(i + 1);
					team(i + 1) := temp_score;
					swapped := true;
				end if;
			end loop;
		end loop;

	end best_best_prep;


	----------------------------------------------------------------------
	-- Purpose: Reverse the order of an array
	-- Preconditions: the array is not null
	-- Postconditions: the array is in reveresed order
	----------------------------------------------------------------------
	procedure best_worst_prep(team: in out team_scores) is

		temp_score: scores_possible; -- Temp score used to swap values
	begin
		for i in team'range loop
			if i <= team'last / 2 then
				temp_score := team(i);
				team(i) := team(team'last - i + 1);
				team(team'last - i + 1) := temp_score;
			end if;
		end loop;
	end best_worst_prep;


	----------------------------------------------------------------------
	-- Purpose: Organizes the neccessary function and procedure calls to
	--     achieve the main procedure's purpose.
	-- Precondition: There exists a data file with 1..100 complete sets.
	-- Postcondition: All intended calls to output have been done.
	----------------------------------------------------------------------
	procedure caller is
		team_a: team_scores(sets_range); -- First team player's scores
		team_b: team_scores(sets_range); -- Second team player's scores
		num_players_each: sets_range := 1; -- Number of players on each team
		a_is_winner: boolean; -- Whether team a was the most recent winner
		not_used: boolean; -- Boolean to call a function without using the
						   --     return value.

		-- Each of the following strings are the titles for their
		--     respective output sections.
		original_out: String := "Original pairings:";
		reduced_out: String := "Reduced team pairings:";
		best_best_out: String := "Reduced best vs best pairings:";
		best_worst_out: String := "Reduced best vs worst pairings:";
	begin
		get_data(team_a, team_b, num_players_each);

		-- Note: Both arrays are using the upper bound of num_players_each
		--     since they must have an equal number of players.
		a_is_winner := output(team_a(team_a'first..num_players_each)
			, team_b(team_b'first..num_players_each), original_out);
		
		-- Adjusts arrays for second output
		if a_is_winner then
			-- Second output calls
			reduced_output_prep(team_a(team_a'first..num_players_each),
				team_b(team_b'first..num_players_each), num_players_each);
			
			not_used := output(team_a(team_a'first..num_players_each)
   				, team_b(team_b'first..num_players_each), reduced_out);
		else
			-- Second output calls
			reduced_output_prep(team_b(team_b'first..num_players_each),
				team_a(team_a'first..num_players_each), num_players_each);

			not_used := output(team_a(team_a'first..num_players_each)
               	, team_b(team_b'first..num_players_each), reduced_out);
		end if;
		-- Third output calls
		best_best_prep(team_a(team_a'first..num_players_each));
		best_best_prep(team_b(team_b'first..num_players_each));

		not_used := output(team_a(team_a'first..num_players_each)
   			, team_b(team_b'first..num_players_each), best_best_out);

		-- Fourth and final output calls
		best_worst_prep(team_b(team_b'first..num_players_each));

		not_used := output(team_a(team_a'first..num_players_each)
        	, team_b(team_b'first..num_players_each), best_worst_out);

	end caller;

begin

caller;

end do_teams;
