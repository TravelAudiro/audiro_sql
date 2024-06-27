
-- 유저 테이블 
create table users (
    users_id        number(10) generated as identity, --pk
    id              varchar2(30 char) not null,   
    password_hash   varchar2(100) not null,   
    user_name       varchar2(30 char) not null,   
    nickname        varchar2(30 char) not null,   
    phone           varchar2(15 char) not null,  
    email           varchar2(50 char) not null,  

    constraint users_users_id_pk primary key (users_id),
    constraint users_id_uq unique (id),
    constraint users_nickname_uq unique (nickname),
    constraint users_phone_uq unique (phone),
    constraint users_email_uq unique (email)
);


-- 프로필 테이블
create table profile (
    profile_id         number(10) generated as identity,
    users_id           number(10) not null,
    introduction       varchar2(200 char) DEFAULT ' ', -- null로 주면 화면에 자기소개 : null 이렇게 되서 안됨.
    path               varchar2(3000 char) DEFAULT 'images/defaultprofile.png', --DEFAULT경로 이미지 static 폴더 밑 images폴더에 해당 defaultprofile.png이미지 넣어야함. 그리고 쓸 때는 필요에 따라서 코드에는 src="../${profile.path}"이렇게 써야하는데 필요에 따라서 변동이 있기 때문에 지금 저게 나음. 뷰가 어디에 있느냐에 따라 달라져서 코드에서 조정이 가능함.
    registration_time  TIMESTAMP DEFAULT SYSTIMESTAMP,
    
    constraint profile_profile_id_pk primary key (profile_id),
    constraint profile_users_id_fk foreign key (users_id) references users (users_id) on delete cascade
);


-- 태그 테이블
create table tag (
    tag_id      number(3) generated as identity,
    category    varchar2(10 char) not null, -- ex) 지역, 테마, 동행자 등...
    name        varchar2(10 char) not null,
    constraint  tag_tag_id_pk primary key (tag_id),
    constraint  tag_name_uq unique (name) 
);

-- 
select * from tag;

-- 태그 데이터
insert into tag (category, name) values ('지역', '서울');
insert into tag (category, name) values ('지역', '인천');
insert into tag (category, name) values ('지역', '대전');
insert into tag (category, name) values ('지역', '대구');
insert into tag (category, name) values ('지역', '울산');
insert into tag (category, name) values ('지역', '부산');
insert into tag (category, name) values ('지역', '광주');
insert into tag (category, name) values ('지역', '세종');
insert into tag (category, name) values ('지역', '경기');
insert into tag (category, name) values ('지역', '강원');
insert into tag (category, name) values ('지역', '충북');
insert into tag (category, name) values ('지역', '충남');
insert into tag (category, name) values ('지역', '경북');
insert into tag (category, name) values ('지역', '경남');
insert into tag (category, name) values ('지역', '전북');
insert into tag (category, name) values ('지역', '전남');
insert into tag (category, name) values ('지역', '제주');
insert into tag (category, name) values ('테마', '힐링');
insert into tag (category, name) values ('테마', '문화');
insert into tag (category, name) values ('테마', '체험');
insert into tag (category, name) values ('테마', '액티비티');
insert into tag (category, name) values ('동행자', '가족');
insert into tag (category, name) values ('동행자', '친구');
insert into tag (category, name) values ('동행자', '연인');
insert into tag (category, name) values ('동행자', '혼자');
insert into tag (category, name) values ('동행자', '반려동물');


-- 여행지 테이블 
create table travel_destination ( -- 태그 컬럼 3개 + 제약조건 삭제
    travel_destination_id      number(10) generated as identity, 
    name                       varchar2(30 char) not null, 
    description                varchar2(1000 char) not null,
    phone                      varchar2(15 char),
    site                       varchar2(500 char),
    address                    varchar2(100 char) not null,
    latitude                   number not null, 
    longitude                  number not null, 
    img_url                    varchar2(500 char) not null,
    
    constraint travel_destination_travel_destination_id_pk primary key (travel_destination_id),
    constraint travel_destination_name_uq unique (name),
    constraint travel_destination_address_uq unique (address),
    constraint travel_destination_img_url_uq unique (img_url)
);


-- 여행지_태그 조인 테이블
create table destination_tag ( 
    destination_id    number(10) not null,
    tag_id            number(3) not null,
    constraint destination_tag_destination_id_fk foreign key (destination_id) references travel_destination (travel_destination_id),
    constraint destination_tag_tag_id_fk foreign key (tag_id) references tag (tag_id),
    constraint destination_tag_destination_id_tag_id_pk primary key (destination_id, tag_id) -- 복합키 제약조건 이름 뭐라고 하지..?
);


-- 여행 계획 
create table travel_plan (
    travel_plan_id      number(10) generated as identity, 
    users_id            number(10) not null, 
    title               varchar2(40 char) not null, 
    start_date          date not null, 
    duration            number(3) not null, 
    end_date            date not null, 
    is_reviewed         number(1) default 0, --(0= 후기 작성 안함, 1= 후기 작성 함)
    created_time        timestamp default systimestamp,
    modified_time       timestamp default systimestamp,
    
    constraint travel_plan_travel_plan_id_pk primary key (travel_plan_id),
    constraint travel_plan_users_id_fk foreign key (users_id) references users (users_id) on delete cascade
);


