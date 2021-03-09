declare date_start datetime default DATETIME_TRUNC(CURRENT_DATETIME(),DAY);
declare date_back datetime default DATE_SUB(date_start, interval 30 DAY);

SELECT
    sum( -- FASCIA ORARIA: Early Morning 06-09
         case 
              when fascia_oraria = "Early_Morning" then duration_sec  
              when fascia_oraria = "Multifascia_2_13" then 10800  
              when fascia_oraria = "Multifascia_23_9" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 6 HOUR), SECOND)
              when fascia_oraria = "Multifascia_2_9" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 6 HOUR), SECOND)
              when fascia_oraria = "Multifascia_6_13" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 9 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_6_18" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 9 HOUR),playback_start2,SECOND)
         end) 
    as TTS_EARLY_MORNING_Weekday_linear,


    sum( -- FASCIA ORARIA: Morning 09-13
         case 
              when fascia_oraria = "Morning" then duration_sec  
              when fascia_oraria = "Multifascia_6_18" then 14400  
              when fascia_oraria = "Multifascia_2_13" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 9 HOUR), SECOND)
              when fascia_oraria = "Multifascia_6_13"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 9 HOUR), SECOND)
              when fascia_oraria = "Multifascia_9_18" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 13 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_9_20" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 13 HOUR),playback_start2,SECOND)
         end) 
    as TTS_MORNING_Weekday_linear,


    sum( -- FASCIA ORARIA: Afternoon 13-18
         case 
              when fascia_oraria = "Afternoon" then duration_sec  
              when fascia_oraria = "Multifascia_9_20" then 14400  
              when fascia_oraria = "Multifascia_6_18" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 13 HOUR), SECOND)
              when fascia_oraria = "Multifascia_9_18"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 13 HOUR), SECOND)
              when fascia_oraria = "Multifascia_13_20" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 18 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_13_21" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 18 HOUR),playback_start2,SECOND)
         end) 
    as TTS_AFTERNOON_Weekday_linear,


    sum( -- FASCIA ORARIA: Preserale 18-20
         case 
              when fascia_oraria = "Preserale" then duration_sec  
              when fascia_oraria = "Multifascia_13_21" then 7200 
              when fascia_oraria = "Multifascia_9_20" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 18 HOUR), SECOND)
              when fascia_oraria = "Multifascia_13_20"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 18 HOUR), SECOND)
              when fascia_oraria = "Multifascia_18_21" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 20 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_18_23" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 20 HOUR),playback_start2,SECOND)
         end) 
    as TTS_PRESERALE_Weekday_linear,


    sum( -- FASCIA ORARIA: Acces 20-21
         case 
              when fascia_oraria = "Preserale" then duration_sec  
              when fascia_oraria = "Multifascia_18_23" then 3600 
              when fascia_oraria = "Multifascia_13_21" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 20 HOUR), SECOND)
              when fascia_oraria = "Multifascia_18_21"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 20 HOUR), SECOND)
              when fascia_oraria = "Multifascia_20_23" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 21 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_20_2" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 21 HOUR),playback_start2,SECOND)
         end) 
    as TTS_ACCESS_Weekday_linear,  


    sum( -- FASCIA ORARIA: Prime_Time 21-23
         case 
              when fascia_oraria = "Prime_Time" then duration_sec  
              when fascia_oraria = "Multifascia_20_2" then 7200 
              when fascia_oraria = "Multifascia_18_23" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 21 HOUR), SECOND)
              when fascia_oraria = "Multifascia_20_23"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 21 HOUR), SECOND)
              when fascia_oraria = "Multifascia_21_2" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 23 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_21_6"  then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 23 HOUR),playback_start2,SECOND)
         end) 
    as TTS_PRIMETIME_Weekday_linear, 


    sum( -- FASCIA ORARIA: Seconda_Serata 23-02
         case 
              when fascia_oraria = "Seconda_Serata" then duration_sec  
              when fascia_oraria = "Multifascia_21_6" then 10800
              when fascia_oraria = "Multifascia_20_2" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 23 HOUR), SECOND)
              when fascia_oraria = "Multifascia_21_2"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 23 HOUR), SECOND)
              when fascia_oraria = "Multifascia_23_6" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 26 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_23_9"  then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 26 HOUR),playback_start2,SECOND)
         end) 
    as TTS_PRIMETIME_Weekday_linear, 


    sum( -- FASCIA ORARIA: Overnight 02-06
         case 
              when fascia_oraria = "Seconda_Serata" then duration_sec  
              when fascia_oraria = "Multifascia_23_9" then 14400
              when fascia_oraria = "Multifascia_21_6" then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 2 HOUR), SECOND)
              when fascia_oraria = "Multifascia_23_6"  then DATETIME_DIFF(playback_end2, DATETIME_ADD(DATETIME_TRUNC(playback_end2,DAY), INTERVAL 2 HOUR), SECOND)
              when fascia_oraria = "Multifascia_2_9" then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 6 HOUR),playback_start2,SECOND)
              when fascia_oraria = "Multifascia_2_13"  then DATETIME_DIFF(DATETIME_ADD(DATETIME_TRUNC(playback_start2,DAY),INTERVAL 6 HOUR),playback_start2,SECOND)
         end) 
    as TTS_OVERNIGHT_Weekday_linear, 

FROM `skyita-da-datalab-cmo.ds_personal_dataset_cmo_alessandrodugheriastagista.Elementary_DataSet_EXPORT`
where day_of_week > 1 and day_of_week < 7
AND playback_start2 > date_back and playback_start2 < date_start
AND event_type = "VIEWCH"
group by sc_sn
