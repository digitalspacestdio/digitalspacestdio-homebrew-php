require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php80Redis < AbstractPhp80Extension
  init
  desc "PHP extension for Redis"
  url "https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz"
  sha256 "6f5cda93aac8c1c4bafa45255460292571fb2f029b0ac4a5a4dc66987a9529e6"
  head "https://github.com/phpredis/phpredis.git"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23527d8504d470d9198364f0457ffceb6ad734a404b002f9f6ec7e7fde87d714"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a77ff72b7bfb94984d5859f7fa798274f321f3dd1a9c03e7dd0f558f2b3853c"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ca8c7a75263d71bf4761d342870e3567ad09e2483a8825e83af7e2bb19a9ea"
    sha256 cellar: :any_skip_relocation, monterey:      "20d2e7afeec6138c1c6a2892a341d2888975756f48aad57ccda330eab502f55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a0f2e069dbc0de1a61b2cbfaf7c177ca9561823487a05ef489dd1b6eb571740"
  end

  depends_on "digitalspacestdio/php/php80-igbinary"
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
