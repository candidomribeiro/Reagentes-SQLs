delimiter #

create trigger 触发器报废瓶子 before delete on 瓶子 -- 触发器 chù fā qì (trigger)
for each row
begin
declare n, nr bigint;
declare dt datetime;
    set n = old.瓶号;
    select 唯一的试剂序列号, 瓶子创立日期 into nr, dt from RFID标签
        join 瓶子 on RFID标签.RFID标签编号 = 瓶子.RFID标签编号
        where 瓶子.瓶号 = n;
    
    insert into 报废(瓶号, 唯一的试剂序列号, RFID标签编号, 瓶型, 瓶子容量, 皮重, 瓶子创立日期, 瓶子丢弃日期)
              values(old.瓶号, nr, old.RFID标签编号, old.瓶型, old.瓶子容量, old.皮重, dt, now());
    delete from 报废标记 where 瓶号 = n;
    
end#

-- drop trigger 触发器报废瓶子; 

delimiter #

create trigger 触发器要求 after insert on 要求 -- 触发器 chù fā qì (trigger)
for each row
begin
declare n bigint;
    set n = new.订单号;
    insert into 要求赞同(订单号, 赞同) values(n, 0);
end#

-- drop trigger 触发器要求;

delimiter #

create trigger 触发器输回 after insert on 输回表
for each row
begin
declare n, bottle bigint;
declare p double;
    set n = new.订单号;
    set p = new.瓶子总重;
    set bottle = (select 瓶号 from 要求 where 订单号 = n);
    
    update 要求赞同 set 赞同 = 2 where 订单号 = n;
    update 瓶子 set 瓶子的总重量 = p where 瓶号 = bottle;
end#
