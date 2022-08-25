FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

RUN apt update \
	&& apt install -y \
  build-essential curl cmake git wget vim lsb-release software-properties-common 

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain 1.63.0 -y

# Install Corrosion
WORKDIR /var
RUN git clone https://github.com/corrosion-rs/corrosion.git
RUN cmake -Scorrosion -Bbuild -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --config Release && cmake --install build --config Release

# Compile example app
COPY . /var/cxx_example
WORKDIR /var/cxx_example
RUN rm -dfr build && cmake -B build . && make -C build -j4

# Run the example app
CMD ["/var/cxx_example/build/cxx_cmake"]
