
alter table sbi_activiteit alter column omschr varchar(255);

create table vestg_activiteit(
    fk_vestg_nummer varchar(32) references vestg(sc_identif),
    fk_sbi_activiteit_code varchar(6) references sbi_activiteit(sbi_code),
    indicatie_hoofdactiviteit decimal(1,0),
    primary key(fk_vestg_nummer, fk_sbi_activiteit_code)
);

ALTER TABLE vestg_naam
  ALTER COLUMN naam varchar(500) NOT NULL;
ALTER TABLE vestg_naam
  ALTER COLUMN fk_ves_sc_identif varchar(32) NOT NULL;
ALTER TABLE vestg_naam
  ADD PRIMARY KEY (naam, fk_ves_sc_identif);
