select t1.唯一的试剂序列号 as 唯一的试剂序列号, t1.试剂名称 as 试剂名称, sum(t5.出口总瓶重 - t6.瓶子总重) as 数量,
	   sum(timediff(t6.归期, t5.出发日期)) / 86400 as 时期
from 试剂 as t1
left outer join RFID标签 as t2 on t1.唯一的试剂序列号 = t2.唯一的试剂序列号
left outer join 瓶子 as t3 on t3.RFID标签编号 = t2.RFID标签编号
left outer join 要求 as t4 on t3.瓶号 = t4.瓶号
left outer join 输出表 as t5 on t5.订单号 = t4.订单号
left outer join 输回表 as t6 on t6.订单号 = t5.订单号
where (出发日期 > '2021-10-11T12:00:00' and 归期 < '2021-10-12T15:20:55') or 出发日期 is null
group by t1.唯一的试剂序列号
)x;

************************************************************************
3.12

select 试剂名称, min(qtde), max(qtde), avg(qtde), max(d1) - min(d1) + 1 from
(
select 试剂.唯一的试剂序列号, 试剂.试剂名称, round(出口总瓶重 - 瓶子总重, 4) as qtde, 
date(归期) as d1, date(出发日期) as d2 -- , date(瓶子创立日期),date(瓶子丢弃日期)
from 报废
join 试剂 on 试剂.唯一的试剂序列号 = 报废.唯一的试剂序列号
join 要求 on 报废.瓶号 = 要求.瓶号
join 输出表 on 输出表.订单号 = 要求.订单号
join 输回表 on 输回表.订单号 = 要求.订单号
where 瓶子创立日期 > '2021-10-05' and 瓶子丢弃日期 < '2021-10-14'
)x;

create temporary table mytable
(
    n bigint,
    nome varchar(128),
    qtde double,
    dtini datetime,
    dtfinal datetime
);

insert into mytable (n, nome, qtde)
select 唯一的试剂序列号, 试剂名称, 0 from 试剂;

select n as 唯一的试剂序列号, nome as 试剂名称, sum(qtde) as 数量, tempo as 天, sum(qtde)/tempo as 数量除天 from tmp group by n, nome;

create temporary table tmpcicle
(
    唯一的试剂序列号 bigint,
	试剂名称 varchar(128),
	订单号 bigint,
	出口总瓶重 double,
	瓶子总重 double,
	瓶子创立日期 datetime,
	瓶子丢弃日期 datetime
);

select 唯一的试剂序列号, 试剂名称, round(sum(出口总瓶重 - 瓶子总重),4) as 一共, round(min(出口总瓶重 - 瓶子总重),4) as 最小, round(max(出口总瓶重 - 瓶子总重),4) as 最大, 天, round(sum(出口总瓶重 - 瓶子总重) / 天,4) as 一共除天 from tmpcicle group by 唯一的试剂序列号, 试剂名称;

select count(试剂.唯一的试剂序列号) as 数, 试剂.唯一的试剂序列号, 试剂.试剂名称, 试剂.试剂类别,
round(sum(试剂采购.购买数量),4) as 一共, 试剂采购.购买日期时间
from 试剂 join 试剂采购 on 试剂.唯一的试剂序列号 = 试剂采购.唯一的试剂序列号
where 试剂采购.购买日期时间 between '2021-10-06' and '2021-10-07'
group by 试剂.唯一的试剂序列号, 试剂.试剂名称, 试剂.试剂类别;