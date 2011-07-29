class Soup
  module TestHelper
    def stub_soup(*snips)
      soup = Soup.new(Soup::Backends::Memory.new)
      snips.each { |s| soup << s }
      soup
    end
  end
end