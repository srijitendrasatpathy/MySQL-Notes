-- 1. Finding 5 oldest users.

SELECT username FROM users
ORDER BY created_at
LIMIT 5;

-- 2. What day of week do most users register on?
SELECT DAYNAME(created_at) as day, COUNT(*) as total_users  
FROM users
GROUP BY day
ORDER BY total_users DESC
LIMIT 1;

-- 3. Find a user who has never posted a photo.
SELECT username
FROM users
WHERE id NOT IN (SELECT user_id 
                FROM photos);

            --(or)

SELECT username 
FROM users
LEFT JOIN photos
    on users.id = photos.user_id
WHERE photos.id IS NULL;

-- 4. What is the best photo based on likes in the database.
SELECT photos.id, username, photos.image_url, COUNT(*) as total_likes 
FROM photos
INNER JOIN likes
    on likes.photo_id = photos.id
INNER JOIN users
    on photos.user_id = users.id
GROUP BY id
ORDER BY total_likes DESC
LIMIT 1;

-- 5. How many times does the averager user posts?
SELECT
(SELECT COUNT(*) FROM photos)
/(SELECT COUNT(*) FROM users);

-- 6. Top 5 hashtags used.
SELECT tags.tag_name, COUNT(*) as total_likes
FROM photo_tags
JOIN tags
    ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total_likes DESC
LIMIT 5;

-- 7. Finding bots - user account that have liked every single photo in the database.
SELECT username, COUNT(*) as number_likes
FROM users
INNER JOIN likes
    on users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);
