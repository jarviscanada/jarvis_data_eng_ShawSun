
-- Question 1:
SELECT *
FROM cd.members;

-- Question 2:
INSERT INTO cd.facilities (
    facid, name, membercost, guestcost,
    initialoutlay, monthlymaintenance
)
VALUES
    (
        (
            SELECT
                MAX(facid)
            FROM
                cd.facilities
        ) + 1,
        'Spa',
        20,
        30,
        100000,
        800
    );

`` Question 3:
UPDATE
  cd.facilities
SET
  initialoutlay = 10000
WHERE
  name = 'Tennis Court 2'

-- Question 4:
UPDATE
  cd.facilities
SET
  membercost = (
    SELECT
      membercost
    FROM
      cd.facilities
    WHERE
      name = 'Tennis Court 1'
  ) * 1.1,
  guestcost = (
    SELECT
      guestcost
    FROM
      cd.facilities
    WHERE
      name = 'Tennis Court 1'
  ) * 1.1
WHERE
  name = 'Tennis Court 2'

-- Question 5:
DELETE FROM
    cd.bookings;

-- Question 6:
DELETE FROM
  cd.members
WHERE
  memid = 37;

-- Basic:
-- Question 1:
SELECT
  facid,
  name,
  membercost,
  monthlymaintenance
FROM
  cd.facilities
WHERE
  membercost < (monthlymaintenance / 50)
  and membercost != 0;

-- Question 2:
SELECT
  *
FROM
  cd.facilities
WHERE
  name LIKE '%Tennis%'

-- Question 3:
SELECT
  *
FROM
  cd.facilities
WHERE
  facid IN (1, 5);

-- Question 4:
SELECT
  memid,
  surname,
  firstname,
  joindate
FROM
  cd.members
WHERE
  joindate >= '2012-09-01 00:00:00'

-- Question 5:
SELECT
  surname
FROM
  cd.members
UNION
SELECT
  name
FROM
  cd.facilities;

-- Join:
-- Question 1:
SELECT
    b.starttime
FROM
    cd.bookings b
    JOIN cd.members m ON b.memid = m.memid
WHERE
    m.surname = 'Farrell'
    and m.firstname = 'David';

-- Question 2:
SElECT
  b.starttime as start,
  f.name
FROM
  cd.bookings b
  JOIN cd.facilities f ON b.facid = f.facid
WHERE
  '2012-09-22' > b.starttime
  and b.starttime >= '2012-09-21'
  and f.name LIKE '%Tennis Court%'
ORDER BY
  b.starttime;

-- Question 3:
SELECT
  m1.firstname as memfname,
  m1.surname as memsname,
  m2.firstname as recfname,
  m2.surname as recsname
FROM
  cd.members m1
  LEFT JOIN cd.members m2 ON m1.recommendedby = m2.memid
ORDER BY
  m1.surname,
  m1.firstname;

-- Question 4:
SELECT
  DISTINCT m2.firstname as firstname,
  m2.surname as surname
FROM
  cd.members m1
  JOIN cd.members m2 ON m1.recommendedby = m2.memid
ORDER BY
  m2.surname,
  m2.firstname;

-- Question 5:
SELECT
  DISTINCT mems.firstname || ' ' || mems.surname AS member,
  (
    SELECT
      recs.firstname || ' ' || recs.surname AS recommender
    FROM
      cd.members recs
    WHERE
      recs.memid = mems.recommendedby
  )
FROM
  cd.members mems
ORDER BY
  member;

-- Aggregation:
-- Question 1:
SELECT
    recommendedby,
    COUNT(recommendedby)
FROM
    cd.members
WHERE
    recommendedby IS NOT NULL
GROUP BY
    recommendedby
ORDER BY
    recommendedby;

-- Question 2:
SELECT
  facid,
  SUM(slots) as "Total Slots"
FROM
  cd.bookings
GROUP BY
  facid
ORDER BY
  facid;

-- Question 3:
SELECT
  facid,
  SUM(slots) as "Total Slots"
FROM
  cd.bookings
WHERE
  starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY
  facid
ORDER BY
  SUM(slots);

-- Question 4:
SELECT
  facid,
  EXTRACT(
    MONTH
    FROM
      starttime
  ) as "month",
  SUM(slots) as "Total Slots"
FROM
  cd.bookings
WHERE
  EXTRACT(
    YEAR
    FROM
      starttime
  ) = 2012
GROUP BY
  facid,
  "month"
ORDER BY
  facid,
  "month";

-- Question 5:
SELECT
  COUNT(DISTINCT b.memid)
FROM
  cd.bookings b
  JOIN cd.members m ON m.memid = b.memid;

-- Question 6:
SELECT
  m.surname,
  m.firstname,
  m.memid,
  MIN(b.starttime) as "starttime"
FROM
  cd.members m
  LEFT JOIN cd.bookings b ON m.memid = b.memid
WHERE
  starttime > '2012-09-01'
GROUP BY
  m.memid
ORDER BY
  m.memid;

-- Question 7:
select
  (
    select
      count(*)
    from
      cd.members
  ) as count,
  firstname,
  surname
from
  cd.members
order by
  joindate

-- Question 8:
select
  row_number() over(
    order by
      joindate
  ),
  firstname,
  surname
from
  cd.members
order by
  joindate

-- Question 9:
select
  facid,
  total
from
  (
    select
      facid,
      sum(slots) total,
      rank() over (
        order by
          sum(slots) desc
      ) rank
    from
      cd.bookings
    group by
      facid
  ) as ranked
where
  rank = 1

-- String:
-- Question 1:
SELECT
  (surname || ', ' || firstname) as name
FROM
  cd.members;

--  Question 2:
SELECT
  memid,
  telephone
FROM
  cd.members
WHERE
  telephone LIKE '(%)%';

-- Question 3:
SELECT
  SUBSTRING(surname, 1, 1) as "letter",
  COUNT(*)
FROM
  cd.members
GROUP BY
  "letter"
ORDER BY
  "letter";