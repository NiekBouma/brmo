/*
Views for visualizing the BAG data.
25-06-2015
*/
-- DROP VIEWS
-- DROP VIEW v_adres_totaal;
-- DROP VIEW v_adres_standplaats;
-- DROP VIEW v_adres_ligplaats;
-- DROP VIEW v_adres;
-- DROP VIEW v_ligplaats;
-- DROP VIEW v_standplaats;
-- DROP VIEW v_pand_gebruik_niet_ingemeten;
-- DROP VIEW v_pand_in_gebruik;
-- DROP VIEW v_verblijfsobject;
-- DROP VIEW v_verblijfsobject_gevormd;
-- DROP VIEW v_verblijfsobject_alles;

-------------------------------------------------
-- v_verblijfsobject_alles
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_verblijfsobject_alles
    (
        fid,
        pand_id,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        --gebruiksdoel,
        status,
        oppervlakte,
        the_geom
    ) AS
SELECT
    vbo.sc_identif              AS fid,
    fkpand.fk_nn_rh_pnd_identif AS pand_id,
    gem.naam                    AS gemeente,
    wp.naam                    	AS woonplaats,
    geor.naam_openb_rmte        AS straatnaam,
    addrobj.huinummer						AS huisnummer,
    addrobj.huisletter,
    addrobj.huinummertoevoeging AS huisnummer_toev,
    addrobj.postcode,
    --doel.gebruiksdoel_gebouwd_obj,
    vbo.status,
    gobj.oppervlakte_obj AS oppervlakte,
    gobj.puntgeom        AS the_geom
FROM
    verblijfsobj vbo
JOIN
    verblijfsobj_pand fkpand
ON
    (
        fkpand.fk_nn_lh_vbo_sc_identif = vbo.sc_identif )
JOIN
    gebouwd_obj gobj
ON
    (
        gobj.sc_identif = vbo.sc_identif )
JOIN
    verblijfsobj_nummeraand vna
ON
    (
        vna.fk_nn_lh_vbo_sc_identif = vbo.sc_identif )
JOIN
    nummeraand na
ON
    (
        na.sc_identif = vna.fk_nn_rh_nra_sc_identif )
JOIN
    addresseerb_obj_aand addrobj
ON
    (
        addrobj.identif = na.sc_identif )
JOIN
    gem_openb_rmte geor
ON
    (
        geor.identifcode = addrobj.fk_7opr_identifcode )
LEFT JOIN
    openb_rmte_wnplts orwp
ON
    (
        geor.identifcode = orwp.fk_nn_lh_opr_identifcode)
LEFT JOIN
    wnplts wp
ON
    (
        orwp.fk_nn_rh_wpl_identif = wp.identif)
LEFT JOIN
    gemeente gem
ON
    (
        wp.fk_7gem_code = gem.code )
    /*
    left join
    gebouwd_obj_gebruiksdoel doel
    on
    (
    doel.fk_gbo_sc_identif = gobj.sc_identif)
    */
WHERE
    addrobj.dat_eind_geldh IS NULL
AND geor.datum_einde_geldh IS NULL
AND gem.datum_einde_geldh IS NULL
AND gobj.datum_einde_geldh IS NULL;
-------------------------------------------------
-- v_verblijfsobject_gevormd
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_verblijfsobject_gevormd
    (
        fid,
        pand_id,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        --gebruiksdoel,
        status,
        oppervlakte,
        the_geom
    ) AS
SELECT
    fid,
    pand_id,
    gemeente,
    woonplaats,
    straatnaam,
    huisnummer,
    huisletter,
    huisnummer_toev,
    postcode,
    --gebruiksdoel,
    status,
    oppervlakte,
    the_geom
FROM
    v_verblijfsobject_alles
WHERE
    status = 'Verblijfsobject gevormd';
-------------------------------------------------
-- v_verblijfsobject
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_verblijfsobject
    (
        fid,
        pand_id,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        --gebruiksdoel,
        status,
        oppervlakte,
        the_geom
    ) AS
SELECT
    fid,
    pand_id,
    gemeente,
    woonplaats,
    straatnaam,
    huisnummer,
    huisletter,
    huisnummer_toev,
    postcode,
    --gebruiksdoel,
    status,
    oppervlakte,
    the_geom
FROM
    v_verblijfsobject_alles
WHERE
    status = 'Verblijfsobject in gebruik (niet ingemeten)'
OR  status = 'Verblijfsobject in gebruik';
-------------------------------------------------
-- v_pand_in_gebruik
-------------------------------------------------
CREATE VIEW
    v_pand_in_gebruik
    (
        fid,
        eind_datum_geldig,
        begin_datum_geldig,
        status,
        bouwjaar,
        the_geom
    ) AS
