declare date_start datetime default DATETIME_TRUNC(CURRENT_DATETIME(),DAY);
declare date_back datetime default DATE_SUB(date_start, interval 30 DAY);

-- Calcolo Total Time Spent in secondi nell'ultimo mese per ogni singolo id_account
-- utilizzo di interval durata poichè sembra un valore filtrato rispetto alla durata non modificata.

WITH TTS_overall as (
                    SELECT 
                        SC_SN,
                        sum(case when event_type = "VIEWCH" then duration_sec end) as TTS_overall_linear,
                        
                    FROM `skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.Elementary_DataSet_EXPORT` 
                    where playback_start2 > date_start and playback_start2 < date_back
                    and day_of_week = 1 or day_of_week = 7
                    group by sc_sn),

     id_account_lookup as (
                    select *
                    from `skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.LOOKUP_id_contract_sc_sn`)

SELECT B.id_contract, A.*
FROM TTS_overall A 
JOIN id_account_lookup B
ON A.SC_SN = B.SC_SN