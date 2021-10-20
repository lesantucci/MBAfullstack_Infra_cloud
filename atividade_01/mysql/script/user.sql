CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'rootAccess';
GRANT ALL PRIVILEGES ON petclinic.* TO 'root'@'%' IDENTIFIED BY 'rootAccess';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';