USE ipo_db2;

SELECT
#   ru.id,
#   su.user_id
  COUNT(*)
FROM
    k13_reg_users AS ru
    INNER JOIN
    k13_sensei_users AS su
      ON ru.id = su.sensei_id;

SELECT
  ru.id, ru.login, sch.*, COUNT(pack.id), SUM(pack.users_count)
FROM
  k13_reg_users AS ru
  INNER JOIN
    k13_packets AS pack
  ON pack.requested_by = ru.id
  INNER JOIN
    k13_schools as sch
  ON ru.school = sch.id
  WHERE pack.status = 2 and pack.trash = 0
GROUP BY ru.id;

SELECT
  ru.id, pack.id
FROM
    k13_reg_users AS ru
    INNER JOIN
    k13_packets AS pack
      ON pack.requested_by = ru.id
WHERE pack.status = 2 and pack.trash = 0;