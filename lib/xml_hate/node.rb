module XmlHate
  class Node
    def initialize(hash)
      all_items_in_the_hash_that_are_not_nil(hash).each do |k, v|
        create_accessor_for k, convert_the_value_to_the_appropriate_form(v)
      end
    end

    def method_missing(meth, *args, &blk)
      an_empty_array_for_plurals_or_empty_string_for_singulars meth
    end

    private

    def all_items_in_the_hash_that_are_not_nil(the_hash)
      the_hash.select{|k, v| !v.nil? }
    end

    def an_empty_array_for_plurals_or_empty_string_for_singulars(meth)
      meth.to_s == meth.to_s.pluralize ? [] : ""
    end

    def create_accessor_for(k, v)
      self.instance_variable_set("@#{k}", v)
      self.instance_eval("
      class << self
        attr_accessor :#{k}
      end")
    end

    def convert_the_value_to_the_appropriate_form(value)
      return Node.new(value) if value.class == Hashie::Mash 
      return value.map {|i| i.class == Hashie::Mash ? Node.new(i) : i} if value.class == Array
      value
    end
  end
end
