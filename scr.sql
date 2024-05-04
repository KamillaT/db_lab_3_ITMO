BEGIN;

DROP TABLE IF EXISTS action_description CASCADE;
DROP TABLE IF EXISTS action CASCADE;
DROP TABLE IF EXISTS object CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS person CASCADE;

CREATE TABLE person( id SERIAL PRIMARY KEY, name VARCHAR (45) NOT NULL );

CREATE TABLE location( id SERIAL PRIMARY KEY, name VARCHAR (45) NOT NULL, state VARCHAR (255) );

CREATE TABLE object( id SERIAL PRIMARY KEY, name VARCHAR (45) NOT NULL, location_id INT NOT NULL, state VARCHAR (255),
                     FOREIGN KEY (location_id) REFERENCES location (id) );

CREATE TABLE action( id SERIAL PRIMARY KEY, action_number INT NOT NULL,
                     person_id INT NOT NULL, current_location_id INT NOT NULL,
                     FOREIGN KEY (person_id) REFERENCES person (id),
                     FOREIGN KEY (current_location_id) REFERENCES location (id) );

CREATE TABLE action_description( id SERIAL PRIMARY KEY, action_id INT NOT NULL UNIQUE,
                                 change_location_state BOOLEAN NOT NULL,
                                 change_object_state BOOLEAN NOT NULL,
                                 thought BOOLEAN NOT NULL,
                                 action_description VARCHAR (255) NOT NULL, FOREIGN KEY (action_id) REFERENCES action (id) );

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

INSERT INTO person(name) VALUES('Тим');

INSERT INTO location(name) VALUES('машина');

INSERT INTO object(name, location_id) VALUES('ручка', 1);
INSERT INTO object(name, location_id) VALUES('окно', 1);
INSERT INTO object(name, location_id) VALUES('дверь', 1);

INSERT INTO action(action_number, person_id, current_location_id) VALUES(1, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(2, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(3, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(4, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(5, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(6, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(7, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(8, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(9, 1, 1);
INSERT INTO action(action_number, person_id, current_location_id) VALUES(10, 1, 1);

INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(1, false, false, false, 'Тим опустил глаза');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(2, false, false, false, 'Тим посмотрел на свои ноги');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(3, false, false, false, 'Тим стоял на дверной ручке');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(4, false, false, false, 'Тим присел на корточки');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(5, false, false, false, 'Тим постарался разглядеть ручку');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(6, false, false, false, 'Тиму в темноте было плохо видно');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(7, false, true, true, 'Тим понял, что на двери огромная вмятина и ручку заклинило');
UPDATE object SET state='На двери была вмятина' WHERE name='дверь';
UPDATE object SET state='Ручку заклинило' WHERE name='ручка';
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(8, false, false, true, 'Тим попытался открыть окно');
UPDATE object SET state='Окно заклинило' WHERE name='окно';
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(9, false, false, true, 'Тим подумал о задней двери');
INSERT INTO action_description(action_id, change_location_state, change_object_state, thought, action_description)
VALUES(10, true, false, false, 'Тим перегнулся через сиденье');
UPDATE location SET state='Машина резко накренилась' WHERE id=1;

COMMIT;