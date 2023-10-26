CREATE TABLE RAM_Memory (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Capacity INT NOT NULL CHECK ( Capacity > 0),
  Frequency INT NOT NULL  CHECK ( Frequency > 0),
  RAMType TEXT CHECK (RAMType ~ '^DDR'),
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE PowerSupply (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  Power INT CHECK (POWER > 0),
  Modular BOOLEAN,
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE Processors (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  Cores INT NOT NULL CHECK (Cores > 0 AND CORES <= 64),
  ClockSpeed FLOAT NOT NULL CHECK (ClockSpeed > 0),
  Socket TEXT NOT NULL,
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE Motherboards (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  FormFactor TEXT NOT NULL,
  RAMSlots TEXT CHECK (RAMSlots ~ '^DDR'),
  Interface TEXT NOT NULL CHECK (Interface::FLOAT >= 1.0 AND Interface::FLOAT <= 5.0),
  Socket TEXT NOT NULL,
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE GraphicsCards (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  VRAM INT NOT NULL CHECK (VRAM > 0 AND VRAM <= 24),
  Interface TEXT NOT NULL CHECK (Interface::FLOAT >= 1.0 AND Interface::FLOAT <= 5.0),
  PowerConsumption INT NOT NULL CHECK (PowerConsumption > 0),
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE ComputerCases (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  Color TEXT NOT NULL,
  FormFactor TEXT NOT NULL,
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE DataStorage (
  ID SERIAL PRIMARY KEY,
  Name TEXT NOT NULL,
  Manufacturer TEXT NOT NULL,
  Type TEXT NOT NULL,
  Capacity INT NOT NULL CHECK (Capacity > 0),
  Price INT NOT NULL CHECK (Price > 0)
);

CREATE TABLE ProcessorsMotherboards (
    ProcessorsId INT REFERENCES Processors ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    MotherboardsId INT REFERENCES Motherboards ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (ProcessorsId, MotherboardsId)
);

CREATE TABLE ComputerCasesMotherboards
(
    ComputerCasesId INT REFERENCES ComputerCases ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    MotherboardsId INT REFERENCES Motherboards ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (ComputerCasesId, MotherboardsId)
);

CREATE TABLE RAM_MemoryMotherboards
(
    RAM_MemoryId INT REFERENCES RAM_Memory ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    MotherboardsId INT REFERENCES Motherboards ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (RAM_MemoryId, MotherboardsId)
);

CREATE TABLE GraphicsCardsMotherboards
(
    GraphicsCardsId INT REFERENCES GraphicsCards ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    MotherboardsId INT REFERENCES Motherboards ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (MotherboardsId, GraphicsCardsId)
);