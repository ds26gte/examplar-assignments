include cpo
provide *
provide-types *

data Dir:
 | dir(name :: String, ds :: List<Dir>, fs :: List<File>)
end

data File:
 | file(name :: String, content :: String)
    with:
    method size(self):
      string-length(self.content)
    end
    #|where:
  zero-size = file("test", "")
  zero-size.size() is 0
  one-size = file("test", "i")
  one-size.size() is 1
  ten-size = file("test", "aaaaaaaaaa")
  ten-size.size() is 10
  spaces-file = file("test", "    ")
  spaces-file.size() is 4|#
end

type Path = List<String>
