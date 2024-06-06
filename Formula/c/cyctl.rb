class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "02ed62bec983a9937ec6decb4185c405c5a2da41adaa056b30c846d9161cf46e"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

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
