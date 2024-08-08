SELECT 
  date_date,
  ROUND(operational_margin - ads_cost,1) AS ads_margin,
  ROUND(average_basket,2) AS average_basket,
  operational_margin,
  ads_cost,
  ads_impression,
  ads_clicks,
  revenue,
  margin,
FROM {{ ref('int_campaigns_day') }}
FULL OUTER JOIN {{ ref('finance_days') }} 
  USING (date_date)
ORDER BY date_date DESC