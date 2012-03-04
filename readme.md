# XML Hate

## Reading XML with my own ten-foot poll.

xml_hate is a small gem that describes my feelings for XML imports.  I've written a billion of them, yet each time I start another I feel like I'm writing Assembler. Shouldn't it be easier?  Shouldn't the code look nicer?  Shouldn't this be more fun?

I've also noticed a number of things that I always tend to do.  I always convert the XML to objects, I parse through the hierarchy to find child objects, I put in defensive checks for data that might-or-might-not exist, etc.

This gem is where I'm going to put these conventions and processes of mine.  My goal is to take a XML document and immediately get it in the form that I need to use it.

### Example

``` xml
<root>
  <directory>
    <employee lastname="Galt">
      <address>123 W St</address>
      <address>456 S Blvd</address>
      <firstname>John</firstname>
    </employee>
    <employee lastname="Roark" firstname="Howard">
      <address>789 S</address>
    </employee>
    <employee lastname="Rearden" />
  </directory>
</root>
```

```ruby
document = XmlHate::Document.new(xml)

document.directory.employees.count # 3, note pluralization happened automatically

john_galt = document.directory.employees[0]

# note how I treat the single-value element and attribute the same
john_galt.lastname # Galt
john_galt.firstname # John

john_galt.addresses.count # 2, notice pluralization again

howard_roark = document.directory.employees[1]

howard_roark.firstname # Howard
howard_roark.lastname # Roark
howard_roark.addresses.count # 1
howard_roark.address # 789 S

rearden = document.directory.employees[2]
rearden.lastname # Rearden
rearden.firstname # "", defaults to empty string if the value cannot be found
rearden.whatever_i_want # "", see above
rearden.addresses.count # 0, returns [] by assuming you want the plural version

```