-- QUERY 1: CREAZIONE TABELLA LOOKUP SC_SN e ID_ACCOUNT

declare datetime_start datetime default DATETIME_TRUNC(DATETIME_SUB(CURRENT_DATETIME(), interval 365 DAY), DAY);

create or replace table`skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.LOOKUP_id_contract_sc_sn` as

with a as(SELECT *, 
             LEAD(DATE_START,1) OVER (PARTITION BY enablement_number_q ORDER BY DATE_START) AS NEXT_DATE_START,
             LAG(DATE_START,1) OVER (PARTITION BY enablement_number_q ORDER BY DATE_START) AS PREV_DATE_START             
        FROM (SELECT enablement_number_q, id_account, min(DATE(partition_date)) AS DATE_START 
                FROM `skyita-da-daita-prod.asset_management.asset_smartcard_transcoding` 
                WHERE enablement_number_q<>""
                GROUP BY enablement_number_q, id_account)),
b as ( SELECT UPPER(enablement_number_q) AS SC_SN,
       IF(PREV_DATE_START IS NULL,"2001-01-01",DATE_START) AS DATE_START,
       COALESCE(DATE_SUB(NEXT_DATE_START, INTERVAL 1 DAY), "2099-12-31") AS DATE_END,
       id_account
FROM a ),
c as (SELECT id_account AS ID_CONTRACT, A.*
FROM `skyita-da-composer-prod.ethan_elementary_data.Elementary_DataSet` AS A
LEFT JOIN b
ON A.SC_SN=B.SC_SN AND PLAYBACK_DATE BETWEEN DATE_START AND DATE_END
WHERE PLAYBACK_DATE  >=  datetime_start)
select distinct ID_CONTRACT ,SC_SN 
from c;


      
-- QUERY 2: ESTRAZIONE DATI DI VISIONE 

declare datetime_start datetime default DATETIME_TRUNC(DATETIME_SUB(CURRENT_DATETIME(), interval 365 DAY), DAY);

create or replace table  `skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.Elementary_DataSet_EXPORT` AS

      -- ESTRAZIONE DEI DATI DI VISIONE E FASCE ORARIE
      
SELECT 
        SC_SN,
        duration_sec,
        playback_start2,
        playback_end2,
        des_live_ts,
        event_type,
        orig_net_id,
        tp_stream_id,
        SI_SERV_ID,
        VOD_ID,
        X_SPEED,
                      
    CASE
        -- FASCE ORARIE STANDARD
              when start_hour >= 23 and end_hour < 2 then "Seconda_Serata"  -- fascia 23-02
              when start_hour >= 0 and end_hour < 2 then "Seconda_Serata"   -- fascia 23-02
              when start_hour = 23 and end_hour = 23 then "Seconda_Serata"  -- fascia 23-02
              when start_hour >= 2 and end_hour < 6 then "Overnight"        -- fascia 02-06
              when start_hour >=6 and end_hour <9 then "Early_Morning"      -- fascia 06-09
              when start_hour >=9 and end_hour <13 then "Morning"           -- fascia 09-13
              when start_hour >=13 and end_hour <18 then "Afternoon"        -- fascia 13-18
              when start_hour >=18 and end_hour <20 then "Preserale"        -- fascia 18-20
              when start_hour =20 and end_hour =20  then "Access"           -- fascia 20-21
              when start_hour >=21 and end_hour < 23 then "Prime_Time"      -- fascia 21-23
        --FASCE ORARIE DOPPIE
              when start_hour IN (2,3,4,5) and end_hour IN (6,7,8) then "Multifascia_2_9"
              when start_hour IN (6,7,8) and end_hour IN (9,10,11,12) then "Multifascia_6_13"
              when start_hour IN (9,10,11,12) and end_hour IN (13,14,15,16,17) then "Multifascia_9_18"
              when start_hour IN (13,14,15,16,17) and end_hour IN (18,19) then "Multifascia_13_20"
              when start_hour IN (18,19) and end_hour IN (20) then "Multifascia_18_21"
              when start_hour IN (20) and end_hour IN (21,22) then "Multifascia_20_23"
              when start_hour IN (21,22) and end_hour IN (23,0,1) then "Multifscia_21_2"
              when start_hour IN (23,0,1) and end_hour IN (2,3,4,5) then "Multifascia_23_6"
        --FASCIA ORARIA TRIPLA
              when start_hour IN (2,3,4,5) and end_hour IN (9,10,11,12) then "Multifascia_2_13"
              when start_hour IN (6,7,8) and end_hour IN (13,14,15,16,17) then "Multifascia_6_18"
              when start_hour IN (9,10,11,12) and end_hour IN (18,19) then "Multifascia_9_20"
              when start_hour IN (13,14,15,16,17) and end_hour IN (20) then "Multifascia_13_21"
              when start_hour IN (18,19) and end_hour IN (21,22) then "Multifascia_18_23"
              when start_hour IN (20) and end_hour IN (23,0, 1) then "Multifascia_20_2"
              when start_hour IN (21,22) and end_hour IN (2,3,4,5) then "Multifascia_21_6"
              when start_hour IN (23,0,1) and end_hour IN (6,7,8) then "Multifascia_23_9"
        --FASCIA ORARIA INDEFINITA
              else "MultiFascia_Indefinita"
    END AS fascia_oraria,

       EXTRACT(DAYOFWEEK FROM playback_start2) AS day_of_week  -- 1 = Domenica, 2 = Lunedi, 3 = Martedi ... 7 = Sabato

                
FROM
       (SELECT 
            SC_SN,
            duration_sec
            playback_date,
            duration_sec,
            playback_start2,
            playback_end2,
            EXTRACT (HOUR FROM playback_start2) AS start_hour,
            EXTRACT (HOUR FROM playback_end2) AS end_hour,
            des_live_ts,
            event_type,
            orig_net_id,
            tp_stream_id,
            si_serv_id AS SI_SERV_ID,
            VOD_ID,
            X_SPEED,
      FROM `skyita-da-composer-prod.ethan_elementary_data.Elementary_DataSet`
      WHERE DURATION_SEC <86400 -- scartiamo tutti i record uguali a 24 ore di visione
      AND SC_SN in (select distinct sc_sn from `skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.TEMP`)
      AND capping_status <> "NOT VALIDATED" -- scartiamo tutti i record non validati
      AND playback_date > datetime_start) -- selezioniamo solo i dati a partire dalla data scelta (1 anno di default)
      

