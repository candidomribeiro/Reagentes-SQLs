create table AspNetRoles
(
    id                      varchar(256) not null primary key,
	name                    varchar(256),
	NormalizedName          varchar(256),
	ConcurrencyStamp        varchar(256)
);

create table AspNetUsers
(
    Id                      varchar(256) not null primary key,
	UserName                varchar(256),
	NormalizedUserName      varchar(256),
    Email                   varchar(256),
    NormalizedEmail         varchar(256),
    EmailConfirmed          int not null,
    PasswordHash            longtext,
    SecurityStamp           longtext,
    ConcurrencyStamp        varchar(256),
    PhoneNumber             varchar(256),
    PhoneNumberConfirmed    int not null,
    TwoFactorEnabled        int not null,
    LockoutEnd              datetime,
    LockoutEnabled          int not null,
    AccessFailedCount       int not null
);

create table AspNetRoleClaims
(
    id                      int primary key,
	roleid                  varchar(256),
	ClaimType               longtext,
	ClaimValue              longtext
);

create table AspNetUserClaims
(
    Id                      int not null primary key,
	UserId                  varchar(256),
	foreign key (UserId) references AspNetUsers(Id) on delete cascade,
	ClaimType               longtext,
	ClaimValue              longtext
);

create table AspNetUserLogins
(
    LoginProvider           varchar(256) primary key,
	ProviderKey             varchar(256),
	ProviderDisplayName     varchar(256),
	UserId                  varchar(256),
	foreign key (UserId) references AspNetUsers(Id) on delete cascade
);

create table AspNetUserRoles
(
    UserId                  varchar(256) not null primary key,
	RoleId                  varchar(256) not null,
	foreign key (RoleId) references AspNetRoles(Id) on delete cascade,
	foreign key (UserId) references AspNetUsers(Id) on delete cascade
);

create table AspNetUserTokens
(
    UserId                  varchar(256) not null primary key,
	LoginProvider           varchar(256) not null,
	Name                    varchar(256) not null,
	Value                   longtext,
	foreign key (UserId) references AspNetUsers(Id) on delete cascade
);

