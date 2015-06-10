create table pm_adr_object_nummeraand as select * from pv_adr_object_nummeraand ;

/*******************************
OPMERKING 30-04-2015: UNIQUE VAN DE INDEX TIJDELIJK VERWIJDERD I.V.M. DUBBELE RECORDS IN TABEL WNPLTS
*******************************/

create index ui_aon on pm_adr_object_nummeraand(identif);
create table pm_ander_natuurlijk_persoon as select * from pv_ander_natuurlijk_persoon ;
create unique index ui_anp on pm_ander_natuurlijk_persoon(sc_identif);
create table pm_appartementsrecht as select * from pv_appartementsrecht ;
create unique index ui_apr on pm_appartementsrecht(sc_kad_identif);
create table pm_benoemd_obj_kad_onr_zk as select * from pv_benoemd_obj_kad_onr_zk ;
create unique index ui_bok on pm_benoemd_obj_kad_onr_zk(fk_nn_lh_tgo_identif, fk_nn_rh_koz_kad_identif);
create table pm_benoemd_object as select * from pv_benoemd_object ;
create unique index ui_bob on pm_benoemd_object(identif);
create table pm_benoemd_terrein as select * from pv_benoemd_terrein ;
create unique index ui_bte on pm_benoemd_terrein(sc_identif);
create table pm_gebouwd_obj_gebruiksdoel as select * from pv_gebouwd_obj_gebruiksdoel ;
create unique index ui_gog on pm_gebouwd_obj_gebruiksdoel(gebruiksdoel_gebouwd_obj, fk_gbo_sc_identif);
create table pm_gebouwd_object as select * from pv_gebouwd_object ;
create unique index ui_gob on pm_gebouwd_object(sc_identif);
create table pm_gemeente as select * from pv_gemeente ;
create unique index ui_gem on pm_gemeente(code);
--create table pm_i_map_kpe as select * from pv_i_map_kpe;
--create unique index ui_imkp on pm_i_map_kpe(sc_kad_identif);
create table pm_ingeschr_natuurlijk_persoon as select * from pv_ingeschr_natuurlijk_persoon;
create unique index ui_inp on pm_ingeschr_natuurlijk_persoon(sc_identif);
create table pm_niet_ingezetene as select * from pv_niet_ingezetene;
create unique index ui_nig on pm_niet_ingezetene(sc_identif);
create table pm_kad_onr_zk_aantek as select * from pv_kad_onr_zk_aantek ;
create unique index ui_koa on pm_kad_onr_zk_aantek(kadaster_identif_aantek);
create table pm_kad_onr_zk_his_rel as select * from pv_kad_onr_zk_his_rel ;
create unique index ui_koh on pm_kad_onr_zk_his_rel(fk_sc_lh_koz_kad_identif, fk_sc_rh_koz_kad_identif);
create table pm_kad_onroerende_zaak as select * from pv_kad_onroerende_zaak ;
create unique index ui_koz on pm_kad_onroerende_zaak(kad_identif);
create table pm_kad_perceel as select * from pv_kad_perceel ;
create unique index ui_kpe on pm_kad_perceel(sc_kad_identif);
create table pm_ligplaats as select * from pv_ligplaats ;
create unique index ui_lip on pm_ligplaats(sc_identif);
create table pm_ligplaats_nummeraand as select * from pv_ligplaats_nummeraand ;
create unique index ui_lin on pm_ligplaats_nummeraand(fk_nn_lh_lpl_sc_identif, fk_nn_rh_nra_sc_identif);
create table pm_natuurlijk_persoon as select * from pv_natuurlijk_persoon ;
create unique index ui_npe on pm_natuurlijk_persoon(sc_identif);
create table pm_niet_natuurlijk_persoon as select * from pv_niet_natuurlijk_persoon ;
create unique index ui_nnp on pm_niet_natuurlijk_persoon(sc_identif);
--create table pm_o_map_kpe as select * from pv_o_map_kpe;
--create unique index ui_omkp on pm_o_map_kpe(sc_kad_identif);
create table pm_pand as select * from pv_pand ;
create unique index ui_pnd on pm_pand(identif);
create table pm_persoon as select * from pv_persoon ;
create unique index ui_pso on pm_persoon(sc_identif);
create table pm_standplaats as select * from pv_standplaats ;
create unique index ui_atp on pm_standplaats(sc_identif);
create table pm_standplaats_nummeraand as select * from pv_standplaats_nummeraand ;
create unique index ui_stn on pm_standplaats_nummeraand(fk_nn_lh_spl_sc_identif, fk_nn_rh_nra_sc_identif);
create table pm_verblijfsobj_nummeraand as select * from pv_verblijfsobj_nummeraand ;
create unique index ui_von on pm_verblijfsobj_nummeraand(fk_nn_lh_vbo_sc_identif, fk_nn_rh_nra_sc_identif);
create table pm_verblijfsobj_pand as select * from pv_verblijfsobj_pand ;
create unique index ui_vop on pm_verblijfsobj_pand(fk_nn_lh_vbo_sc_identif, fk_nn_rh_pnd_identif);
create table pm_verblijfsobject as select * from pv_verblijfsobject ;
create unique index ui_vob on pm_verblijfsobject(sc_identif);
create table pm_woonplaats as select * from pv_woonplaats ;
create unique index ui_wpl on pm_woonplaats(identif);
create table pm_zakelijk_recht as select * from pv_zakelijk_recht ;
create unique index ui_zre on pm_zakelijk_recht(kadaster_identif);
create table pm_zakelijk_recht_aantekening as select * from pv_zakelijk_recht_aantekening ;
create unique index ui_zra on pm_zakelijk_recht_aantekening(kadaster_identif_aantek_recht);


