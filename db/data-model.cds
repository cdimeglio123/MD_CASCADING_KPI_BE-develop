namespace db;

using {managed} from '@sap/cds/common';

//ZCV_PRD_BTP_001
entity ZKPI_PDV_ANAG {
    key PDV : String(32);
    DESCR_PDV: String(60);
    DATA_APERTURA: String(8);
    PARITA: String(20);
    REGIONE: String(25);
    SEMAFORI: String(1);
    CLUSTER_DIMENSIONALE: String(1);
    COUNTRY: String(3); //default 'IT';
    ANNO_RISTR: String(5);
    CDC: String(10);
    CLUSTER_PERFORMANCE_FCT: String(20);
    CALYEAR: String(4);
    ZONA: String(50);
    AREA_REGIONALE: String(50);
    AREA_MANAGER: String(50);
    MQ_VENDITA: Decimal(21,7);
    N_CASSE: String(10);
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
}

//ZCV_PRD_BTP_002
entity ZKPI_PDV_FORECAST {
    key PDV: String(32);
    key ANNO: String(4);
    TIPOLOGIA_AGGR: String(20);
    RESA_MQ_LORDA: Decimal(21,7);
    MARGINE_COMM: Decimal(7,3);
    TOT_DIFF_INV: Decimal(7,3);
    TRASPORTO_VERSO: Decimal(7,3);
    COSTO_LAVORO_ORD: Decimal(7,3);
    TOTALE_COSTI: Decimal(7,3);
    EBITDA: Decimal(7,3);
    AMMORTAMENTI: Decimal(7,3);
    EBIT: Decimal(7,3);
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_003
entity ZKPI_PDV_ECONOMICO {
    Key PDV: String(32);
    key ANNO_MESE: String(6);
    VENDITE_LORDE: Decimal;
    VENDITE_BUDGET: Decimal;
    VENDITE_LORDE_AP: Decimal;
    VENDITE_NETTE: Decimal;
    EBIT: Decimal;
    EBITDA: Decimal;
    RISULTATO_NETTO: Decimal;
    TRASPORTO: Decimal;
    CDL: Decimal;
    VS_MESE_PREC: Decimal;
    VS_BUDGET: Decimal;
    VS_ANNO_PREC: Decimal;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

entity ZKPI_PDV_ECONOMICO_AGGR(PDV: String(32) null, ANNO_MESE_DA : String(8) default '202001', ANNO_MESE_A : String(8) default '202012') as
        select from  ZKPI_PDV_ECONOMICO as a
        left outer join ZKPI_PDV_ECONOMICO as b
        on a.PDV = b.PDV
        and a.ANNO_MESE >= :ANNO_MESE_DA  
        and a.ANNO_MESE <= :ANNO_MESE_A
        and b.ANNO_MESE = :ANNO_MESE_A
        and a.UPD_TYPE <> 'D'
        and b.UPD_TYPE <> 'D'
        {
            key a.PDV,
            SUM(a.VENDITE_LORDE)  as VENDITE_LORDE: Decimal, 
            SUM(a.VENDITE_BUDGET) as VENDITE_BUDGET: Decimal,
            SUM(a.VENDITE_LORDE_AP) as VENDITE_LORDE_AP: Decimal,
            SUM(a.VENDITE_NETTE) as VENDITE_NETTE: Decimal,
            SUM(a.EBIT) as EBIT: Decimal,
            SUM(a.EBITDA) as EBIT_DA: Decimal,
            SUM(a.RISULTATO_NETTO) as RISULTATO_NETTO: Decimal,
            SUM(a.TRASPORTO) as TRASPORTO: Decimal,
            SUM(a.CDL) as CDL: Decimal,
            SUM(a.VS_BUDGET) as VS_BUDGET: Decimal,
            SUM(a.VS_ANNO_PREC) as VS_ANNO_PREC: Decimal,
            SUM(b.VS_MESE_PREC) as VS_MESE_PREC: Decimal,
        } 
        where
        //Al Fine di rendere non obbligatorio il parametro PDv (parametro inserito per problemi lato FE)        
        (CASE
            WHEN :PDV IS NOT NULL AND :PDV <> '' THEN
                (CASE
                    WHEN a.PDV = :PDV THEN 1
                    ELSE 0
                END)
            ELSE 1
        END) = 1
        and  a.ANNO_MESE >= :ANNO_MESE_DA  
        and a.ANNO_MESE <= :ANNO_MESE_A
        and b.ANNO_MESE = :ANNO_MESE_A
        group by a.PDV;

//ZCV_PRD_BTP_004
entity ZKPI_PDV_VENSMI {
    key PDV: String(32);
    key ANNO_MESE: String(6);
    QTA_VEN: Decimal;
    QTA_SMI: Decimal;
    QTA_MOV: Decimal;
    TRASFERITO: Decimal;
    DISTRUTTI: Decimal;
    SOMMA_TRASF: Decimal;
    INV_STAT: Decimal;
    RETTIF_ROTAT: Decimal; 
    VAL_DIFF_INV: Decimal;
    INC_DIF_INV: Decimal;
    IND_ROTAZ_MAG: Decimal;
    GIACENZA_REALE: Decimal;
    COSTO_MEDIO: Decimal;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;    
};

//ZCV_PRD_BTP_014
entity ZKPI_PDV_WEIGHT {
    key PDV: String(6);
    key ANNO: String(4);
    key ANNOMESE: String(6);
    key ANNOSETTIMANA: String(6);
    key REPARTO: String(3);
    key SETTIMANA: String(2);
    LORDO_CY: Decimal(17,2);
    N_SCO_CY: Integer;
    WEIGHT_N_SCO_CY: Decimal(17,2);
    WEIGHT_LORDO_CY: Decimal(17,2);
    LORDO_PY: Decimal(17,2);
    N_SCO_PY: Integer;
    WEIGHT_N_SCO_PY: Decimal(17,2);
    WEIGHT_LORDO_PY: Decimal(17,2);
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
}

//ZCV_PRD_BTP_005
entity ZKPI_PDV_SCONTR {
    key PDV: String(32);
    key ANNO_MESE: String(6);
    N_SCONTRINI: Integer;
    N_PROD_SCONTR: Decimal;
    SCONTR_MEDIO: Decimal;
    QTA_SCONTR: Decimal;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_008
entity ZKPI_PDV_SCONTR_TIME_RANGE {
    key PDV: String(32);
    key ANNO_MESE: String(6);
    key FASCIA_ORARIA: String(1);
    N_CASSE_ORARIA: Decimal;
    QTA_SCONTR_ORARIA: Decimal;
    N_SCONTRINI: Integer;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_009
entity ZKPI_PDV_SCONTR_WEEK_DAY {
    key PDV: String(32);
    key ANNO_MESE: String(6);
    key GIORNO_SETT: String(3);
    N_CASSE_GIORNO: Decimal;
    QTA_SCONTR_GIORNO: Decimal;
    N_SCONTRINI: Integer;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};


//ZCV_PRD_BTP_006   
entity ZKPI_ANALYTICS {
    key ANNO_MESE: String(6);
    key REGIONE: String(21);
    KEY CLUSTER: String(1);
    key COUNTRY: String(3);
    RESA_REGIONE: Decimal;
    SCONTRINO_MEDIO_REGIONE: Decimal;
    CODICE_SCONTRINO_REGIONE: Decimal;
    QTA_SCONTRINO_REGIONE: Decimal;
    LORDO_LATTICINI_REGIONE: Decimal default 0.00;
    LORDO_PESCHERIA_REGIONE: Decimal default 0.00;
    LORDO_MACELLERIA_REGIONE: Decimal default 0.00;
    LORDO_GASTRONOMIA_REGIONE: Decimal default 0.00;
    LORDO_ABBIGLIAMENTO_REGIONE: Decimal default 0.00;
    LORDO_PANETTERIA_REGIONE: Decimal default 0.00;
    LORDO_PASTICCERIA_REGIONE: Decimal default 0.00;
    RESA_CLUSTER: Decimal;
    SCONTRINO_MEDIO_CLUSTER: Decimal;
    CODICE_SCONTRINO_CLUSTER: Decimal;
    QTA_SCONTRINO_CLUSTER: Decimal;
    LORDO_LATTICINI_CLUSTER: Decimal default 0.00;
    LORDO_PESCHERIA_CLUSTER: Decimal default 0.00;
    LORDO_MACELLERIA_CLUSTER: Decimal default 0.00;
    LORDO_GASTRONOMIA_CLUSTER: Decimal default 0.00;
    LORDO_ABBIGLIAMENTO_CLUSTER: Decimal default 0.00;
    LORDO_PANETTERIA_CLUSTER: Decimal default 0.00;
    LORDO_PASTICCERIA_CLUSTER: Decimal default 0.00;
    RESA_COUNTRY: Decimal;
    SCONTRINO_MEDIO_COUNTRY: Decimal;
    CODICE_SCONTRINO_COUNTRY: Decimal;
    QTA_SCONTRINO_COUNTRY: Decimal;
    LORDO_LATTICINI_COUNTRY: Decimal default 0.00;
    LORDO_PESCHERIA_COUNTRY: Decimal default 0.00;
    LORDO_MACELLERIA_COUNTRY: Decimal default 0.00;
    LORDO_GASTRONOMIA_COUNTRY: Decimal default 0.00;
    LORDO_ABBIGLIAMENTO_COUNTRY: Decimal default 0.00;
    LORDO_PANETTERIA_COUNTRY: Decimal default 0.00;
    LORDO_PASTICCERIA_COUNTRY: Decimal default 0.00;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_010
entity ZKPI_ANALYTICS_TIME_RANGE {
    key ANNO_MESE: String(6);
    key REGIONE: String(21);
    KEY CLUSTER: String(1);
    key COUNTRY: String(3);
    key FASCIA_ORARIA: String(1);
    N_CASSE_ORARIA_CLUSTER: Decimal;
    QTA_SCONTRINO_ORARIA_CLUSTER: Decimal;
    N_SCONTRINI_CLUSTER: Integer;
    N_CASSE_ORARIA_REGIONE: Decimal;
    QTA_SCONTRINO_ORARIA_REGIONE: Decimal;
    N_SCONTRINI_REGIONE: Integer;
    N_CASSE_ORARIA_COUNTRY: Decimal;
    QTA_SCONTRINO_ORARIA_COUNTRY: Decimal;
    N_SCONTRINI_COUNTRY: Integer;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_011
entity ZKPI_ANALYTICS_WEEK_DAY {
    key ANNO_MESE: String(6);
    key REGIONE: String(21);
    KEY CLUSTER: String(1);
    key COUNTRY: String(3);
    key GIORNO_SETTIMANA: String(3);
    N_CASSE_GIORNO_CLUSTER: Decimal;
    QTA_SCONTRINO_GIORNO_CLUSTER: Decimal;
    N_SCONTRINI_CLUSTER: Integer;
    N_CASSE_GIORNO_REGIONE: Decimal;
    QTA_SCONTRINO_GIORNO_REGIONE: Decimal;
    N_SCONTRINI_REGIONE: Integer;
    N_CASSE_GIORNO_COUNTRY: Decimal;
    QTA_SCONTRINO_GIORNO_COUNTRY: Decimal;
    N_SCONTRINI_COUNTRY: Integer;
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_007
entity ZKPI_PDV_REPARTO {
    key PDV: String(32);
    key ANNO_MESE: String(6);
    LORDO_TOTALE: Decimal default 0.00;
    LORDO_MACELLERIA: Decimal default 0.00;
    BP_MACELLERIA: String(10);
    LORDO_PESCHERIA: Decimal default 0.00;
    BP_PESCHERIA: String(10);
    LORDO_PASTICCERIA: Decimal default 0.00;
    BP_PASTICCERIA: String(10);
    LORDO_GASTRONOMIA: Decimal default 0.00;
    BP_GASTRONOMIA: String(10);
    LORDO_PANETTERIA: Decimal default 0.00;
    BP_PANETTERIA: String(10);
    LORDO_ABBIGLIAMENTO: Decimal default 0.00;
    BP_ABBIGLIAMENTO: String(10);
    LORDO_LATTICINI: Decimal default 0.00;
    BP_LATTICINI: String(10);
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

//ZCV_PRD_BTP_012
entity ZKPI_COMMENTI_ANAG {
    key ID_COMMENTO: String(3);
    TESTO_COMMENTO: String(60);
    key ID_TIPOLOGIA: String(3);
    TESTO_TIPOLOGIA:String(30);
    UPD_TYPE: String(1);
    UPD_TIME: Timestamp;
};

entity ZKPI_PDV_COMMENTI : managed {
    key PDV: String(32);
    key ANNO: String(4);
    key ID_TIPOLOGIA: String(3);
    TESTO_TIPOLOGIA:String(30);
    ID_COMMENTO: String(3);
    TESTO_COMMENTO: String(60);
    COMMENTO_LIBERO: String;

    @odata.etag
    modifiedAt     : Timestamp  @cds.on.insert: $now  @cds.on.update: $now;
}

define view ZKPI_PDV_ANALYTICS_V as
    select distinct
        key anag.PDV,
        key anal.ANNO_MESE,
        fore.RESA_MQ_LORDA as RESA_LORDA,
        anal.RESA_REGIONE,
        anal.RESA_CLUSTER,
        anal.RESA_COUNTRY,
        scontr.N_SCONTRINI,
        scontr.SCONTR_MEDIO,
        anal.SCONTRINO_MEDIO_REGIONE,
        anal.SCONTRINO_MEDIO_CLUSTER,
        anal.SCONTRINO_MEDIO_COUNTRY,
        scontr.N_PROD_SCONTR as CODICE_SCONTRINO,
        anal.CODICE_SCONTRINO_REGIONE,
        anal.CODICE_SCONTRINO_CLUSTER,
        anal.CODICE_SCONTRINO_COUNTRY,
        scontr.QTA_SCONTR,
        anal.QTA_SCONTRINO_REGIONE,
        anal.QTA_SCONTRINO_CLUSTER,
        anal.QTA_SCONTRINO_COUNTRY,
        rep.LORDO_LATTICINI,
        anal.LORDO_LATTICINI_REGIONE,
        anal.LORDO_LATTICINI_CLUSTER,
        anal.LORDO_LATTICINI_COUNTRY,
        rep.LORDO_PESCHERIA,
        anal.LORDO_PESCHERIA_REGIONE,
        anal.LORDO_PESCHERIA_CLUSTER,
        anal.LORDO_PESCHERIA_COUNTRY,
        rep.LORDO_MACELLERIA,
        anal.LORDO_MACELLERIA_REGIONE,
        anal.LORDO_MACELLERIA_CLUSTER,
        anal.LORDO_MACELLERIA_COUNTRY,
        rep.LORDO_GASTRONOMIA,
        anal.LORDO_GASTRONOMIA_REGIONE,
        anal.LORDO_GASTRONOMIA_CLUSTER,
        anal.LORDO_GASTRONOMIA_COUNTRY,
        rep.LORDO_ABBIGLIAMENTO,
        anal.LORDO_ABBIGLIAMENTO_REGIONE,
        anal.LORDO_ABBIGLIAMENTO_CLUSTER,
        anal.LORDO_ABBIGLIAMENTO_COUNTRY,
        rep.LORDO_PANETTERIA,
        anal.LORDO_PANETTERIA_REGIONE,
        anal.LORDO_PANETTERIA_CLUSTER,
        anal.LORDO_PANETTERIA_COUNTRY,
        rep.LORDO_PASTICCERIA,
        anal.LORDO_PASTICCERIA_REGIONE,
        anal.LORDO_PASTICCERIA_CLUSTER,
        anal.LORDO_PASTICCERIA_COUNTRY
    from ZKPI_PDV_ANAG as anag
        left outer join ZKPI_ANALYTICS as anal
            on anal.REGIONE = anag.REGIONE
            and anal.CLUSTER = anag.CLUSTER_DIMENSIONALE
            and anal.COUNTRY = anag.COUNTRY
            and anal.UPD_TYPE <> 'D'
        left outer join ZKPI_PDV_FORECAST as fore
            on anag.PDV = fore.PDV
            and fore.ANNO = SUBSTRING(anal.ANNO_MESE, 1, 4)
            and fore.UPD_TYPE <> 'D'
            and anag.UPD_TYPE <> 'D'
        left outer join ZKPI_PDV_SCONTR as scontr
            on anag.PDV = scontr.PDV
            and anal.ANNO_MESE = scontr.ANNO_MESE
        left outer join ZKPI_PDV_REPARTO as rep
            on anag.PDV = rep.PDV
            and anal.ANNO_MESE = rep.ANNO_MESE
    where anal.ANNO_MESE is not null;    

define view ZKPI_PDV_ANALYTICS_TIME_RANGE_V as 
    select distinct
        key anag.PDV,
        key scontr.ANNO_MESE,
        key scontr.FASCIA_ORARIA,
        scontr.N_CASSE_ORARIA,
        anal.N_CASSE_ORARIA_REGIONE,
        anal.N_CASSE_ORARIA_CLUSTER,
        anal.N_CASSE_ORARIA_COUNTRY,
        scontr.QTA_SCONTR_ORARIA,
        anal.QTA_SCONTRINO_ORARIA_REGIONE,
        anal.QTA_SCONTRINO_ORARIA_CLUSTER,
        anal.QTA_SCONTRINO_ORARIA_COUNTRY,
        scontr.N_SCONTRINI,
        anal.N_SCONTRINI_REGIONE,
        anal.N_SCONTRINI_CLUSTER,
        anal.N_SCONTRINI_COUNTRY
    from ZKPI_PDV_ANAG as anag
        left outer join ZKPI_PDV_SCONTR_TIME_RANGE as scontr
        on  anag.PDV =  scontr.PDV
        and anag.UPD_TYPE <> 'D'
        left outer join ZKPI_ANALYTICS_TIME_RANGE as anal
        on anag.REGIONE = anal.REGIONE
        and anag.CLUSTER_DIMENSIONALE = anal.CLUSTER
        and anal.COUNTRY = anag.COUNTRY
        and scontr.ANNO_MESE = anal.ANNO_MESE 
        and scontr.FASCIA_ORARIA = anal.FASCIA_ORARIA
        and anal.UPD_TYPE <> 'D'
        and scontr.UPD_TYPE <> 'D'
    where anal.ANNO_MESE is not null;

define view ZKPI_PDV_ANALYTICS_WEEK_DAY_V as 
    select distinct
        key anag.PDV,
        key scontr.ANNO_MESE,
        key scontr.GIORNO_SETT,
        scontr.N_CASSE_GIORNO,
        anal.N_CASSE_GIORNO_REGIONE,
        anal.N_CASSE_GIORNO_CLUSTER,
        anal.N_CASSE_GIORNO_COUNTRY,
        scontr.QTA_SCONTR_GIORNO,
        anal.QTA_SCONTRINO_GIORNO_REGIONE,
        anal.QTA_SCONTRINO_GIORNO_CLUSTER,
        anal.QTA_SCONTRINO_GIORNO_COUNTRY,
        scontr.N_SCONTRINI,
        anal.N_SCONTRINI_REGIONE,
        anal.N_SCONTRINI_CLUSTER,
        anal.N_SCONTRINI_COUNTRY
    from ZKPI_PDV_ANAG as anag
        left outer join ZKPI_PDV_SCONTR_WEEK_DAY as scontr
        on  anag.PDV =  scontr.PDV
        and anag.UPD_TYPE <> 'D'
        left outer join ZKPI_ANALYTICS_WEEK_DAY as anal
        on anag.REGIONE = anal.REGIONE
        and anag.CLUSTER_DIMENSIONALE = anal.CLUSTER
        and anal.COUNTRY = anag.COUNTRY
        and scontr.ANNO_MESE = anal.ANNO_MESE 
        and scontr.GIORNO_SETT = anal.GIORNO_SETTIMANA
        and anal.UPD_TYPE <> 'D'
        and scontr.UPD_TYPE <> 'D'          
    where anal.ANNO_MESE is not null;

entity ZKPI_PDV_ANALYTICS_AGGR(PDV: String(32) null, ANNO_MESE_DA : String(8) default '202001', ANNO_MESE_A : String(8) default '202012') as
        select from  ZKPI_PDV_ANALYTICS_V as a
        {
            key a.PDV,
            SUM(a.RESA_LORDA) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as RESA_LORDA : Decimal,
            SUM(a.RESA_REGIONE) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as RESA_REGIONE : Decimal,
            SUM(a.RESA_CLUSTER) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as RESA_CLUSTER : Decimal,
            SUM(a.RESA_COUNTRY) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as RESA_COUNTRY : Decimal,
            SUM(a.N_SCONTRINI)  as N_SCONTRINI : Decimal,
            SUM(a.SCONTR_MEDIO) as SCONTR_MEDIO : Decimal,
            SUM(a.SCONTRINO_MEDIO_REGIONE) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as SCONTRINO_MEDIO_REGIONE : Decimal,
            SUM(a.SCONTRINO_MEDIO_CLUSTER) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as SCONTRINO_MEDIO_CLUSTER : Decimal,
            SUM(a.SCONTRINO_MEDIO_COUNTRY) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as SCONTRINO_MEDIO_COUNTRY : Decimal,
            SUM(a.CODICE_SCONTRINO) as CODICE_SCONTRINO : Decimal,
            SUM(a.CODICE_SCONTRINO_REGIONE ) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as CODICE_SCONTRINO_REGIONE  : Decimal,
            SUM(a.CODICE_SCONTRINO_CLUSTER) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as CODICE_SCONTRINO_CLUSTER  : Decimal,
            SUM(a.CODICE_SCONTRINO_COUNTRY) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as CODICE_SCONTRINO_COUNTRY  : Decimal,
            SUM(a.QTA_SCONTR) as QTA_SCONTR : Decimal,
            SUM(a.QTA_SCONTRINO_REGIONE) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as QTA_SCONTRINO_REGIONE : Decimal,
            SUM(a.QTA_SCONTRINO_CLUSTER) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as QTA_SCONTRINO_CLUSTER : Decimal,
            SUM(a.QTA_SCONTRINO_COUNTRY) / MONTHS_COUNT(:PDV, :ANNO_MESE_DA, :ANNO_MESE_A) as QTA_SCONTRINO_COUNTRY : Decimal,
            SUM(a.LORDO_LATTICINI) as LORDO_LATTICINI : Decimal,
            SUM(a.LORDO_LATTICINI_REGIONE) as LORDO_LATTICINI_REGIONE : Decimal, 
            SUM(a.LORDO_LATTICINI_CLUSTER) as LORDO_LATTICINI_CLUSTER : Decimal,
            SUM(a.LORDO_LATTICINI_COUNTRY) as LORDO_LATTICINI_COUNTRY : Decimal,  
            SUM(a.LORDO_PESCHERIA)  as LORDO_PESCHERIA : Decimal,
            SUM(a.LORDO_PESCHERIA_REGIONE) as LORDO_PESCHERIA_REGIONE : Decimal,
            SUM(a.LORDO_PESCHERIA_CLUSTER) as LORDO_PESCHERIA_CLUSTER : Decimal,  
            SUM(a.LORDO_PESCHERIA_COUNTRY) as LORDO_PESCHERIA_COUNTRY : Decimal,
            SUM(a.LORDO_MACELLERIA) as LORDO_MACELLERIA : Decimal,
            SUM(a.LORDO_MACELLERIA_REGIONE) as LORDO_MACELLERIA_REGIONE: Decimal,
            SUM(a.LORDO_MACELLERIA_CLUSTER) as LORDO_MACELLERIA_CLUSTER: Decimal,
            SUM(a.LORDO_MACELLERIA_COUNTRY) as LORDO_MACELLERIA_COUNTRY: Decimal,
            SUM(a.LORDO_GASTRONOMIA) as LORDO_GASTRONOMIA : Decimal,
            SUM(a.LORDO_GASTRONOMIA_REGIONE) as LORDO_GASTRONOMIA_REGIONE : Decimal,
            SUM(a.LORDO_GASTRONOMIA_CLUSTER) as LORDO_GASTRONOMIA_CLUSTER : Decimal, 
            SUM(a.LORDO_GASTRONOMIA_COUNTRY) as LORDO_GASTRONOMIA_COUNTRY : Decimal,
            SUM(a.LORDO_ABBIGLIAMENTO) as LORDO_ABBIGLIAMENTO : Decimal,
            SUM(a.LORDO_ABBIGLIAMENTO_REGIONE) as LORDO_ABBIGLIAMENTO_REGIONE : Decimal,
            SUM(a.LORDO_ABBIGLIAMENTO_CLUSTER) as LORDO_ABBIGLIAMENTO_CLUSTER : Decimal,
            SUM(a.LORDO_ABBIGLIAMENTO_COUNTRY) as LORDO_ABBIGLIAMENTO_COUNTRY : Decimal,
            SUM(a.LORDO_PANETTERIA) as LORDO_PANETTERIA : Decimal,
            SUM(a.LORDO_PANETTERIA_REGIONE) as LORDO_PANETTERIA_REGIONE : Decimal,
            SUM(a.LORDO_PANETTERIA_CLUSTER) as LORDO_PANETTERIA_CLUSTER : Decimal,
            SUM(a.LORDO_PANETTERIA_COUNTRY) as LORDO_PANETTERIA_COUNTRY : Decimal,
            SUM(a.LORDO_PASTICCERIA) as LORDO_PASTICCERIA : Decimal,
            SUM(a.LORDO_PASTICCERIA_REGIONE) as LORDO_PASTICCERIA_REGIONE : Decimal,
            SUM(a.LORDO_PASTICCERIA_CLUSTER) as LORDO_PASTICCERIA_CLUSTER : Decimal,
            SUM(a.LORDO_PASTICCERIA_COUNTRY) as LORDO_PASTICCERIA_COUNTRY : Decimal        } 
        where
        //Al Fine di rendere non obbligatorio il parametro PDv (parametro inserito per problemi lato FE)        
        (CASE
            WHEN :PDV IS NOT NULL AND :PDV <> '' THEN
                (CASE
                    WHEN a.PDV = :PDV THEN 1
                    ELSE 0
                END)
            ELSE 1
        END) = 1
        and  a.ANNO_MESE >= :ANNO_MESE_DA  
        and a.ANNO_MESE <= :ANNO_MESE_A
        group by a.PDV;