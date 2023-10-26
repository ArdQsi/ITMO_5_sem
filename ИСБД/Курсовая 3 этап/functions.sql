CREATE OR REPLACE FUNCTION check_ProcessorsMotherboards()
    RETURNS trigger AS
$$
begin
DELETE FROM ProcessorsMotherboards;
                INSERT INTO ProcessorsMotherboards
SELECT Processors.ID, Motherboards.ID
FROM Processors
	JOIN Motherboards ON Processors.Socket = Motherboards.Socket;
return NEW;
end;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_ComputerCasesMotherboards()
    RETURNS trigger AS
$$
begin
DELETE FROM ComputerCasesMotherboards;
                INSERT INTO ComputerCasesMotherboards
SELECT ComputerCases.ID, Motherboards.ID
FROM ComputerCases
         JOIN Motherboards ON ComputerCases.FormFactor = Motherboards.FormFactor;
    return NEW;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_RAM_MemoryMotherboards()
    RETURNS trigger AS
$$
begin
    DELETE FROM RAM_MemoryMotherboards;
    INSERT INTO RAM_MemoryMotherboards
    SELECT RAM_Memory.ID, Motherboards.ID
    FROM RAM_Memory
             JOIN Motherboards ON RAM_Memory.RAMType = Motherboards.RAMSlots;
    return NEW;
end;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_GraphicsCardsMotherboards()
    RETURNS trigger AS
$$
begin
DELETE FROM GraphicsCardsMotherboards;
                INSERT INTO GraphicsCardsMotherboards
SELECT GraphicsCards.ID, Motherboards.ID
FROM GraphicsCards
         JOIN Motherboards ON GraphicsCards.Interface = Motherboards.Interface;
    return NEW;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateMotherboards()
    RETURNS trigger AS
$$
begin
DELETE FROM ProcessorsMotherboards;
DELETE FROM ComputerCasesMotherboards;
DELETE FROM RAM_MemoryMotherboards;
DELETE FROM GraphicsCardsMotherboards;

INSERT INTO ProcessorsMotherboards
SELECT Processors.ID, Motherboards.ID
FROM Processors
JOIN Motherboards ON Processors.Socket = Motherboards.Socket;

INSERT INTO ComputerCasesMotherboards
SELECT ComputerCases.ID, Motherboards.ID
FROM ComputerCases
JOIN Motherboards ON ComputerCases.FormFactor = Motherboards.FormFactor;

INSERT INTO RAM_MemoryMotherboards
SELECT RAM_Memory.ID, Motherboards.ID
FROM RAM_Memory
JOIN Motherboards ON RAM_Memory.RAMType = Motherboards.RAMSlots;

INSERT INTO GraphicsCardsMotherboards
SELECT GraphicsCards.ID, Motherboards.ID
FROM GraphicsCards
JOIN Motherboards ON GraphicsCards.Interface = Motherboards.Interface;

return NEW;
end;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_processors()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.socket = '' THEN
        NEW.socket = NULL;
    END IF;
        IF NEW.name = '' THEN
            NEW.name = NULL;
        END IF;
        IF NEW.manufacturer = '' THEN
            NEW.manufacturer = NULL;
        END IF;
        RETURN NEW;
    END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_ram_memory()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.RAMType = '' THEN
        NEW.RAMType = NULL;
    END IF;
    IF NEW.name = '' THEN
        NEW.name = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_power_supply()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.Manufacturer = '' THEN
        NEW.Manufacturer = NULL;
    END IF;
    IF NEW.name = '' THEN
        NEW.name = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_motherboards()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.Manufacturer = '' THEN
        NEW.Manufacturer = NULL;
    END IF;
    IF NEW.name = '' THEN
        NEW.name = NULL;
    END IF;
    IF NEW.FormFactor = '' THEN
        NEW.FormFactor = NULL;
    END IF;
    IF NEW.RAMSlots = '' THEN
        NEW.RAMSlots = NULL;
    END IF;
    IF NEW.Interface = '' THEN
        NEW.Interface = NULL;
    END IF;
    IF NEW.Socket = '' THEN
        NEW.Socket = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_graphics_cards()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.Name = '' THEN
        NEW.Name = NULL;
    END IF;
    IF NEW.Manufacturer = '' THEN
        NEW.Manufacturer = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_computer_case()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.Name = '' THEN
        NEW.Name = NULL;
    END IF;
    IF NEW.Manufacturer = '' THEN
        NEW.Manufacturer = NULL;
    END IF;
    IF NEW.Color = '' THEN
        NEW.Color = NULL;
    END IF;
    IF NEW.FormFactor = '' THEN
        NEW.FormFactor = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION replace_empty_string_with_null_for_data_storage()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.Manufacturer = '' THEN
        NEW.Manufacturer = NULL;
    END IF;
    IF NEW.name = '' THEN
        NEW.name = NULL;
    END IF;
    IF NEW.Type = '' THEN
        NEW.Type = NULL;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getComputerForPrice(my_price int) RETURNS
    TABLE (
              computercases text,
              datastorage text,
              motherboards text,
              powersupply text,
              processors text,
              ram_memory text,
              price int
          ) AS
$$
begin
    return QUERY
        SELECT computercases.name, datastorage.name, motherboards.name, powersupply.name, processors.name, ram_memory.name,
               (computercases.price + motherboards.price + graphicscards.price +
                processors.price + ram_memory.price + datastorage.price + powersupply.price) AS ЦЕНА
        FROM computercases
                 JOIN computercasesmotherboards ON computercases.id = computercasesmotherboards.computercasesid
                 JOIN motherboards ON computercasesmotherboards.motherboardsid = motherboards.id
                 JOIN graphicscardsmotherboards ON motherboards.id = graphicscardsmotherboards.motherboardsid
                 JOIN graphicscards ON graphicscardsmotherboards.graphicscardsid = graphicscards.id
                 JOIN processorsmotherboards ON motherboards.id = processorsmotherboards.motherboardsid
                 JOIN processors ON processorsmotherboards.processorsid = processors.id
                 JOIN ram_memorymotherboards ON motherboards.id = ram_memorymotherboards.motherboardsid
                 JOIN ram_memory ON ram_memorymotherboards.ram_memoryid = ram_memory.id
                 JOIN powersupply ON powersupply.power >= graphicscards.powerconsumption
                 CROSS JOIN datastorage
        WHERE (computercases.price + motherboards.price + graphicscards.price +
               processors.price + ram_memory.price + datastorage.price + powersupply.price) >= my_price-1000 and
                (computercases.price + motherboards.price + graphicscards.price +
                 processors.price + ram_memory.price + datastorage.price + powersupply.price) <= my_price+1000
                LIMIT 500;
end;
$$ LANGUAGE plpgsql;