comment on table pm_adr_object_nummeraand is 'uses pv_adr_object_nummeraand';
comment on table pm_ander_natuurlijk_persoon is 'uses pv_ander_natuurlijk_persoon';
comment on table pm_appartementsrecht is 'uses pv_appartementsrecht';
comment on table pm_benoemd_obj_kad_onr_zk is 'uses pv_benoemd_obj_kad_onr_zk';
comment on table pm_benoemd_object is 'uses pv_benoemd_object';
comment on table pm_benoemd_terrein is 'uses pv_benoemd_terrein';
comment on table pm_gebouwd_obj_gebruiksdoel is 'uses pv_gebouwd_obj_gebruiksdoel';
comment on table pm_gebouwd_object is 'uses pv_gebouwd_object';
comment on table pm_gemeente is 'uses pv_gemeente';
comment on table pm_ingeschr_natuurlijk_persoon is 'uses pv_ingeschr_natuurlijk_persoon';
comment on table pm_kad_onr_zk_aantek is 'uses pv_kad_onr_zk_aantek';
comment on table pm_kad_onr_zk_his_rel is 'uses pv_kad_onr_zk_his_rel';
comment on table pm_kad_onroerende_zaak is 'uses pv_kad_onroerende_zaak';
comment on table pm_kad_perceel is 'uses pv_kad_perceel';
comment on table pm_ligplaats is 'uses pv_ligplaats';
comment on table pm_ligplaats_nummeraand is 'uses pv_ligplaats_nummeraand';
comment on table pm_natuurlijk_persoon is 'uses pv_natuurlijk_persoon';
comment on table pm_niet_ingezetene is 'uses pv_niet_ingezetene';
comment on table pm_niet_natuurlijk_persoon is 'uses pv_niet_natuurlijk_persoon';
comment on table pm_pand is 'uses pv_pand';
comment on table pm_persoon is 'uses pv_persoon';
comment on table pm_standplaats is 'uses pv_standplaats';
comment on table pm_standplaats_nummeraand is 'uses pv_standplaats_nummeraand';
comment on table pm_verblijfsobj_nummeraand is 'uses pv_verblijfsobj_nummeraand';
comment on table pm_verblijfsobj_pand is 'uses pv_verblijfsobj_pand';
comment on table pm_verblijfsobject is 'uses pv_verblijfsobject';
comment on table pm_woonplaats is 'uses pv_woonplaats';
comment on table pm_zakelijk_recht is 'uses pv_zakelijk_recht';
comment on table pm_zakelijk_recht_aantekening is 'uses pv_zakelijk_recht_aantekening';


--vacuum analyze uitvoeren als superuser;