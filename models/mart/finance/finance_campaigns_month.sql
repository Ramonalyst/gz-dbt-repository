SELECT 
  date_trunc(date_date, MONTH) AS datemonth,
  ROUND(SUM(operational_margin - ads_cost),1) AS ads_margin,
  ROUND(SUM(average_basket),2) AS average_basket,
  ROUND(SUM(operational_margin),2) AS operational_margin,
  SUM(ads_cost) AS ads_cost,
  SUM(ads_impression) AS ads_impression,
  SUM(ads_clicks) AS ads_clicks,
  SUM(revenue) AS revenue,
  SUM(margin) AS margin,
FROM {{ ref('int_campaigns_day') }}
FULL OUTER JOIN {{ ref('finance_days') }} 
  USING (date_date)
GROUP BY datemonth
ORDER BY datemonth DESC