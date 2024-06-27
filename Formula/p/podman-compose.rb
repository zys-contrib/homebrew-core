class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/bd/67/0f8cf5ef346a22ce73dfdd0e60cf81342329b71a7fc118128929f0c07b62/podman_compose-1.2.0.tar.gz"
  sha256 "e47665546598a48d83d30ca2709a679412824bbe84b93f61779bc863e1a6f060"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "783ac4b2510eabc348829774901fce491d2d23c3bb17ac47f1f9c355f1b5e8de"
    sha256 cellar: :any,                 arm64_ventura: "583cb828ec81f48ff5fc36d5ca462666b8e5d7c2137da6ac010f85d8fce78c3b"
    sha256 cellar: :any,                 sonoma:        "eececc20a02d2655ebcce4fcabfd4e12f3b2c525522fa157814007d394e2cdf8"
    sha256 cellar: :any,                 ventura:       "10f1fca3c03c36a3897ff0cf53fc88f967641fe057dc745579bb03fceadea1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e5123bb5c25c48ee67e50f1ad070e5134734100afd9543159cb0ff67694f49"
  end

  depends_on "libyaml"
  depends_on "podman"
  depends_on "python@3.12"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COMPOSE_PROJECT_NAME"] = "brewtest"

    port = free_port

    (testpath/"compose.yml").write <<~EOS
      version: "3"
      services:
        test:
          image: nginx:1.22
          ports:
            - #{port}:80
          environment:
            - NGINX_PORT=80
    EOS

    assert_match "podman ps --filter label=io.podman.compose.project=brewtest",
      shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    # If it's trying to connect to Podman, we know it at least found the
    # compose.yml file and parsed/validated the contents
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1")
  end
end
