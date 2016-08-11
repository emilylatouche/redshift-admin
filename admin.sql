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
from      stv_inflight 


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

