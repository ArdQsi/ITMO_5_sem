CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON Processors
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_processors();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON RAM_Memory
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_ram_memory();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON PowerSupply
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_power_supply();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON Motherboards
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_motherboards();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON GraphicsCards
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_graphics_cards();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON ComputerCases
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_computer_case();

CREATE TRIGGER replace_empty_string_trigger
BEFORE INSERT ON DataStorage
FOR EACH ROW
EXECUTE FUNCTION replace_empty_string_with_null_for_data_storage();




CREATE TRIGGER trigger_for_Motherboards AFTER UPDATE OR INSERT OR DELETE
    ON Motherboards
    FOR EACH STATEMENT
EXECUTE PROCEDURE updateMotherboards();

CREATE TRIGGER trigger_for_Processors AFTER UPDATE OR INSERT OR DELETE
    ON Processors
    FOR EACH STATEMENT
EXECUTE PROCEDURE check_ProcessorsMotherboards();

CREATE TRIGGER trigger_for_ComputerCases AFTER UPDATE OR INSERT OR DELETE
    ON ComputerCases
    FOR EACH STATEMENT
EXECUTE PROCEDURE check_ComputerCasesMotherboards();

CREATE TRIGGER trigger_for_RAM_Memory AFTER UPDATE OR INSERT OR DELETE
    ON RAM_Memory
    FOR EACH STATEMENT
EXECUTE PROCEDURE check_RAM_MemoryMotherboards();

CREATE TRIGGER trigger_for_GraphicsCards AFTER UPDATE OR INSERT OR DELETE
    ON GraphicsCards
    FOR EACH STATEMENT
EXECUTE PROCEDURE check_GraphicsCardsMotherboards();
