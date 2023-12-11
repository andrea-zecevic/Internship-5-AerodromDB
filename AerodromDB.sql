CREATE TABLE Airports(
	AirportId SERIAL PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	City VARCHAR(255) NOT NULL,
	RunwayCapacity INT NOT NULL,
	StoreCapacity INT NOT NULL
)

CREATE TYPE STATUS AS ENUM ('On sale' , 'Active', 'For repair', 'Disassembled')

CREATE TABLE Airplanes (
	AirplaneId SERIAL PRIMARY KEY,
	CompanyName VARCHAR(50) NOT NULL,
	Model VARCHAR(20),
	Capacity INT NOT NULL,
	YearOfManufacture INT NOT NULL,
	Status VARCHAR(50),
	AirportId INT REFERENCES Airports(AirportId)
)

CREATE TABLE Flights (
	FlightId SERIAL PRIMARY KEY,
	FlightCapacity INT NOT NULL,
	AirplaneId INT REFERENCES Airplanes(AirplaneId),
	DepartureAirportId INT REFERENCES Airports(AirportId),
	DestinationAirportId INT REFERENCES Airports(AirportId),
	DepartureTime TIME NOT NULL,
	ArrivalTime TIME NOT NULL,
	Price DECIMAL
)

CREATE TABLE Users (
	UserId SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	Email VARCHAR(100),
	Birth DATE NOT NULL,
	LoyaltyCardExpiy DATE
)

CREATE TABLE Tickets (
	TicketId SERIAL PRIMARY KEY,
	FlightId INT REFERENCES Flights(FlightId),
	UserId INT REFERENCES Users(UserId),
	SeatNumber VARCHAR(5) NOT NULL
)

CREATE TABLE Seats (
	SeatId SERIAL PRIMARY KEY,
	FlightId INT REFERENCES Flights(FlightId),
	Section VARCHAR(10) NOT NULL,
	Occupied BOOLEAN DEFAULT FALSE,
	OccupiedBy INT REFERENCES Users(UserId)
)

CREATE TYPE ROLE AS ENUM ('Pilot' , 'Cabin Crew')

CREATE TABLE Crew (
	CrewId SERIAL PRIMARY KEY,
	Name VARCHAR(30),
	Surname VARCHAR(30),
	Role ROLE NOT NULL,
	Birth DATE,
	FlightId INT REFERENCES Flights(FlightId)	
)

CREATE TABLE Ratings (
	RatingId SERIAL PRIMARY KEY,
	UserId INT REFERENCES Users(UserId),
	FlightId INT REFERENCES Flights(FlightId),
	Rating INT CHECK (Rating BETWEEN 1 AND 5),
	Comment TEXT,
	CreationDate DATE,
	Anonymous BOOLEAN
)

--Trigers and constraints


