# ibeacon

```bash
docker rm -f becotrack_web_container && docker build . -t becotrack && docker run -p 8100:8000 -it -v ${PWD}:/usr/src/app --name becotrack_web_container --network becotrack_network becotrack bash -c "cd becotrack;bash"
```

```bash
docker rm -f becotrack_web_container && docker build . -t becotrack && docker run -p 8000:8000 -it -v ${PWD}:/usr/src/app --name becotrack_web_container  becotrack bash -c "cd becotrack;bash"

python manage.py runserver 0.0.0.0:8000
```
