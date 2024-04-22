require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Apcu < AbstractPhp70Extension
  init
  desc "APC User Cache"
  homepage "https://pecl.php.net/package/apcu"
  url "https://github.com/krakjoe/apcu/archive/v5.1.8.tar.gz"
  sha256 "09848619674a0871053cabba3907d2aade395772d54464d3aee45f519e217128"
  head "https://github.com/krakjoe/apcu.git"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3bfb29828504394a4bb8f597578276fe29981c1132a6affe56c57f93f49dc20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fcbad52aac55bc96cfc90737342a67a2828576a0f188fec09862f7c37f28d86"
    sha256 cellar: :any_skip_relocation, monterey:       "dbbdfdc1bf6687099f8b568aed019cc804a1e75873f1304ef8a2b97dbfb39d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f62b7ba1d703fa1e132d810f287b5cbdd19cc136ec64fc0a57a1b2de6deb8b"
  end

  depends_on "pcre2"

  def install
    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["pcre2"].opt_prefix}/include"

    args = []
    args << "--enable-apcu"

    safe_phpize

    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          *args
    system "make"
    prefix.install "modules/apcu.so"
    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS
      apc.enabled=1
      apc.shm_size=64M
      apc.ttl=7200
      apc.mmap_file_mask=/tmp/apc.XXXXXX
      apc.enable_cli=1
    EOS
  end
end
