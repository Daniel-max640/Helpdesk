CREATE TABLE "movies" (
  "id" serial PRIMARY KEY,
  "title" varchar(100),
  "release_year" date
);

CREATE TABLE "actors" (
  "id" serial PRIMARY KEY,
  "first_name" varchar(100),
  "last_name" varchar(100),
  "birthday" date
);

CREATE TABLE "genres" (
  "id" serial PRIMARY KEY,
  "name" varchar(50)
);

CREATE TABLE "films" (
  "id" serial PRIMARY KEY,
  "movies_id" int,
  "actors_id" int
);

CREATE TABLE "movies_genres" (
  "id" serial PRIMARY KEY,
  "movies_id" int,
  "genres_id" int
);

ALTER TABLE "films" ADD FOREIGN KEY ("movies_id") REFERENCES "movies" ("id");

ALTER TABLE "films" ADD FOREIGN KEY ("actors_id") REFERENCES "actors" ("id");

ALTER TABLE "movies_genres" ADD FOREIGN KEY ("movies_id") REFERENCES "movies" ("id");

ALTER TABLE "movies_genres" ADD FOREIGN KEY ("genres_id") REFERENCES "genres" ("id");
