CREATE TABLE "comments" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "body" text,
  "author" varchar,
  "post_id" integer,
  "created_at" datetime NOT NULL,
  
  /* Added to ensure Comment#post does not break */
  FOREIGN KEY("post_id") REFERENCES "posts"("id") 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
