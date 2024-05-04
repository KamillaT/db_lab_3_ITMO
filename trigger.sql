DROP TRIGGER IF EXISTS door_trigger on object;

CREATE OR REPLACE FUNCTION do_on_door_trigger()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.name = 'дверь' AND NEW.state = 'На двери была вмятина' THEN
        UPDATE action_description
        SET action_description = 'Тим понял, что ничего не может сделать с дверью'
        WHERE action_description = 'Тим понял, что на двери огромная вмятина и ручку заклинило';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER door_trigger
    BEFORE INSERT OR UPDATE ON object
    FOR EACH ROW
EXECUTE FUNCTION do_on_door_trigger();


DROP TRIGGER IF EXISTS window_trigger on object;

CREATE OR REPLACE FUNCTION do_on_window_trigger()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.name = 'окно' AND NEW.state = 'Окно заклинило' THEN
        UPDATE action_description
        SET action_description = 'Тим стал думать, что он может сделать с задней дверью'
        WHERE action_description = 'Тим попытался открыть окно';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER window_trigger
    BEFORE INSERT OR UPDATE ON object
    FOR EACH ROW
EXECUTE FUNCTION do_on_window_trigger();