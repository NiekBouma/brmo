brmo datamodel
==============

Via onderstaande commando's kan het rsgb datamodel script voor oracle en postgresql worden gegenereerd op basis van het RSGB 2.2 UML. Alle aanvullende scripts in de map extra_scripts worden in het totaal script opgenomen. Indien een update gedaan moet worden op een oudere versie van de database, dan kunnen de scripts uit deze map natuurlijk wel zelfstandig gebruikt worden.

Voor het genereren van het totaal script volg je volgende stappen:

```
java -jar lib/saxon9he.jar -s:rsgb22.xml -xsl:rsgbsst2.xsl -o:generated_scripts/rsgb_converted.xml

java -jar lib/saxon9he.jar -s:generated_scripts/rsgb_converted.xml -xsl:rsgbrepair.xsl -o:generated_scripts/rsgb_converted_repaired.xml

java -jar lib/saxon9he.jar -s:generated_scripts/rsgb_converted_repaired.xml -xsl:rsgb_db_identifiers.xsl -o:generated_scripts/rsgb_db_identifiers.xml

java -jar lib/saxon9he.jar -s:generated_scripts/rsgb_converted_repaired.xml -xsl:datamodel.xsl -o:generated_scripts/datamodel.xml

java -jar lib/saxon9he.jar -s:generated_scripts/datamodel.xml -xsl:datamodel_postgres.xsl -o:generated_scripts/datamodel_postgresql.sql

java -jar lib/saxon9he.jar -s:generated_scripts/datamodel.xml -xsl:datamodel_oracle.xsl -o:generated_scripts/datamodel_oracle.sql

java -jar lib/saxon9he.jar -s:generated_scripts/datamodel.xml -xsl:datamodel_sqlserver.xsl -o:generated_scripts/datamodel_sqlserver.sql
```

De scripts in de map utility_scripts worden niet opgenomen in het totaal script. Deze zijn vaak klantspecifiek en dienen naar behoefte handmatig gedraaid te worden.
