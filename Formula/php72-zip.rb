require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php72Zip < AbstractPhp72Extension
  init
  desc "Zip"
  homepage "https://www.php.net/manual/ru/book.zip.php"
  revision PHP_REVISION

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee6a0bf9eb1b59c48a8312462a58cc9bdd53f51643d4ee40609dae28a25699e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16ed759e5195d3e67a176a5824e75dd64329cccc9dde07fa912dc813f73ec8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c460ac9e7eb07f889db2bf24b1bacad1731306ba3219ad6fde960158d4fdba6"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc03346c05ccfbb955ca560942d77dd35b1f2964034903f341c3265c3401dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a57896903e9aa08835ae9748a4dd25071dfbd4580935c35ea542dbd53522b97"
  end

  depends_on "libzip"
  depends_on "zlib"
  depends_on "pkg-config" => :build

  def install
        # Required due to icu4c dependency
    ENV.cxx11

    # icu4c 61.1 compatability
    #ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"
    
    Dir.chdir "ext/zip"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--enable-zip",
                          "--with-libzip=#{Formula["libzip"].opt_prefix}",
                          "--with-zlib-dir=#{Formula["zlib"].opt_prefix}"
    system "make"
    prefix.install "modules/zip.so"
    write_config_file if build.with? "config-file"
  end
end
