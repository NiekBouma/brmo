--
-- Vul de meta tabel GEOMETRY_COLUMNS ten behoeve van Geoserver/Geotools
-- 
-- NB let op de schema naam 'RSGBTEST' in dit bestand; die dient vervangen te worden
-- NB de lijst views is mogelijk niet compleet, afhankelijk van installatie
--


-- V_KAD_PERCEEL_EIGENAAR
INSERT INTO GEOMETRY_COLUMNS (F_TABLE_SCHEMA, F_TABLE_NAME, F_GEOMETRY_COLUMN, COORD_DIMENSION, SRID, TYPE) 
    VALUES ('FLV_RSGB', 'V_KAD_PERCEEL_EIGENAAR', 'BEGRENZING_PERCEEL', 2, 28992, 'MULTIPOLYGON');
-- V_KAD_EIGENARENKAART
INSERT INTO GEOMETRY_COLUMNS (F_TABLE_SCHEMA, F_TABLE_NAME, F_GEOMETRY_COLUMN, COORD_DIMENSION, SRID, TYPE) 
    VALUES ('FLV_RSGB', 'V_KAD_EIGENARENKAART', 'BEGRENZING_PERCEEL', 2, 28992, 'MULTIPOLYGON');
