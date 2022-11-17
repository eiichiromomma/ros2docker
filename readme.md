## docker build
Dockerfileを置いたディレクトリで

```bash
docker build . -t ros2env
```

でイメージを作成して

## docker run

### OpenGL付きのROS2環境(ホストはLinuxでOpenGLが使える前提)

```bash
docker run --rm -e DISPLAY=unix$DISPLAY -p 7400-7401:7400-7401 -p 7410-7419:7410-7419 \
-v /tmp/.X11-unix:/tmp/.X11-unix -v /path_to/dockermount:/mnt --gpus all -it ros2env /bin/bash
```

### WSL2+wslg+NVIDIAドライバなROS2環境

```/mnt/wslg```のマウントはデバイスの共有?

```bash
docker run -it --rm -e DISPLAY=$DISPLAY -p 7400-7401:7400-7401 -p 7410-7419:7410-7419 \
-v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg --gpus all ros2env /bin/bash
```

### 動作確認

```bash
xeyes
```
で目玉のウィンドウが出たらXの設定は成功。

```bash
glxgears
```
で歯車が出てきたらOpenGLも成功。

## docker上でGAZEBO

とりあえずgazebo+turtlebot3を使ってみる

```bash
TURTLEBOT3_MODEL=burger ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```
でgazeboが開く。別のターミナルを開き
```bash
docker container ls
```
で動いてるコンテナ一覧が出るので，ros2envのコンテナを探し，その最後にある名前(例えば distracted_swirles みたいの)を指定して同一コンテナで別のシェルを起動する

```bash
docker exec -it その名前 /bin/bash
```
で，コンテナに入ったら
```bash
TURTLEBOT3_MODEL=burger ros2 run turtlebot3_teleop teleop_keyboard
```
を実行すると，GAZEBO上のTurtlebot3 burgerをキーボードで移動できるようになる。
