# XML Hate

## Reading XML with my own ten-foot poll.

xml_hate is a small gem that describes my feelings for XML imports.  I've written a billion of them, yet each time I start another I feel like I'm writing Assembler. Shouldn't it be easier?  Shouldn't the code look nicer?  Shouldn't this be more fun?

I've also noticed a number of things that I always tend to do.  I always convert the XML to objects, I parse through the hierarchy to find child objects, I put in defensive checks for data that might-or-might-not exist, etc.

This gem is where I'm going to put these conventions and processes of mine.  My goal is to take a XML document and immediately get it in the form that I need to use it.

### Example

``` xml
<root>
  <directory>
    <employee firstname="Galt">
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