-- 여행계획 상세보기
create table detailed_plan(
    detailed_plan_id    number(10) generated as identity,
    travel_plan_id      number(10) not null,
    day                 number(3) not null,
    destination_id      number(10) not null,
    
    constraint detailed_plan_detailed_plan_id_pk primary key (detailed_plan_id),
    constraint detailed_plan_travel_plan_id_fk foreign key (travel_plan_id) references travel_plan (travel_plan_id) on delete cascade,
    constraint detailed_plan_destination_id_fk foreign key (destination_id) references travel_destination (travel_destination_id) on delete cascade
);


-- 포스트 타입 테이블
create table post_type (
    post_type_id   number(2), --pk
    type           varchar2(10 char) not null, -- uq 
    
    constraint post_type_post_type_id_pk primary key (post_type_id), 
    constraint post_type_type_uq unique (type)
);



-- 포스트 테이블 
create table post (
    post_id             number(10) generated as identity, --pk
    users_id            number(10) not null,
    post_type_id        number(2) not null, --fk
    title               varchar2(40 char) default '(제목없음)' not null,
    content             clob default '(내용없음)' not null, --데이터 타입을 CLOB으로 변경
    created_time        timestamp default systimestamp,
    modified_time       timestamp default systimestamp,
    good                number(10) default 0,
    travel_plan_id      number(10),
     
    constraint post_post_id_pk primary key (post_id),
    constraint post_users_id_fk foreign key (users_id) references users (users_id) on delete cascade, -- on update cascade는 Oracle에서 지원하지 않음
    constraint post_type_post_type_id_fk foreign key (post_type_id) references post_type (post_type_id) on delete cascade, 
    constraint post_travel_plan_id foreign key (travel_plan_id) references travel_plan (travel_plan_id) on delete cascade
);


-- 임시저장 테이블 
create table draft_post (
    draft_post_id     number(10) generated as identity, 
    type_id           number(3), 
    title             varchar2(40 char) default '(제목없음)',  
    users_id          number(10) not null,
    content           CLOB default '(내용없음)',
    modified_time     timestamp default systimestamp,
    
    constraint draft_post_draft_post_id_pk primary key (draft_post_id),
    constraint draft_post_type_id_fk foreign key (type_id) references post_type (post_type_id) on delete cascade,  
    constraint draft_post_users_id_fk foreign key (users_id) references users (users_id) on delete cascade
);

        
-- 댓글 테이블 
create table comments (
    comments_id         number(10) generated as identity,
    post_id             number(10) not null,
    users_id            number(10) not null,
    content             varchar2(500 char) not null,
    created_time        timestamp default systimestamp,
    modified_time       timestamp default systimestamp, 
    parent_comment_id   number(10),--comments의 id 불러오기 (대댓기능)
    is_private          number(1) default 0, --비밀댓글(0=공개 1=비밀)
    
    constraint comments_comments_id_pk primary key (comments_id),
    constraint comments_post_id_fk foreign key (post_id) references post (post_id) on delete cascade, 
    constraint comments_user_id_fk foreign key (users_id) references users (users_id) on delete cascade 
);

-- 찜 목록 테이블(여행지)
create table favorite_destination (
	favorite_destination_id     number(10) generated as identity,
	users_id                    number(10) not null,
	destination_id              number(10) not null,
	
	constraint favorite_destination_favorite_destination_id_pk primary key (favorite_destination_id),
	constraint favorite_destination_users_id_fk foreign key (users_id) references users (users_id) on delete cascade,
	constraint favorite_destination_destination_id_fk foreign key (destination_id) references travel_destination (travel_destination_id) on delete cascade 
);


-- 찜 목록 테이블(유저)
create table favorite_users (
	favorite_users_id       number(10) generated as identity,
	users_id                number(10) not null,
	interested_user_id      number(10) not null,
	
	constraint favorite_users_favorite_users_id_pk primary key (favorite_users_id),
	constraint favorite_users_users_id_fk foreign key (users_id) references users (users_id) on delete cascade,
	constraint favorite_users_interested_user_id_fk foreign key (interested_user_id) references users (users_id) on delete cascade 
);


-- 찜 목록 테이블(게시글)
create table favorite_post (
	favorite_post_id        number(10) generated as identity,
	users_id                number(10) not null,
	post_id                 number(10) not null,
	
	constraint favorite_post_favorite_post_id_pk primary key (favorite_post_id),
	constraint favorite_post_users_id_fk foreign key (users_id) references users (users_id) on delete cascade,
	constraint favorite_post_post_id_fk foreign key (post_id) references post (post_id) on delete cascade 
);


-- commit, select, delete, insert
commit;
select * from users order by id desc;
delete from users where id= ;



