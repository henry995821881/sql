PROCEDURE PS_DO_SEARCH
  (
    P_TERMINAL  IN  VARCHAR2, --
    P_HANNI IN VARCHAR2, -- 
    P_NENDO IN VARCHAR2, --
    --P_SYORI_DATE IN VARCHAR2, --
    P_KAISOU_LEVEL IN VARCHAR2, -- 
    P_SOSITU_FLAG IN VARCHAR2, --
    --P_KAISOU_UMU IN VARCHAR2, -- 
    P_NEW_KAISOU_LEVEL IN VARCHAR2, -- 
    P_DATA_OUTPUT_SYUBETU IN VARCHAR2, -- 
    P_OUTPUT_UMU IN VARCHAR2, -- 
    P_OUPUT_START_DATE IN VARCHAR2, -- 
    P_OUPUT_END_DATE IN VARCHAR2, 
    P_KNSN_SYUBETU IN VARCHAR2, 
    P_JIGYOUSYO IN VARCHAR2,
    --P_SYOZOKU_FROM IN VARCHAR2,
    --P_SYOZOKU_TO IN VARCHAR2, 
    P_KIKAN_CD IN VARCHAR2, 
    P_INPUT_START_DATE IN VARCHAR2, 
    P_INPUT_END_DATE IN VARCHAR2, 
    P_JYUSIN_START_DATE IN VARCHAR2, 
    P_JYUSIN_END_DATE IN VARCHAR2, 
    --P_SYAIN_NO IN VARCHAR2, 
    P_KIGOU IN VARCHAR2, 
    P_BANGOU IN VARCHAR2, 
    P_AGE_FROM IN VARCHAR2, --
    P_AGE_TO  IN VARCHAR2, --
    P_KNSNSEQNO   IN NUMBER, 
    P_KAISOUKA_START_DATE IN VARCHAR2, 
    P_KAISOUKA_END_DATE IN VARCHAR2, 
    P_SENTAKU_CHECK_FLG IN VARCHAR2, 
    P_KAISOUKA_FLG IN VARCHAR2, 
    P_KIBOU IN VARCHAR2,
    P_DHPKBN IN VARCHAR2, 
    P_KAJISIDATE IN VARCHAR2,
    P_KANYU_NO IN VARCHAR2,
    P_FUYOU_NO IN VARCHAR2,
    P_ANKETO IN VARCHAR2,
    P_STATUS OUT NUMBER 
  )AS
    v_query         VARCHAR2(32767);
    v_process       VARCHAR2(150) := ''; 
    v_program       VARCHAR2(50)  := 'DAI_PCK_NEW_KAISOUKA.PS_DO_SEARCH'; 
    v_nendo_to_c    CHAR(4);
  BEGIN
    P_STATUS := 0;
    v_process := 'LOG START';
    pck_loging.initialize(v_program, PCK_COMM_CHK.c_syokuin);
    pck_loging.output(1, 'P_TERMINAL             = ' || P_TERMINAL);
    pck_loging.output(1, 'P_HANNI                = ' || P_HANNI);
    pck_loging.output(1, 'P_NENDO                = ' || P_NENDO);
    --pck_loging.output(1, 'P_SYORI_DATE           = ' || P_SYORI_DATE);
    pck_loging.output(1, 'P_KAISOU_LEVEL         = ' || P_KAISOU_LEVEL);
    pck_loging.output(1, 'P_SOSITU_FLAG          = ' || P_SOSITU_FLAG);
    --pck_loging.output(1, 'P_KAISOU_UMU           = ' || P_KAISOU_UMU);
    pck_loging.output(1, 'P_NEW_KAISOU_LEVEL     = ' || P_NEW_KAISOU_LEVEL);
    pck_loging.output(1, 'P_DATA_OUTPUT_SYUBETU  = ' || P_DATA_OUTPUT_SYUBETU);
    pck_loging.output(1, 'P_OUTPUT_UMU           = ' || P_OUTPUT_UMU);
    pck_loging.output(1, 'P_OUPUT_START_DATE     = ' || P_OUPUT_START_DATE);
    pck_loging.output(1, 'P_OUPUT_END_DATE       = ' || P_OUPUT_END_DATE);
    pck_loging.output(1, 'P_KNSN_SYUBETU         = ' || P_KNSN_SYUBETU);
    pck_loging.output(1, 'P_JIGYOUSYO            = ' || P_JIGYOUSYO);
    --pck_loging.output(1, 'P_SYOZOKU_FROM         = ' || P_SYOZOKU_FROM);
    --pck_loging.output(1, 'P_SYOZOKU_TO           = ' || P_SYOZOKU_TO);
    pck_loging.output(1, 'P_KIKAN_CD             = ' || P_KIKAN_CD);
    pck_loging.output(1, 'P_INPUT_START_DATE     = ' || P_INPUT_START_DATE);
    pck_loging.output(1, 'P_INPUT_END_DATE       = ' || P_INPUT_END_DATE);
    pck_loging.output(1, 'P_JYUSIN_START_DATE    = ' || P_JYUSIN_START_DATE);
    pck_loging.output(1, 'P_JYUSIN_END_DATE      = ' || P_JYUSIN_END_DATE);
    --pck_loging.output(1, 'P_SYAIN_NO             = ' || P_SYAIN_NO);
    pck_loging.output(1, 'P_KIGOU                = ' || P_KIGOU);
    pck_loging.output(1, 'P_BANGOU               = ' || P_BANGOU);
    pck_loging.output(1, 'P_AGE_FROM             = ' || P_AGE_FROM);
    pck_loging.output(1, 'P_AGE_TO               = ' || P_AGE_TO);
    pck_loging.output(1, 'P_KNSNSEQNO            = ' || P_KNSNSEQNO);
    pck_loging.output(1, 'P_KAISOUKA_START_DATE  = ' || P_KAISOUKA_START_DATE);
    pck_loging.output(1, 'P_KAISOUKA_END_DATE    = ' || P_KAISOUKA_END_DATE);
    pck_loging.output(1, 'P_SENTAKU_CHECK_FLG    = ' || P_SENTAKU_CHECK_FLG);
    pck_loging.output(1, 'P_KAISOUKA_FLG         = ' || P_KAISOUKA_FLG);
    pck_loging.output(1, 'P_KIBOU                = ' || P_KIBOU);
    pck_loging.output(1, 'P_DHPKBN               = ' || P_DHPKBN);
    pck_loging.output(1, 'P_KAJISIDATE           = ' || P_KAJISIDATE);
    pck_loging.output(1, 'P_KANYU_NO             = ' || P_KANYU_NO);
    pck_loging.output(1, 'P_FUYOU_NO             = ' || P_FUYOU_NO);
    pck_loging.output(1, 'P_ANKETO               = ' || P_ANKETO);


    v_process := 'STEP0';
    SELECT NENDO_TO INTO v_nendo_to_c FROM USERINFO;

    v_process := 'STEP1';
    DELETE FROM DAI_X_NEW_KAISOUKA
    WHERE TERMN_IDENT = TO_TIMESTAMP(P_TERMINAL,'RR-MM-DD HH24:MI:SSXFF');

    v_process := 'STEP2';
    v_query :=
    'INSERT INTO DAI_X_NEW_KAISOUKA
     (
        ID,
        TERMN_IDENT,
        NENDO,
        KANYU_NO,
        FUYOU_NO,
        SYUTOKU_NO,
        YEARMONTH,
        KIGOU,
        BANGOU,
        SYAIN_NO,
        ZOKUGARA_CD,
        ZOKUGARA_NM,
        NM,
        KNSN_SEQNO,
        KIKAN_CD,
        KIKAN_NM,
        SYUBETU_CD,
        SYUBETU_NM,
        KENSINBI,
        SIDOU_KBN,
        SIDOU_KBN_NM,
        KAISOUKA_FLG,
        OUTPUT_DATE,
        A_SYOZOKU_CD,
        A_SYOZOKU_NM,
        A_HON_NM,
        A_NENREI,
        A_TANJOUBI,
        A_SEIBETU_CD,
        A_SEIBETU_NM,
        A_YUBIN_NO,
        A_ADDRESS,
        A_TEL_NO,
        A_NEED_KENSIN_KBN,
        A_NEED_KENSIN_RE_KBN,
        A_SIDOU_KBN,
        A_SIDOU_KBN_NM,
        A_SIDOU_KBN_RE,
        A_SIDOU_KBN_RE_NM,
        A_SIDOU_KBN_RE_NM2,
        A_SIDOU_KBN_RE_NOTE,
A_TAISYOGAI_FLG,
        A_JIGYOUSYO_NM,
        KIGOU_NOW,
        BANGOU_NOW,
        ZOKUGARA_CD_NOW,
        SIDOU_KBN_NOW,
        B_1_CSVDATA,
        B_2_CSVDATA,
        B_3_CSVDATA,
        KIKAN_NM2,
        YOUJYUSHIN_STEP,
        KAISOUKAJISI_DATE,
        USER_ID,
        DHP_KBN,
        DHP_ITEM1_CNT,
        DHP_ITEM2_CNT
     )
      SELECT /*+ FIRST_ROWS */
        DAI_SEQ_X_NEW_KAISOUKA.NEXTVAL,
        TO_TIMESTAMP('''||P_TERMINAL||''',''RR-MM-DD HH24:MI:SSXFF''),
        TS.NENDO,
        TS.KANYU_NO,
        TS.FUYOU_NO,
        TS.SYUTOKU_NO,
        TO_DATE(DT.SYORIYM||''01'', ''YYYY/MM/DD''),
        KO.KIGOU,
        KO.BANGOU,
        KO.SYAIN_NO,
        KO.ZOKUGARA_CD,
        (SELECT NM FROM ZOKUGARA WHERE CD = KO.ZOKUGARA_CD) AS zokugara_nm,
        KOJ.NM,
        KN.SEQ_NO AS KNSN_SEQNO,
        KN.KIKAN_CD,
        (SELECT NM FROM KIKAN WHERE CD = KN.KIKAN_CD) AS KIKAN_NM,
        KN.SYUBETU AS SYUBETU_CD,
        (SELECT NM FROM KNSNSYUBETU WHERE CD = KN.SYUBETU) AS SYUBETU_NM,
        KN.KENSINBI,
        DT.SIDOU_KBN,
        (SELECT ORG FROM CTM_CODE_TBL WHERE CD = DT.SIDOU_KBN AND KBN = ''D02'') AS SIDOU_KBN_NM,
        NVL2(DT.SIDOU_KBN, 2, 1) AS KAISOUKA_FLG,
        (CASE
           WHEN '||P_DATA_OUTPUT_SYUBETU||' = 1 THEN DT.LSTOUTPUT_DATE
           WHEN '||P_DATA_OUTPUT_SYUBETU||' = 2 THEN DT.LSTOUTPUT_DATE_RD
           WHEN '||P_DATA_OUTPUT_SYUBETU||' = 3 THEN DT.LSTOUTPUT_DATE_RJ
           WHEN '||P_DATA_OUTPUT_SYUBETU||' = 4 THEN DT.LSTOUTPUT_DATE_HK
           WHEN '||P_DATA_OUTPUT_SYUBETU||' = 5 THEN DT.LSTOUTPUT_DATE_SI
        END) AS OUTPUT_DATE,
      
        KO.SYOZOKU_CD AS A_SYOZOKU_CD,
        (SELECT NM FROM SYOZOKU WHERE CD = KO.SYOZOKU_CD) AS A_SYOZOKU_NM,
        (SELECT NM FROM KOJIN WHERE KANYU_NO = KO.KANYU_NO AND FUYOU_NO = 0) AS A_HON_NM,
        KN.nenrei AS A_NENREI,
       
        KOJ.TANJOUBI AS A_TANJOUBI,
       
        KN.seibetu AS A_SEIBETU_CD,
        (SELECT ORG FROM M_CODE_TBL WHERE CD = KN.seibetu AND KBN = ''119'') AS A_SEIBETU_NM,
        (SELECT YUBIN_NO FROM JUUSYO WHERE KANYU_NO=TS.KANYU_NO AND FUYOU_NO=0) AS A_YUBIN_NO,
        (SELECT ADDRESS FROM JUUSYO WHERE KANYU_NO=TS.KANYU_NO AND FUYOU_NO=0) AS A_ADDRESS,
        (SELECT TEL_NO FROM JUUSYO WHERE KANYU_NO=TS.KANYU_NO AND FUYOU_NO=0) AS A_TEL_NO,
   
        (CASE WHEN NVL(DT.YOUJYUSHIN_STEP, 0) = 1 THEN 1 ELSE 0 END) AS A_NEED_KENSIN_KBN,
        (CASE WHEN NVL(DT.YOUJYUSHIN_STEP, 0) = 2 THEN 1 ELSE 0 END) AS A_NEED_KENSIN_RE_KBN,
    
        TS.SIDOU_KBN AS A_SIDOU_KBN,
        (SELECT ORG FROM CTM_CODE_TBL WHERE CD = TS.SIDOU_KBN AND KBN = ''D01'') AS A_SIDOU_KBN_NM,
        NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) AS A_SIDOU_KBN_RE,
        (SELECT NM FROM CTM_CODE_TBL WHERE CD = NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) AND KBN = ''D02'') AS A_SIDOU_KBN_RE_NM,
        (SELECT ORG FROM CTM_CODE_TBL WHERE CD = NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) AND KBN = ''D02'') AS A_SIDOU_KBN_RE_NM2,
        (SELECT NOTE FROM CTM_CODE_TBL WHERE CD = NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) AND KBN = ''D02'') AS A_SIDOU_KBN_RE_NOTE,
