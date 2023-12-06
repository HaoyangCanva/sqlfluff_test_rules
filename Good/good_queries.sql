with cte as (
  select *
  from staging._fact_attribution_last_non_direct_touch;
)
select id
from cte;


select
  appsflyer_device_id,
  channel,
  source,
  medium,
  attributed_touch_time,
  attributed_touch_type,
  concat(
    appsflyer_device_id, '~',
    channel, '~',
    attributed_touch_time, '~',
    attributed_touch_type
  ) as touchpoint_id
from ds_prod.staging._fact_appsflyer_native_event_fired
-- Need to deduplicate rows because multiple appsflyer events can have the same touchpoint reported by AppsFlyer
qualify row_number() over (
  partition by touchpoint_id
  order by customer_user_id nulls last
) = 1;

select
  p.name as project_name,
  count(b.id) as backings_count
from ksr.projects as p,
  ksr.backings as b
where b.project_id = p.id;


select
  p.name as project_name,
  count(b.id) as backings_count
from ksr.projects as p
join ksr.backings as b
  on p.id = b.project_id
  and b.project_country != 'US';

select
  name,
  goal,
  case
    when category = 'Art'
      and country = 'US'
      then art_backer_id
    else food_backer_id
  end as backer_id
from ksr.projects
where country = 'US'
  and deadline >= '2015-01-01';

select
  timestamp,
  user_id,
  context_ip_f
from event.event_homepage_visit_logged_in -- Web visit homepage

union all

select
  timestamp,
  user_id,
  context_ip_f
from event.event_layout_added -- android

union all

select
  timestamp,
  user_id,
  context_ip_f
from event.event_layout_add; -- iOS


select
  country_name,
  count(*) as users
from model.dim_country
group by country_name;

