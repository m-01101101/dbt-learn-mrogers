{{config(
    materialized = 'incremental',
    unique_key = 'page_view_id'
)}}

with events as (
    select * from {{source('snowplow','event')}}
    {% if is_incremental() %}
    {# "using the max timestamp will not allow us to append late arriving data" #}
    where collector_tstamp >= (select max(max_collector_tstamp) from {{ this }})
    {% endif %}
)

, page_views as (
    select
        domain_sessionid as session_id
        , domain_userid as anonymous_user_id
        -- page_view_id is the unique key
        -- checks if the row has changed and updates or appends
        , web_page_context.value:data.id::varchar as page_view_id
        , page_url
        , count(*) * 10 as approx_time_on_page
        , min(derived_tstamp) as page_view_start
        , max(collector_tstamp) as max_collector_tstamp
    from events,
    lateral flatten (input => parse_json(contexts):data) web_page_context
    group by 1,2,3,4
)

select * from page_views