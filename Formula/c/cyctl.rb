class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "959c59c6697379f89f4f5edb61fe3e882ad5463987166f72657491e262033dcb"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861547fd7ec90b5da6bb743c3a4912375d6d31b4a2fac5f533acd2c97d80cbca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861547fd7ec90b5da6bb743c3a4912375d6d31b4a2fac5f533acd2c97d80cbca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "861547fd7ec90b5da6bb743c3a4912375d6d31b4a2fac5f533acd2c97d80cbca"
    sha256 cellar: :any_skip_relocation, sonoma:        "2765f01223edb4f37691935c4c2394114334dbae971b6a6b58f2b5a1bb111048"
    sha256 cellar: :any_skip_relocation, ventura:       "2765f01223edb4f37691935c4c2394114334dbae971b6a6b58f2b5a1bb111048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd09f8aa72b8a72c85c81b5b7a020b95cf717df01e9faba70c4bc54e4e035fd"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
