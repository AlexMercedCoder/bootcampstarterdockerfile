## Install Java 17
RUN sudo wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
RUN sudo tar xvf openjdk-17_linux-x64_bin.tar.gz
RUN sudo mv jdk-17 /opt/
RUN echo 'JAVA_HOME=/opt/jdk-17' >> ~/.bashrc
RUN echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
RUN . ~/.bashrc

## Insall Coursier
RUN sudo curl -Lo cs https://git.io/coursier-cli-linux && sudo chmod +x cs && sudo ./cs setup -y
RUN sudo ./cs install scala3
RUN sudo ./cs install scala3-compiler
RUN echo 'PATH=$PATH:~/.local/share/coursier/bin' >> ~/.bashrc
RUN . ~/.bashrc

## Install Java 11 for Spark
RUN sudo apt-get install openjdk-11-jdk -y
RUN echo "alias java17='/opt/jdk-17/bin/java'" >> ~/.bashrc
RUN . ~/.bashrc

## Install Apache Spark
RUN sudo apt-get install python3 python3-dev -y
RUN sudo wget https://dlcdn.apache.org/spark/spark-3.0.3/spark-3.0.3-bin-hadoop2.7.tgz
RUN sudo mkdir /opt/spark
RUN sudo tar -xf spark-3.0.3-bin-hadoop2.7.tgz -C /opt/spark --strip-component 1
RUN sudo chmod -R 777 /opt/spark
RUN echo 'SPARK_HOME=/opt/spark' >> ~/.bashrc
RUN echo 'PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.bashrc
RUN echo 'PYSPARK_PYTHON=/usr/bin/python3' >> ~/.bashrc
RUN . ~/.bashrc

## Make sure scala is installed
RUN ./cs setup -y
RUN ./cs install scala3
RUN ./cs install scala3-compiler