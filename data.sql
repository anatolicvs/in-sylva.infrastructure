\connect insylva
CREATE TABLE IF NOT EXISTS users (
    id serial UNIQUE PRIMARY KEY,
    kc_id varchar(100) UNIQUE NOT NULL,
    username varchar(50) NOT NULL,
    name varchar(50) ,
    surname varchar(50),
    email varchar(50) UNIQUE NOT NULL,
    password varchar(50) NOT NULL,
    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE TABLE IF NOT EXISTS sources (
    id serial PRIMARY KEY,
    index_id varchar(50),
    mng_id varchar(50) NOT NULL,
    name varchar(50) NOT NULL ,
    description text,
    
    is_send boolean  default false,
    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS provider_sources (
    id serial PRIMARY KEY,
    user_id integer NOT NULL,
    source_id integer,

    CONSTRAINT provider_sources_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES sources(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT provider_sources_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS std_fields(
    id serial UNIQUE NOT NULL,
    std_field_id integer,

    category varchar(100),
    field_name varchar(250),
    definition_and_comment varchar(250),
    obligation_or_condition varchar(250),
    cardinality varchar(200),
    field_type varchar(100),
    values text,

    isPublic BOOLEAN,
    isOptional BOOLEAN,
    PRIMARY KEY (id),

    CONSTRAINT std_fields_id_fkkey FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS std_fields_values(
    id serial UNIQUE NOT NULL,
    std_field_id int NOT NULL,
    values varchar(150),

    CONSTRAINT std_fields_values_fkkey FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS addtl_fields(
    id serial UNIQUE NOT NULL ,
    addtl_field_id integer,

    category varchar(100),
    field_name varchar(250),
    definition_and_comment varchar(250),
    obligation_or_condition varchar(250),
    field_type varchar(100),
    values text,
    cardinality varchar(200),
    isPublic BOOLEAN,
    isOptional BOOLEAN,
    PRIMARY KEY (id),

    CONSTRAINT addtl_fields_id_fkkey FOREIGN KEY (addtl_field_id)
        REFERENCES addtl_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS addtl_fields_sources(
    id serial PRIMARY KEY ,
    addtl_field_id integer,
    source_id integer,

    CONSTRAINT addtl_fields_sources_addtl_field_id_fkey FOREIGN KEY (addtl_field_id)
        REFERENCES addtl_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT addtl_fields_sources_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES sources(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);


CREATE table IF NOT EXISTS roles(
    id serial primary key,
    name varchar(50),
    description text,
    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table  IF NOT EXISTS realm(
      id serial primary key,
      name varchar(50),
      create_at timestamp NOT NULL DEFAULT NOW(),
      update_at timestamp
);

CREATE table  IF NOT EXISTS realm_user(
    id serial primary key,
    realm_id INTEGER NOT NULL,
    kc_id varchar(100) NOT NULL,

    CONSTRAINT realm_user_realm_id_fkey FOREIGN KEY (realm_id)
        REFERENCES  realm(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT realm_user_kc_id_fkey FOREIGN KEY  (kc_id)
        REFERENCES  users(kc_id) MATCH SIMPLE
        ON UPDATE NO ACTION  ON DELETE  NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS roles_std_fields(
    id serial primary key,
    role_id INTEGER  NOT NULL,
    std_field_id INTEGER  NOT NULL,

    CONSTRAINT  roles_fields_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES roles(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT  roles_fields_field_id_fkey FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS roles_addtl_fields(
    id serial primary key,
    role_id INTEGER  NOT NULL,
    addtl_field_id INTEGER  NOT NULL,

    CONSTRAINT  roles_fields_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES roles(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT  roles_fields_field_id_fkey FOREIGN KEY (addtl_field_id)
        REFERENCES addtl_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);


CREATE table IF NOT EXISTS roles_users (
    id serial primary key,
    role_id INTEGER NOT NULL,
    kc_id varchar(100) NOT NULL,

    CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES  roles(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,


    CONSTRAINT roles_users_kc_id_fkey FOREIGN KEY  (kc_id)
        REFERENCES  users(kc_id) MATCH SIMPLE
        ON UPDATE NO ACTION  ON DELETE  NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table  IF NOT EXISTS user_search_his(
    id serial not null,
    user_id int not null references users(id),

    PRIMARY KEY (id, user_id),

    query text,
    name varchar(50),
    description text,
    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

create unique index sources_name_uindex
    on sources (name);

CREATE TABLE IF NOT EXISTS user_profile (
    id serial PRIMARY KEY, 
    profil_name varchar(100), 
    kc_id varchar(100),

    CONSTRAINT user_profile_kc_id FOREIGN KEY (kc_id)
        REFERENCES users(kc_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
); 

CREATE TABLE IF NOT EXISTS field_specifications (
    id serial PRIMARY KEY,
    std_field_id int,
    addtl_field_id int,
    kc_id varchar(100),

    CONSTRAINT field_specifications_std_field_id FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT field_specifications_addtl_field_id FOREIGN KEY (addtl_field_id)
        REFERENCES addtl_fields(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT field_specifications_kc_id FOREIGN KEY (kc_id)
        REFERENCES users(kc_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE TABLE IF NOT EXISTS profile_specifications(
    profil_id int, 
    field_specification_id int, 

    CONSTRAINT profile_specifications_profil_id FOREIGN KEY (profil_id)
        REFERENCES user_profile(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT field_specifications_field_specification_id FOREIGN KEY (field_specification_id)
        REFERENCES field_specifications(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
); 


/*
CREATE OR REPLACE FUNCTION func_role_updater() RETURNS TRIGGER AS $BODY$
    BEGIN
        UPDATE roles SET update_at = current_timestamp WHERE id = OLD.id;
        RETURN NEW;
    END;
$BODY$
LANGUAGE 'plpgsql' NOT LEAKPROOF-- Says the function is implemented in the plpgsql language; VOLATILE says the function has side effects.
COST 1000; -- Estimated execution cost of the function.


CREATE TRIGGER tr_role_updater AFTER UPDATE ON roles
     FOR EACH ROW
  EXECUTE PROCEDURE func_role_updater();

DROP TRIGGER IF EXISTS tr_role_updater ON roles;




CREATE OR REPLACE FUNCTION func_resource_updater() RETURNS TRIGGER AS $BODY$
    BEGIN
        UPDATE sources SET update_at = current_timestamp WHERE id = NEW.id;
        RETURN  NEW;
    END;
$BODY$
LANGUAGE plpgsql VOLATILE -- Says the function is implemented in the plpgsql language; VOLATILE says the function has side effects.
COST 100; -- Estimated execution cost of the function.

CREATE TRIGGER tr_resource_updater AFTER UPDATE ON sources
     FOR EACH ROW
  EXECUTE PROCEDURE func_resource_updater();


CREATE OR REPLACE FUNCTION func_user_updater() RETURNS TRIGGER AS $BODY$
    BEGIN
        UPDATE users SET update_at = current_timestamp WHERE id = NEW.id;
        RETURN  NEW;
    END;
$BODY$
LANGUAGE plpgsql VOLATILE -- Says the function is implemented in the plpgsql language; VOLATILE says the function has side effects.
COST 100; -- Estimated execution cost of the function.

CREATE TRIGGER tr_user_updater AFTER UPDATE ON users
     FOR EACH ROW
  EXECUTE PROCEDURE func_user_updater();
*/























