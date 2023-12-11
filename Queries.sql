-- ispis imena i modela svih aviona s kapacitetom većim od 100
SELECT CompanyName, Model
FROM Airplanes
WHERE Capacity > 100

-- ispis svih karata čija je cijena između 100 i 200 eura
SELECT *
FROM Tickets
WHERE Price BETWEEN 100 AND 200

-- ispis svih pilotkinja s više od 20 odrađenih letova do danas
SELECT Name, Surname, Role
FROM Crew
WHERE Role = 'Pilot' AND NumberOfFlights > 20

-- ispis svih domaćina/ca zrakoplova koji su trenutno u zraku
SELECT Name, Surname, Role
FROM Crew
WHERE Role = 'Cabin Crew' AND FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE DepartureTime < current_time AND ArrivalTime > current_time
)

-- ispis broja letova u Split/iz Splita 2023. godine
-- nemam grad Split u tablici, u Mackaroo su mi se generirali "strani" gradovi isto vrijedi i za Beč
SELECT COUNT(*)
FROM Flights
WHERE DepartureAirportId = (SELECT AirportId FROM Airports WHERE City = 'Split')
AND EXTRACT(YEAR FROM DepartureTime) = 2023

-- ispis svih letova za Beč u prosincu 2023.
SELECT *
FROM Flights
WHERE DestinationAirportId = (SELECT AirportId FROM Airports WHERE City = 'Beč')
    AND EXTRACT(MONTH FROM DepartureTime) = 12 AND EXTRACT(YEAR FROM DepartureTime) = 2023


-- ispis broj prodanih Economy letova kompanije AirDUMP u 2021.
SELECT COUNT(*)
FROM Tickets, Flights, Airplanes
WHERE Tickets.FlightId = Flights.FlightId
  AND Flights.AirplaneId = Airplanes.AirplaneId
  AND Tickets.SeatNumber LIKE 'B%'
  AND Airplanes.CompanyName = 'AirDUMP'
  AND DATE_TRUNC('year', CURRENT_DATE + Flights.DepartureTime) = '2021-01-01'

-- ispis prosječne ocjene letova kompanije AirDUMP
SELECT AVG(Rating)
FROM Ratings
WHERE FlightId IN (SELECT FlightId FROM Flights WHERE AirplaneId IN (SELECT AirplaneId FROM Airplanes WHERE CompanyName = 'AirDUMP'))

-- ispis svih aerodroma u Londonu, sortiranih po broju Airbus aviona trenutno na njihovim pistama
SELECT Name AS AirportName, (
    SELECT COUNT(*)
    FROM Airplanes
    WHERE Airplanes.AirportId = Airports.AirportId
      AND Airplanes.Model = 'Airbus'
) AS NumberOfAirbus
FROM Airports
WHERE City = 'London'
ORDER BY NumberOfAirbus DESC;

--	ispis svih aerodroma udaljenih od Splita manje od 1500km


-- smanjite cijenu za 20% svim kartama čiji letovi imaju manje od 20 ljudi
UPDATE Flights
SET Price = Price * 0.8
WHERE FlightId IN (SELECT FlightId FROM Flights WHERE FlightCapacity < 20)

-- ispis novih cijena letova nakon smanjenja za 20%
SELECT FlightId, Price AS OldPrice, (Price * 0.8) AS NewPrice
FROM Flights
WHERE FlightId IN (SELECT FlightId FROM Flights WHERE FlightCapacity < 20);

-- povisite plaću za 100 eura svim pilotima koji su ove godine imali više od 10 letova
UPDATE Crew
SET Salary = Salary + 100
WHERE Role = 'Pilot'
  AND NumberOfFlights > 10
  AND FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) = EXTRACT(YEAR FROM CURRENT_TIMESTAMP)
  )

-- ispis trenutnih i novih plaća pilota koji zadovoljavaju uvjete
SELECT 
    Name,
    Surname,
    Salary AS CurrentSalary,
    Salary + 100 AS NewSalary
FROM Crew
WHERE Role = 'Pilot'
  AND NumberOfFlights > 10
  AND FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) = EXTRACT(YEAR FROM CURRENT_TIMESTAMP)
  )

-- razmontirajte avione starije od 20 godina koji nemaju letove pred sobom
UPDATE Airplanes
SET Status = 'Disassembled'
WHERE YearOfManufacture < EXTRACT(YEAR FROM CURRENT_DATE) - 20
  AND AirplaneId NOT IN (
    SELECT DISTINCT AirplaneId
    FROM Flights
  )

SELECT * 
FROM Airplanes
WHERE Status = 'Disassembled'

-- izbrišite sve letove koji nemaju ni jednu prodanu kartu
DELETE FROM Tickets
WHERE FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE FlightId NOT IN (SELECT DISTINCT FlightId FROM Tickets)
)

DELETE FROM Seats
WHERE FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE FlightId NOT IN (SELECT DISTINCT FlightId FROM Tickets)
)

DELETE FROM Ratings
WHERE FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE FlightId NOT IN (SELECT DISTINCT FlightId FROM Tickets)
)

DELETE FROM Crew
WHERE FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE FlightId NOT IN (SELECT DISTINCT FlightId FROM Tickets)
)

SELECT *
FROM Flights
WHERE FlightId NOT IN (SELECT FlightId FROM Tickets)

DELETE FROM Flights
WHERE FlightId NOT IN (SELECT DISTINCT FlightId FROM Tickets)

-- izbrišite sve kartice vjernosti putnika čije prezime završava na -ov/a, -in/a
DELETE FROM Users
WHERE LoyaltyCardExpiy IS NOT NULL AND (Surname LIKE '%ov' OR Surname LIKE '%in')