SELECT
    p.identif           AS fid,
    p.datum_einde_geldh AS eind_datum_geldig,
    p.dat_beg_geldh     AS begin_datum_geldig,
    p.status,
    p.oorspronkelijk_bouwjaar AS bouwjaar,
    p.geom_bovenaanzicht      AS the_geom
FROM
    pand p
WHERE
    status IN ('Sloopvergunning verleend',
               'Pand in gebruik (niet ingemeten)',
               'Pand in gebruik',
               'Bouw gestart')
AND datum_einde_geldh IS NULL;
-------------------------------------------------
-- v_pand_gebruik_niet_ingemeten
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_pand_gebruik_niet_ingemeten
    (
        fid,
        begin_datum_geldig,
        status,
        bouwjaar,
        the_geom
    ) AS
SELECT
    p.identif       AS fid,
    p.dat_beg_geldh AS begin_datum_geldig,
    p.status,
    p.oorspronkelijk_bouwjaar AS bouwjaar,
    p.geom_bovenaanzicht      AS the_geom
FROM
    pand p
WHERE
    status = 'Pand in gebruik (niet ingemeten)'
AND datum_einde_geldh IS NULL;
-------------------------------------------------
-- v_standplaats
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_standplaats
    (
        sc_identif,
        status,
        fk_4nra_sc_identif,
        datum_begin_geldh,
        geometrie
    ) AS
SELECT
    sp.sc_identif,
    sp.status,
    sp.fk_4nra_sc_identif,
    bt.dat_beg_geldh,
    bt.geom AS geometrie
FROM
    standplaats sp
LEFT JOIN
    benoemd_terrein bt
ON
    (
        sp.sc_identif = bt.sc_identif);
-------------------------------------------------
-- v_ligplaats
-------------------------------------------------
CREATE OR REPLACE VIEW
    v_ligplaats
    (
        sc_identif,
        status,
        fk_4nra_sc_identif,
        dat_beg_geldh,
        geometrie
    ) AS
SELECT
    lp.sc_identif,
    lp.status,
    lp.fk_4nra_sc_identif,
    bt.dat_beg_geldh,
    bt.geom AS geometrie
FROM
    ligplaats lp
LEFT JOIN
    benoemd_terrein bt
ON
    (
        lp.sc_identif = bt.sc_identif) ;
-------------------------------------------------
-- v_adres
-------------------------------------------------
/*
volledige adressenlijst
standplaats en ligplaats via benoemd_terrein, 
waarbij centroide van polygon wordt genomen
plus verblijfsobject via punt object van gebouwd_obj
*/
CREATE OR REPLACE VIEW
    v_adres
    (
        fid,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        status,
        oppervlakte,
        the_geom
    ) AS
SELECT
    vbo.sc_identif       AS fid,
    gem.naam             AS gemeente,
    wp.naam              AS woonplaats,
    geor.naam_openb_rmte AS straatnaam,
    addrobj.huinummer    AS huisnummer,
    addrobj.huisletter,
    addrobj.huinummertoevoeging AS huisnummer_toev,
    addrobj.postcode,
    vbo.status,
    gobj.oppervlakte_obj || ' m2' AS oppervlakte,
    gobj.puntgeom                 AS the_geom
FROM
    verblijfsobj vbo
JOIN
    gebouwd_obj gobj
ON
    (
        gobj.sc_identif = vbo.sc_identif )
LEFT JOIN
    verblijfsobj_nummeraand vna
ON
    (
        vna.fk_nn_lh_vbo_sc_identif = vbo.sc_identif )
LEFT JOIN
    nummeraand na
ON
    (
        na.sc_identif = vna.fk_nn_rh_nra_sc_identif )
LEFT JOIN
    addresseerb_obj_aand addrobj
ON
    (
        addrobj.identif = na.sc_identif )
JOIN
    gem_openb_rmte geor
ON
    (
        geor.identifcode = addrobj.fk_7opr_identifcode )
LEFT JOIN
    openb_rmte_wnplts orwp
ON
    (
        geor.identifcode = orwp.fk_nn_lh_opr_identifcode)
LEFT JOIN
    wnplts wp
ON
    (
        orwp.fk_nn_rh_wpl_identif = wp.identif)
LEFT JOIN
    gemeente gem
ON
    (
        wp.fk_7gem_code = gem.code )
WHERE
    na.status = 'Naamgeving uitgegeven'
AND (
        vbo.status = 'Verblijfsobject in gebruik (niet ingemeten)'
    OR  vbo.status = 'Verblijfsobject in gebruik');
-------------------------------------------------
-- v_adres_ligplaats
-------------------------------------------------
CREATE VIEW
    v_adres_ligplaats
    (
        fid,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        status,
        the_geom,
        centroide
    ) AS
