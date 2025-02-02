# **PPGEEC - Localização Robótica - Trabalho Final**

O presente trabalho consiste no estudo da robustez da odometria de um robô ([Husky](https://clearpathrobotics.com/husky-a300-unmanned-ground-vehicle-robot/), da Clearpath Robotics) calculada a partir de uma estratégia de SLAM 3D ([GLIM](https://github.com/koide3/glim)) usando somente um LiDAR ([Velodyne VLP-16](https://ouster.com/products/hardware/vlp-16)).

## **Descrição do pacote**

O pacote `lar_point_cloud_dec` aqui presente foi montado com base no pacote [`lar_gazebo`](https://github.com/lar-deeufba/lar_gazebo), integrando o robô [Husky](https://clearpathrobotics.com/husky-a300-unmanned-ground-vehicle-robot/) à estratégia de SLAM 3D [GLIM](https://github.com/koide3/glim).

O pacote executa toda a estratégia de mapeamento e localização com base somente no LiDAR [Velodyne VLP-16](https://ouster.com/products/hardware/vlp-16) e na estratégia de SLAM 3D escolhida; a odometria das rodas não está sendo utilizada e o nó `ekf_localization` foi desativado.

O intuito do experimento conduzido com este pacote é fazer um *downsampling* aleatório da nuvem de pontos retornada pelo LiDAR e utilizar a versão *downsampled* para guiar a estratégia de SLAM 3D, e com isto, averiguar o desempenho por meio do cálculo da diferença entre a localização estimada pela estratégia e o *ground truth*; o cálculo da diferença é efetuado pelo script `glim_odom_diff.py`.

## **Instruções de execução**

### Ambiente ROS em Container Docker e VSCode

Este repositório possui configurações para fácil execução do ambiente em qualquer computador com Docker e Visual Studio Code instalados.

O repositório conta com configuração de Dev Container, ou seja, abrindo este repositório no VSCode, é possível executar o container diretamente.

Caso seu setup possua placa de vídeo Nvidia, remova o arquivo `Dockerfile` e renomeie o arquivo `Dockerfile_CUDA` como `Dockerfile` antes de inicializar o container.

### *Launchfile* e script bash

O launchfile principal deste pacote é o `lar_glim.launch`; da maneira como o ambiente está configurado, ele pode ser chamado de forma *standalone*, mas o recomendado é executá-lo por meio do script `glim_decimation.sh`. O script pode ser chamado com um parâmetro contendo a quantidade de pontos da nuvem pós-downsample.

### Exemplo de execução


Para rodar o projeto com uma nuvem *downsampled* contendo 5000 pontos:
```bash
    ./glim_decimation.sh 5000
```