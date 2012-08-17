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
      return [] if meth.to_s == meth.to_s.pluralize

      empty_string = ''
      attempt_to_attach_content_singleton_to_the_value empty_string
      empty_string
    end

    def create_accessor_for(k, v)
      property_name = get_a_valid_property_name(k)
      self.instance_variable_set("@#{property_name}", v)
      self.instance_eval("
      class << self
        attr_accessor :#{property_name}
      end")
    end

    def get_a_valid_property_name(name)
      name = name.to_s.gsub('-', '_')
      name = name.gsub('@', '')
      name = name.gsub(':', '')
      name.to_sym
    end

    def convert_the_value_to_the_appropriate_form(the_value)
      return Node.new(the_value) if the_value.class == Hashie::Mash 
      return the_value.map {|i| i.class == Hashie::Mash ? Node.new(i) : i} if the_value.class == Array
      attempt_to_attach_content_singleton_to_the_value the_value
      the_value
    end

    def attempt_to_attach_content_singleton_to_the_value(the_value)
      begin
        def the_value.content
          self
        end
      rescue
      end
    end
  end
end
