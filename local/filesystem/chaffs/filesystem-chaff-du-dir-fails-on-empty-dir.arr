# CSCI0190 (Fall 2020)

include cpo
import lists and lysts

provide {how-many: how-many, du-dir: du-dir, can-find: can-find, fynd: fynd} end

#| chaff (tdelvecc, Aug 31, 2020): 
    Du-dir raises an error when Dir is empty.
    Search "CHAFF DIFFERENCE" for changed code.
|#

include file("../filesystem-types.arr")

fun how-many(directory :: Dir) -> Number:
  doc: "Finds the number of files in the directory tree."
  # Fold over sub-directories, starting with number of files in current directory
  for fold(num-files from directory.fs.length(), sub-dir from directory.ds):
    num-files + how-many(sub-dir)
  end
end

fun du-dir(directory :: Dir) -> Number block:
  doc: "Finds the total size of the directory tree."
  # CHAFF DIFFERENCE: Raises an error when Dir is empty.
  when is-empty(directory.fs) and is-empty(directory.ds):
    raise("Found empty directory.")
  end
  
  # Find size of files in current directory
  for fold(files-size from directory.fs.length(), a-file from directory.fs):
    files-size + a-file.size()
  end
  +
  # Find size of sub-directories in current directory
  for fold(directories-size from directory.ds.length(), a-dir from directory.ds):
    directories-size + du-dir(a-dir)
  end
end

fun can-find(directory :: Dir, name :: String) -> Boolean:
  doc: "Determines whether a file with given name is in the directory tree."
  # Check if it's in current directory
  for any(a-file from directory.fs):
    a-file.name == name
  end
  or
  # Check if it's in sub-directories
  for any(a-dir from directory.ds):
    can-find(a-dir, name)
  end
end

fun fynd(directory :: Dir, name :: String) -> List<Path>:
  doc: "Finds all instances of files with given name in the directory tree."
  sub-dir-paths :: List<Path> =
    directory.ds
    ^ map(fynd(_, name), _) # Recur on sub-dirs
    ^ fold(lysts.append, empty, _) # Combine results into one list
    ^ map(link(directory.name, _), _) # Add current directory to paths
  
  # If file is in current directory, add new path
  if directory.fs.map(_.name).member(name):
    link([list: directory.name], sub-dir-paths)
  else:
    sub-dir-paths
  end
end
