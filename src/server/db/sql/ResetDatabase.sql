-- Created by msullivan on 11/18/24.

-- Tickets and related tables
DROP TABLE IF EXISTS tickets CASCADE;
CREATE TABLE tickets
(
    ticket_id SERIAL PRIMARY KEY,
    team_id INT,
    sla_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'New',
    priority VARCHAR(50) DEFAULT 'Medium',
    assigned_to VARCHAR(100)
);

DROP TABLE IF EXISTS subtasks CASCADE;
CREATE TABLE subtasks
(
    subtask_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'New',
    FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS deadlines CASCADE;
CREATE TABLE deadlines
(
    deadline_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    is_strict BOOLEAN NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS sla CASCADE;
CREATE TABLE sla
(
    sla_id SERIAL PRIMARY KEY,
    response_time INTERVAL,
    resolution_time INTERVAL,
    description TEXT
);

DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments
(
    comment_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    author VARCHAR(50) NOT NULL,
    text TEXT NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id) ON DELETE CASCADE
);

-- Users and related tables
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users
(
    user_id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    email VARCHAR(100) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create a server user as a default. Will probably need to force the user to change the password after the first login
INSERT INTO users (username, password_hash)
VALUES ('Administrator', 'Mpwftsi$20031911');

-- CREATE authenticate_user FUNCTION HERE

DROP TABLE IF EXISTS roles CASCADE;
CREATE TABLE roles
(
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

DROP TABLE IF EXISTS user_roles CASCADE;
CREATE TABLE user_roles
(
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS teams CASCADE;
CREATE TABLE teams
(
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS team_members CASCADE;
CREATE TABLE team_members
(
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES teams (team_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- Activity table
DROP TABLE IF EXISTS activity CASCADE;
CREATE TABLE activity
(
    activity_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activity_type VARCHAR(50), -- e.g., "Comment", "Status Change"
    description TEXT, -- e.g., "Changed status to Resolved"
    FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);