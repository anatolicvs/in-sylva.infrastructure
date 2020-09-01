\connect insylva
CREATE EXTENSION postgis;

CREATE TABLE IF NOT EXISTS users (
    id serial UNIQUE PRIMARY KEY,
    kc_id varchar(100) UNIQUE,
    username varchar(50) NOT NULL,
    name varchar(50) ,
    surname varchar(50),
    email varchar(50) UNIQUE NOT NULL,
    password varchar(50) NOT NULL,
    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE TABLE IF NOT EXISTS sources (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL ,
    description text,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE TABLE IF NOT EXISTS sources_indices(
   id serial PRIMARY KEY, 
   source_id integer,

   index_id varchar(50),
   mng_id varchar(50) NOT NULL,
   is_send boolean  default false, 

   CONSTRAINT sources_indices_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES sources(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION, 
   
   createdAt timestamp NOT NULL DEFAULT NOW(),
   updatedAt timestamp
);

CREATE TABLE IF NOT EXISTS policies (
    id serial PRIMARY KEY, 
    name varchar(50) NOT NULL,
    source_id integer, 
    user_id integer, 
    
    CONSTRAINT policy_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT policy_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES sources(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    is_default boolean default false,
    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE TABLE IF NOT EXISTS policy_fields(
    id serial PRIMARY KEY, 
    policy_id integer,
    std_field_id integer, 

    CONSTRAINT policy_field_policy_id_fkey FOREIGN KEY (policy_id)
        REFERENCES policies(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT std_fields_id_fkkey FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);


CREATE TABLE IF NOT EXISTS groups (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    user_id integer, 
    
    CONSTRAINT groups_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
); 

CREATE TABLE IF NOT EXISTS groups_policies (
    id serial PRIMARY KEY,
    group_id  integer,
    policy_id integer,

    CONSTRAINT group_policy_policy_id_fkey FOREIGN KEY (policy_id)
        REFERENCES policies(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT group_policy_group_id_fkey FOREIGN KEY (group_id)
        REFERENCES groups(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
); 

CREATE TABLE IF NOT EXISTS group_users (
    id serial PRIMARY KEY,
    group_id  integer,
    user_id integer, 

    CONSTRAINT group_user_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

     CONSTRAINT group_user_group_id_fkey FOREIGN KEY (group_id)
        REFERENCES groups(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
); 
/* CREATE TABLE IF NOT EXISTS policy_user(
    id serial PRIMARY KEY,
    policy_id integer,
    user_id integer,

    CONSTRAINT policy_user_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT policy_user_policy_id_fkey FOREIGN KEY (policy_id)
        REFERENCES policies(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
); */

CREATE TABLE IF NOT EXISTS source_sharing(
    id serial PRIMARY KEY,
    source_id integer,
    user_id integer,

    CONSTRAINT source_sharing_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES users(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT source_sharing_source_id_fkey FOREIGN KEY (source_id)
        REFERENCES sources(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

        createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE table IF NOT EXISTS std_fields_values(
    id serial UNIQUE NOT NULL,
    std_field_id int NOT NULL,
    values varchar(150),

    CONSTRAINT std_fields_values_fkkey FOREIGN KEY (std_field_id)
        REFERENCES std_fields(id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);


CREATE table IF NOT EXISTS roles(
    id serial primary key,
    name varchar(50),
    description text,
    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

/* Insert default roles */ 
INSERT INTO roles (name,description) values ('super-admin','All/*');
INSERT INTO roles (name,description) values ('source-manager','Source/*');
INSERT INTO roles (name,description) values ('normal-user','Search/*');

CREATE table  IF NOT EXISTS realm(
      id serial primary key,
      name varchar(50),
      createdAt timestamp NOT NULL DEFAULT NOW(),
      updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE table  IF NOT EXISTS user_search_his(
    id serial primary key,
    kc_id varchar(100) NOT NULL,

    query text,
    name varchar(50),
    ui_structure text,
    description text,
   
    CONSTRAINT roles_users_kc_id_fkey FOREIGN KEY  (kc_id)
        REFERENCES  users(kc_id) MATCH SIMPLE
        ON UPDATE NO ACTION  ON DELETE  NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

create unique index sources_name_uindex
    on sources (name);

CREATE TABLE IF NOT EXISTS user_profile (
    id serial PRIMARY KEY, 
    profil_name varchar(100), 
    kc_id varchar(100),

    CONSTRAINT user_profile_kc_id FOREIGN KEY (kc_id)
        REFERENCES users(kc_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
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

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

CREATE TABLE IF NOT EXISTS profile_specifications(
    profil_id int, 
    field_specification_id int, 

    CONSTRAINT profile_specifications_profil_id FOREIGN KEY (profil_id)
        REFERENCES user_profile(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT field_specifications_field_specification_id FOREIGN KEY (field_specification_id)
        REFERENCES field_specifications(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

    createdAt timestamp NOT NULL DEFAULT NOW(),
    updatedAt timestamp
);

drop table if exists unblurred_sites cascade;
CREATE TABLE IF NOT EXISTS unblurred_sites
(
    id SERIAL PRIMARY KEY,
    userid integer ,
    sourceid integer ,
    siteid integer,
    x real NOT NULL,
    y real NOT NULL,
    geom geometry,
    blurring_rule character(30) COLLATE pg_catalog."default" NOT NULL,
    new_point boolean
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

COMMENT ON TABLE unblurred_sites
    IS 'Spatial table containing unblurred coordinates; userid, sourceid, siteid are not mandatory...';


DROP FUNCTION add_geom_from_x_y();
CREATE FUNCTION add_geom_from_x_y()
  RETURNS BOOLEAN
  LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE unblurred_sites SET
      new_point=false,
      geom = ST_SetSRID(ST_MakePoint(x,y), 4326)
    WHERE new_point=true;

  RETURN true;
END;
$$

--Third part: function generate_blurred_sites
-- This function computes the blurred points
-- It returns the number of lost points: meaning that the function has not been able to random geographic point because of overlapping by other points.
-- TODO: do not compute if the blurred point is already calculted and is not overlapped by any other new donut
-- TODO: output an array of ids of points that have not been blurred (and disappear) because of overlapping
-- TODO: join attributes (siteid,sourceid,userid)  from unblurred_sites table in blurred_sites table

CREATE OR REPLACE FUNCTION generate_blurred_sites(OUT nb_perdus integer)
  LANGUAGE PLPGSQL
AS $$
BEGIN
DROP TABLE IF EXISTS donut CASCADE;
--Step 1: create donuts
create TABLE donut as
select id, ST_BuildArea(ST_Collect(smallc,bigc))::geometry(Polygon,4326) as geom
FROM (SELECT
        id, ST_Buffer(geom, split_part(blurring_rule,';',1)::float, 'quad_segs=8') as smallc,
          ST_Buffer(geom, split_part(blurring_rule,';',2)::float, 'quad_segs=8') as bigc
                  from unblurred_sites
        ) as s;

-- Step 2: create view with only allowed zones for random query
-- Step 2.1: create a view with only small discs (interior circle)
-- Output: disque_interieur
------------------------------------------------------------------
DROP TABLE IF EXISTS disque_interieur CASCADE;
create TABLE disque_interieur as
select id, ST_Buffer(geom, split_part(blurring_rule,';',1)::float, 'quad_segs=8')::geometry(Polygon,4326) as geom
from unblurred_sites;

DROP TABLE IF EXISTS zones_interdites;
create TABLE zones_interdites as
select ST_Union(ST_Buffer(geom, split_part(blurring_rule,';',1)::float, 'quad_segs=8')::geometry(Polygon,4326)) as geom
from unblurred_sites;

-- Step 2.3: create final view by excluding overlapping all parts that are inside the small discs computed at step 2.1
-- Output: allowed_zones
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS allowed_zones CASCADE;
create TABLE allowed_zones as
select id, ST_Multi(ST_Difference(donut.geom,cuter.st_union))::geometry geom from
             donut,
             (select ST_Union(ARRAY(select geom from disque_interieur) ) )as cuter;

-- Step 3: compute random selection that will generate a layer with one point for each coordinate. The point will be inside allowed zones
-- Output: blurred_sites
------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS blurred_sites CASCADE;
CREATE TABLE blurred_sites AS
select id, ST_GeneratePoints(geom,1)::geometry(MultiPoint,4326) as geom from (
select  donut.id,
    ST_Multi(
        ST_Buffer(
            ST_Intersection(donut.geom, allowed_zones.geom),
            0.0
        )
    ) geom
from allowed_zones
     inner join donut on ST_Intersects(allowed_zones.geom, donut.geom)
where not ST_IsEmpty(ST_Buffer(ST_Intersection(allowed_zones.geom, donut.geom), 0.0)) AND
	allowed_zones.id = donut.id
) as donuts_allowed;
-- Step2.2: determine if donuts are fully overlapped by zones_interdites
select into nb_perdus count(id) from zones_interdites as A, donut as B
where ST_Contains(A.geom, B.geom);
END
$$

\connect keycloak

update REALM set ssl_required = 'NONE' where id = 'master';


/*
    DROP SCHEMA public CASCADE;
    CREATE SCHEMA public;
*/
/*
CREATE OR REPLACE FUNCTION func_role_updater() RETURNS TRIGGER AS $BODY$
    BEGIN
        UPDATE roles SET updatedAt = current_timestamp WHERE id = OLD.id;
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
        UPDATE sources SET updatedAt = current_timestamp WHERE id = NEW.id;
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
        UPDATE users SET updatedAt = current_timestamp WHERE id = NEW.id;
        RETURN  NEW;
    END;
$BODY$
LANGUAGE plpgsql VOLATILE -- Says the function is implemented in the plpgsql language; VOLATILE says the function has side effects.
COST 100; -- Estimated execution cost of the function.

CREATE TRIGGER tr_user_updater AFTER UPDATE ON users
     FOR EACH ROW
  EXECUTE PROCEDURE func_user_updater();
*/