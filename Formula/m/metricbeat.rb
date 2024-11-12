class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.4",
      revision: "bb01339f5a453be79bda545a40c863353134e88a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "544d460fd7a771474c8fc4220a9c076ab2704ce635f9213d6f7cc569b9de33bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc46213dd85e0484c1c1a5ab29a833b58bad51f4434112ec803e98c6210cedb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fdaed69a4770b1c4d2a8e0f851a06a786ede328b6298bf0ad9d5abc5164c915"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a7b5765706bc95e7a6bf22eefea7f6acffd02b9e015de63c232ace009f7675a"
    sha256 cellar: :any_skip_relocation, ventura:       "82cb22bc5f18cab768c508c18144c8179061cd684315ba94f41ce76f55cfe782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b402d860fffe700634ba66edb32f2bc3b09f615deb98adb17f11b1bb93dc6848"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
