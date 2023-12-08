CREATE TABLE Airports(
	AirportId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	RunwayCapacity INT,
	StoreCapacity INT	
)

CREATE TABLE Airplanes (
	AirplaneId SERIAL PRIMARY KEY,
	Name VARCHAR(10) NOT NULL,
	Model VARCHAR(10),
	Capacity INT,
	YearOfManufacture INT,
	Status VARCHAR(50),
	Location POINT,
	AirportId INT REFERENCES Airports(AirportId)
)

ALTER TABLE Airplanes
ADD CONSTRAINT CheckStatus
CHECK (Status IN ('Na prodaji', 'Aktivan', 'Na popravku', 'Razmontiran'));

CREATE TABLE Flights (
	FlightId SERIAL PRIMARY KEY,
	FlightCapacity INT NOT NULL,
	AirplaneId INT REFERENCES Airplanes(AirplaneId),
	DepartureAirportId INT REFERENCES Airports(AirportId),
    DestinationAirportId INT REFERENCES Airports(AirportId),
    DepartureTime TIME,
	ArrivalTime TIME
)

ALTER TABLE Flights
ADD CONSTRAINT CheckFlighCapacity
CHECK (FlightCapacity <= (SELECT Capacity FROM Airplanes WHERE AirplaneId = Flights.AirplaneId));

CREATE TABLE Tickets (
	TicketId SERIAL PRIMARY KEY,
	FlightId INT REFERENCES Flights(FlightId),
	UserId INT REFERENCES Users(UserId),
	SeatNumber VARCHAR(5) UNIQUE,
	Price DECIMAL		
)

CREATE TABLE Users (
	UserId SERIAL PRIMARY KEY,
	Name VARCHAR(30),
	Surname VARCHAR(30),
	Email VARCHAR(100),
	Birth DATE,
	LoyaltyCardId INT REFERENCES LoyaltyCard(LoyaltyCardId)
)

CREATE TABLE LoyaltyCard(
    LoyaltyCardId SERIAL PRIMARY KEY,
    UserId INT REFERENCES Users(UserId),
    ExpiryDate DATE
)

ALTER TABLE Users
ADD CONSTRAINT CheckNumberOfTickets
CHECK ((SELECT COUNT(*) FROM Tickets WHERE UserId = Users.UserId) >= 10)



