class Kubetrim < Formula
  desc "Trim your KUBECONFIG automatically"
  homepage "https://github.com/alexellis/kubetrim"
  url "https://github.com/alexellis/kubetrim/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "fb1c127efa8c927e74627bae9a043e2cf505183d607cbfacf6eea8c8449a3383"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/alexellis/kubetrim/pkg.Version=#{version} -X github.com/alexellis/kubetrim/pkg.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetrim --help")

    # fake k8s configuration
    (testpath/".kube/config").write <<~YAML
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https://localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences: {}
      users:
        - name: test-user
          user:
            token: test-token
    YAML

    output = shell_output("#{bin}/kubetrim -write=false")
    assert_match "failed to connect to cluster", output
  end
end
