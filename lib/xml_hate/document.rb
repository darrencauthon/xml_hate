require 'hashie'
require 'active_support/inflector'

module XmlHate
  class Document
    def initialize(xml)
      @document = lower_case_please(XmlSimple.xml_in(xml))
    end

    def method_missing(meth, *args, &blk)
      meth = meth.to_s
      unless @document.has_key?(meth)
        if @document.has_key?(meth.singularize)
          meth = meth.singularize
        else
          return ''
        end
      end
      objects = pull_the_objects_from_the_xml_document(meth)
      objects.count == 1 ? objects[0] : objects
    end

    private

    def lower_case_please hash
      hash.keys.reduce({}) do |t, key|
        value = hash[key].is_a?(Hash) ? lower_case_please(hash[key])
                                      : hash[key]
        value = hash[key]
        t.merge!( { key.to_s.underscore => value } )
      end
    end

    def pull_the_objects_from_the_xml_document(meth)
      nodes = read_the_matching_nodes_from_the_xml_document(meth)
      convert_the_hashes_to_objects(nodes)
    end

    def read_the_matching_nodes_from_the_xml_document(meth)
      @document[meth].map { |n| process_this_top_level_node(n) }
    end

    def convert_the_hashes_to_objects(objects)
      objects.map do |v|
        v.class == Hashie::Mash ? Node.new(v) : v
      end
    end

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
      values_to_pluralize.each do |key, value| 
        node[key] = value if !key.nil?
      end

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
      begin
        node.select{|k,v| get_the_number_of_elements(v) >= 1}
      rescue
        []
      end
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
