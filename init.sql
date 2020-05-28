CREATE SCHEMA ds_types;

SET SEARCH_PATH = "ds_types";

CREATE TABLE IF NOT EXISTS project
(
  project_id SMALLSERIAL PRIMARY KEY,
  name       VARCHAR(24) NOT NULL UNIQUE
);

INSERT INTO
  project (name)
VALUES
  ('AmoebaDB'),
  ('ClinepiDB'),
  ('CryptoDB'),
  ('FungiDB'),
  ('GiardiaDB'),
  ('HostDB'),
  ('MicrobiomeDB'),
  ('MicrosporidiaDB'),
  ('Orthomcl'),
  ('PiroplasmaDB'),
  ('PlasmoDB'),
  ('SchistoDB'),
  ('ToxoDB'),
  ('TrichDB'),
  ('TritrypDB'),
  ('Vectorbase');

CREATE TABLE IF NOT EXISTS status
(
  status_id SMALLSERIAL PRIMARY KEY,
  name      VARCHAR(24) NOT NULL UNIQUE
);

INSERT INTO
  status (name)
VALUES
  ('receiving-from-client'),
  ('sending-to-handler'),
  ('handler-unpacking'),
  ('handler-processing'),
  ('handler-packing'),
  ('receiving-from-handler'),
  ('sending-to-datastore'),
  ('success'),
  ('rejected'),
  ('errored');

RESET SEARCH_PATH;

CREATE SCHEMA IF NOT EXISTS ds_jobs;

SET SEARCH_PATH = "ds_jobs";

CREATE TABLE IF NOT EXISTS jobs
(
  db_id       SERIAL PRIMARY KEY,
  job_id      VARCHAR(22)  NOT NULL UNIQUE,
  user_id     BIGINT       NOT NULL,
  status_id   SMALLINT     NOT NULL
    REFERENCES ds_types.status (status_id) ON DELETE RESTRICT,
  name        VARCHAR(256) NOT NULL,
  description VARCHAR,
  summary     VARCHAR,
  started     TIMESTAMPTZ  NOT NULL DEFAULT now(),
  finished    TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS jobs_user_id ON jobs (user_id);

CREATE TABLE IF NOT EXISTS job_files
(
  db_id      INT         NOT NULL
    REFERENCES jobs (db_id) ON DELETE CASCADE,
  file       VARCHAR(32) NOT NULL,
  total_size BIGINT      NOT NULL
);

CREATE TABLE IF NOT EXISTS job_projects
(
  db_id      INT NOT NULL
    REFERENCES jobs (db_id) ON DELETE CASCADE,
  project_id INT NOT NULL
    REFERENCES ds_types.project (project_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_messages
(
  db_id   INT   NOT NULL
    REFERENCES jobs (db_id) ON DELETE CASCADE,
  message JSONB NOT NULL
);
