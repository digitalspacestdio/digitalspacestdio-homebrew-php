require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php72Redis < AbstractPhp72Extension
  init
  desc "PHP extension for Redis"
  homepage "https://github.com/phpredis/phpredis"
  url "https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz"
  sha256 "6f5cda93aac8c1c4bafa45255460292571fb2f029b0ac4a5a4dc66987a9529e6"
  head "https://github.com/phpredis/phpredis.git"
  revision 1

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8840ff84004d4501cd93d406bbdea0230f4b85f8ab032d22b0bc333ea9ce66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f21a4551aacb0da36e0ce782731d9f30d4147b61355d8bad5406da7c11ea71"
    sha256 cellar: :any_skip_relocation, ventura:       "03be31fb76fc0c689a18c74cdc87f58971b889470e2b1d4250d60e2969c6c742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e1791a8ecbbe471042515db37e30cc2f271d0758eb783a2fc891643fd6e658"
  end

  depends_on "digitalspacestdio/php/php72-igbinary"
  depends_on "igbinary" => :build

  def install
    args = []
    args << "--enable-redis-igbinary"

    safe_phpize

    # Install symlink to igbinary headers inside memcached build directory
    (Pathname.pwd/"ext").install_symlink Formula["igbinary"].opt_include/"php7" => "igbinary"

    system "./configure", "--prefix=#{prefix}", phpconfig, *args
    system "make"

    prefix.install "modules/redis.so"

    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<~EOS

      ; phpredis can be used to store PHP sessions.
      ; To do this, uncomment and configure below
      ;session.save_handler = redis
      ;session.save_path = "tcp://host1:6379?weight=1, tcp://host2:6379?weight=2&timeout=2.5, tcp://host3:6379?weight=2"
    EOS
  end
end
