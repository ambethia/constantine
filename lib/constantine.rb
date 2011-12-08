require "constantine/version"

module Constantine

  class << self

    def constantize(word)
      modules = []
      variations(split(word)) { |m| modules << m }
      modules.uniq!
      modules.each do |potential_name|
        names = potential_name.split('::')
        names.shift if names.empty? || names.first.empty?
        constant = Object
        names.each do |name|
          constant = constant.const_get(name) if constant.const_defined?(name)
          return constant if constant.name == potential_name
        end
      end
      Object.const_missing(word)
    end

    def variations(words, prefix = [], &block)
      (words.length-1).downto(0).each do |count|
        pre = words[0..count].join("")
        post = words[count+1..words.length-1]
        yield [prefix + [pre], post].reject(&:empty?).join("::")
        variations(post, prefix + [pre], &block)
      end
    end

    def split(word)
      word = word.dup
      word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      word.split(" ")
    end
  end

  # def self.constantize(camel_cased_word)
  #   names = camel_cased_word.split('::')
  #   names.shift if names.empty? || names.first.empty?
  # 
  #   constant = Object
  #   names.each do |name|
  #     constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
  #   end
  #   constant
  # end
end
