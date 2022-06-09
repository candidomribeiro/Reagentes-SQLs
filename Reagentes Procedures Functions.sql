delimiter #

create function 功能核实用户凭据 (v用户 bigint, v瓶号 bigint)
returns bigint deterministic
begin
declare 结果 bigint;
    
   select count(*) into 结果 -- RFID标签.唯一的试剂序列号, 用户凭据.用户, 瓶子.瓶号
   from RFID标签
   join 瓶子 on RFID标签.RFID标签编号 = 瓶子.RFID标签编号
   join 用户凭据 on 用户凭据.唯一的试剂序列号 = RFID标签.唯一的试剂序列号
   where 用户凭据.用户 = v用户 and 瓶子.瓶号 = v瓶号;
   
return 结果;
end#


delimiter #

create procedure 程序要求(in v用户 bigint, in 操作类型 bigint, in 开始日期 datetime, in 结束日期 datetime, 
                          in v瓶号 bigint, in 注释 varchar(512))    
begin
    declare bottle, reagent bigint;
    select 瓶号, 唯一的试剂序列号 into bottle, reagent from 视野瓶可用 where 唯一的试剂序列号 in
    (
        select 唯一的试剂序列号 from 用户凭据 where 用户 = v用户
    ) and 瓶号 = v瓶号;

    if bottle is not null then
        insert into 要求(订单号, 用户, 唯一的试剂序列号, 订单日期, 操作类型, 开始日期, 结束日期, 瓶号, 注释) 
		         values (null, v用户, reagent, now(), 操作类型, 开始日期, 结束日期, v瓶号, 注释);
    else
        signal sqlstate '45000' set message_text = '瓶子不可用或未经授权';
	end if;
end#

delimiter #

create procedure 程序用户删除(in v用户名 varchar(128))
begin
    declare id bigint default 0;
    
    select 用户 into id from 试剂用户 where 用户名 = v用户名; 
    
        delete from 用户凭据 where 用户 = id;
        update 试剂用户 set 用户名 = null, 工号 = null where 用户 = id;
end#

delimiter #

create procedure 程序产品输出(in v用户名 varchar(128), v瓶号 bigint, v出口总瓶重 double)
begin
    declare v订单号, v用户 bigint;
	
	select 要求.订单号, 试剂用户.用户 into v订单号, v用户
	from 要求 
    join 要求赞同 on 要求.订单号 = 要求赞同.订单号
    join 试剂用户 on 试剂用户.用户 = 要求.用户
    where 赞同 = 1 and 用户名 = v用户名 and 瓶号 = v瓶号;
    
	if v订单号 is not null then
	    insert into 输出表 (用户, 订单号, 出发日期, 出口总瓶重) 
		            values (v用户, v订单号, now(), v出口总瓶重);
		update 要求赞同 set 赞同 = 10 where 订单号 = v订单号;
	else
        signal sqlstate '45000' set message_text = '未经授权或已经在进行中';
	end if;
end#

delimiter #

create procedure 程序产品退回(in v瓶号 bigint, v瓶子总重 double)
begin
    declare v订单号, v用户 bigint;
	
	select /* 要求.瓶号, */ 输出表.用户, 输出表.订单号 into v用户, v订单号
    from 输出表 
    left outer join 输回表 on 输回表.订单号 = 输出表.订单号
    join 要求 on 要求.订单号 = 输出表.订单号
    where 输回表.订单号 is null and 要求.瓶号 = v瓶号;
	
	if v订单号 is not null then
	    insert into 输回表(用户, 订单号, 归期, 瓶子总重) 
		           values (v用户, v订单号, now(), v瓶子总重);
	else
	    signal sqlstate '45000' set message_text = '订单号没找到';
	end if;
end#


delimiter #

create procedure 程序格律学 (in 开始日期 datetime, in 结束日期 datetime)
begin
    declare tm bigint;
    set tm = datediff(结束日期, 开始日期) + 1;
    drop temporary table if exists tmp;
    create temporary table tmp
    (
        n bigint,
        nome varchar(128),
        qtde double default 0,
        tempo bigint default 0
    );
    
    insert into tmp(n,nome)
        select 唯一的试剂序列号, 试剂名称 from 试剂;
    
    insert into tmp(n,nome,qtde,tempo)
        select n, nome, round(sum(qtde),4),tm from
        (
             select 试剂.唯一的试剂序列号 as n , 试剂名称 as nome, 
             ifnull(出口总瓶重 - 瓶子总重,0) as qtde, 出发日期 as dtini, 归期 as dtfinal
             from 试剂 
             left outer join 要求 on 试剂.唯一的试剂序列号 = 要求.唯一的试剂序列号
             left outer join 输出表 on 输出表.订单号 = 要求.订单号
             left outer join 输回表 on 输回表.订单号 = 要求.订单号
		)x
        where dtini > 开始日期 and dtfinal < 结束日期
        group by n;
end#


delimiter #

create procedure 程序周期分析 (in 瓶子创立日期 datetime, in 瓶子丢弃日期 datetime)
begin
    declare tm bigint;
	set tm = datediff(瓶子丢弃日期, 瓶子创立日期) + 1;
	
    drop temporary table if exists tmpcicle;
    create temporary table tmpcicle
    (
        唯一的试剂序列号 bigint,
	    试剂名称 varchar(128),
	    订单号 bigint,
	    出口总瓶重 double,
	    瓶子总重 double,
	    瓶子创立日期 datetime,
	    瓶子丢弃日期 datetime,
		天 bigint
    );
    
    insert into tmpcicle
    select 试剂.唯一的试剂序列号, 试剂名称, 要求.订单号, 输出表.出口总瓶重, 输回表.瓶子总重, 瓶子创立日期, 瓶子丢弃日期, tm
    from 试剂
    join 报废 on 试剂.唯一的试剂序列号 = 报废.唯一的试剂序列号
    join 要求 on 要求.瓶号 = 报废.瓶号
    join 输出表 on 输出表.订单号 = 要求.订单号
    join 输回表 on 输回表.订单号 = 要求.订单号;  
    
end#
