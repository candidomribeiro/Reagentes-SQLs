-- 在MySQL中，需要一次运行一个'create table'

create table 试剂                                  -- reagentes
(
    唯一的试剂序列号 bigint primary key,           -- número de série exclusivo do reagente(chave primária PK1)
    试剂名称         varchar(128) not null,        -- nome do reagente
    试剂的化学功能   varchar(128) not null,        -- função química do reagente
    试剂类别         varchar(128) not null,        -- categoria do reagente
    报废多少天       bigint not null,              -- tempo de sucateamento (em dias)
    注释             varchar(512)                  -- observações
);

create table RFID标签                              -- etiquetas RFID
(
    RFID标签编号     bigint primary key,           -- número da etiqueta RFID (chave primária PK2)
    唯一的试剂序列号 bigint ,
    foreign key (唯一的试剂序列号) references 试剂(唯一的试剂序列号),
    创立日期         datetime not null             -- data da criação
);

create table 瓶子                                  -- frascos
(
    瓶号             bigint primary key,           -- número do frasco (chave primária PK4)
    RFID标签编号     bigint unique,                -- número da etiqueta RFID (chave estrangeira FK2 referencia PK2)
    foreign key (RFID标签编号) references RFID标签(RFID标签编号) on delete cascade on update cascade,
	瓶子创立日期     datetime not null,            -- data da criação
	报废日期         datetime not null,            -- data do sucateamento (prevista na validade)
    瓶型             varchar(128),                 -- tipo do frasco
    瓶子容量         double,                       -- capacidade do frasco
    皮重             double,                       -- tara
    瓶子的总重量     double                        -- peso bruto do frasco
);

create table 仓库地方                              -- local de armazenamento
(
    瓶号             bigint primary key,           -- número do frasco (chave primaria, chave estrangeira única FK1 referencia PK4)
    foreign key (瓶号) references 瓶子(瓶号) on delete cascade on update cascade,
	仓库编号         bigint,                       -- número do armazém
    柜号             bigint,                       -- número do gabinete
    地位             bigint,                       -- status
    其他信息         varchar(512)                  -- outras informações
);

create table 试剂用户                              -- usuários dos reagentes
(
    用户             bigint auto_increment primary key,  -- id usuário (chave primária PK3)
	工号             bigint unique                 -- id de trabalho
    用户名           varchar(128) unique,          -- nome do usuário único
	名字             varchar(128) not null,        -- nome real
	身份证号         varchar(64) not null,         -- número da identidade
	邮件             varchar(128) not null,        -- email
	电话号码         varchar(64),                  -- telefone
    注册日期         datetime not null             -- data do registro
);

create table 用户凭据                              -- credenciais do usuário
(
    注册号           bigint auto_increment primary key,
    用户             bigint,                       -- id usuário (chave estrangeira FK4 referencia PK3)
    foreign key (用户) references 试剂用户(用户),
    唯一的试剂序列号 bigint,                       -- número de série exclusivo do reagente (chave estrangeira FK5 referencia PK1)
    foreign key (唯一的试剂序列号) references 试剂(唯一的试剂序列号),
    凭据更新日期     datetime not null             -- data de atualização das credenciais
);

create table 仓库经理                              -- gerente do armazém
(
    用户 bigint,                                   -- id do gerente
    foreign key (用户) references 试剂用户(用户),  -- chave estrangeira referencia PK3
    仓库编号 bigint,                               -- número do armazém
    注册日期 datetime not null                     -- data do registro 
);

create table 要求                                  -- pedidos
(
    check (开始日期 < 结束日期),
    订单号           bigint auto_increment primary key, -- número do pedido (único)
    用户             bigint not null,              -- id usuário (chave estrangeira FK6 referencia PK3)
    foreign key (用户) references 试剂用户(用户),
	唯一的试剂序列号 bigint not null,              -- númento de série exclusivo do reagente
	foreign key (唯一的试剂序列号) references 试剂(唯一的试剂序列号), -- chave estrangeira FK10 referencia PK1
    订单日期         datetime not null,            -- data do pedido
    操作类型         bigint,                       -- tipo de operação
    开始日期         datetime not null,            -- data início
    结束日期         datetime not null,            -- data fim
    瓶号             bigint not null,              -- número do frasco 
    注释             varchar(512)                  -- observações
);

create table 输出表                                -- saída
(
--    输出号           bigint auto_increment primary key,
    用户             bigint not null,              -- id usuário (chave estrangeira FK9 referencia PK3)
    foreign key (用户) references 试剂用户(用户),
    订单号           bigint unique,                -- número do pedido (único)
    出发日期         datetime not null,            -- data de saída
    出口总瓶重       double                        -- peso bruto do frasco na saída
);

create table 输回表                                -- devolução
(
--    输回号           bigint auto_increment primary key,          
    用户             bigint not null,              -- id usuário (chave estrangeira FK7 referencia PK3)
    foreign key (用户) references 试剂用户(用户),
    订单号           bigint unique,                -- número do pedido (único)
    归期             datetime not null,            -- data da devolução
    瓶子总重         double                        -- peso bruto do frasco
);

create table 报废                                  -- sucateamento
(   
    check (瓶子创立日期 < 瓶子丢弃日期),
    瓶号             bigint primary key,           -- número do frasco 
    唯一的试剂序列号 bigint,                       -- número de série exclusivo do reagente
    RFID标签编号     bigint,                       -- número da etiqueta RFID
	瓶型             varchar(128),                 -- tipo do frasco
    瓶子容量         double,                       -- capacidade do frasco
    皮重             double,                       -- tara
	瓶子创立日期     datetime not null,            -- data da criação
    瓶子丢弃日期     datetime not null             -- data e hora do descarte do frasco 
);

create table 异常行为                              -- comportamento anormal
(
--    注册号           bigint auto_increment primary key,
    用户             bigint not null,              -- id usuário (chave estrangeira FK8 referencia PK3)
	foreign key (用户) references 试剂用户(用户),
    一种例外         bigint not null,              -- tipo de exceção
    操作类型         bigint not null,              -- tipo de operação
    日期时间         datetime not null             -- data e hora
);

create table 试剂采购                              -- Aquisição de reagentes
(
--    采购号           bigint auto_increment primary key,
    唯一的试剂序列号 bigint not null,              -- número de série exclusivo do reagente
    购买数量         double not null,              -- quantidade adquirida
    购买日期时间     datetime not null             -- data e hora da aquisição
);

create table RFID标签报废
(
--    报废号           bigint auto_increment primary key,
    RFID标签编号     bigint,                       -- número da etiqueta RFID
	标签创立日期     datetime,                     -- data da criação
	标签丢弃日期     datetime                      -- data e hora do descarte da etiqueta
);

create table 要求赞同
(
 --   赞同号           bigint auto_increment primary key,
    订单号           bigint unique,
	foreign key (订单号) references 要求(订单号) on delete cascade on update cascade, -- chave estrangeira FK9
	管理用户         bigint,                       -- id do gerente
	管理名           varchar(128),                 -- nome de usuário do gerente
	赞同             bigint,                       -- status aprovação
	日期时间         datetime,                     -- data da aprovação
	管理注释         varchar(512)                  -- observações do administrador
);

create table 报废标记                              -- marca de refúgo
(
    唯一的试剂序列号 bigint,
	瓶号 bigint,
	数量 double,
	日期 datetime not null,
	用户名 varchar(128) not null,
	注释 varchar(512)
);