SELECT
    lpa.sc_identif       AS fid,
    gem.naam             AS gemeente,
    wp.naam              AS woonplaats,
    geor.naam_openb_rmte AS straatnaam,
    addrobj.huinummer    AS huisnummer,
    addrobj.huisletter,
    addrobj.huinummertoevoeging AS huisnummer_toev,
    addrobj.postcode,
    lpa.status,
    benter.geom AS the_geom,
    st_centroid(benter.geom)
FROM
    ligplaats lpa
JOIN
    benoemd_terrein benter
ON
    (
        benter.sc_identif = lpa.sc_identif )
LEFT JOIN
    ligplaats_nummeraand lna
ON
    (
        lna.fk_nn_lh_lpl_sc_identif = lpa.sc_identif )
LEFT JOIN
    nummeraand na
ON
    (
        na.sc_identif = lna.fk_nn_rh_nra_sc_identif )
LEFT JOIN
    addresseerb_obj_aand addrobj
ON
    (
        addrobj.identif = na.sc_identif )
JOIN
    gem_openb_rmte geor
ON
    (
        geor.identifcode = addrobj.fk_7opr_identifcode )
LEFT JOIN
    openb_rmte_wnplts orwp
ON
    (
        geor.identifcode = orwp.fk_nn_lh_opr_identifcode)
LEFT JOIN
    wnplts wp
ON
    (
        orwp.fk_nn_rh_wpl_identif = wp.identif)
LEFT JOIN
    gemeente gem
ON
    (
        wp.fk_7gem_code = gem.code )
WHERE
    na.status = 'Naamgeving uitgegeven'
AND lpa.status = 'Plaats aangewezen';
-------------------------------------------------
-- v_adres_standplaats
-------------------------------------------------
CREATE VIEW
    v_adres_standplaats
    (
        fid,
        gemeente,
        woonplaats,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        status,
        the_geom,
        centroide
    ) AS
SELECT
    spl.sc_identif       AS fid,
    gem.naam             AS gemeente,
    wp.naam              AS woonplaats,
    geor.naam_openb_rmte AS straatnaam,
    addrobj.huinummer    AS huisnummer,
    addrobj.huisletter,
    addrobj.huinummertoevoeging AS huisnummer_toev,
    addrobj.postcode,
    spl.status,
    benter.geom AS the_geom,
    st_centroid(benter.geom)
FROM
    standplaats spl
JOIN
    benoemd_terrein benter
ON
    (
        benter.sc_identif = spl.sc_identif )
LEFT JOIN
    standplaats_nummeraand sna
ON
    (
        sna.fk_nn_lh_spl_sc_identif = spl.sc_identif )
LEFT JOIN
    nummeraand na
ON
    (
        na.sc_identif = sna.fk_nn_rh_nra_sc_identif )
LEFT JOIN
    addresseerb_obj_aand addrobj
ON
    (
        addrobj.identif = na.sc_identif )
JOIN
    gem_openb_rmte geor
ON
    (
        geor.identifcode = addrobj.fk_7opr_identifcode )
LEFT JOIN
    openb_rmte_wnplts orwp
ON
    (
        geor.identifcode = orwp.fk_nn_lh_opr_identifcode)
LEFT JOIN
    wnplts wp
ON
    (
        orwp.fk_nn_rh_wpl_identif = wp.identif)
LEFT JOIN
    gemeente gem
ON
    (
        wp.fk_7gem_code = gem.code )
WHERE
    na.status = 'Naamgeving uitgegeven'
AND spl.status = 'Plaats aangewezen';
-------------------------------------------------
-- v_adres_totaal
-------------------------------------------------
CREATE VIEW
    v_adres_totaal
    (
        fid,
        straatnaam,
        huisnummer,
        huisletter,
        huisnummer_toev,
        postcode,
        gemeente,
        woonplaats,
        the_geom
    ) AS
    (
        SELECT
            fid ,
            straatnaam,
            huisnummer,
            huisletter,
            huisnummer_toev,
            postcode,
            gemeente,
        		woonplaats,
            the_geom
        FROM
            v_adres
        UNION ALL
        SELECT
            fid ,
            straatnaam,
            huisnummer,
            huisletter,
            huisnummer_toev,
            postcode,
            gemeente,
        		woonplaats,
            centroide AS the_geom
        FROM
            v_adres_ligplaats
        UNION ALL
        SELECT
            fid ,
            straatnaam,
            huisnummer,
            huisletter,
            huisnummer_toev,
            postcode,
            gemeente,
        		woonplaats,
            centroide AS the_geom
        FROM
            v_adres_standplaats
    );