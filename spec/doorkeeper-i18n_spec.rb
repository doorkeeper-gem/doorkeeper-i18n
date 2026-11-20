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
      # Drop strftime directives from date formats first: "%d.%m.%Yг." renders as
      # "20.11.2026г.". Other values keep "%", so "100%aвто" is still caught.
      strings = ->(node, key = nil) do
        case node
        when Hash then node.flat_map { |k, v| strings.call(v, k) }
        when Array then node.flat_map { |v| strings.call(v, key) }
        when String
          key.to_s.end_with?('format') ? [node.gsub(/%[-_0^#:]*\d*[EO]?[A-Za-z%]/, ' ')] : [node]
        else []
        end
      end
      # Scan the decoded values, so YAML escapes do not split or hide a word, and end a
      # word at any other letter, as in Japanese text with no spaces between words.
      words = strings.call(YAML.load_file(locale_file))
                     .flat_map { |value| value.scan(/[\p{Latin}\p{Cyrillic}\p{Greek}\p{M}]+/) }
      mixed = words.select { |word| scripts.count { |script| word.match?(script) } > 1 }
      expect(mixed).to be_empty
    end
  end
end
