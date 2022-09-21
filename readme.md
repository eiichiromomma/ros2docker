## OpenGL付きのROS2環境(ホストはLinuxでOpenGLが使える前提)

Dockerfileを置いたディレクトリで

```bash
docker build . -t ros2env
```

でイメージを作成して

```bash
docker run --rm -e DISPLAY=unix$DISPLAY -p 7400-7401:7400-7401 -p 7410-7419:7410-7419 -v /tmp/.X11-unix:/tmp/.X11-unix -v /path_to/dockermount:/mnt --gpus all -it ros2env /bin/bash
```
