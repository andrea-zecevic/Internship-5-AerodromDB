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

CREATE TABLE Flights (
	FlightId SERIAL PRIMARY KEY,
	FlightCapacity INT NOT NULL,
	AirplaneId INT REFERENCES Airplanes(AirplaneId),
	DepartureAirportId INT REFERENCES Airports(AirportId),
    DestinationAirportId INT REFERENCES Airports(AirportId),
    DepartureTime TIME,
	ArrivalTime TIME,
	Price DECIMAL
)

CREATE TABLE Users (
	UserId SERIAL PRIMARY KEY,
	Name VARCHAR(30),
	Surname VARCHAR(30),
	Email VARCHAR(100),
	Birth DATE,
	LoyaltyCardExpiy DATE
)

CREATE TABLE Tickets (
	TicketId SERIAL PRIMARY KEY,
	FlightId INT REFERENCES Flights(FlightId),
	UserId INT REFERENCES Users(UserId),
	SeatNumber VARCHAR(5) UNIQUE
)

CREATE TABLE Seats (
    SeatId SERIAL PRIMARY KEY,
    FlightId INT REFERENCES Flights(FlightId),
    SeatNumber VARCHAR(5) UNIQUE,
    Section VARCHAR(10),
	Occupied BOOLEAN DEFAULT FALSE,
    OccupiedBy INT REFERENCES Users(UserId)
)

CREATE TABLE Pilots (
	PilotId SERIAL PRIMARY KEY,
	Name VARCHAR(30),
	Surname VARCHAR(30),
	Birth DATE,
	CONSTRAINT CheckPilotAge CHECK (DATE_PART('year', CURRENT_DATE) - DATE_PART('year', Birth) BETWEEN 20 AND 60)
)

CREATE TABLE Crew (
	CrewId SERIAL PRIMARY KEY,
	Name VARCHAR(30),
	Surname VARCHAR(30),
	Role VARCHAR(30),
	FlightId INT REFERENCES Flights(FlightId),
	CONSTRAINT UniqueCrewMember UNIQUE (FlightId, Role),
	CHECK (Role IN ('Pilot', 'CabinCrew'))
)

CREATE TABLE Ratings (
	RatingId SERIAL PRIMARY KEY,
	UserId INT REFERENCES Users(UserId),
	FlightId INT REFERENCES Flights(FlightId),
	Rating INT CHECK (Rating BETWEEN 1 AND 5),
	Comment TEXT,
	CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Anonymous BOOLEAN
)

ALTER TABLE Flights
ADD CONSTRAINT CheckTicketPrice
CHECK (Price >= 0)

ALTER TABLE Seats
ADD CONSTRAINT CheckSeatSection
CHECK (Section IN ('Business', 'Economy'))




