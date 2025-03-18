class Mintoolkit < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/mintoolkit/mint/archive/refs/tags/1.41.7.tar.gz"
  sha256 "a5375339dda7752b8c7a1d29d25cc7e7e52c60b2badb6a3f6d816f7743fde91a"
  license "Apache-2.0"
  head "https://github.com/mintoolkit/mint.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  skip_clean "bin/mint-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/mintoolkit/mint/pkg/version.appVersionTag=#{version}"
    tags = %w[
      remote
      containers_image_openpgp
      containers_image_docker_daemon_stub
      containers_image_fulcio_stub
      containers_image_rekor_stub
    ]
    system "go", "build",
                 *std_go_args(output: bin/"mint", ldflags:, tags:),
                 "./cmd/mint"

    # mint-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"mint-sensor", ldflags:, tags:),
                 "./cmd/mint-sensor"
    (bin/"mint-sensor").chmod 0555

    # Create backwards compatible symlinks similar to build script
    # https://github.com/mintoolkit/mint/blob/master/scripts/src.build.sh
    bin.install_symlink "mint" => "docker-slim"
    bin.install_symlink "mint" => "slim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mint --version")
    system "test", "-x", bin/"mint-sensor"

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine
      RUN apk add --no-cache curl
    DOCKERFILE

    output = shell_output("#{bin}/mint lint #{testpath}/Dockerfile")
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end
