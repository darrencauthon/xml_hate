require 'hashie'
require 'active_support/inflector'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      return "" if @document.has_key?(meth.to_s) == false 
      return_values = @document[meth.to_s].map { |n| process_this_node(n) }
      return_values.count == 1 ? return_values[0] : return_values
    end

    private

    def process_this_node(node)
      return node if node.class == String
      new_object = Hashie::Mash.new(node)
      push_single_elements_up_to_attributes(new_object)
    end

    def push_single_elements_up_to_attributes(node)
      values_to_pluralize = {}
      node.select{|k,v| get_the_number_of_elements(v) >= 1}.each do |key, value|
        values_to_pluralize[key.pluralize] = value if key.pluralize != key
        cleaned_values = value.map { |v| push_single_elements_up_to_attributes(v) }
        node[key] = get_the_number_of_elements(value) == 1 ? value[0] : value
      end
      values_to_pluralize.each { |key, value| node[key] = value }
      node
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
