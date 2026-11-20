require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Dir.glob('rails/locales/*.yml').each do |locale_file|
  describe "a doorkeeper-i18n #{locale_file} locale file" do
    it_behaves_like 'a valid locale file', locale_file
    it { expect(locale_file).to be_a_subset_of 'rails/locales/en.yml' }
    it { expect('rails/locales/en.yml').to be_a_subset_of locale_file }

    # A word that mixes Latin, Cyrillic and Greek letters is a typo: a lookalike
    # letter (Latin "i" for Cyrillic "і") was typed with the wrong keyboard layout.
    it 'has no words that mix letters from different alphabets' do
      scripts = [/\p{Latin}/, /\p{Cyrillic}/, /\p{Greek}/]
      strings = ->(node) do
        case node
        when Hash then node.values.flat_map(&strings)
        when Array then node.flat_map(&strings)
        when String then [node]
        else []
        end
      end
      # Scan the decoded values, so YAML escapes do not split or hide a word, and end a
      # word at any other letter, as in Japanese text with no spaces between words.
      # Drop strftime directives first: "%d.%m.%Yг." renders as "20.11.2026г.".
      words = strings.call(YAML.load_file(locale_file))
                     .map { |value| value.gsub(/%[-_0^#:]*\d*[A-Za-z%]/, ' ') }
                     .flat_map { |value| value.scan(/[\p{Latin}\p{Cyrillic}\p{Greek}\p{M}]+/) }
      mixed = words.select { |word| scripts.count { |script| word.match?(script) } > 1 }
      expect(mixed).to be_empty
    end
  end
end