decode(PCK_JISSEKI_HOUKOKU.FN_TOTYUUDATTAI_CHECK(TS.NENDO, TS.KANYU_NO, TS.FUYOU_NO, USERINFO.NENDO_FROM, ''1''),''1'',''0'',''1'') AS A_TAISYOGAI_FLG,
        (SELECT JIGYOUSYO_NM FROM JIGYOUSYO WHERE JIGYOUSYO.KIGOU = KO.KIGOU) AS A_JIGYOUSYO_NM,
        KO.KIGOU AS KIGOU_NOW,
        KO.BANGOU AS BANGOU_NOW,
        KO.ZOKUGARA_CD AS ZOKUGARA_CD_NOW,
        NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) AS SIDOU_KBN_NOW,
        '''' AS B_1_CSVDATA,
        '''' AS B_2_CSVDATA,
        '''' AS B_3_CSVDATA,
        (CASE
          WHEN KN.KIKAN_CD = ''999'' AND TRIM(KN2.VAL) IS NOT NULL THEN TRIM(KN2.VAL)
          ELSE (SELECT NM FROM KIKAN WHERE CD = KN.KIKAN_CD)
        END) AS KIKAN_NM2,
        DT.YOUJYUSHIN_STEP,
        DT.KAISOUKAJISI_DATE,
        DAI_SEQ_X_NEW_KAISOUKA.CURRVAL,
        DT.DHP_KBN,
        DT.DHP_ITEM1_CNT,
        DT.DHP_ITEM2_CNT
      FROM TS_SIDOUTAI TS
      INNER JOIN DAI_TS_SIDOUTAI DT
        ON TS.NENDO = DT.NENDO
        AND TS.KANYU_NO = DT.KANYU_NO
        AND TS.FUYOU_NO = DT.FUYOU_NO
        AND TS.SYUTOKU_NO = DT.SYUTOKU_NO
      JOIN KNSN1 KN
        ON KN.SEQ_NO = NVL(DT.KAISOUKA_KNSN_NO,TS.HANTEI_SEQ)
      JOIN KOJINRIREKI KO
        ON TS.KANYU_NO = KO.KANYU_NO
        AND TS.FUYOU_NO = KO.FUYOU_NO
        AND TS.SYUTOKU_NO = KO.SYUTOKU_NO
      JOIN KOJIN KOJ
        ON KO.KANYU_NO = KOJ.KANYU_NO
        AND KO.FUYOU_NO = KOJ.FUYOU_NO
      LEFT JOIN KNSN2 KN2
        ON KN2.SEQ_NO      = KN.SEQ_NO
        AND KN2.KOUMOKU_CD = ''0900''
LEFT JOIN USERINFO
        ON 1 = 1
      LEFT JOIN DAI_ANK DA
        ON DT.NENDO = DA.NENDO
        AND DT.KANYU_NO = DA.KANYU_NO
        AND DT.FUYOU_NO = DA.FUYOU_NO
        WHERE TS.NENDO = '''||P_NENDO||'''';
     

    IF P_KAISOU_LEVEL IS NOT NULL THEN
      v_query := v_query || '
        AND TS.SIDOU_KBN = '||P_KAISOU_LEVEL;
    END IF;
    IF P_NEW_KAISOU_LEVEL IS NOT NULL THEN
      v_query := v_query || '
        AND NVL(DT.SIDOU_KBN_RE, DT.SIDOU_KBN) = '||P_NEW_KAISOU_LEVEL;
    END IF;
 
      v_query := v_query || '
        AND (
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = TS.KANYU_NO
                AND FUYOU_NO = TS.FUYOU_NO) IS NULL
            )
            OR
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = TS.KANYU_NO
                AND FUYOU_NO = TS.FUYOU_NO) > SYSDATE
             AND
             (SELECT DISTINCT FIRST_VALUE(SYUTOKUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = TS.KANYU_NO
                AND FUYOU_NO = TS.FUYOU_NO) <= SYSDATE
            )
        )';
   
    END IF;
    --IF P_KAISOU_UMU IS NOT NULL THEN
      v_query := v_query || '
        AND NVL2(DT.SIDOU_KBN, 2, 1) = ''2''';
    --END IF;
    IF P_DHPKBN IS NOT NULL THEN
      v_query := v_query || '
        AND DT.DHP_KBN IN ('||P_DHPKBN||')';
    END IF;
  
    IF P_DATA_OUTPUT_SYUBETU = '1' THEN
      IF P_OUTPUT_UMU IS NOT NULL THEN
        v_query := v_query || '
        AND NVL2(DT.LSTOUTPUT_DATE, 2, 1) = '||P_OUTPUT_UMU;
      END IF;
      IF P_OUPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE, ''YYYY/MM/DD'') >= '''||P_OUPUT_START_DATE||'''';
      END IF;
      IF P_OUPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';
      END IF;
    END IF;
    IF P_DATA_OUTPUT_SYUBETU = '2' THEN
      IF P_OUTPUT_UMU IS NOT NULL THEN
        v_query := v_query || '
        AND NVL2(DT.LSTOUTPUT_DATE_RD, 2, 1) = '||P_OUTPUT_UMU;
      END IF;
      IF P_OUPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_RD, ''YYYY/MM/DD'') >= '''||P_OUPUT_START_DATE||'''';
      END IF;
      IF P_OUPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_RD, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';
      END IF;
    END IF;
    IF P_DATA_OUTPUT_SYUBETU = '3' THEN
      IF P_OUTPUT_UMU IS NOT NULL THEN
        v_query := v_query || '
        AND NVL2(DT.LSTOUTPUT_DATE_RJ, 2, 1) = '||P_OUTPUT_UMU;
      END IF;
      IF P_OUPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_RJ, ''YYYY/MM/DD'') >= '''||P_OUPUT_START_DATE||'''';
      END IF;
      IF P_OUPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_RJ, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';
      END IF;
    END IF;
    IF P_DATA_OUTPUT_SYUBETU = '4' THEN
      IF P_OUTPUT_UMU IS NOT NULL THEN
        v_query := v_query || '
        AND NVL2(DT.LSTOUTPUT_DATE_HK, 2, 1) = '||P_OUTPUT_UMU;
      END IF;
      IF P_OUPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_HK, ''YYYY/MM/DD'') >= '''||P_OUPUT_START_DATE||'''';
      END IF;
      IF P_OUPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_HK, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';
      END IF;
    END IF;
    IF P_DATA_OUTPUT_SYUBETU = '5' THEN
      IF P_OUTPUT_UMU IS NOT NULL THEN
        v_query := v_query || '
        AND NVL2(DT.LSTOUTPUT_DATE_SI, 2, 1) = '||P_OUTPUT_UMU;
      END IF;
      IF P_OUPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_SI, ''YYYY/MM/DD'') >= '''||P_OUPUT_START_DATE||'''';
      END IF;
      IF P_OUPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.LSTOUTPUT_DATE_SI, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';
      END IF;
    END IF;

    IF P_KAISOUKA_FLG = '0' THEN
    IF P_KAISOUKA_START_DATE IS NOT NULL THEN
      v_query := v_query || '
      AND TO_CHAR(DT.KAISOUKAJISI_DATE, ''YYYY/MM/DD'') >= '''||P_KAISOUKA_START_DATE||'''';
    END IF;
    IF P_KAISOUKA_END_DATE IS NOT NULL THEN
      v_query := v_query || '
      AND TO_CHAR(DT.KAISOUKAJISI_DATE, ''YYYY/MM/DD'') <= '''||P_KAISOUKA_END_DATE||'''';
    END IF;
    END IF;
    IF P_KAISOUKA_FLG = '1' THEN
      IF P_KAJISIDATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(DT.KAISOUKAJISI_DATE, ''YYYY/MM/DD'') IN ('||P_KAJISIDATE||')';
      END IF;
    END IF;
    IF P_ANKETO IS NOT NULL THEN
      v_query := v_query || '
          AND NVL2(DA.KIBOU_FLG,1,0) = '||P_ANKETO;
    END IF;
    IF P_KIBOU IS NOT NULL THEN
      v_query := v_query || '
        AND DA.KIBOU_FLG = '||P_KIBOU;
    END IF;
    IF P_SENTAKU_CHECK_FLG = '1' THEN
  
    IF P_HANNI = '1' THEN
      IF P_KNSN_SYUBETU IS NOT NULL THEN
        v_query := v_query || '
        AND KN.SYUBETU IN (' || P_KNSN_SYUBETU || ')';
      END IF;
      IF P_JIGYOUSYO IS NOT NULL THEN
        v_query := v_query || '
        AND KO.KIGOU IN (' || P_JIGYOUSYO || ')';
      END IF;
      --IF P_SYOZOKU_FROM IS NOT NULL THEN
      --  v_query := v_query || '
      --  AND KO.SYOZOKU_CD BETWEEN '''||P_SYOZOKU_FROM||''' AND '''||P_SYOZOKU_TO||'''';
      --END IF;
      IF P_KIKAN_CD IS NOT NULL THEN
        v_query := v_query || '
        AND KN.KIKAN_CD = '''||P_KIKAN_CD||'''';
      END IF;
      IF P_INPUT_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(KN.SYORIBI, ''YYYY/MM/DD'') >= '''||P_INPUT_START_DATE||'''';
      END IF;
      IF P_INPUT_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(KN.SYORIBI, ''YYYY/MM/DD'') <= '''||P_INPUT_END_DATE||'''';
      END IF;
      IF P_JYUSIN_START_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(KN.KENSINBI, ''YYYY/MM/DD'') >= '''||P_JYUSIN_START_DATE||'''';
      END IF;
      IF P_JYUSIN_END_DATE IS NOT NULL THEN
        v_query := v_query || '
        AND TO_CHAR(KN.KENSINBI, ''YYYY/MM/DD'') <= '''||P_JYUSIN_END_DATE||'''';
      END IF;
    END IF;
   
    IF P_HANNI = '2' THEN
      --IF P_SYAIN_NO IS NOT NULL THEN
      --  v_query := v_query || '
      --  AND KO.SYAIN_NO = '''||P_SYAIN_NO||'''';
      --END IF;
        IF P_KANYU_NO IS NOT NULL THEN
          v_query := v_query || '
          AND KO.KANYU_NO = '''||P_KANYU_NO||'''';
          IF P_FUYOU_NO IS NOT NULL THEN
            v_query := v_query || '
            AND KO.FUYOU_NO = '''||P_FUYOU_NO||'''';
          END IF;
        ELSE
      IF P_KIGOU IS NOT NULL THEN
        v_query := v_query || '
        AND KO.KIGOU = '''||P_KIGOU||'''';
      END IF;
      IF P_BANGOU IS NOT NULL THEN
        v_query := v_query || '
        AND KO.BANGOU = '||P_BANGOU;
      END IF;
    END IF;
    END IF;
    
    IF P_HANNI = '3' THEN
      IF P_KNSNSEQNO IS NOT NULL THEN
        v_query := v_query || '
        AND KN.SEQ_NO = ' || P_KNSNSEQNO; --|| '
--        AND DT.NENDO IS NOT NULL ';
      END IF;
    END IF;
    END IF;

    v_process := 'STEP3';
    pck_loging.output(1, 'v_query = ' || v_query);
    EXECUTE IMMEDIATE v_query;

    v_process := 'NORMAL END';
    pck_loging.normal_end(v_program);
  EXCEPTION
    WHEN OTHERS THEN
        pck_loging.abort_end( v_program, SQLERRM(SQLCODE), v_process);
        P_STATUS := 9;
        RETURN;--9F
  END PS_DO_SEARCH;