class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "44e8c94ffa41174f12e25ff60a9c7fd30cfd404b07b2332ec04070a27c2d2e74"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/crossplane/crossplane/internal/version.version=v#{version}"), "./cmd/crank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"controllerconfig.yaml").write <<~EOS
      apiVersion: pkg.crossplane.io/v1alpha1
      kind: ControllerConfig
      metadata:
       name: irsa
      spec:
       args:
         - --enable-external-secret-stores
    EOS
    expected_output = <<~EOS
      apiVersion: pkg.crossplane.io/v1beta1
      kind: DeploymentRuntimeConfig
      metadata:
        name: irsa
      spec:
        deploymentTemplate:
          spec:
            selector: {}
            strategy: {}
            template:
              metadata:
              spec:
                containers:
                - args:
                  - --enable-external-secret-stores
                  name: package-runtime
                  resources: {}
    EOS
    system bin/"crossplane", "beta", "convert", "deployment-runtime", "controllerconfig.yaml", "-o",
"deploymentruntimeconfig.yaml"
    inreplace "deploymentruntimeconfig.yaml", /^\s+creationTimestamp.+$\n/, ""
    assert_equal expected_output, File.read("deploymentruntimeconfig.yaml")
  end
end
