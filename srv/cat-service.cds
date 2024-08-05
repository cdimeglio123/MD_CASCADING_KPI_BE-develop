using db from '../db/data-model';

@path: '/cascading-kpi'
@(requires: ['authenticated-user'])
service CascadingKPI @(impl: 'srv/cat-service.js') {

TYPE ZKPI_PDV_ECONOMICO_AGGR{
    PDV: String(32);
    ANNO_MESE: String(6);
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
}

@readonly entity PdvAnag as projection on db.ZKPI_PDV_ANAG where UPD_TYPE <> 'D';
@readonly entity PdvForecast as projection on db.ZKPI_PDV_FORECAST where UPD_TYPE <> 'D';
@readonly entity PdvEconomicoAggr(PDV: String(32), ANNO_MESE_DA: String(8), ANNO_MESE_A: String(8)) as select from  db.ZKPI_PDV_ECONOMICO_AGGR(PDV: :PDV, ANNO_MESE_DA: :ANNO_MESE_DA,ANNO_MESE_A: :ANNO_MESE_A ){*};
@readonly entity PdvVenSmi as projection on db.ZKPI_PDV_VENSMI where UPD_TYPE <> 'D';
@readonly entity PdvScontr as projection on db.ZKPI_PDV_SCONTR where UPD_TYPE <> 'D';
@readonly entity KPICommAnag as projection on db.ZKPI_COMMENTI_ANAG where UPD_TYPE <> 'D';
          entity PdvCommenti as projection on db.ZKPI_PDV_COMMENTI;  
@readonly entity PdvAnalytics as projection on db.ZKPI_PDV_ANALYTICS_V;
@readonly entity PdvAnalyticsAggr (PDV: String(32), ANNO_MESE_DA: String(8), ANNO_MESE_A: String(8)) as select from db.ZKPI_PDV_ANALYTICS_AGGR(PDV: :PDV, ANNO_MESE_DA: :ANNO_MESE_DA,ANNO_MESE_A: :ANNO_MESE_A ){*};
@readonly entity PdvAnalyticsTimeRange as projection on db.ZKPI_PDV_ANALYTICS_TIME_RANGE_V;
@readonly entity PdvAnalyticsWeekDay as projection on db.ZKPI_PDV_ANALYTICS_WEEK_DAY_V;
@readonly entity PdvWeight as projection on db.ZKPI_PDV_WEIGHT;
@readonly entity LastMonthCE as select from db.ZKPI_PDV_ECONOMICO distinct {key ANNO_MESE: String} order by ANNO_MESE desc limit 1;
};