CREATE SCHEMA "eStudent";

CREATE TABLE "eStudent".address ( 
	id bigserial NOT NULL,
	city varchar( 50 ) NULL,
	kifle_ketema varchar( 50 ) NULL,
	kebele varchar( 50 ) NULL,
	woreda varchar( 50 ) NULL,
	house_numebr varchar( 50 ) NULL,
	telephone varchar( 50 ) NULL,
	person_id bigserial NULL,
CONSTRAINT pk_address PRIMARY KEY ( id ),
CONSTRAINT pk_address_0 UNIQUE ( person_id )
 );

COMMENT ON COLUMN "eStudent".address.person_id IS 'foreign key for person';

CREATE TABLE "eStudent".countries ( 
	id bigserial NOT NULL,
	name varchar( 255 ) NOT NULL,
	code varchar( 10 ) NOT NULL,
	continent varchar( 255 ) NULL,
CONSTRAINT pk_countries PRIMARY KEY ( id )
 );

CREATE TABLE "eStudent".courses ( 
	id bigserial NOT NULL,
	code varchar( 50 ) NOT NULL,
	title varchar( 255 ) NULL,
	credit int2 NOT NULL,
	description text NULL,
CONSTRAINT pk_courses PRIMARY KEY ( id )
 );

ALTER TABLE "eStudent".courses ADD CONSTRAINT ck_unique_course_number CHECK ( unique(course_number) );

COMMENT ON COLUMN "eStudent".courses.code IS 'Course number (Course code) is a unique-human-readable identifiernthat is used to uniquely represent a course.nFormat : ABC-XXXX => Comp234';

COMMENT ON COLUMN "eStudent".courses.title IS 'Course title is a descriptive text that is used to give additional ninformation about the course';

COMMENT ON COLUMN "eStudent".courses.credit IS 'Credit given to this course interms of contact hours';

COMMENT ON COLUMN "eStudent".courses.description IS 'A textual description about the course';

CREATE TABLE "eStudent".people ( 
	id bigserial NOT NULL,
	first_name varchar( 255 ) NOT NULL,
	father_name varchar( 255 ) NOT NULL,
	grandfather_name varchar( 255 ) NULL,
	sex varchar( 1 ) DEFAULT 'F' NOT NULL,
	birth_date timestamp NOT NULL,
	nationality int8 DEFAULT 1 NOT NULL,
	birth_place varchar( 60 ) NULL,
CONSTRAINT pk_people PRIMARY KEY ( id )
 );

ALTER TABLE "eStudent".people ADD CONSTRAINT ck_unique_person CHECK ( unique(first_name,father_name,grandfather_name) );

CREATE INDEX idx_people ON "eStudent".people ( nationality );

COMMENT ON COLUMN "eStudent".people.birth_place IS 'Birth Place of a person';

CREATE TABLE "eStudent".students ( 
	id bigserial NOT NULL,
	person_id bigserial NOT NULL,
	id_number varchar( 255 ) NULL,
	department_id bigserial NULL,
	dorm_id bigserial NULL,
	campus_id bigserial NULL,
	joined_date int4 NULL,
CONSTRAINT pk_students PRIMARY KEY ( id )
 );

ALTER TABLE "eStudent".students ADD CONSTRAINT ck_unque_person_in_students CHECK ( unique(person_id) );

CREATE INDEX idx_students ON "eStudent".students ( person_id );

COMMENT ON TABLE "eStudent".students IS 'A table for students.';

COMMENT ON COLUMN "eStudent".students.id IS 'Primary key and internal identifier';

COMMENT ON COLUMN "eStudent".students.id_number IS 'Id Number of a student';

COMMENT ON COLUMN "eStudent".students.department_id IS 'foreign key for department';

COMMENT ON COLUMN "eStudent".students.dorm_id IS 'foreign key for Dorm';

COMMENT ON COLUMN "eStudent".students.campus_id IS 'foreign key for campus';

COMMENT ON COLUMN "eStudent".students.joined_date IS 'The date that the student joined the university';

CREATE TABLE "eStudent".prerequisites ( 
	course_id int8 NOT NULL,
	prerequisite_id int8 NOT NULL,
CONSTRAINT idx_prerequisites_0 PRIMARY KEY ( course_id, prerequisite_id )
 );

ALTER TABLE "eStudent".prerequisites ADD CONSTRAINT ck_unique_course_set CHECK ( unique(course_id,prerequisite_id) );

CREATE INDEX idx_prerequisites ON "eStudent".prerequisites ( course_id );

CREATE INDEX idx_prerequisites ON "eStudent".prerequisites ( prerequisite_id );

COMMENT ON TABLE "eStudent".prerequisites IS 'Course prerequisites';

CREATE TABLE "eStudent".student_class_years ( 
	student_id int8 NOT NULL,
	academic_year int8 NOT NULL,
	class_year_id int8 NOT NULL
 );

CREATE INDEX idx_student_class_years ON "eStudent".student_class_years ( class_year_id );

CREATE INDEX idx_student_class_years_0 ON "eStudent".student_class_years ( student_id );

CREATE TABLE "eStudent".class_years ( 
	id bigserial NOT NULL,
	year_code varchar( 5 ) NOT NULL,
	title varchar( 50 ) NOT NULL,
CONSTRAINT pk_class_years PRIMARY KEY ( id )
 );

ALTER TABLE "eStudent".people ADD CONSTRAINT fk_people_countries FOREIGN KEY ( nationality ) REFERENCES "eStudent".countries( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".people ADD CONSTRAINT fk_people FOREIGN KEY ( id ) REFERENCES "eStudent".address( person_id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".students ADD CONSTRAINT fk_students_people FOREIGN KEY ( person_id ) REFERENCES "eStudent".people( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".prerequisites ADD CONSTRAINT fk_prerequisites_courses FOREIGN KEY ( course_id ) REFERENCES "eStudent".courses( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".prerequisites ADD CONSTRAINT fk_prerequisites_courses_prerequisite FOREIGN KEY ( prerequisite_id ) REFERENCES "eStudent".courses( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".student_class_years ADD CONSTRAINT fk_student_class_years_year FOREIGN KEY ( class_year_id ) REFERENCES "eStudent".class_years( id ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "eStudent".student_class_years ADD CONSTRAINT fk_student_class_years_student FOREIGN KEY ( student_id ) REFERENCES "eStudent".students( id ) ON DELETE CASCADE ON UPDATE CASCADE;

