## OpenGL付きのROS2環境

## 0. dockerの準備
NVIDIAのGPUとCUDAドライバ，dockerとNVIDIA Container Toolkitも必要。[NVIDIAのページ(英語)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)でも説明しているが，"Ubuntu docker nvidia"とかでググれば日本語の解説も出てくる。色々変わってるので極力新しい情報を使う。

WSL2の場合も同様でWindows用のDocker Desktopと，[ここらへん](https://learn.microsoft.com/ja-jp/windows/ai/directml/gpu-cuda-in-wsl)を参考にWSL用CUDAドライバも入れる。あとWSLgも必要なので出来ればWindows11が望ましい。(Windows10でもInsider Previewにしちゃえば使えたが，今どうなってるかは不明)

## 1. docker build
Dockerfileを置いたディレクトリで

```bash
docker build . -t ros2env
```

でイメージを作成して

## 2. docker run

### 2.1.1 LinuxでNVIDIAのグラボがある環境

```bash
docker run --rm -e DISPLAY=unix$DISPLAY -p 7400-7401:7400-7401 -p 7410-7419:7410-7419 \
-v /tmp/.X11-unix:/tmp/.X11-unix -v /path_to/dockermount:/mnt --gpus all -it ros2env /bin/bash
```

### 2.1.2 Windows (WSL2+wslg+NVIDIAドライバなROS2環境)

```/mnt/wslg```のマウントはデバイスの共有?

```bash
docker run -it --rm -e DISPLAY=$DISPLAY -p 7400-7401:7400-7401 -p 7410-7419:7410-7419 \
-v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg --gpus all ros2env /bin/bash
```

### 2.2 動作確認

```bash
xeyes
```
で目玉のウィンドウが出たらXの設定は成功。

```bash
glxgears
```
で歯車が出てきたらOpenGLも成功。

## 3. docker上でGAZEBO

とりあえずgazebo+turtlebot3を使ってみる

```bash
TURTLEBOT3_MODEL=burger ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```
でgazeboが開く。(初回起動は結構な時間がかかる場合があるので，docker起動時の--rmは付けずにdocker startで以後使う方が良いかも知れない)

gazeboは最初にバナーウィンドウが表示されるのだが，wslgがWindowsのスケーリングと相性が悪いようで100%じゃないと真っ黒な長方形が表示される。

別のターミナルを開き
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
