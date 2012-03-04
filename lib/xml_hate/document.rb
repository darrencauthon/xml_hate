require 'hashie'
require 'active_support/inflector'

module XmlHate
  class Document
    def initialize(xml)
      @document = XmlSimple.xml_in(xml)
    end

    def method_missing(meth, *args, &blk)
      begin
        this_node = @document[meth.to_s]
        if this_node.count == 1
          this_node = this_node[0] if this_node.count == 1
          return this_node if this_node.class == String

          return_value = Hashie::Mash.new(this_node)
          push_single_elements_up_to_attributes(return_value)

          return return_value
        else
          return_values = []
          this_node.each do |n|
            sigh = Hashie::Mash.new(n)
            push_single_elements_up_to_attributes(sigh)
            return_values << sigh 
          end
          return return_values
        end
      rescue
        ""
      end
    end

    private

    def push_single_elements_up_to_attributes(node)
      array_values = {}
      node.each do |key, value|
        begin
          if value.count >= 1
            array_values[key.pluralize] = value if key.pluralize != key
            cleaned_values = []
            value.each do |v|
              cleaned_values << push_single_elements_up_to_attributes(v)
            end
            value = push_single_elements_up_to_attributes(value)
          end
          if value.count == 1
            node[key] = value[0] 
          else
            node[key] = value
          end
        rescue
        end
      end
      array_values.each do |key, value|
        node[key] = value
      end
      node
    end
  end
end
