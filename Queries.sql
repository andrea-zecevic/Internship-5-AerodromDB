-- ispis imena i modela svih aviona s kapacitetom većim od 100
SELECT CompanyName, Model
FROM Airplanes
WHERE Capacity > 100

-- ispis svih karata čija je cijena između 100 i 200 eura
SELECT *
FROM Flights
WHERE Price BETWEEN 100 AND 200

-- ispis svih pilotkinja s više od 20 odrađenih letova do danas


-- ispis svih domaćina/ca zrakoplova koji su trenutno u zraku
SELECT Name, Surname, Role
FROM Crew
WHERE Role = 'Cabin Crew' AND FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE DepartureTime < current_time AND ArrivalTime > current_time
)

-- ispis broja letova u Split/iz Splita 2023. godine


-- ispis svih letova za Beč u prosincu 2023.


-- ispis broj prodanih Economy letova kompanije AirDUMP u 2021.
SELECT COUNT(*)
FROM Tickets
WHERE SeatNumber LIKE 'B%'
  AND FlightId IN (
    SELECT FlightId
    FROM Flights
    WHERE CURRENT_DATE + DepartureTime BETWEEN '2021-01-01' AND '2021-12-31'
)

-- ispis prosječne ocjene letova kompanije AirDUMP
SELECT AVG(Rating)
FROM Ratings
WHERE FlightId IN (SELECT FlightId FROM Flights WHERE AirplaneId IN (SELECT AirplaneId FROM Airplanes WHERE CompanyName = 'AirDUMP'))

-- ispis svih aerodroma u Londonu, sortiranih po broju Airbus aviona trenutno na njihovim pistama


--	ispis svih aerodroma udaljenih od Splita manje od 1500km



-- smanjite cijenu za 20% svim kartama čiji letovi imaju manje od 20 ljudi
UPDATE Flights
SET Price = Price * 0.8
WHERE FlightId IN (SELECT FlightId FROM Flights WHERE FlightCapacity < 20)


-- povisite plaću za 100 eura svim pilotima koji su ove godine imali više od 10 letova duljih od 10 sati

-- razmontirajte avione starije od 20 godina koji nemaju letove pred sobom
UPDATE Airplanes
SET Status = 'Disassembled'
WHERE YearOfManufacture < EXTRACT(YEAR FROM current_date) - 20
  AND AirplaneId NOT IN (SELECT DISTINCT AirplaneId FROM Flights WHERE DepartureTime > current_time)


-- izbrišite sve letove koji nemaju ni jednu prodanu kartu

-- izbrišite sve kartice vjernosti putnika čije prezime završava na -ov/a, -in/a
DELETE FROM Users
WHERE LoyaltyCardExpiy IS NOT NULL AND (Surname LIKE '%ov' OR Surname LIKE '%in')













