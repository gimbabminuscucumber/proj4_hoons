## 환경

- macOs
- jdk 21
- tomcat 9.0
- sts tool
- mysql 8.3.0
- postman
- lombok
- gson (json파싱)
- 인코딩 utf-8
- git

## 프로젝트 설명
- '훈이네'는 친구가 운영하는 마트를 위한 홈페이지입니다.
	물건을 포장 및 구매를 하거나 프로모션 등을 확인할 수 있습니다.

## MySQL 데이터베이스 생성 및 사용자 생성

```sql
create user 'bloguser'@'%' identified by '1234';
GRANT ALL PRIVILEGES ON *.* TO 'bloguser'@'%';
create database blog;
```

## MySQL 테이블 생성

- bloguser 사용자로 접속
- use blog; 데이터 베이스 선택

```sql
CREATE TABLE user(
    id int primary key auto_increment,
    username varchar(100) not null unique,
    nickName varchar(100),
    password varchar(100) not null,
    email varchar(100) not null,
    address varchar(100),
    userRole varchar(20),
    createDate timestamp
) engine=InnoDB default charset=utf8;

CREATE TABLE board(
    id int primary key auto_increment,
    userId int,
    title varchar(100) not null,
    content longtext,
    readCount int default 0,
    createDate timestamp,
    category int,
    foreign key (userId) references user (id),
    category int
) engine=InnoDB default charset=utf8;

CREATE TABLE reply(
    replyId int primary key auto_increment,
    userId int,
    boardId int,
    content varchar(300) not null,
    count varchar(300),
    createDate timestamp,
    foreign key (userId) references user (id) on delete set null,
    foreign key (boardId) references board (id) on delete cascade
) engine=InnoDB default charset=utf8;

CREATE TABLE product(
    id int primary key auto_increment,
    userId int,
    price int not null,
    weight varchar(100),
    categoryId int,
    brand longtext not null,
    img longtext,
    content longtext,
    createDate timestamp,
    count int default 0,
    view int default 0,
    foreign key (userId) references user (id)
) engine=InnoDB default charset=utf8;

CREATE TABLE buy (
    id int primary key auto_increment,
    userId int,
    productId int,
    orderNum int,
    totalPrice int,
    totalCount int,
    state varchar(100) default '주문 확인',
    createDate timestamp
) engine=InnoDB default charset=utf8;

CREATE TABLE basket (
    id int primary key auto_increment,
    userId int,
    productId int,
    totalCount int,
    totalPrice int,
    img longtext,
    brand varchar(100),
    content longtext,
    price int,
    createDate timestamp
) engine=InnoDB default charset=utf8;

CREATE TABLE review(
	id int primary key auto_increment,
    userId int,
    buyId int,
    productId int,
    score int,
    text varchar(250),
    status int,
    createDate timestamp
) engine=InnoDB default charset=utf8;

```