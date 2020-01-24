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
    index_id varchar(50) NOT NULL,
    mng_id varchar(50) NOT NULL,
    name varchar(50) NOT NULL ,
    description text,
    is_send boolean  default false,
    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS provider_sources (
    id serial PRIMARY KEY ,
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

CREATE table IF NOT EXISTS std_fields (
    id serial UNIQUE NOT NULL ,
    std_field_id integer,
    name varchar(50) NOT NULL ,
    field_type varchar(20) NOT NULL,
    isPublic BOOLEAN,
    isOptional BOOLEAN, 
    PRIMARY KEY (id), 

    CONSTRAINT std_fields_id_fkkey FOREIGN KEY (std_field_id) 
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
        

    create_at timestamp NOT NULL DEFAULT NOW(),
    update_at timestamp
);

CREATE table IF NOT EXISTS addtl_fields (
    id serial UNIQUE NOT NULL ,
    addtl_field_id integer,
    name varchar(50) NOT NULL ,
    field_type varchar(20) NOT NULL,
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























