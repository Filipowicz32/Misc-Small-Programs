-- John Filipowicz
-- Homework 5 Script
DROP VIEW Upper_Classmen_v
;

CREATE VIEW Upper_Classmen_v AS
	SELECT s.First, s.Last, s.Rank, s.Gender, d.Name, r.Room_no, d.Campus
	FROM Student1 s INNER JOIN Room_Assign r
		ON s.SID = r.SID INNER JOIN Dorm d
		ON r.Dorm_Name = d.Name
	WHERE Rank = 'SR' OR Rank = 'JR'
;

SELECT Name, Room_no, Gender
	FROM Upper_Classmen_v
	WHERE Rank = 'JR'
	ORDER BY Name, Room_no
;

SELECT v.First, v.Last, c.Zip
	FROM Upper_Classmen_v v INNER JOIN Campus c
		ON v.Campus = c.Name
	WHERE v.Rank = 'SR' AND (v.Campus = 'Loudon' OR v.Campus = 'Manassas')
;

SELECT Campus, COUNT(*) NUM_UPPER
	FROM Upper_Classmen_v
;

-- The view we created increases usability for the intended scope, but not for
--   items not included into the view itself. Because of this, I also believe the
--   view provides security to a certain extent. The usability goes hand in hand
--   with the view making the queries less complex.

