select    *
from      svv_table_info
order by  size desc
limit     30; -- find the top 30 largest tables. size measuered in MB

select    sum(used)::float / sum(capacity) as percentage_cap_used
from      stv_partitions;  --find how much space is left

SELECT    *
FROM      pg_locks; -- what tables are being locked out

select    *
from      stl_tr_conflict; -- lock conflicts


select    userid, query, pid, starttime, left(text, 50) as text
from      stv_inflight   -- current queries running


select
  table_id,
  last_update,
  last_commit,
  lock_owner_pid,
  lock_status
from stv_locks
order by last_update asc




select t.name, count(tbl) / 1000.0 as gb
from (
	select distinct datname id, name
	from stv_tbl_perm
		join pg_database on pg_database.oid = db_id
	) t
join stv_blocklist on tbl=t.id
group by t.name order by gb desc -- find how much space each table is using

select          a.pid, count(a.locktype)
from            pg_locks a
join            stv_inflight b
on              a.pid=b.pid
group by        a.pid order by count desc;

select * from pg_locks  limit 1

select * from stv_inflight limit 2


-- Check table specific permissions for each user
SELECT *
FROM
    (
    SELECT
        schemaname
        ,objectname
        ,usename
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'select') AS sel
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'insert') AS ins
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'update') AS upd
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'delete') AS del
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'references') AS ref
    FROM
        (
        SELECT schemaname, 't' AS obj_type, tablename AS objectname, schemaname + '.' + tablename AS fullobj FROM pg_tables
        WHERE schemaname not in ('pg_internal')
        UNION
        SELECT schemaname, 'v' AS obj_type, viewname AS objectname, schemaname + '.' + viewname AS fullobj FROM pg_views
        WHERE schemaname not in ('pg_internal')
        ) AS objs
        ,(SELECT * FROM pg_user) AS usrs
    ORDER BY fullobj
    )
WHERE (sel = true or ins = true or upd = true or del = true or ref = true)


-- Get a list of users, then a list of user to group mappings
SELECT *
FROM pg_user

SELECT *
FROM pg_group

-- Grant a specific permission to a specific group
GRANT SELECT ON TABLE schemaname.tablename TO GROUP groupname;

-- Create a new user in a specific group
create user guest password 'ABCd4321' in group read_only;

-- Add an existing user to an existing group
alter group webpowerusers add user webappuser2;


