require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php73Redis < AbstractPhp73Extension
  init
  desc "PHP extension for Redis"
  homepage "https://github.com/phpredis/phpredis"
  url "https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz"
  sha256 "6f5cda93aac8c1c4bafa45255460292571fb2f029b0ac4a5a4dc66987a9529e6"
  head "https://github.com/phpredis/phpredis.git"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1641882b4d2474103fb784463faf6db9caff174ee6356ef515ac858eb6a2ad1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e5d169c03f3c80b84aa599025b203926db4c0d386630fd26150e58fe79b3f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f080e287e4eef09ad17b8cb934a013b4a2181030683fca1a45bc4202f4017a2"
    sha256 cellar: :any_skip_relocation, ventura:       "04b2f203f03f080113a1832112c212f4bc3cb6bf40d1a26255f1a21caf25d9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a1f01e5652eacb2541338e221d0e69082ac547d972923ee271961c57ad1a9b"
  end

  depends_on "digitalspacestdio/php/php73-igbinary"
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
