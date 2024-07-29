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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e35b4df0a9c69c4c4679479704004e6db0496c04957f00828707dd8106197cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e35b4df0a9c69c4c4679479704004e6db0496c04957f00828707dd8106197cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e35b4df0a9c69c4c4679479704004e6db0496c04957f00828707dd8106197cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "577227f26db84d126e9802d11475319688691cee6ff141cb2d63bca09e68a424"
    sha256 cellar: :any_skip_relocation, ventura:        "577227f26db84d126e9802d11475319688691cee6ff141cb2d63bca09e68a424"
    sha256 cellar: :any_skip_relocation, monterey:       "577227f26db84d126e9802d11475319688691cee6ff141cb2d63bca09e68a424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1321dd4fbc200d03f8faac5b3b023e2c504bdc765dbc7e4a5a73757718544d25"
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
