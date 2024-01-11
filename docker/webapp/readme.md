# Becotrack

## Databaza

### Inicializacia

```bash
docker exec -it {container id} bash

mysql -h dev4.ccsipro.sk --port=13303 -u root  -p44qWpvvg4FF
CREATE DATABASE becotrack;
GRANT ALL PRIVILEGES ON *.* TO 'pv31';
```

### Prístup na local docker

```bash
db
HOST: localhost
PORT: 11306
MYSQL_USER: becotrack
MYSQL_PASSWORD: becotrack
```

### Prístup na remote docker

```bash
dev4.ccsipro.sk:13303
MYSQL_DATABASE: becotrack
MYSQL_ROOT_PASSWORD: 44qWpvvg4FF
MYSQL_USER: pv31
```

## Django aplikacia

### Spustenie Docker

```bash
docker rm -f becotrack_web_container && docker build . -t becotrack && docker run -p 8000:8000 -it -v ${PWD}:/usr/src/app --name becotrack_web_container --network becotrack_network becotrack bash -c "cd becotrack;bash"
```

### Spustenie Django

```bash
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

### View po migracii

```sql
SELECT
 `base_loadedbeacontags`.`id` AS `id`,
 `base_loadedbeacontags`.`rssi` AS `rssi`,
 `base_loadedbeacontags`.`read_datetime` AS `read_datetime`,
 `base_loadedbeacontags`.`created` AS `created`,
 `base_loadedbeacontags`.`modified` AS `modified`,
 ifnull( `base_beaconreaders`.`name`, `base_loadedbeacontags`.`reader_uid` ) AS `reader_name`,
 ifnull( `base_beacontags`.`name`, `base_loadedbeacontags`.`tag_uid` ) AS `tag_name` 
FROM
 ((
   `base_loadedbeacontags`
  LEFT JOIN `base_beaconreaders` ON ( `base_beaconreaders`.`uid` = `base_loadedbeacontags`.`reader_uid` ))
 LEFT JOIN `base_beacontags` ON ( `base_loadedbeacontags`.`tag_uid` = `base_beacontags`.`uid` ))
```
