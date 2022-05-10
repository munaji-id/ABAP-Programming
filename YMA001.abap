*&---------------------------------------------------------------------*
*& Trx. Code   : -
*& Module      : -
*& Functional  : -
*& Author      : Munaji (SAPAJI)
*& Mentor      : HARRY M
*& Description : Training 001
*& Create Date : 27.04.2022
*&---------------------------------------------------------------------*
*& REVISION LOG:
*& DATE              AUTHOR         TRCODE            DESCRIPTION
*&
*&---------------------------------------------------------------------*
REPORT yma001.

TABLES ymadt001.

TYPE-POOLS: vrm.

DATA: name    TYPE vrm_id,
      list    TYPE vrm_values,
      value   LIKE LINE OF list.

DATA: it_data TYPE TABLE OF ymadt001,
      wa_data TYPE ymadt001,
      idk     TYPE c.

SET BLANK LINES ON.
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-001.
    PARAMETERS: r1 RADIOBUTTON GROUP rb DEFAULT 'X' USER-COMMAND ucom,
                r2 RADIOBUTTON GROUP rb,
                r3 RADIOBUTTON GROUP rb,
                r4 RADIOBUTTON GROUP rb.
SELECTION-SCREEN END OF BLOCK block1.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-002.
    PARAMETERS: p_nohp(12) TYPE c MODIF ID scp,
                p_nama(50) TYPE c MODIF ID scp,
                p_gender(1) AS LISTBOX VISIBLE LENGTH 13 MODIF ID scp,
                p_alamat(100) TYPE c MODIF ID scp,
                p_tglgb TYPE d MODIF ID scp,
                p_wa AS CHECKBOX MODIF ID scp
                .
SELECTION-SCREEN END OF BLOCK block2.

*SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-003.
*    PARAMETERS: p_noh(12) TYPE c MODIF ID SCR,
*                p_nam(50) TYPE c MODIF ID SCR,
*                p_alama(100) TYPE c MODIF ID SCR.
*SELECTION-SCREEN END OF BLOCK block3.

MOVE p_nohp     TO wa_data-no_hp.
MOVE p_nama     TO wa_data-nama.
MOVE p_gender   TO wa_data-kelamin.
MOVE p_alamat   TO wa_data-alamat.
MOVE p_tglgb    TO wa_data-tanggal.
MOVE p_wa       TO wa_data-whatsapp.

AT SELECTION-SCREEN ON p_nohp.
    IF idk = '1'.
        IF r1 EQ abap_true AND p_nohp NS '0123456789' AND p_nohp(2) NE '08'.
            MESSAGE e398(00) WITH 'Enter a value must be a number and start with the number 08' DISPLAY LIKE 'E'.
        ENDIF.
    ENDIF.
AT SELECTION-SCREEN ON p_nama.
    IF idk = '1'.
        IF r1 EQ abap_true AND p_nama IS INITIAL.
            MESSAGE e398(00) WITH 'Enter a value!' DISPLAY LIKE 'E'.
        ENDIF.
    ENDIF.
AT SELECTION-SCREEN ON p_gender.
    IF idk = '1'.
        IF r1 EQ abap_true AND p_gender IS INITIAL.
            MESSAGE e398(00) WITH 'Enter a value!' DISPLAY LIKE 'E'.
        ENDIF.
    ENDIF.

AT SELECTION-SCREEN OUTPUT.
    name = 'p_gender'.

    value-key = 'L'.
    value-text = 'Laki-laki'.
    APPEND value TO list.

    value-key = 'P'.
    value-text = 'Perempuan'.
    APPEND value TO list.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id      = name
        values   = list.

    LOOP AT SCREEN.
        IF screen-group1 = 'SCP'.
            IF r1 = 'X'.
                screen-active = '1'.
                idk = 1.
            ELSE.
                screen-active = '0'.
                idk = 0.
                CLEAR list.
            ENDIF.
            MODIFY SCREEN.
*        ELSEIF screen-group1 = 'SCR'.
*            IF r2 = 'X'.
*                SCREEN-ACTIVE = '1'.
*            ELSE.
*                SCREEN-ACTIVE = '0'.
*            ENDIF.
*            MODIFY SCREEN.
        ENDIF.
    ENDLOOP.



START-OF-SELECTION.
    INSERT ymadt001 FROM wa_data.

    IF sy-subrc EQ 0.
        MESSAGE: 'Data saved successfully.' TYPE 'S'.
        STOP.
    ELSE.
        MESSAGE: 'Data not saved!' TYPE 'E'.
        STOP.
    ENDIF.
