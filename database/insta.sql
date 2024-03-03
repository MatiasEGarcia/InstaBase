 CREATE DATABASE insta;

USE insta;

CREATE TABLE IF NOT EXISTS users(
	id int primary key auto_increment not null,
    image mediumblob ,
    username varchar(20) unique not null,
    password varchar(100) not null,
    visible boolean default 1,
    rol varchar(10) not null
);
CREATE TABLE IF NOT EXISTS personal_details(
	id int primary key auto_increment not null,
    name varchar(45) not null,
    lastname varchar(45) not null,
    age  tinyint not null,
    email varchar(45) unique not null,
    associate_user int not null,
	foreign key (associate_user) references users(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS publicated_images(
	id int primary key auto_increment not null,
    img mediumblob not null,
    user_owner int not null,
    created_at timestamp not null,
    description varchar(100),
	foreign key (user_owner) references users(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS chats(
	id int primary key auto_increment not null,
    name varchar(20), -- can be null, because only groups can have names, private chats no.
    image mediumblob, -- can be null, because only groups will have a selected image, private chats will have the image of the other user.
    type ENUM('GROUP','PRIVATE') not null
);
CREATE TABLE IF NOT EXISTS messages(
	id int primary key auto_increment not null,
    body varchar(420) not null, -- encrypted and enconded can be 342 just to be sure I added a litle more.
    user_owner varchar(20) not null,
    chat int not null,
    sended_at datetime not null,
    watched_by varchar(300) not null, -- at least the user owner should have seen it
	foreign key (chat) references chats(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS chats_users(
	id int not null auto_increment primary key,
	associate_user int not null,
    chat int not null,
    is_admin boolean default 0, -- false
	foreign key (associate_user) references users(id) on delete cascade,
	foreign key (chat) references chats(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS comments(
	id int primary key auto_increment not null,
    body varchar(100) not null,
    owner_user int not null,
    img int not null,
    parent int,
    created_at datetime not null, 
	foreign key (img) references publicated_images(id) on delete cascade,
    foreign key (owner_user) references users(id) on delete cascade, 
    foreign key (parent) references comments(id) on delete cascade -- it references itself
);
CREATE TABLE IF NOT EXISTS follow(
	id int not null primary key auto_increment,
    followed int not null,
    follower int not null,
    status varchar(20) not null,
	foreign key (followed) references users(id) on delete cascade,
	foreign key (follower) references users(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS likes(
	id int primary key not null auto_increment,
    item_type ENUM('PULICATED_IMAGE','COMMENT') not null,
    item_id int not null, -- no fk , because can be images or comments or,etc, and I don't know to wich table connect
    decision boolean not null, -- false = dislike, true = like
    owner_like int not null,
    liked_at datetime not null,
	foreign key (owner_like) references users(id) on delete cascade
);
CREATE TABLE IF NOT EXISTS invalid_tokens(
	id int primary key auto_increment,
    token varchar(300),
    invalidate_date timestamp not null
);
CREATE TABLE IF NOT EXISTS notifications(
	id int primary key auto_increment,
    from_who int not null,
    to_who int not null,
    type ENUM('FOLLOW','MESSAGE','LIKE','COMMENT','PUBLICATION'),
    element_id int, -- will have the id of the elemente created, like follow's id or comment's id
    noti_message varchar(50), -- to make more especific notifications
    created_at datetime not null,
    watched boolean DEFAULT 0,  -- false 
    foreign key(from_who) references users(id) on delete cascade,
    foreign key(to_who) references users(id) on delete cascade
);
