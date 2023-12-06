select *
from staging._fact_attribution_last_non_direct_touch;

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
  partition by
    appsflyer_device_id,
    channel,
    attributed_touch_time,
    attributed_touch_type
  order by customer_user_id nulls last
) = 1;

select
  p.name as project_name,
  count(b.id) as backings_count
from ksr.projects as p
join ksr.backings as b
  on b.project_id = p.id;

select
  col_1,
  col_2,
from model.dim_user as u
  , lateral flatten (input => output) as o;


select timestamp, user_id, context_ip_f
from event.event_homepage_visit_logged_in -- Web visit homepage
union all
select timestamp, user_id, context_ip_f
from event.event_layout_added -- android
union all
select timestamp, user_id, context_ip_f
from event.event_layout_add; -- iOS

select
  country_name,
  count(*) as users
from model.dim_country
group by 1
order by 1 asc;