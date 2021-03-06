
select  
   sum(ws_ext_discount_amt)  as "Excess Discount Amount" 
into pg_temp.tpcds_q92
from 
    web_sales 
   ,item 
   ,date_dim
where
i_manufact_id = 269
and i_item_sk = ws_item_sk 
and d_date between '1998-03-18' and 
        (cast('1998-03-18' as date) + '90 days'::interval)
and d_date_sk = ws_sold_date_sk 
and ws_ext_discount_amt  
     > ( 
         SELECT 
            1.3 * avg(ws_ext_discount_amt) 
         FROM 
            web_sales 
           ,date_dim
         WHERE 
              ws_item_sk = i_item_sk 
          and d_date between '1998-03-18' and
                             (cast('1998-03-18' as date) + '90 days'::interval)
          and d_date_sk = ws_sold_date_sk 
      ) 
order by sum(ws_ext_discount_amt)
limit 100;




--- validation check
(SELECT * FROM pg_temp.tpcds_q92.sql
 EXCEPT
 SELECT * FROM public.tpcds_q92.sql);
(SELECT * FROM public.tpcds_q92.sql
 EXCEPT
 SELECT * FROM pg_temp.tpcds_q92.sql);
