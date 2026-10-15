-- 实验一/四：MySQL 初始化脚本（一次性执行）
-- 用法：mysql -u root -p < db/init-mysql.sql
CREATE DATABASE IF NOT EXISTS lab_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lab_db;

DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(64)  NOT NULL,
    password   VARCHAR(255) NOT NULL,
    email      VARCHAR(128),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uk_users_username UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE roles (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(64) NOT NULL,
    name VARCHAR(64) NOT NULL,
    CONSTRAINT uk_roles_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE permissions (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(64) NOT NULL,
    name VARCHAR(64) NOT NULL,
    CONSTRAINT uk_permissions_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE role_permissions (
    role_id       BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    PRIMARY KEY (role_id, permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 密码均为 BCrypt 加密后的 "123456"
INSERT INTO users (username, password, email) VALUES ('admin', '$2a$10$wYrGLC3b0qNNWwbcq5n2Wese9Gxh/Kviu.SEy3jejwPDK8wiII.fa', 'admin@example.com');
INSERT INTO users (username, password, email) VALUES ('zhangsan', '$2a$10$wYrGLC3b0qNNWwbcq5n2Wese9Gxh/Kviu.SEy3jejwPDK8wiII.fa', 'zhangsan@example.com');

INSERT INTO roles (code, name) VALUES ('ROLE_ADMIN', '管理员'), ('ROLE_USER', '普通用户');
INSERT INTO permissions (code, name) VALUES ('user:read', '查看用户'), ('user:write', '新增/修改用户'), ('user:delete', '删除用户'), ('ai:ask', '使用智能问答');
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1), (2, 2);
INSERT INTO role_permissions (role_id, permission_id) VALUES (1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (2, 4);
