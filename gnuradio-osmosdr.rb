class GnuradioOsmosdr < Formula
  desc "osmocom Gnu Radio Blocks"
  homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"

  stable do
      url "http://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-0.1.4.zip"
      sha256 "1c36fdb24b76b4114beeebdab77b463820f434c16a2b622657983e3885f32a4a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "hackrf"

  # cheetah starts here
  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha256 "b8370fce4fbcd6b68b6b36c0fb0f4ec24d6ba37ea22988740f4701536611f1ae"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end
  # cheetah ends here

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_path "PATH", libexec/"vendor/bin" if build.with? "documentation"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[Markdown Cheetah]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make install"
    end
  end
end
