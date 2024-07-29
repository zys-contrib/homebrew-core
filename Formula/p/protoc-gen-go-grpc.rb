class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.5.0.tar.gz"
  sha256 "04c464ca834f411273468a51ebfd7f4b9fc22eebc6b24aa8080006ea4f1c5f00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54e069e294ed066cea79382a990ea8cca724ab375efdfeb987f4587aaabffba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54e069e294ed066cea79382a990ea8cca724ab375efdfeb987f4587aaabffba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54e069e294ed066cea79382a990ea8cca724ab375efdfeb987f4587aaabffba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f5ad040c80e043489b9f61c98d50cb19768e93ee9494d161886305ea29602d9"
    sha256 cellar: :any_skip_relocation, ventura:        "6f5ad040c80e043489b9f61c98d50cb19768e93ee9494d161886305ea29602d9"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5ad040c80e043489b9f61c98d50cb19768e93ee9494d161886305ea29602d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b00231000adce3581fe6bb425b387f8e2c109c8b1a566ea147bd6937d789907"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    cd "cmd/protoc-gen-go-grpc" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"service.proto").write <<~EOS
      syntax = "proto3";

      option go_package = ".;proto";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    EOS

    system "protoc", "--plugin=#{bin}/protoc-gen-go-grpc", "--go-grpc_out=.", "service.proto"

    assert_predicate testpath/"service_grpc.pb.go", :exist?
  end
end
