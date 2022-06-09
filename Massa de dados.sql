insert into 试剂 values(1234, '硫酸', '酸', '腐蚀', 365, '危险');
insert into 试剂 values(1235, '氢氧化钠', '硷质', '苛性', 365, '危险');
insert into 试剂 values(1236, '硫酸铜', '酸盐', '盐', 600, '毒药');
insert into 试剂 values(1237, '氰化钾', '氰化物', '盐', 365, '毒药');
insert into 试剂 values(1238, '硝酸银', '硝酸盐', '盐', 365, '小心');

insert into RFID标签 values (9876, 1234, now());
insert into RFID标签 values (9877, 1234, now());
insert into RFID标签 values (9878, 1234, now());
insert into RFID标签 values (9879, 1234, now());
insert into RFID标签 values (9880, 1235, now());
insert into RFID标签 values (9881, 1235, now());
insert into RFID标签 values (9882, 1235, now());
insert into RFID标签 values (9883, 1236, now());
insert into RFID标签 values (9884, 1237, now());
insert into RFID标签 values (9885, 1237, now());
insert into RFID标签 values (9886, 1238, now());

insert into 瓶子 values(1, 9876, now(), adddate(now(),365), '瓶子', 437.5312, 99.7, 500.2987);
insert into 瓶子 values(2, 9877, now(), adddate(now(),365), '瓶子', 436.5917, 98.3, 500.111);
insert into 瓶子 values(3, 9878, now(), adddate(now(),365), '瓶子', 439.7411, 96.7, 502.2);
insert into 瓶子 values(4, 9879, now(), adddate(now(),365), '瓶子', 440.5, 100.01, 505.9);
insert into 瓶子 values(5, 9880, now(), adddate(now(),365), '瓶子', 999.98, 75.01, 1171.15327);
insert into 瓶子 values(6, 9881, now(), adddate(now(),365), '瓶子', 990.98, 70.01, 1000.327);
insert into 瓶子 values(7, 9882, now(), adddate(now(),365), '瓶子', 1000.98, 75.77, 1071.7);
insert into 瓶子 values(8, 9883, now(), adddate(now(),600), '袋子', 1000.0, 5.0, 1005.0);
insert into 瓶子 values(9, 9884, now(), adddate(now(),365), '袋子', 500.8, 5.2, 506.0);
insert into 瓶子 values(10, 9885, now(), adddate(now(),365), '袋子', 430.7, 5.1, 503.1);
insert into 瓶子 values(11, 9886, now(), adddate(now(),365), '袋子', 412.8, 7.0, 506.0);

insert into 仓库地方 values(1, 88, 100, 1, null);
insert into 仓库地方 values(2, 88, 100, 0, null);
insert into 仓库地方 values(3, 88, 100, 2, null);
insert into 仓库地方 values(4, 88, 100, 1, null);
insert into 仓库地方 values(5, 88, 101, 0, null);
insert into 仓库地方 values(6, 88, 101, 0, null);
insert into 仓库地方 values(7, 88, 101, 1, null);
insert into 仓库地方 values(8, 88, 100, 0, null);
insert into 仓库地方 values(9, 88, 100, 0, null);
insert into 仓库地方 values(10, 88, 100, 1, null);
insert into 仓库地方 values(11, 88, 100, 1, null);

insert into 试剂用户 values(null, 'zhang','张颖',123456789, 'test@shiyuan.sy', 987654321, now());
insert into 试剂用户 values(null, 'hei','黑山', 369124578, 'hei@shiyuan.sy', 54621557, now());
insert into 试剂用户 values(null, 'yaya','李丫丫', 897545231, 'yaya@shiyuan.sy', 45687126, now());
insert into 试剂用户 values(null, 'sb', '孙武', 56487851,'sb@shiyuan.sy', 78945612, now());

insert into 用户凭据 values(3, 1234, now());
insert into 用户凭据 values(3, 1235, now());
insert into 用户凭据 values(3, 1236, now());
insert into 用户凭据 values(3, 1237, now());
insert into 用户凭据 values(3, 1238, now());

insert into 用户凭据 values(4, 1234, now());
insert into 用户凭据 values(4, 1234, now());

insert into 用户凭据 values(1, 1234, now());
insert into 用户凭据 values(1, 1235, now());
insert into 用户凭据 values(1, 1238, now());

insert into 用户凭据 values(2, 1234, now());
insert into 用户凭据 values(2, 1235, now());
insert into 用户凭据 values(2, 1237, now());
insert into 用户凭据 values(2, 1238, now());

insert into 试剂采购 values(1234, 2378.5, now());

insert into 异常行为 values(1, 4, 99, now());

insert into 要求 values (1, null, now(), 1, adddate(now(), 1), adddate(now(),10), 7, null);
