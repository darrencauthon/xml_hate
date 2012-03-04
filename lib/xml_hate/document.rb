require 'hashie'
require 'active_support/inflector'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      return "" if @document.has_key?(meth.to_s) == false 
      return_values = @document[meth.to_s].map { |n| process_this_top_level_node(n) }
      return_values = return_values.map do |v|
        v.class == Hashie::Mash ? Node.new(v) : v
      end
      return_values.count == 1 ? return_values[0] : return_values
    end

    private

    def process_this_top_level_node(node)
      return node if node.class == String
      new_object = Hashie::Mash.new(node)
      process_this_inner_node(new_object)
    end

    def process_this_inner_node(node)
      # get the values to pluralize before modifying the node
      values_to_pluralize = get_values_to_pluralize(node)

      # this may modify the values checked to be pluralized
      bring_up_single_elements_as_properties(node)

      # now "pluralize" by setting the pluralized key
      values_to_pluralize.each { |key, value| node[key] = value }

      node
    end

    def bring_up_single_elements_as_properties(node)
      get_properties_with_multiple_elements(node).each do |key, value|
        value.each { |v| process_this_inner_node(v) }
        node[key] = value[0] if get_the_number_of_elements(value) == 1 
      end
    end

    def get_values_to_pluralize(node)
      values_to_pluralize = {}
      get_properties_with_multiple_elements(node).each do |key, value|
        values_to_pluralize[key.pluralize] = value if key.pluralize != key
      end
      values_to_pluralize
    end

    def get_properties_with_multiple_elements(node)
      node.select{|k,v| get_the_number_of_elements(v) >= 1}
    end

    def get_the_number_of_elements(value)
      begin
        value.count
      rescue
        0
      end
    end
  end
end
