CREATE USER IF NOT EXISTS 'scoob_user'@'%' IDENTIFIED BY 'scoob_pass';
GRANT ALL PRIVILEGES ON scoob_db.* TO 'scoob_user'@'%' WITH GRANT OPTION;